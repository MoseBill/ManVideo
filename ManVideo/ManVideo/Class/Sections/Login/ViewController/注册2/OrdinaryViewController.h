//
//  OrdinaryViewController.h
//  Clipyeu ++
//
//  Created by Josee on 29/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrdinaryViewController : GKDYBaseViewController

@property(weak,nonatomic)IBOutlet UITextField *iphoneFieldText;
@property(weak,nonatomic)IBOutlet UITextField *codeFieldText;
@property(weak,nonatomic)IBOutlet UITextField *InviteCodeField;
@property(weak,nonatomic)IBOutlet UITextField *passwordNewField;
@property(nonatomic,copy)NSString *ipStr;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
