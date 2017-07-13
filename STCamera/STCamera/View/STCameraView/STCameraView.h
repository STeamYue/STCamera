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
@class STCameraC;
@class STCameraProtocol;
@interface STCameraView : UIView

/*---------------------- UI -----------------------------------*/

@property (nonatomic, strong) STCameraC           *stCameraC;            //STCameraC加载STCameraView时，记录下父层viewC，不走Getter
@property (nonatomic, strong) STCameraProtocol    *protocol;             //处理类
@property (nonatomic, strong) UIView              *topFunctionView;      //上半部功能View
@property (nonatomic, strong) UIButton            *closeBtn;             //关闭Btn  关闭界面
@property (nonatomic, strong) UIView              *progressView;         //进度层View
@property (nonatomic, strong) UIView              *bottomFunctionView;   //下半部功能View
@property (nonatomic, strong) UIButton            *takeControlBtn;       //录制控制按钮
@property (nonatomic, strong) UIButton            *saveBtn;              //保存
@property (nonatomic, strong) UIButton            *undoBtn;              //取消

/*---------------------- Layer ---------------------------------*/

/*---------------------- GPUImage ------------------------------*/
@property (nonatomic, strong) GPUImageView        *gpuImgView;
@property (nonatomic, strong) GPUImageMovieWriter *imgMovieWriter;    //写入临时文件
@property (nonatomic, strong) GPUImageStillCamera *imgStillCamera;
@property (nonatomic, strong) STGPUImgFilter      *stGPUImgFilter;


@end
