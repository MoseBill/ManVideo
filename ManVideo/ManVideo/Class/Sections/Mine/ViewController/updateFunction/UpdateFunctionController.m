//
//  UpdateFunctionController.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "UpdateFunctionController.h"

@implementation UpdateFunctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navTitle =  NSLocalizedString(@"VDUpdatefunctionText", nil);
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    //    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    
    [self setupView];
}

- (void)setupView {
    
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}


@end
