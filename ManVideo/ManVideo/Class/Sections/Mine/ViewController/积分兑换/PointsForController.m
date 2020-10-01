//
//  PointsForController.m
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "PointsForController.h"
#import "RedeemedCashController.h"
#import "TopUpViewController.h"
#import "ChangeHistoryController.h"

extern LZTabBarVC *tabBarVC;

@interface PointsForController ()

@property(weak,nonatomic)IBOutlet UILabel *consumption;
//电话卡
@property(weak,nonatomic)IBOutlet UIButton *fiveMonBtn;
@property(weak,nonatomic)IBOutlet UIButton *tenHoBtn;
@property(weak,nonatomic)IBOutlet UIButton *twityHoBtn;
@property(weak,nonatomic)IBOutlet UIButton *FiftyBtn;
//兑换现金
@property(weak,nonatomic)IBOutlet UIButton *cashOneBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashTwoBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashThirdBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashFourBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashFiveBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashSixBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashSevenBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashEightBtn;
@property(weak,nonatomic)IBOutlet UIButton *cashNineBtn;
@property(weak,nonatomic)IBOutlet UIButton *changeNow;//
@property(weak,nonatomic)IBOutlet UILabel *integralLabel;
@property(weak,nonatomic)IBOutlet UILabel *iphoneTopUp;
@property(weak,nonatomic)IBOutlet UILabel *changeMonry;
@property(weak,nonatomic)IBOutlet UILabel *toltalState;
@property(weak,nonatomic)IBOutlet UIImageView *pointsForImage;
@property(nonatomic,copy)NSString *moneyString;
@property(nonatomic,assign)int  moneyCount;
@property(nonatomic,strong)UIButton *cancelBtn;

//@property(nonatomic,strong)UIButton *BackBtn;
@property(nonatomic,strong)UILabel *titleKLab;
@property(nonatomic,strong)UIButton *RightBtn;

@end

@implementation PointsForController

