//
//  STCameraProtocol.m
//  STCamera
//
//  Created by 岳克奎 on 2017/7/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "STCameraProtocol.h"
#import "STCameraView.h"
#import <GPUImage.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation STCameraProtocol
#pragma - stCameraProtocolDelegate
/**
 Protocol代理
 负责回调交互
 */
- (void)setStCameraProtocolDelegate:(id<STCameraProtocolDelegate>)stCameraProtocolDelegate{
    _stCameraProtocolDelegate = stCameraProtocolDelegate;
}
#pragma - btnSelector
- (SEL)btnSelector{
    if (!_btnSelector) {
        _btnSelector = @selector(show_btnClick:);
    }
    return _btnSelector;
}
#pragma -  界面btn事件
/**
 界面btn事件
 tag= 除了导航左右1和2，其余5起步
 tag = 5 开始录制按钮
 */
- (void)show_btnClick:(UIButton *)sender{
    if (sender.tag == 5) {
        
        //操作权限
        unlink([[self.stCameraView moviePathStr] UTF8String]);
        [self.stCameraView.stGPUImgFilter addTarget:self.stCameraView.imgMovieWriter];
        [[self.stCameraView imgMovieWriter] startRecording];
        //10 秒后结束 录制
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           @autoreleasepool {
                               __weak typeof(self)weakSelf = self;
                               [self.stCameraView.imgMovieWriter finishRecordingWithCompletionHandler:^{
                                   //销毁imgMovieWriter
                                   weakSelf.stCameraView.imgMovieWriter = nil;
                                   NSURL *oldUrl = [NSURL fileURLWithPath:weakSelf.stCameraView.moviePathStr];
                                   NSData *videoData = [NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Movie.mov"]];
                                   NSLog(@"----eeeeee-------%lu",(unsigned long)videoData.length);
                                   NSString *newUrlStr =[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Movie01.mov"];
                                   [weakSelf mergeAndExportVideosAtFileURLs:oldUrl
                                                                     newUrl:newUrlStr
                                                           widthHeightScale:16/9
                                                                 presetName:AVAssetExportPresetHighestQuality
                                                                   complete:^(BOOL finished) {
                                            
                                                                       if (finished) {
                                                                           NSLog(@"完成");
                                                                       }else    {
                                                                           NSLog(@"失败！");
                                                                       }
                                                                   }];
                                   //                                   [weakSelf.stCameraView avPlayerLayer].player = [AVPlayer playerWithURL:[NSURL fileURLWithPath: weakSelf.stCameraView.moviePathStr]];
                                   //                                   [weakSelf.stCameraView.avPlayerLayer.player play];
                               }];
                           }
                       });
    }
}

#pragma mark  视频裁剪
/*
 fileURL :原视频url
 mergeFilePath:新的fileurl
 whScalle:所需裁剪的宽高比
 presetName:压缩视频质量,不传则 AVAssetExportPresetMediumQuality
 */
-(void)mergeAndExportVideosAtFileURLs:(NSURL *)fileURL
                               newUrl:(NSString *)mergeFilePath
                     widthHeightScale:(CGFloat)whScalle
                           presetName:(NSString *)presetName
                             complete:(void(^)(BOOL finished))block

{
    NSError *error = nil;
    
    CMTime totalDuration = kCMTimeZero;
    //转换AVAsset
    AVAsset *asset = [AVAsset assetWithURL:fileURL];
    if (!asset) {
        if (block) {
            block(NO);
        }
        return;
    }
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //提取音频、视频
    NSArray * assetArray = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    AVAssetTrack *assetTrack;
    if (assetArray.count) {
        assetTrack = [assetArray objectAtIndex:0];
    }
    
    [self audioTrackWith:mixComposition assetTrack:assetTrack asset:asset totalDuration:totalDuration error:error];
    
    AVMutableCompositionTrack *videoTrack = [self videoTrackWith:mixComposition assetTrack:assetTrack asset:asset totalDuration:totalDuration error:error];
    
    CGFloat renderW = [self videoTrackRenderSizeWithassetTrack:assetTrack];
    totalDuration = CMTimeAdd(totalDuration, asset.duration);
    
    NSMutableArray *layerInstructionArray = [self assetArrayWith:videoTrack
                                                   totalDuration:totalDuration
                                                      assetTrack:assetTrack
                                                         renderW:renderW
                                                widthHeightScale:whScalle];
    
    [self mergingVideoWithmergeFilePath:mergeFilePath
                  layerInstructionArray:layerInstructionArray
                         mixComposition:mixComposition
                          totalDuration:totalDuration
                                renderW:renderW
                       widthHeightScale:whScalle
                             presetName:presetName
                               complete:^(BOOL finished) {
                                   if (block) {
                                       block(finished);
                                   }
                               }];
}

//压缩视频
-(void)mergingVideoWithmergeFilePath:(NSString *)mergeFilePath
               layerInstructionArray:(NSMutableArray*)layerInstructionArray
                      mixComposition:(AVMutableComposition *)mixComposition
                       totalDuration:(CMTime)totalDuration
                             renderW:(CGFloat)renderW
                    widthHeightScale:(CGFloat)whScalle
                          presetName:(NSString *)presetName
                            complete:(void(^)(BOOL finished))block

{
    //get save path
    NSURL *mergeFileURL = [NSURL fileURLWithPath:mergeFilePath];
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW/whScalle);//renderW/4*3
    
    __block AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:presetName?:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                if (block) {
                    block(YES);
                }
            }else{
                if (block) {
                    block(NO);
                }
            }
        });
    }];
    
}

//合成视频
-(NSMutableArray *)assetArrayWith:(AVMutableCompositionTrack *)videoTrack
                    totalDuration:(CMTime)totalDuration
                       assetTrack:(AVAssetTrack *)assetTrack
                          renderW:(CGFloat)renderW
                 widthHeightScale:(CGFloat)whScalle

{
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    CGFloat rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
    CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height/whScalle) / 2.0));//向上移动取中部影响
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
    [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
    [layerInstruciton setOpacity:0.0 atTime:totalDuration];
    //data
    [layerInstructionArray addObject:layerInstruciton];
    
    return layerInstructionArray;
}



-(void)audioTrackWith:(AVMutableComposition *)mixComposition
           assetTrack:(AVAssetTrack *)assetTrack
                asset:(AVAsset *)asset
        totalDuration:(CMTime)totalDuration
                error:(NSError *)error{
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSArray *array =  [asset tracksWithMediaType:AVMediaTypeAudio];
    if (array.count > 0) {
        AVAssetTrack *audiok =[array objectAtIndex:0];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:audiok
                             atTime:totalDuration
                              error:nil];
    }
}

//视频大小
-(CGFloat)videoTrackRenderSizeWithassetTrack:(AVAssetTrack *)assetTrack{
    
    CGSize renderSize = CGSizeMake(0, 0);
    renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
    renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    return MIN(renderSize.width, renderSize.height);
}


//videoTrack
-(AVMutableCompositionTrack*)videoTrackWith:(AVMutableComposition *)mixComposition
                                 assetTrack:(AVAssetTrack *)assetTrack
                                      asset:(AVAsset *)asset
                              totalDuration:(CMTime)totalDuration
                                      error:(NSError *)error{
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:assetTrack
                         atTime:totalDuration
                          error:&error];
    
    
    return videoTrack;
    
}
@end
