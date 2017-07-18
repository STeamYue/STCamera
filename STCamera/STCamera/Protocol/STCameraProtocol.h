//
//  STCameraProtocol.h
//  STCamera
//
//  Created by 岳克奎 on 2017/7/12.
//  Copyright © 2017年 ST. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STCameraView;
@protocol STCameraProtocolDelegate <NSObject>
@optional
@end
@interface STCameraProtocol : NSObject
@property (nonatomic, strong) STCameraView                 *stCameraView;
@property (nonatomic, weak  ) id<STCameraProtocolDelegate> stCameraProtocolDelegate;
@property (nonatomic, assign) SEL                          btnSelector;
@end
