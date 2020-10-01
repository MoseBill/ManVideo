//
//  KHTBaseController.h
//  BasicApp
//
//  Created by Jacky-song on 2018/7/25.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KHTBaseController : UIViewController

/**
 *  用于push vc 隐藏tabbar
 *
 *  @param vc       要push的vc
 *  @param animated 动画效果
 */
- (void)dsPushViewController:(UIViewController*)vc animated:(BOOL)animated;

/**
 *  根据根vc返回指定层vc
 *
 *  @param rootViewController 根vc
 *
 *  @return
 */
//- (void)backCurrentViewController:(UIViewController *)rootViewController;

/**
 *  返回任意一个页面
 */
- (void)popToViewControllerAtIndex:(NSInteger)index;

/**
 *popToRoot页面
 */
- (void)popToRoot;

/** 默认文字弹框 */
- (void)showMessage:(NSString *)text view:(UIView *)view;
/** pop页面  */
-(void)back;
/** 设置状态栏背景色 */
- (void)setStatusBarBackgroundColor:(UIColor *)color;

@end
