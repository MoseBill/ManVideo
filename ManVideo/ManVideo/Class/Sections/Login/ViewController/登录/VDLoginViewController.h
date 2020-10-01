//
//  VDLoginViewController.h
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VDLoginViewController : GKDYBaseViewController

@property(weak,nonatomic)IBOutlet UITextField *iphoneTextField;
@property(weak,nonatomic)IBOutlet UITextField *passwordTextField;
@property(weak,nonatomic)IBOutlet UIButton *registerBtn;
@property(nonatomic,strong)NSDateFormatter *formatter;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

- (void)backBtnClickEvent:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
