//
//  InviteFriendsController.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "InviteFriendsController.h"
#import "InviteFriendsController+VM.h"


extern LZTabBarVC *tabBarVC;

@interface InviteFriendsController()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UILabel *myCode;
@property(nonatomic,strong)UILabel *shareLabel;
@property(nonatomic,strong)UIImageView *bacgroudView;
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UIButton *inviteBtn;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,copy)NSString *urlString;

@end

@implementation InviteFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navTitle =  NSLocalizedString(@"VDInviteText", nil);
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
   
    [self setupView];
    [self loadDatanetWork];
}

- (void)setupView {
    
    [self.view addSubview:self.bacgroudView];
    [self.view addSubview:self.headerImage];
     [self.view addSubview:self.myCode];
    [self.view addSubview:self.codeLabel];
    [self.view addSubview:self.inviteBtn];
    [self.view addSubview:self.shareLabel];
 
    [self.bacgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(Height_NavBar);
         make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(91/667.0f*HEIGHT_SCREEN);
    }];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(111/667.0f*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.view);
         make.width.mas_equalTo(75);
        make.height.mas_equalTo(75);
    }];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius =75/2.0f;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *headerImage = [user objectForKey:@"headerImage"];
       NSString *imageString = [NSString stringWithFormat:@"%@%@",REQUEST_URL,headerImage];
    if (headerImage) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                            placeholderImage:[UIImage imageNamed:@"userImage"]];
    }
    [self.myCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.headerImage.mas_centerX);
        make.top.mas_equalTo(self.self.headerImage.mas_bottom).offset(23);
//         make.width.mas_equalTo(93);
        make.height.mas_equalTo(16);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.myCode.mas_bottom).offset(23);
        make.centerX.mas_equalTo(self.myCode.mas_centerX);
        make.height.mas_equalTo(13);
    }];
    
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view);
        make.right.mas_equalTo(-13);
         make.left.mas_equalTo(13);
    }];
    self.inviteBtn.layer.masksToBounds = YES;
    self.inviteBtn.layer.cornerRadius = 10.0f;
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.inviteBtn.mas_bottom).offset(10);
          make.width.mas_equalTo(223);
        make.centerX.mas_equalTo(self.view);
//        make.height.mas_equalTo(13);
    }];
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark —— lazyLoad
- (UIImageView *)bacgroudView {
    if (!_bacgroudView) {
        _bacgroudView = [UIImageView new];
        _bacgroudView.image = [UIImage imageNamed:@"图层 930"];
    }return _bacgroudView;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
        _headerImage.image = [UIImage imageNamed:@"userImage"];
    }return _headerImage;
}

- (UIButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [UIButton new];
        [_inviteBtn setTitle:NSLocalizedString(@"VDInviteText", nil) forState:UIControlStateNormal];
        [_inviteBtn setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
        [_inviteBtn addTarget:self action:@selector(inviteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }return _inviteBtn;
}

- (UILabel *)myCode {
    if (!_myCode) {
        _myCode = [UILabel new];
        _myCode.text = NSLocalizedString(@"VDInvitecodeText", nil);
        _myCode.textColor = kWhiteColor;
        _myCode.font = [UIFont systemFontOfSize:17.0f];
    }return _myCode;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [UILabel new];
//        _codeLabel.text = @"UNF888";
        _codeLabel.textColor = [UIColor colorWithHexString:@"EC165D"];
        _codeLabel.font = [UIFont systemFontOfSize:17.0f];
    }return _codeLabel;
}

- (UILabel *)shareLabel {
    if (!_shareLabel) {
        _shareLabel = [UILabel new];
        _shareLabel.text = NSLocalizedString(@"VDpointsexchangeText", nil);
        _shareLabel.textColor = [UIColor colorWithHexString:@"9D9D9C"];
        _shareLabel.font = [UIFont systemFontOfSize:13.0f];
        _shareLabel.numberOfLines = 0;
    }return _shareLabel;
}

- (void)inviteBtnAction:(UIButton *)sender {
    
    NSUserDefaults *token = [NSUserDefaults standardUserDefaults];
    NSString *userString = [token objectForKey:@"userId"];
    NSString *invateCode = [token objectForKey:@"inviteCode"];
    //     // 先判断有无存储账号信息
        if (userString) { // 登录成功
        
        self.urlString  =  [NSString stringWithFormat:@"%@/?inviteCode=%@",REQUEST_URL,invateCode];
//        NSString *titleVideo = [NSString stringWithFormat:@"%@%@",self.titleLabel,self.urlString];
        if (self.urlString) {
          
    
            NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlString]];
            NSArray *activityItems = @[urlToShare];
            //自定义Activity
            NSArray *activities = @[];
            /**
             创建分享视图控制器
             ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
             Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
             */
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
            //初始化回调方法
            UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
            {
                
                DLog(@"activityType :%@", activityType);
                if (completed)
                {
                    DLog(@"分享成功");
               
                }
                else
                {
                    DLog(@"cancel");
                }
            };
            // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
            //        activityVC.completionWithItemsHandler = myBlock;
            activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            };
            
            //    } else {
            //        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
            //        {
            //            NSLog(@"activityType :%@", activityType);
            //            activityVC.completionWithItemsHandler(activityType, YES, activityItems, nil);
            //            if (completed)
            //            {
            //                NSLog(@"completed");
            //            } else {
            //                NSLog(@"cancel");
            //            }
            //        };
            //        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
            ////        activityVC.completionHandler = myBlock;
            ////
            //        activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            //
            //        };
            //    }
            //Activity 类型又分为“操作”和“分享”两大类
            //     分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
            //    关闭系统的一些activity类型
            activityVC.excludedActivityTypes = @[];
            //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}


@end