-(instancetype)init{
    if (self = [super init]) {
        self.isPush = YES;
        self.isPresent = NO;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.gk_navTitle =  NSLocalizedString(@"VDPointsText", nil);
//    self.gk_navBarAlpha = 0;
//    self.gk_navigationBar.translucent = NO;
//    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"1A142D"];
//    [self.gk_navigationBar setTitleTextAttributes:@{
//                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
//                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
////    self.gk_navTitleView = self.titleView;
//    self.gk_backStyle = GKNavigationBarBackStyleWhite;
//    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
//    self.gk_navLineHidden = YES;

    self.gk_navigationBar.hidden = YES;
    self.gk_navLineHidden = YES;
    self.gk_navBackgroundColor = kClearColor;

//    self.BackBtn.alpha = 1;
    self.titleKLab.alpha = 1;
    self.RightBtn.alpha = 1;

    [self setupView];

    tabBarVC.tabBar.hidden = YES;
}

- (void)setupView {
    
    CGFloat heightAll = 0.0;
    if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
        heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
    } else if (kiPhone6Plus) {
        heightAll = 736.0f;
    } else {
        heightAll = kiPhone5 ? 568 : 667.0f;
    }
    
    self.iphoneTopUp.text = NSLocalizedString(@"VDTopupText", nil);
    self.changeMonry.text = NSLocalizedString(@"VDRedeemedText", nil);
    self.toltalState.text = self.totalScore;
    self.integralLabel.text = NSLocalizedString(@"VDConsumptionText", nil);
    [self.changeNow setTitle:NSLocalizedString(@"VDImmediatelyText", nil)
                    forState:UIControlStateNormal];

//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 70, 44);
//    [rightBtn setTitle:NSLocalizedString(@"VDChangeText", nil) forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor colorWithHexString:@"BE3462"] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    [rightBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.gk_navigationItem.rightBarButtonItem = rightItem;

    [self.pointsForImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Height_NavBar+80);
        if (kiPhone5) {
            make.top.mas_equalTo(50);
        }
        if (kiPhone6) {
            make.top.mas_equalTo(Height_NavBar);
        }
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(121);
    }];
    if (kiPhone5) {
    
    [self.fiveMonBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(20/375.0f*SCREEN_WIDTH);
        make.top.mas_equalTo(self.iphoneTopUp.mas_bottom).offset(16/667.0f*heightAll);
         make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.tenHoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fiveMonBtn.mas_centerY);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.twityHoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.twityHoBtn.mas_centerY);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
        make.right.mas_equalTo(-20/375.0f*SCREEN_WIDTH);
    }];
    [self.FiftyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20/375.0f*SCREEN_WIDTH);
        make.top.mas_equalTo(self.fiveMonBtn.mas_bottom).offset(16/667.0f*heightAll);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashOneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20/375.0f*SCREEN_WIDTH);
        make.top.mas_equalTo(self.changeMonry.mas_bottom).offset(16/667.0f*heightAll);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashTwoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.cashOneBtn.mas_centerY);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashThirdBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.cashOneBtn.mas_centerY);
        make.top.mas_equalTo(self.twityHoBtn.mas_bottom).offset(114/667.0f*heightAll);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
        make.right.mas_equalTo(-20/375.0f*SCREEN_WIDTH);
    }];
    [self.cashFourBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20/375.0f*SCREEN_WIDTH);
        make.top.mas_equalTo(self.cashThirdBtn.mas_bottom).offset(16/667.0f*heightAll);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashFiveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.self.cashFourBtn.mas_centerY);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashSixBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.cashFiveBtn.mas_centerY);
        make.top.mas_equalTo(self.cashThirdBtn.mas_bottom).offset(16/667.0f*heightAll);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
        make.right.mas_equalTo(-20/375.0f*SCREEN_WIDTH);
    }];
    [self.cashSevenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20/375.0f*SCREEN_WIDTH);
        make.top.mas_equalTo(self.cashSixBtn.mas_bottom).offset(16/667.0f*heightAll);
        if (kiPhone5) {
            make.bottom.mas_equalTo(-90/667.0f*heightAll);
        }
        
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashEightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.cashSevenBtn.mas_centerY);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
    }];
    [self.cashNineBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cashEightBtn.mas_centerY);
        make.width.mas_equalTo(100/375.0f*SCREEN_WIDTH);
        make.height.mas_equalTo(45/667.0f*heightAll);
        make.right.mas_equalTo(-20/375.0f*SCREEN_WIDTH);
    }];
        
    }
    self.fiveMonBtn.layer.masksToBounds = YES;
    self.fiveMonBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.fiveMonBtn.layer.borderWidth = 1.0f;
    self.fiveMonBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    
   
    self.tenHoBtn.layer.masksToBounds = YES;
    self.tenHoBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.tenHoBtn.layer.borderWidth = 1.0f;
    self.tenHoBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    
  
    self.twityHoBtn.layer.masksToBounds = YES;
    self.twityHoBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.twityHoBtn.layer.borderWidth = 1.0f;
    self.twityHoBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    
    
    self.FiftyBtn.layer.masksToBounds = YES;
    self.FiftyBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.FiftyBtn.layer.borderWidth = 1.0f;
    self.FiftyBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
   
    self.cashOneBtn.layer.masksToBounds = YES;
    self.cashOneBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashOneBtn.layer.borderWidth = 1.0f;
    self.cashOneBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
  
    self.cashTwoBtn.layer.masksToBounds = YES;
    self.cashTwoBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashTwoBtn.layer.borderWidth = 1.0f;
    self.cashTwoBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    
   
    self.cashThirdBtn.layer.masksToBounds = YES;
    self.cashThirdBtn.layer.cornerRadius = self.cashThirdBtn.frame.size.height/2.0f;
    self.cashThirdBtn.layer.borderWidth = 1.0f;
    self.cashThirdBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    
   
    self.cashFourBtn.layer.masksToBounds = YES;
    self.cashFourBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashFourBtn.layer.borderWidth = 1.0f;
    self.cashFourBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
   
    self.cashFiveBtn.layer.masksToBounds = YES;
    self.cashFiveBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashFiveBtn.layer.borderWidth = 1.0f;
    self.cashFiveBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
   
    self.cashSixBtn.layer.masksToBounds = YES;
    self.cashSixBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashSixBtn.layer.borderWidth = 1.0f;
    self.cashSixBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
   
    self.cashSevenBtn.layer.masksToBounds = YES;
    self.cashSevenBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashSevenBtn.layer.borderWidth = 1.0f;
    self.cashSevenBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
  
    self.cashEightBtn.layer.masksToBounds = YES;
    self.cashEightBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashEightBtn.layer.borderWidth = 1.0f;
    self.cashEightBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
  
    self.cashNineBtn.layer.masksToBounds = YES;
    self.cashNineBtn.layer.cornerRadius = self.fiveMonBtn.height/2.0f;
    self.cashNineBtn.layer.borderWidth = 1.0f;
    self.cashNineBtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    
    [self.changeNow mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(13/375.0f*SCREEN_WIDTH);
         make.right.mas_equalTo(-13/375.0f*SCREEN_WIDTH);
         make.height.mas_equalTo(45/667.0f*heightAll);
        
        if (kiPhone5) {
            make.bottom.mas_equalTo(-35/667.0f*heightAll);
        } else {
             make.bottom.mas_equalTo(-80/667.0f*heightAll);
        }
    }];
    self.changeNow.layer.masksToBounds = YES;
    self.changeNow.layer.cornerRadius = 8.0f;
    self.changeNow.layer.borderWidth = 1.0f;
    self.changeNow.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    self.cancelBtn.alpha = 1;
}

