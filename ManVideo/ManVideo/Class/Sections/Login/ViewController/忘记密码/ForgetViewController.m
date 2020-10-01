//
//  ForgetViewController.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ForgetViewController.h"
#import "ForgetViewController+VM.h"

@interface ForgetViewController ()

@property(weak,nonatomic)IBOutlet UIView *iphoneView;
@property(weak,nonatomic)IBOutlet UIView *codeView;
@property(weak,nonatomic)IBOutlet UIView *passwordView;
@property(weak,nonatomic)IBOutlet UIView *determineNew;
@property(weak,nonatomic)IBOutlet UITextField *passwordDetermine;
@property(weak,nonatomic)IBOutlet UITextField *passNewTextField;
@property(weak,nonatomic)IBOutlet UIButton *codeBtn;
@property(weak,nonatomic)IBOutlet UIButton *pushBtn;
@property(weak,nonatomic)IBOutlet UILabel *forgetPassword;

@end

@implementation ForgetViewController

-(void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    ForgetViewController *vc = [[ForgetViewController alloc] initWithRequestParams:requestParams
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
        self.successBlock = block;
        self.requestParams = requestParams;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
//    self.gk_navTitleView = self.titleView;

    [self NSNotification];
    [self setupView];
}

-(void)NSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.passwordTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValueCodeVert:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.passNewTextField];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHideNotification:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:self.passwordTextField];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHideNotificationCodeVert:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:self.passNewTextField];
}

- (void)setupView {
    self.forgetPassword.text = NSLocalizedString(@"VDForgetPassword", nil);//忘记密码
    [self.pushBtn setTitle:NSLocalizedString(@"VDSubmit", nil)//提交
                  forState:UIControlStateNormal];
    self.iphoneView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.determineNew.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.codeView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.passwordView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.passwordDetermine.backgroundColor = [UIColor colorWithHexString:@"19132B"];

    self.iphoneTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPhoneNumberText", nil)
                                                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                     NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                     green:156/255.0
                                                                                                                                                      blue:157/255.0
                                                                                                                                                     alpha:1.0]}];//输入您的手机号码
    self.codeTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDVerification", nil)
                                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                   NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                   green:156/255.0
                                                                                                                                                    blue:157/255.0
                                                                                                                                                   alpha:1.0]}];//输入您的验证码
    self.passwordTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDNewPassword", nil)
                                                                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                       NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                       green:156/255.0
                                                                                                                                                        blue:157/255.0
                                                                                                                                                       alpha:1.0]}];//输入您的新密码
    //    self.passwordDetermine.attributedPlaceholder = newPassword;
    self.passNewTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPasswordNew", nil)
                                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                      NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                      green:156/255.0
                                                                                                                                                       blue:157/255.0
                                                                                                                                                      alpha:1.0]}];//确定您的新密码
    self.codeBtn.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.iphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.pushBtn.layer.masksToBounds = YES;
    self.pushBtn.layer.cornerRadius = 10.0f;
    [self.codeBtn setTitle:NSLocalizedString(@"VDCodeNumberText", nil)
                  forState:UIControlStateNormal];//获取验证码
}
#pragma mark —— 通知监听
- (void)textFieldDidChangeValue:(NSNotification *)center {
    UITextField *sender = (UITextField *)[center object];
    NSString *tempPwdStr = sender.text;
    sender.text = @"";
    sender.secureTextEntry = YES;
    sender.text = tempPwdStr;
}

- (void)textFieldDidChangeValueCodeVert:(NSNotification *)noti {
    UITextField *sender = (UITextField *)[noti object];
    NSString *tempPwdStr = sender.text;
    sender.text = @"";
    sender.secureTextEntry = YES;
    sender.text = tempPwdStr;
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

- (IBAction)uploadAction:(UIButton *)sender {
    [self upload];
}

-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (IBAction)codeAction:(UIButton *)sender {
    [self loadDataView];
    @weakify(self)
    sender.selected = !sender.selected;
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)
        @weakify(self)
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                 @strongify(self)
                //设置按钮的样式
                [self.codeBtn setTitle:NSLocalizedString(@"VDCodeNumberText", nil)
                              forState:UIControlStateNormal];//获取验证码
                [self.codeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                 @strongify(self)
                //设置按钮显示读秒效果
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%.2ds", seconds]
                              forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark —— lazyLoad

@end
