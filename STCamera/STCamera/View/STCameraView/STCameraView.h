//
//  STCameraView.h
//  STCamera
//
//  Created by 岳克奎 on 2017/7/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>
#import <Masonry.h>
#import "STGPUImgFilter.h"
#import "STCTopFunctionView.h"
#import "STCProgressView.h"
#import "STCBottomFunctionView.h"
@class STCameraC;
@class STCameraProtocol;
@interface STCameraView : UIView

/*---------------------- UI -----------------------------------*/

@property (nonatomic, strong) STCameraC             *stCameraC;            //STCameraC加载STCameraView时，记录下父层viewC，不走Getter
@property (nonatomic, strong) STCameraProtocol      *protocol;             //处理类
@property (nonatomic, strong) STCTopFunctionView    *topFunctionView;      //上半部功能View
@property (nonatomic, strong) STCProgressView       *progressView;         //进度层View
@property (nonatomic, strong) UIView                *showView;             //视频展示 类似相框。预留，扩展
@property (nonatomic, strong) STCBottomFunctionView *bottomFunctionView;   //下半部功能View


/*---------------------- Layer ---------------------------------*/

/*---------------------- GPUImage ------------------------------*/
@property (nonatomic, strong) GPUImageView        *gpuImgView;
@property (nonatomic, strong) GPUImageMovieWriter *imgMovieWriter;    //写入临时文件
@property (nonatomic, strong) GPUImageStillCamera *imgStillCamera;
@property (nonatomic, strong) STGPUImgFilter      *stGPUImgFilter;

/*---------------------- other ------------------------------*/
@property (nonatomic, strong) NSString            *moviePathStr;

@end
