//
//  VideoReleaseVC.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

///视频发布页面
@interface VideoReleaseVC : GKDYBaseViewController
@property(nonatomic,strong)NSData * _Nullable data;
@property(nonatomic,copy)NSString * _Nullable infoStr;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
