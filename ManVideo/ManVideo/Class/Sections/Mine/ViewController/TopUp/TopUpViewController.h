//
//  TopUpViewController.h
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "CashSuccessController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopUpViewController : GKDYBaseViewController

@property(nonatomic,copy)NSString *integralString;
@property(nonatomic,copy)NSString *iphoneString;
@property(nonatomic,copy)NSString *codeString;
@property(nonatomic,strong)CashSuccessController *cashSuccess;

@end

NS_ASSUME_NONNULL_END
