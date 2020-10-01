//
//  ChangePasswordController.h
//  Clipyeu ++
//
//  Created by Josee on 03/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordController : GKDYBaseViewController

@property(weak,nonatomic)IBOutlet UITextField *passwordNewField;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
