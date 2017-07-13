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
        protocol.stCameraC = self.stCameraC;
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
    [self show_layout];
    [self show_load];
}
#pragma - 布局
/**
 */
- (void)show_layout{
    [[self gpuImgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma -加载
/**
 加载
 GPUImge一些配置
 */
- (void)show_load{
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
        _imgStillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
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
        [_gpuImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);//如果这里不写，外面掉view，会导致约束不存在，而子的存在，导致崩溃
        }];
        [self sendSubviewToBack:_gpuImgView];
    }
    return _gpuImgView;
}



















@end