#pragma mark —— 点击事件
- (void)backBtnClickEvent:(UIButton *)sender {
    if (self.isPush &&
        !self.isPresent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (!self.isPush &&
              self.isPresent){
        [self dismissViewControllerAnimated:YES
                                    completion:^{
            NSLog(@"1234");
        }];
    }
}

- (void)changeBtnAction:(UIButton *)click {
    ChangeHistoryController *change = [[ChangeHistoryController alloc]init];
    [self.navigationController pushViewController:change animated:YES];
}

-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (IBAction)fiveAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 2;
    self.moneyString = @"50.000";
    
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
    
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    self.FiftyBtn.backgroundColor = kClearColor;

    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
//        self.tenHoBtn.userInteractionEnabled = NO;

}

- (IBAction)tenAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 3;
    self.moneyString = @"100.000";

    self.fiveMonBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    self.FiftyBtn.backgroundColor = kClearColor;
    
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor =kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor =kClearColor;
}
- (IBAction)twityAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 4;
    self.moneyString = @"200.000";

    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.FiftyBtn.backgroundColor = kClearColor;
    
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
}

- (IBAction)fiftyAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 5;
    self.moneyString = @"500.000";

    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    
    self.cashOneBtn.backgroundColor =kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor =kClearColor;
   
}
- (IBAction)OneHAction:(UIButton *)sender {
    
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 6;
    self.moneyString = @"1.000.000";

    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor =kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor =kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
}
- (IBAction)twityCash:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 7;
    self.moneyString = @"2.000.000";
    
    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor =kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor =kClearColor;
    self.cashFiveBtn.backgroundColor =kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
}

- (IBAction)thirdCash:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
     self.moneyCount = 8;
    self.moneyString = @"3.000.000";
        
    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor =kClearColor;
     self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
}

- (IBAction)fiveCashAction:(UIButton *)sender {
  
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
     self.moneyCount = 9;
    self.moneyString = @"5.000.000";
    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor =kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
     self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor =kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;

}

- (IBAction)tenCashAction:(UIButton *)sender {
  
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
     self.moneyCount = 10;
    self.moneyString = @"10.000.000";

    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
}

- (IBAction)twityCashAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
     self.moneyCount = 20;
    self.moneyString = @"20.000.000";

    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor =kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor = kClearColor;
}

- (IBAction)thirdCashAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
     self.moneyCount = 30;
    self.moneyString = @"30.000.000";
    
    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor =kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor =kClearColor;
    self.cashNineBtn.backgroundColor =kClearColor;
}

- (IBAction)fourCashAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
     self.moneyCount = 40;
    self.moneyString = @"40.000.000";
    self.fiveMonBtn.backgroundColor =kClearColor;
    self.tenHoBtn.backgroundColor =kClearColor;
    self.twityHoBtn.backgroundColor = kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor = kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashNineBtn.backgroundColor =kClearColor;
}

