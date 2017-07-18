//
//  STCBottomFunctionView.m
//  STCamera
//
//  Created by fanfan on 2017/7/18.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "STCBottomFunctionView.h"
#import <Masonry.h>
@implementation STCBottomFunctionView

#pragma  - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    [[self takeControlBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.size.equalTo(@80);
        make.bottom.equalTo(self.mas_bottom).offset(-32);
    }];
}


#pragma -takeControlBtn - 录制按钮
- (UIButton *)takeControlBtn{
    if (!_takeControlBtn) {
        _takeControlBtn = [[UIButton alloc]init];
        _takeControlBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_takeControlBtn];
    }
    return _takeControlBtn;
}

@end
