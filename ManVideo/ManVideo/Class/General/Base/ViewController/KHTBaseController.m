//
//  KHTBaseController.m
//  BasicApp
//
//  Created by Jacky-song on 2018/7/25.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "KHTBaseController.h"

@interface KHTBaseController ()

@end

@implementation KHTBaseController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = kWhiteColor;
}


/**
 *  dimiss页面
 */
- (void)dismissVC{
  [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *返回任意一个页面
 */
- (void)popToViewControllerAtIndex:(NSInteger)index{
  if (self.navigationController.viewControllers.count > index) {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
  }
}
/**
 *popToRoot页面
 */
- (void)popToRoot{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dsPushViewController:(UIViewController*)vc animated:(BOOL)animated{
  
  [self.navigationController pushViewController:vc animated:animated];
}

//-(void)back{
//  
//  if (self.navigationController.viewControllers.firstObject == self && self.navigationController.presentingViewController != nil) {
//    
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//  } else {
//    
//    [self.navigationController popViewControllerAnimated:YES];
//  }
//}

- (void)showMessage:(NSString *)text view:(UIView *)view {
    if (view == nil) view = kAPPWindow;
  // 快速显示一个提示信息
  if ([text isEqualToString:@""] || text == nil) return;
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:1];
  hud.label.text = [NSString stringWithFormat:@"%@",text];
  hud.bezelView.backgroundColor = kBlackColor;
  hud.mode = MBProgressHUDModeCustomView;
  hud.label.textColor = kWhiteColor;
  hud.removeFromSuperViewOnHide = YES;
  [hud hideAnimated:1 afterDelay:1.5];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
  
  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
    statusBar.backgroundColor = color;
  }
}

/**
 *  点击返回按钮调用
 */
- (void)back{
  if (self.childViewControllers.firstObject == self && self.presentingViewController != nil) {
    
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)shouldAutorotate {
  return NO;
}

@end
