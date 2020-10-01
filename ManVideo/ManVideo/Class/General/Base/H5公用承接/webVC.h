//
//  webVC.h
//  ManVideo
//
//  Created by 刘赓 on 2019/8/15.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataBlock)(id data);

@interface webVC : GKDYBaseViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

-(instancetype)initWithRequestParams:(nullable id)requestParams
                             success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
