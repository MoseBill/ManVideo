//
//  GKDYBaseViewController.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "GKDYBaseViewController+VM.h"

@interface GKDYBaseViewController ()<JXCategoryListContentViewDelegate>

@property(nonatomic,strong)UIAlertController *alertController;

@end

@implementation GKDYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecJXCategoryViewDelegateognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate =self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;   //状态栏字体白色 UIStatusBarStyleDefault黑色
}

#pragma mark —— UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return NO;
}

#pragma mark —— JXCategoryListContentViewDelegate
/**
 如果列表是VC，就返回VC.view
 如果列表是View，就返回View自己

 @return 返回列表视图
 */
- (UIView *)listView{
    return self.view;
}

- (void)listDidAppear{
    NSLog(@"");
}

- (void)AFNReachability {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    if (!_isRequestFinish) {
        //如果没有请求完成就检测网络
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    DLog(@"未知网络");
                    if (self.UnknownNetWorking) {
                        self.UnknownNetWorking();
                    }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    DLog(@"没有网络");
                    if (self.NotReachableNetWorking) {
                        self.NotReachableNetWorking();
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    DLog(@"3G网络");//不是WiFi的网络都会识别成3G网络.比如2G/3G/4G网络
                    if (self.ReachableViaWWANNetWorking) {
                        self.ReachableViaWWANNetWorking();
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    DLog(@"WIFI网络");
                    if (self.ReachableViaWiFiNetWorking) {
                        self.ReachableViaWiFiNetWorking();
                    }
                    break;
                default:
                    break;
            }}];
    }
    [manager startMonitoring];
}

-(void)showAlertViewTitle:(NSString *)title
                  message:(NSString *)message
       alertBtnAction:(NSArray *)alertBtnActionArr{
    @weakify(self)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < alertBtnActionArr.count; i++) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             @strongify(self)
                                                             [self performSelector:NSSelectorFromString((NSString *)alertBtnActionArr[i])
                                                                        withObject:Nil];
        }];
        [alertController addAction:okAction];
    }
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

-(void)showLoginAlertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login"
                                                                             message:@"Enter Your Account Info Below"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self)
        textField.placeholder = @"username";
        [textField addTarget:self
                      action:@selector(alertUserAccountInfoDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self)
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
        [textField addTarget:self
                      action:@selector(alertUserAccountInfoDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSLog(@"Cancel Action");
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            UITextField *userName = alertController.textFields.firstObject;
                                                            UITextField *password = alertController.textFields.lastObject;
                                                            // 输出用户名 密码到控制台
                                                            NSLog(@"username is %@, password is %@",userName.text,password.text);
    }];
    loginAction.enabled = NO;   // 禁用Login按钮
    [alertController addAction:cancelAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

//跳转系统设置
-(void)pushToSysConfig{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)alertUserAccountInfoDidChange:(UITextField *)sender{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController){
        self.userName = alertController.textFields.firstObject.text;
        self.password = alertController.textFields.lastObject.text;
        UIAlertAction *loginAction = alertController.actions.lastObject;
        if (self.userName.length > 3 &&
            self.password.length > 5){
            // 用户名大于3位，密码大于5位时，启用Login按钮。
            loginAction.enabled = YES;
            [self login];
        }else{
            // 用户名小于等于3位，密码小于等于5位，禁用Login按钮。
            loginAction.enabled = NO;
        }
    }
}

-(void)refreshAction:(UIButton *)sender{
     NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark —— lazyLoad
-(UILabel *)noContent{
    if (!_noContent) {
        _noContent = [UILabel new];
        _noContent.text = NSLocalizedString(@"VDcontent", nil);
        _noContent.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _noContent.font = [UIFont systemFontOfSize:15.0f];
        _noContent.textAlignment = NSTextAlignmentCenter;
        _noContent.hidden = YES;
        [self.view addSubview:_noContent];
        [_noContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(100/667.0f * SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(SCALING_RATIO(100));
        }];
    }return _noContent;
}

-(UIImageView *)noNetImage{
    if (!_noNetImage) {
        _noNetImage = UIImageView.new;
        _noNetImage.image = [UIImage imageNamed:@"网络异常"];
        _noNetImage.hidden = YES;
        [self.view addSubview:_noNetImage];
        [_noNetImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(179/667.0f*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(99);
            make.height.mas_equalTo(114);
        }];
    }return _noNetImage;
}

-(UILabel *)nonetLabel{
    if (!_nonetLabel) {
        _nonetLabel = UILabel.new;
        _nonetLabel.text = NSLocalizedString(@"VDNetWorkStatus", nil);
        _nonetLabel.textColor = [UIColor colorWithHexString:@"CF1252"];
        _nonetLabel.font = [UIFont systemFontOfSize:14.0f];
        _nonetLabel.textAlignment = NSTextAlignmentCenter;
        _nonetLabel.hidden = YES;
        [self.view addSubview:_nonetLabel];
        [_nonetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.noNetImage.mas_bottom).offset(17);
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(19);
        }];
    }return _nonetLabel;
}

-(UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitle:NSLocalizedString(@"VDRefreshAction", nil)
                     forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:kWhiteColor
                          forState:UIControlStateNormal];
        [_refreshBtn setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
        _refreshBtn.hidden = YES;
        [_refreshBtn addTarget:self
                        action:@selector(refreshAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_refreshBtn];
        _refreshBtn.layer.masksToBounds = YES;
        _refreshBtn.layer.cornerRadius = 10.0f;
        [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nonetLabel.mas_bottom).offset(68/667.0f*SCREEN_HEIGHT);
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(190);
            make.height.mas_equalTo(44);
        }];
    }return _refreshBtn;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn.titleLabel sizeToFit];
        _backBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_backBtn setImage:kIMG(@"icon_return")
                  forState:UIControlStateNormal];
        [_backBtn setTitle:NSLocalizedString(@"VDBack", nil)
                  forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(backBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(SCALING_RATIO(15) + rectOfStatusbar);
            make.left.equalTo(self.view).offset(SCALING_RATIO(15));
        }];
    }return _backBtn;
}

-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"子类需要覆写实现");
}



@end
