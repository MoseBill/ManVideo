//
//  LZTabBarVC.h
//  WebViewTest
//
//  Created by Josee on 2019/3/4.
//  Copyright © 2019年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZTabBarVC : UITabBarController

@property(nonatomic,assign)NSInteger delayIndex;
@property(nonatomic,strong)HomeVC *homeVC;

@end

NS_ASSUME_NONNULL_END
