//
//  STCameraView.m
//  STCamera
//
//  Created by 岳克奎 on 2017/7/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "STCameraView.h"
#import "STCameraC.h"
#import "STCameraProtocol.h"
#define kCameraWidth  540
#define kCameraHeight 960
@implementation STCameraView
#pragma -protocol
/**
 处理类
 protocol 拿到View 和ViewC
 */
- (STCameraProtocol *)protocol{
    if (!_protocol) {
        STCameraProtocol *protocol= [[STCameraProtocol alloc]init];
        protocol.stCameraView = self;
        _protocol = protocol;
    }
    return _protocol;
}
#pragma - 布局+加载
/**
 布局+加载
 
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    [self show_layoutUI];
    [self show_loadCameraSet];
}
#pragma - 布局
/**
 */
- (void)show_layoutUI{
    //topFunctionView 顶部功能View，废弃NavBar
    //topFunctionView
    [[self topFunctionView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@64);
    }];
    //progressView 进度View  放在 导航View下面
    [[self progressView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topFunctionView.mas_bottom);
        make.height.equalTo(@10);
    }];
    //showView 相框
    [[self showView]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.progressView.mas_bottom);
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.width*9/16));
    }];
    //底部 功能view
    [[self bottomFunctionView]mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.showView.mas_bottom);
    }];
    //..gpuImgView 摄像数据实时渲染显示
    [[self gpuImgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.showView);
    }];
    //配置 tag = 5 录制按钮事件
    self.bottomFunctionView.takeControlBtn.tag = 5;
    [self.bottomFunctionView.takeControlBtn addTarget:[self protocol]
                                               action:[self protocol].btnSelector
                                     forControlEvents:UIControlEventTouchUpInside];
}
#pragma - topFunctionView 上半部功能View
- (STCTopFunctionView *)topFunctionView{
    if (!_topFunctionView) {
        _topFunctionView = [[STCTopFunctionView alloc]init];
        [self addSubview:_topFunctionView];
        _topFunctionView.backgroundColor = [UIColor whiteColor];
    }
    return _topFunctionView;
}

#pragma - progressView - 录制进度View
-(STCProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[STCProgressView alloc]init];
        [self addSubview:_progressView];
        _progressView.backgroundColor = [UIColor greenColor];
    }
    return _progressView;
}

#pragma - showView - 视频框
-(UIView *)showView{
    if (!_showView) {
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = [UIColor clearColor];
        [self addSubview:_showView];
    }
    return _showView;
}

#pragma -  bottomFunctionView - 下部分功能View
- (STCBottomFunctionView *)bottomFunctionView{
    if (!_bottomFunctionView) {
        _bottomFunctionView =[[STCBottomFunctionView alloc]init];
        [self addSubview:_bottomFunctionView];
        _bottomFunctionView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomFunctionView;
}
#pragma -加载
/**
 加载
 GPUImge一些配置
 */
- (void)show_loadCameraSet{
    [self protocol];
    [[self imgStillCamera] addTarget:[self stGPUImgFilter]];
    [self.stGPUImgFilter addTarget:[self gpuImgView]];
    self.imgStillCamera.audioEncodingTarget = [self imgMovieWriter];
    [self.imgStillCamera startCameraCapture];                          /// 开始捕获
}
#pragma - imgStillCamera （Getter） 处理实时相机图像类
/**
 处理实时相机图像类
 */
- (GPUImageStillCamera *)imgStillCamera {
    if (!_imgStillCamera)
    {
        _imgStillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetiFrame960x540
                                                              cameraPosition:AVCaptureDevicePositionBack];
        _imgStillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _imgStillCamera.horizontallyMirrorFrontFacingCamera = YES;
    }
    return _imgStillCamera;
}
#pragma - 过滤器
/**
 过滤器(美白+美颜+色调)调节
 */
- (STGPUImgFilter *)stGPUImgFilter{
    if (!_stGPUImgFilter)
    {
     _stGPUImgFilter = [[STGPUImgFilter alloc]init];
    }
    return _stGPUImgFilter;
}
#pragma -GPUImageView
/**
 GPUImageView实时展示传入的图像
 */
- (GPUImageView *)gpuImgView{
    if (!_gpuImgView) {
        _gpuImgView = [[GPUImageView alloc]init];
        [_gpuImgView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
        [self addSubview:_gpuImgView];
//        [_gpuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.top.equalTo(self.mas_top).offset(64+15);
//        }];
        [self sendSubviewToBack:_gpuImgView];
    }
    return _gpuImgView;
}
#pragma - imgMovieWriter （Getter）

- (GPUImageMovieWriter *)imgMovieWriter{
    if (!_imgMovieWriter)
    {
        _imgMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:[self moviePathStr]]
                                                                   size:CGSizeMake(kCameraWidth, kCameraHeight)
                                                               fileType:AVFileTypeQuickTimeMovie
                                                         outputSettings:[self videoSettingsMDic]];
    }
    return _imgMovieWriter;
}
#pragma videoSettingsMDic
- (NSMutableDictionary *)videoSettingsMDic {
    if (!_videoSettingsMDic) {
        _videoSettingsMDic = [[NSMutableDictionary alloc] init];
        [_videoSettingsMDic setObject:AVVideoCodecH264
                               forKey:AVVideoCodecKey];
        [_videoSettingsMDic setObject:[NSNumber numberWithInteger:kCameraWidth]
                               forKey:AVVideoWidthKey];
        [_videoSettingsMDic setObject:[NSNumber numberWithInteger:kCameraHeight]
                               forKey:AVVideoHeightKey];
    }
    return _videoSettingsMDic;
}
/*---------------------- Layer ------------------------------*/
- (AVPlayerLayer *)avPlayerLayer{
    if (!_avPlayerLayer) {
        _avPlayerLayer = [[AVPlayerLayer alloc]init];
        [[self showView].layer insertSublayer:_avPlayerLayer
                                        above:self.showView.layer];
        _avPlayerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width*9/16);
    }
    return _avPlayerLayer;
}
/*---------------------- other ------------------------------*/
- (NSString *)moviePathStr{
    if (!_moviePathStr) {
        _moviePathStr = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Movie.mov"];
    }
    return _moviePathStr;
}
@end
