//
//  ZFCollectionViewListController.h
//  ZFPlayer_Example
//
//  Created by Josee on 2018/7/19.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDViewController.h"

@interface ZFCollectionViewListController : GKDYBaseViewController

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nullable)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock _Nullable )block
                            animated:(BOOL)animated;

- (void)refreshAction:(UIButton *_Nonnull)sender;

@end
