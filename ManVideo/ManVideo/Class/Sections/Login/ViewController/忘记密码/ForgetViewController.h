//
//  ForgetViewController.h
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetViewController : GKDYBaseViewController

@property(weak,nonatomic)IBOutlet UITextField *iphoneTextField;
@property(weak,nonatomic)IBOutlet UITextField *codeTextField;
@property(weak,nonatomic)IBOutlet UITextField *passwordTextField;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
