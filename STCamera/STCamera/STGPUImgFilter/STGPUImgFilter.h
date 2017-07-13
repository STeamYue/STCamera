//
//  STGPUImgFilter.h
//  beichoo-ios
//
//  Created by fanfan on 2017/7/7.
//  Copyright © 2017年 辈出. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<GPUImage/GPUImage.h>)
#import <GPUImage/GPUImage.h>
#elif __has_include("GPUImage/GPUImage.h")
#import "GPUImage/GPUImage.h"
#else
#import "GPUImage.h"
#endif
@interface STGPUImgFilter : GPUImageFilter
@property (nonatomic, assign) CGFloat beautyLevelValue;   //美颜
@property (nonatomic, assign) CGFloat brightLevelValue;   // 美白
@property (nonatomic, assign) CGFloat toneLevelValue;     // 色调
@end
