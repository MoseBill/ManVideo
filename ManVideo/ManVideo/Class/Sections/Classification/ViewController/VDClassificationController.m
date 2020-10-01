//
//  VDClassificationController.m
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDClassificationController.h"
#import "MXNavigationBarManager.h"

@interface VDClassificationController ()

@end

@implementation VDClassificationController

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//
//    [MXNavigationBarManager reStoreToSystemNavigationBar];
//}
//
//- (void)initBarManager {
//    //optional, save navigationBar status
//
//    //required
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
//
//    //optional
//    [MXNavigationBarManager setTintColor:[UIColor whiteColor]];
//    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
//}
//- (void)viewWillAppear:(BOOL)animated
//{
//
//    [super viewWillAppear:animated];
//
////    [self.navigationController setNavigationBarHidden:YES animated:YES];
//       self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@""];
////        self.edgesForExtendedLayout = UIRectEdgeTop;
//    //    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"54ceee"];
//    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"96C8F5"],
//    //                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
//    [self initBarManager];
//}

- (void)vd_layoutNavigation {
    
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
    // 去掉导航栏的边界黑线 方式2
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsCompact];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

}

@end
