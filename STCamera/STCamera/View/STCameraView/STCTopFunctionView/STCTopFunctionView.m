//
//  STCTopFunctionView.m
//  STCamera
//
//  Created by fanfan on 2017/7/18.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "STCTopFunctionView.h"
#import <Masonry.h>
@implementation STCTopFunctionView

-(void)layoutSubviews{
    [super layoutSubviews];
    [self backBtn];
}
#pragma -  backBtn 返回按钮
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.centerY.equalTo(self);
            make.size.equalTo(@40);
        }];
        _backBtn.backgroundColor = [UIColor redColor];
    }
    return _backBtn;
}
@end
