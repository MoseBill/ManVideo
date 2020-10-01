//
//  MineViewController.m
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)vd_layoutNavigation {
    
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
    // 去掉导航栏的边界黑线 方式2
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}


@end
