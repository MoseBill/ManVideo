//
//  RegisteredViewController.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "RegisteredViewController.h"
#import "RegisteredViewController+VM.h"
#import "OrdinaryViewController.h"

@interface RegisteredViewController ()<UITextFieldDelegate>

@property(weak,nonatomic)IBOutlet UIView *iphoneView;
@property(weak,nonatomic)IBOutlet UIView *codeView;
@property(weak,nonatomic)IBOutlet UIButton *coedBtn;
@property(weak,nonatomic)IBOutlet UIButton *loginBtn;
@property(weak,nonatomic)IBOutlet UIButton *registeredBtn;
@property(weak,nonatomic)IBOutlet UIButton *codeVerBtn;
@property(weak,nonatomic)IBOutlet UILabel *userLabel;

@property(nonatomic,strong)NSMutableDictionary *dict;
@property(nonatomic,copy)NSString *ipStr;

@end

@implementation RegisteredViewController

-(instancetype)init{
    if (self = [super init]) {
        @weakify(self);
        self.UnknownNetWorking = ^{
//            @strongify(self)
        };
        self.NotReachableNetWorking = ^{
//            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
        };
        self.ReachableViaWWANNetWorking = ^{
            @strongify(self)
            [self loadDataView];
        };
        self.ReachableViaWiFiNetWorking = ^{
            @strongify(self)
            [self loadDataView];
        };
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRequestFinish = NO;//刚进入界面是没有完成请求数据的
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
   
    [self setupView];
}

- (void)setupView {
    
    self.userLabel.text = NSLocalizedString(@"VDUserRegistrationText", nil);
    [self.coedBtn setTitle:NSLocalizedString(@"VDCodeNumberText", nil)
                  forState:UIControlStateNormal];
    [self.registeredBtn setTitle:NSLocalizedString(@"VDTheRegisteredText", nil)
                        forState:UIControlStateNormal];
    [self.loginBtn setTitle:NSLocalizedString(@"VDTheLoginText", nil)
                   forState:UIControlStateNormal];

    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];

    self.iphoneView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.codeView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDPhoneNumberText", nil)
                                                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                            NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                            green:156/255.0
                                                                                                                                             blue:157/255.0
                                                                                                                                            alpha:1.0]}];
    NSMutableAttributedString *stringPassword = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDVerification", nil)
                                                                                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                    NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                    green:156/255.0
                                                                                                                                                     blue:157/255.0
                                                                                                                                                    alpha:1.0]}];
    self.iphoneTextField.attributedPlaceholder = string;
    self.codePassword.attributedPlaceholder = stringPassword;
    self.coedBtn.backgroundColor = [UIColor colorWithHexString:@"19132B"];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 10.0f;
    self.registeredBtn.layer.masksToBounds = YES;
    self.registeredBtn.layer.cornerRadius  = 10.0f;

    NSMutableAttributedString *invitationString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDinvitationCode", nil)
                                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                      NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                      green:156/255.0
                                                                                                                                                       blue:157/255.0
                                                                                                                                                      alpha:1.0]}];
    self.codeInvitation.attributedPlaceholder = invitationString;
    self.iphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeInvitation.keyboardType = UIKeyboardTypeNamePhonePad;
//    self.codePassword.keyboardType = UIKeyboardTypeNamePhonePad;
    //2分钟
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(60 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       @strongify(self)
                       if (self.codePassword.text.length == 0) {
                           [OrdinaryViewController pushFromVC:self
                                                requestParams:nil
                                                      success:^(id  _Nonnull data) {}
                                                     animated:YES];
        } 
    });
}
#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)backBtnClickEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registeredClick:(UIButton *)sender {
    [self register];
}

- (IBAction)codeActionClick:(UIButton *)sender {

    [self AFNReachability];
    @weakify(self)
    sender.selected = !sender.selected;
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)

        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
              @weakify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                //设置按钮的样式
                [self.coedBtn setTitle:NSLocalizedString(@"VDCodeNumberText", nil)
                              forState:UIControlStateNormal];
                [self.coedBtn setTitleColor:kWhiteColor
                                   forState:UIControlStateNormal];
                self.coedBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                //设置按钮显示读秒效果
                [self.coedBtn setTitle:[NSString stringWithFormat:@"%.2ds", seconds]
                              forState:UIControlStateNormal];
                [self.coedBtn setTitleColor:kWhiteColor
                                   forState:UIControlStateNormal];
                self.coedBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)LoginAction:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

#pragma mark —— lazyLoad
-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = NSMutableDictionary.dictionary;
    }return _dict;
}


@end
