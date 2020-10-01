//
//  CashSuccessController.m
//  Clipyeu ++
//
//  Created by Josee on 17/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CashSuccessController.h"

@interface CashSuccessController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;

@end

@implementation CashSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.successBtn setTitle:NSLocalizedString(@"VDcompleteText", nil) forState:UIControlStateNormal];
    if ([self.type isEqualToString:NSLocalizedString(@"VDRedeemedText", nil)]) {
         self.gk_navTitle = NSLocalizedString(@"VDRedeemedText", nil);
        self.contentLabel.text = NSLocalizedString(@"VDapplyText", nil);
    } else {
        self.gk_navTitle = NSLocalizedString(@"VDphoneText", nil);
        self.contentLabel.text = NSLocalizedString(@"VDtopupText", nil);
    }
   
    self.gk_navBarAlpha = 0;
    self.gk_navigationBar.translucent = NO;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"1A142D"];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
//    self.gk_navTitleView = self.titleView;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;

    self.successBtn.layer.masksToBounds = YES;
    self.successBtn.layer.cornerRadius = 8.0f;
    
}

- (IBAction)sucessAction:(UIButton *)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[PersonalCenterVC class]]) {
            PersonalCenterVC *A =(PersonalCenterVC *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }
}

-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

@end
