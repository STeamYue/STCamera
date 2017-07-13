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
 */
- (void)show_btnClick:(UIButton *)sender{
    
}

@end