- (IBAction)fifityCashAction:(UIButton *)sender {
    [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    self.moneyCount = 50;
    self.moneyString = @"50.000.000";
      
    self.fiveMonBtn.backgroundColor = kClearColor;
    self.tenHoBtn.backgroundColor = kClearColor;
    self.twityHoBtn.backgroundColor =kClearColor;
    
    self.FiftyBtn.backgroundColor = kClearColor;
    self.cashOneBtn.backgroundColor = kClearColor;
    self.cashTwoBtn.backgroundColor = kClearColor;
    self.cashThirdBtn.backgroundColor = kClearColor;
    self.cashFourBtn.backgroundColor = kClearColor;
    self.cashFiveBtn.backgroundColor =kClearColor;
    self.cashSixBtn.backgroundColor = kClearColor;
    self.cashSevenBtn.backgroundColor = kClearColor;
    self.cashEightBtn.backgroundColor = kClearColor;
}

- (IBAction)changeAction:(UIButton *)sender {
    if (self.moneyCount >= 6) {
        RedeemedCashController *redeemed = [[RedeemedCashController alloc]init];
        redeemed.money = self.moneyString;
        [self.navigationController pushViewController:redeemed
                                             animated:YES];
     
    } else if (self.moneyCount < 6 &&
               self.moneyCount >0) {
        TopUpViewController *top = [[TopUpViewController alloc]init];
        top.integralString = self.moneyString;
        [self.navigationController pushViewController:top
                                             animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDselectrewardText", nil)];
    }
}

#pragma mark —— lazyLoad
-(UILabel *)titleKLab{
    if (!_titleKLab) {
        _titleKLab = UILabel.new;
        _titleKLab.textAlignment = NSTextAlignmentCenter;
        _titleKLab.attributedText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPointsText", nil)
                                                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:17],
                                                                                        NSForegroundColorAttributeName : kWhiteColor}];
        [self.view addSubview:_titleKLab];
        [_titleKLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 4, SCALING_RATIO(30)));
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(rectOfStatusbar);;
        }];
    }return _titleKLab;
}

-(UIButton *)RightBtn{
    if (!_RightBtn) {
        _RightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_RightBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDChangeText", nil) 
                                                                             attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial"
                                                                                                                               size: 12],
                                                                                          NSForegroundColorAttributeName: [UIColor colorWithRed:190/255.0
                                                                                                                                          green:52/255.0
                                                                                                                                           blue:98/255.0
                                                                                                                                          alpha:1.0]}]
                             forState:UIControlStateNormal];
        [_RightBtn addTarget:self
                      action:@selector(changeBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_RightBtn];
        [_RightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(rectOfStatusbar);
            make.right.equalTo(self.view).offset(SCALING_RATIO(-15));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(60), SCALING_RATIO(30)));
        }];
    }return _RightBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDBack", nil)
                                                                              attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial"
                                                                                                                                size: 17],
                                                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:229/255.0
                                                                                                                                           green:229/255.0
                                                                                                                                            blue:229/255.0
                                                                                                                                           alpha:1.0]}]
                              forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor colorWithRed:128/255.0
                                                     green:128/255.0
                                                      blue:128/255.0
                                                      alpha:1.0];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 8.0f;
        _cancelBtn.layer.borderWidth = 1.0f;
        [_cancelBtn addTarget:self
                       action:@selector(backBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.borderColor = kWhiteColor.CGColor;
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.changeNow.mas_bottom).offset(SCALING_RATIO(10));
            make.size.equalTo(self.changeNow);
        }];

    }return _cancelBtn;
}

//-(UIButton *)BackBtn{
//    if (!_BackBtn) {
//        _BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _BackBtn.frame = CGRectMake(SCALING_RATIO(15),
//                                    SCALING_RATIO(30) + (IS_IPHONE_X ? SCALING_RATIO(20) : 0),
//                                    SCALING_RATIO(60),
//                                    SCALING_RATIO(30));
//        [_BackBtn setImage:[UIImage imageNamed:@"icon_return"]
//                  forState:UIControlStateNormal];
//        [_BackBtn setTitle:NSLocalizedString(@"VDBack", nil)
//                  forState:UIControlStateNormal];
//        [_BackBtn addTarget:self
//                     action:@selector(backBtnClickEvent:)
//           forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_BackBtn];
//        [_BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(rectOfStatusbar);
//            make.left.equalTo(self.view).offset(SCALING_RATIO(15));
//            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(60), SCALING_RATIO(30)));
//        }];
//    }return _BackBtn;
//}


@end
