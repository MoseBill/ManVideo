//
//  MARFaceBeautyControllerViewController.h
//  MARFaceBeauty
//
//  Created by Maru on 2016/11/12.
//  Copyright © 2016年 Maru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "VideoReleaseVC.h"
//#import "LFGPUImageBeautyFilter.h"
//#import "SSAddImage.h"
//#import "WYVideoCompressTools.h"
//#import "GIFManager.h"

/// https://www.meiwen.com.cn/subject/sjukvttx.html 因为是每帧识别，所以CPU的消耗较高。
@interface MARFaceBeautyVC : GKDYBaseViewController

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;


@end
