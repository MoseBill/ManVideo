//
//  ChangePasswordController.m
//  Clipyeu ++
//
//  Created by Josee on 03/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChangePasswordController.h"
#import "ChangePasswordController+VM.h"

@interface ChangePasswordController ()

@property(weak,nonatomic)IBOutlet UITextField *passwordNewTextField;
@property(weak,nonatomic)IBOutlet UILabel *changeLabel;
@property(weak,nonatomic)IBOutlet UIButton *uploadBtn;
@property(nonatomic,copy)NSString *passwordString;

@end

@implementation ChangePasswordController

-(void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    ChangePasswordController *vc = [[ChangePasswordController alloc]initWithRequestParams:requestParams
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
                                               object:self.passwordNewField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.passwordNewField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValueCodeVert:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.passwordNewTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotificationCodeVert:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.passwordNewTextField];
}

- (void)setupView {
    
    self.changeLabel.text = NSLocalizedString(@"VDUpdatePassword", nil);//修改密码
    [self.uploadBtn setTitle:NSLocalizedString(@"VDSubmit", nil)//提交
                    forState:UIControlStateNormal];
    self.passwordNewField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDNewPassword", nil)//输入您的新密码
                                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                      NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                      green:156/255.0
                                                                                                                                                       blue:157/255.0
                                                                                                                                                      alpha:1.0]}];

    self.passwordNewTextField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPasswordNew", nil)//确定您的新密码
                                                                                             attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size: 15],
                                                                                                          NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                          green:156/255.0
                                                                                                                                                           blue:157/255.0
                                                                                                                                                          alpha:1.0]}];
     
    self.uploadBtn.layer.masksToBounds = YES;
    self.uploadBtn.layer.cornerRadius = 8.0f;
}
#pragma mark —— 通知监听
- (void)textFieldDidChangeValue:(NSNotification *)center {
    UITextField *sender = (UITextField *)[center object];
    self.passwordString = sender.text;
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

-(void)keyboardWillHideNotification:(NSNotification *)noti{
    NSLog(@"1234");
}

-(void)keyboardWillHideNotificationCodeVert:(NSNotification *)noti{
    NSLog(@"1234");
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (IBAction)uploadAction:(UIButton *)sender {
    if (self.passwordNewTextField.text &&
        self.passwordNewField.text) {
        [self upload];
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"VDPassword", nil)];
    }
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

@end
