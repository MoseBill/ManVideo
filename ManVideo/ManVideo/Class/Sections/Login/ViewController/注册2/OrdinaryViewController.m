//
//  OrdinaryViewController.m
//  Clipyeu ++
//
//  Created by Josee on 29/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "OrdinaryViewController.h"
#import "OrdinaryViewController+VM.h"

@interface OrdinaryViewController ()


@property(weak,nonatomic)IBOutlet UIButton *loginBtn;
@property(weak,nonatomic)IBOutlet UIButton *registeredBtn;
@property(weak,nonatomic)IBOutlet UILabel *userLabel;


@end

@implementation OrdinaryViewController

-(void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    OrdinaryViewController *vc = [[OrdinaryViewController alloc]initWithRequestParams:requestParams
                                                                              success:block];
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block{
    if (self = [super init]) {
        self.isPush = NO;
        self.isPresent = YES;
        self.requestParams = requestParams;
        self.successBlock = block;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.gk_navLineHidden = YES;
    //    self.gk_navTitleView = self.titleView;
    
    self.userLabel.text = NSLocalizedString(@"VDUserRegistrationText", nil);//用户注册登录
    [self.registeredBtn setTitle:NSLocalizedString(@"VDTheRegisteredText", nil)
                        forState:UIControlStateNormal];//注册
    [self.loginBtn setTitle:NSLocalizedString(@"VDTheLoginText", nil)
                   forState:UIControlStateNormal];//登录
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];


    self.iphoneFieldText.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPhoneNumberText", nil)
                                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                     NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                     green:156/255.0
                                                                                                                                                      blue:157/255.0
                                                                                                                                                     alpha:1.0]}];//输入您的手机号码
    self.codeFieldText.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDmima", nil)
                                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                   NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                   green:156/255.0
                                                                                                                                                    blue:157/255.0
                                                                                                                                                   alpha:1.0]}];//输入密码
    
    self.passwordNewField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDqueding", nil)
                                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                      NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                      green:156/255.0
                                                                                                                                                       blue:157/255.0
                                                                                                                                                      alpha:1.0]}];//确认输入密码
    self.InviteCodeField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDinvitationCode", nil)
                                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                     NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                     green:156/255.0
                                                                                                                                                      blue:157/255.0
                                                                                                                                                     alpha:1.0]}];//邀请码(*选填)
    
    self.iphoneFieldText.keyboardType = UIKeyboardTypeNumberPad;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 10.0f;
    self.registeredBtn.layer.masksToBounds = YES;
    self.registeredBtn.layer.cornerRadius = 10.0f;
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (IBAction)loginAction:(UIButton *)sender {
}

- (IBAction)registeredAction:(UIButton *)sender {
    [self loadData];
}

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

#pragma mark —— lazyLoad


@end
