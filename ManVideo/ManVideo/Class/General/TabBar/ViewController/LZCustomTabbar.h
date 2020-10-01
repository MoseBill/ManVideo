//
//  LZCustomTabbar.h
//  WebViewTest
//
//  Created by Josee on 2019/3/4.
//  Copyright © 2019年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(UIButton * _Nonnull btn);

NS_ASSUME_NONNULL_BEGIN

@interface LZCustomTabbar : UITabBar

@property (nonatomic, copy) ClickBlock btnClickBlock;

+(CGFloat)setTabBarUI:(NSArray *)views
            tabBar:(UITabBar *)tabBar
      topLineColor:(UIColor *)lineColor
   backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
