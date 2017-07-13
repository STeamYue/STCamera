//
//  STCameraC.m
//  STCamera
//
//  Created by 岳克奎 on 2017/7/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import "STCameraC.h"
#import "STCameraView.h"
@interface STCameraC ()

@end

@implementation STCameraC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self stCameraView];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - stCameraView层
- (STCameraView *)stCameraView{
    if (!_stCameraView) {
        STCameraView *stCameraView = [[STCameraView alloc]init];
        stCameraView.stCameraC = self;
        [self.view addSubview:stCameraView];
        [stCameraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _stCameraView = stCameraView;
    }
    return _stCameraView;
}

@end
