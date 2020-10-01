//
//  VDLoginViewController.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDLoginViewController.h"
#import "RegisteredViewController.h"
#import "ForgetViewController.h"
#import "LoginModel.h"
#import "SocketRocketUtility.h"
#import "ZHKeyChainManager.h"
#import "LZTabBarVC.h"
#import "OrdinaryViewController.h"
#import "VDLoginViewController+VM.h"

extern LZTabBarVC *tabBarVC;

@interface VDLoginViewController ()<UITextFieldDelegate>
@property(weak,nonatomic)IBOutlet UIView *iphoneView;
@property(weak,nonatomic)IBOutlet UIView *passwordView;
@property(weak,nonatomic)IBOutlet UIButton *loginbtn;
@property(weak,nonatomic)IBOutlet UIButton *forgetPassword;
@property(weak,nonatomic)IBOutlet UILabel *userTitle;
@property(nonatomic,strong)RegisteredViewController *resgister;
@property(nonatomic,strong)NSMutableDictionary *dict;


@end

@implementation VDLoginViewController

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    
    VDLoginViewController *vc = VDLoginViewController.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;

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

-(instancetype)init{
    if (self = [super init]) {
        self.isPush = NO;
        self.isPresent = YES;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
//    self.gk_navLineHidden = YES;
//    self.gk_backStyle =  GKNavigationBarBackStyleWhite;

    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backBtn];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.gk_navigationBar.hidden = YES;
   self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
}

- (void)setupView {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPhoneNumberText", nil)
                                                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                            NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                            green:156/255.0
                                                                                                                                             blue:157/255.0
                                                                                                                                            alpha:1.0]}];
    NSMutableAttributedString *stringPassword = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPasswordNumberText", nil)
                                                                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                    green:156/255.0
                                                                                                                                                     blue:157/255.0
                                                                                                                                                    alpha:1.0]}];
    self.iphoneTextField.attributedPlaceholder = string;
    self.iphoneTextField.delegate = self;
    self.iphoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //KKK
//    self.iphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.loginbtn.layer.masksToBounds = YES;
    self.loginbtn.layer.cornerRadius = 10.0f;
    [self.loginbtn setTitle:NSLocalizedString(@"VDTheLoginText", nil)
                   forState:UIControlStateNormal];
    self.passwordTextField.attributedPlaceholder = stringPassword;
    self.passwordTextField.secureTextEntry = YES;
    self.userTitle.text = NSLocalizedString(@"VDUserRegistrationText", nil);
    [self.forgetPassword setTitle:NSLocalizedString(@"VDForgotNumberText", nil)
                         forState:UIControlStateNormal];
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 10.0f;
    [self.registerBtn setTitle:NSLocalizedString(@"VDTheRegisteredText", nil)
                      forState:UIControlStateNormal];
    self.iphoneView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.passwordView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (void)backBtnClickEvent:(UIButton *)sender {
    if (self.isPush &&
        !self.isPresent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (!self.isPush &&
              self.isPresent){
        tabBarVC.selectedIndex = 0;//跳到首页
        [self dismissViewControllerAnimated:YES
                                    completion:^{
            NSLog(@"1234");
        }];
    }
}

- (IBAction)resgisteredClick:(UIButton *)sender {
//    [self.navigationController pushViewController:self.resgister
//                                         animated:YES];
    @weakify(self)
    [OrdinaryViewController pushFromVC:self_weak_
                         requestParams:nil
                               success:^(id  _Nonnull data) {}
                              animated:YES];
}

- (IBAction)forwordBtn:(UIButton *)sender {
    @weakify(self)
    [ForgetViewController pushFromVC:self_weak_
                       requestParams:nil
                             success:^(id  _Nonnull data) {}
                            animated:YES];
}

- (IBAction)LoginAction:(UIButton *)sender {
    [self login];
}

-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark —— lazyLoad
-(RegisteredViewController *)resgister{
    if (!_resgister) {
        _resgister = RegisteredViewController.new;
    }return _resgister;
}

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = NSDateFormatter.new;
        [_formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }return _formatter;
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = NSMutableDictionary.new;
    }return _dict;
}


@end
