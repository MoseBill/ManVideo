//
//  AbountUsController.m
//  Clipyeu ++
//
//  Created by Josee on 28/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "AbountUsController.h"

@interface AbountUsController ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation AbountUsController

- (void)viewDidLoad {
    [super viewDidLoad];
 
   
    self.gk_navTitle =  @"Về chúng ta.";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
//    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    [self setupView];
    
}

- (void)setupView {
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Height_NavBar);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-92);
    }];
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

@end
