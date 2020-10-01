//
//  VideoReleaseVC.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VideoReleaseVC.h"
#import "VideoReleaseVC+VM.h"
#import "CustomerAVPlayer.h"
#import "StatisticsTextView.h"

extern LZTabBarVC *tabBarVC;
extern UINavigationController *rootVC;

@interface VideoReleaseVC ()
@property(nonatomic,strong)StatisticsTextView *textView;
@property(nonatomic,strong)CustomerAVPlayer *customerAVPlayer;
@property(nonatomic,strong)UIButton *releaseBtn;
@property(nonatomic,strong)NSURL *movieURL;

@end

@implementation VideoReleaseVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    VideoReleaseVC *vc = VideoReleaseVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if ([requestParams isKindOfClass:[NSURL class]]) {
        vc.movieURL = requestParams;
        vc.data = [NSData dataWithContentsOfURL:requestParams];//视频资源
    }else{
        NSLog(@"URL不合法");
        [SVProgressHUD showErrorWithStatus:@"URL不合法"];
    }
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

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(Text:)
                                                     name:@"Text"
                                                   object:nil];
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customerAVPlayer.alpha = 1;
    self.textView.alpha = 1;
    self.releaseBtn.alpha = 1;
    tabBarVC.tabBar.hidden = YES;
    rootVC.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navTitle = NSLocalizedString(@"VedioRelease",nil);
    self.gk_navigationBar.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName: kWhiteColor,
                                                  NSFontAttributeName: [UIFont systemFontOfSize:20]
                                                  };
    self.gk_navBarAlpha = 0;
    self.gk_navigationItem.leftBarButtonItems = @[
                                                  [[UIBarButtonItem alloc]initWithCustomView:self.backBtn]
                                                  ];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma mark —— 通知
-(void)Text:(NSNotification *)noti{
    self.infoStr = [noti object];
}
#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)releaseBtnClickEvent:(UIButton *)sender{
    [self upLoadFile];
}

#pragma mark —— lazyLoad
-(CustomerAVPlayer *)customerAVPlayer{
    if (!_customerAVPlayer) {
        _customerAVPlayer = [[CustomerAVPlayer alloc] initWithURL:self.movieURL];
//        _customerAVPlayer.backgroundColor = KYellowColor;
//        @weakify(self)
        [_customerAVPlayer actionBlock:^(id  _Nonnull data) {
//            @strongify(self)
//点两次重选
        }];
        [self.view addSubview:_customerAVPlayer];
        [_customerAVPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(rectOfStatusbar + rectOfNavigationbar);//offset(SCALING_RATIO(50));
            make.left.equalTo(self.view).offset(SCALING_RATIO(13));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(150),SCALING_RATIO(230)));
        }];
    }return _customerAVPlayer;
}

-(StatisticsTextView *)textView{
    if (!_textView) {
        _textView = StatisticsTextView.new;
        _textView.backgroundColor = kClearColor;
        [self.view addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.customerAVPlayer);
            make.left.equalTo(self.customerAVPlayer.mas_right);
            make.right.equalTo(self.view).offset(SCALING_RATIO(-13));
        }];
    }return _textView;
}

-(UIButton *)releaseBtn{
    if (!_releaseBtn) {
        _releaseBtn = UIButton.new;
        _releaseBtn.backgroundColor = [UIColor colorWithRed:190/255.0
                                                      green:52/255.0
                                                       blue:98/255.0
                                                      alpha:1.0];
        _releaseBtn.layer.cornerRadius = 8;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"SureVedioRelease",nil)
                                                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],
                                                                                                NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0
                                                                                                                                                green:255/255.0
                                                                                                                                                 blue:255/255.0
                                                                                                                                                alpha:1.0]}];
        [_releaseBtn setAttributedTitle:string
                               forState:UIControlStateNormal];
        [_releaseBtn addTarget:self
                        action:@selector(releaseBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_releaseBtn];
        [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.customerAVPlayer.mas_bottom).offset(SCALING_RATIO(30));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(349), SCALING_RATIO(44)));
            make.centerX.equalTo(self.view);
        }];
    }return _releaseBtn;
}



@end
