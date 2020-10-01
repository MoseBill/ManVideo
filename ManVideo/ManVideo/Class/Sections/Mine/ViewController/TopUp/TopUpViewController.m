//
//  TopUpViewController.m
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "TopUpViewController.h"
#import "TopUpViewController+VM.h"

@interface TopUpViewController ()

@property(weak,nonatomic)IBOutlet UITextField *iphoneTextFild;
@property(weak,nonatomic)IBOutlet UITextField *codeTextFild;
@property(weak,nonatomic)IBOutlet UIView *iphoneView;
@property(weak,nonatomic)IBOutlet UIButton *iphoneCardBtn;
@property(weak,nonatomic)IBOutlet UIButton *PrepaidBtn;
@property(weak,nonatomic)IBOutlet UIButton *codeBtn;

@end

@implementation TopUpViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.gk_navTitle = NSLocalizedString(@"VDphoneText", nil);
    self.gk_navBarAlpha = 0;
    self.gk_navigationBar.translucent = NO;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"1A142D"];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor,
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold"
                                                                                          size:17]}];
//    self.gk_navTitleView = self.titleView;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;

    [self setupView];
}
#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)setupView {
    
    [self.PrepaidBtn setTitle:NSLocalizedString(@"VDConfirmText", nil)
                     forState:UIControlStateNormal];
    [self.codeBtn setTitle:NSLocalizedString(@"VDCodeNumberText", nil)
                  forState:UIControlStateNormal];
    [self.iphoneView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Height_NavBar + 60);
         make.left.mas_equalTo(39);
        make.right.mas_equalTo(-39);
        make.height.mas_equalTo(44);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.iphoneTextFild];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.iphoneTextFild];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValueCode:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.codeTextFild];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotificationCode:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.codeTextFild];
    
    NSAttributedString *iphoneString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"VDPhoneNumberText", nil)
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9C9C9D"],
                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"VDShortMessage", nil)
                                                                     attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9C9C9D"],
                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];

    self.iphoneTextFild.attributedPlaceholder = iphoneString;
    self.codeTextFild.attributedPlaceholder = nameString;
    
    self.iphoneCardBtn.layer.masksToBounds = YES;
    self.iphoneCardBtn.layer.cornerRadius = 8.0f;
    
}

#pragma mark ===================== 监听===================================
- (void)textFieldDidChangeValue:(NSNotification *)notification{
    UITextField *sender = (UITextField *)[notification object];
    sender.keyboardType = UIKeyboardTypeNumberPad;
    sender.clearButtonMode = UITextFieldViewModeAlways;
    // 获取键盘基本信息（动画时长与键盘高度）
//    NSDictionary *userInfo = [notification userInfo];
//    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    DLog(@"输入手机号%@",sender.text);
    self.iphoneString = sender.text;
}

- (void)textFieldDidChangeValueCode:(NSNotification *)notification{
    UITextField *sender = (UITextField *)[notification object];
    sender.clearButtonMode = UITextFieldViewModeAlways;
    DLog(@"输入验证码%@",sender.text);
    self.codeString = sender.text;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    // 获得键盘动画时长
    //    NSDictionary *userInfo   = [notification userInfo];
    //    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)keyboardWillHideNotificationCode:(NSNotification *)notification {
    // 获得键盘动画时长
//    NSDictionary *userInfo   = [notification userInfo];
//    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
}

- (IBAction)codeBtn:(UIButton *)sender {}

- (IBAction)iphoneCard:(UIButton *)sender {
    [self netWorking];
}

#pragma mark —— lazyLoad
-(CashSuccessController *)cashSuccess{
    if (!_cashSuccess) {
        _cashSuccess = CashSuccessController.new;
    }return _cashSuccess;
}

@end
