//
//  STCameraProtocol.m
//  STCamera
//
//  Created by 岳克奎 on 2017/7/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "STCameraProtocol.h"
#import "STCameraView.h"
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
      unlink([self.stCameraView.moviePathStr UTF8String]);              //操作权限
     [self.stCameraView.stGPUImgFilter addTarget:self.stCameraView.imgMovieWriter];
     [[self.stCameraView imgMovieWriter] startRecording];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                });
    }
}

@end
