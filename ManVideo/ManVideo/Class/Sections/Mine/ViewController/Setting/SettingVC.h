//
//  SettingViewController.h
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingVC : GKDYBaseViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
