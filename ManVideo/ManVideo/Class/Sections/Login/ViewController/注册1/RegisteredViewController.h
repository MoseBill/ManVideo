//
//  RegisteredViewController.h
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYBaseViewController.h"
#import "ChangePasswordController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisteredViewController : GKDYBaseViewController

@property(weak,nonatomic)IBOutlet UITextField *iphoneTextField;
@property(weak,nonatomic)IBOutlet UITextField *codePassword;
@property(weak,nonatomic)IBOutlet UITextField *codeInvitation;


@end

NS_ASSUME_NONNULL_END
