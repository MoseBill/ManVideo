//
//  RecommendedController.m
//  Clipyeu ++
//
//  Created by Josee on 19/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "RecommendedController.h"
#import "RecommendedController+VM.h"
#import "DrawCircular.h"//绘制圆形

@interface RecommendedController ()

//@property (nonatomic, strong) UIImageView *bgImgView;
//@property (nonatomic, strong) UIView *effectView;
/*倒计时数*/
@property (nonatomic, strong) UILabel    *timeCountdown;
/*即将播放标题*/
@property (nonatomic, strong) UILabel    *willLabel;
/*下滑进入下一个视频*/
@property (nonatomic, strong) UILabel    *timeDetail;
/*倒计时按钮*/
@property (nonatomic, strong) UIButton    *countdownBtn;
/*即将播放文字*/
@property (nonatomic, strong) UILabel    *immediatelyLabel;
/*第一个视频图片*/
@property (nonatomic, weak) UIImageView  *videoImage;
/*第二个视频图片*/
@property (nonatomic, weak) UIImageView  *videoCenterImage;
/*第三个视频视图*/
@property (nonatomic, weak) UIImageView  *videoRightImage;
/*播放状态左*/
@property (nonatomic, strong) UIImageView  *stateImageLeft;
/*播放状态中*/
@property (nonatomic, strong) UIImageView  *stateImageCenter;
/*播放状态右*/
@property (nonatomic, strong) UIImageView  *stateImageRight;
/*点赞图片*/
@property (nonatomic, strong) UIImageView  *likeImageLeft;
@property (nonatomic, strong) UIImageView  *likeImageCenter;
@property (nonatomic, strong) UIImageView  *likeImageRight;
/*视频播放完成点赞数量*/
@property (nonatomic, strong) UILabel    *countLikeLeft;
@property (nonatomic, strong) UILabel    *countLikeCenter;
@property (nonatomic, strong) UILabel    *countLikeRight;

/*视频标题*/
@property (nonatomic, strong) UILabel    *titleVideoLeft;
@property (nonatomic, strong) UILabel    *titleVideoCenter;
@property (nonatomic, strong) UILabel    *titleVideoRight;

@property (nonatomic, strong) NSString  *stopTimer;

@property (nonatomic, strong) id noty;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation RecommendedController

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [self setupView];
//}

- (void)setupView {
    
//    [self addSubview:self.bgImgView];
//    [self addSubview:self.effectView];
    _noty = [[NSNotificationCenter defaultCenter] addObserverForName:@"presentPlay" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSIndexPath *object = [note object];
        if (object) {
            self.countdownBtn.hidden = NO;
            self.timeDetail.hidden = NO;
            [self timeCountdownAction:nil];
        }
    }];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationPlay:) name:@"presentPlay" object:nil];
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationScroll:) name:@"scrollNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimerScroll:) name:@"stopTimerScroll" object:nil];
    [self addSubview:self.timeCountdown];
    
    
    [self addSubview:self.willLabel];
    
    [self addSubview:self.immediatelyLabel];
    [self addSubview:self.stateImageLeft];
    [self addSubview:self.stateImageCenter];
    [self addSubview:self.stateImageRight];
     [self setupVideoRecommended];
    
//    self.bgImgView.frame = self.view.bounds;
//    self.effectView.frame = self.bgImgView.bounds;
//    self.bgImgView.image = [UIImage imageNamed:@"美女"];
   
}

- (void)notificationScroll:(NSNotification *)scroll {
    
    self.countdownBtn.hidden = YES;
    self.timeDetail.hidden = YES;
    [self timeCountdownAction:@"切换"];
    
}

- (void)setupVideoRecommended {
    
//    self.draw = [DrawCircular new];
//    self.draw.userInteractionEnabled = YES;
//    self.draw.backgroundColor = kClearColor;
//     [self.bgImgView addSubview:self.draw];
//    self.draw.hidden = YES;

//    [keyWindow addSubview:self.countdownBtn];
    //    [self addSubview:self.countdownBtn];
//    [keyWindow addSubview:self.timeDetail];
//    self.countdownBtn.hidden = YES;
//    self.timeDetail.hidden = YES;
//    [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(keyWindow);
//        make.top.mas_equalTo(139/667.0f*SCREEN_HEIGHT);
//        make.width.mas_equalTo(180);
//        make.height.mas_equalTo(180);
//    }];
//    [self.willLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(89/667.0f*SCREEN_HEIGHT);
//        make.left.mas_equalTo(87);
//        make.right.mas_equalTo(-80);
//        make.height.mas_equalTo(27);
//    }];
//    [self.draw mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(139/667.0f*SCREEN_HEIGHT);
//        make.width.mas_equalTo(180);
//        make.height.mas_equalTo(180);
//    }];
    [self.timeCountdown mas_makeConstraints:^(MASConstraintMaker *make) {
        //         make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.countdownBtn.mas_top).offset(23);
        make.left.mas_equalTo(self.countdownBtn.mas_left).offset(35);
        make.centerX.mas_equalTo(kAPPWindow);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(101);
    }];
//    [self.timeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.countdownBtn.mas_top).offset(114);
//        make.width.mas_equalTo(130);
//        make.height.mas_equalTo(36);
//        make.centerX.mas_equalTo(keyWindow);
//    }];
    [self.immediatelyLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(49);
        make.top.mas_equalTo(370/667.0f*SCREEN_HEIGHT);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(22);
    }];
    
    UIImageView  *imageLeft = [[UIImageView alloc]init];
    imageLeft.image = [UIImage imageNamed:@"附近占位"];
    [self addSubview:imageLeft];
    self.videoImage = imageLeft;
    [imageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.immediatelyLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    imageLeft.layer.masksToBounds = YES;
    imageLeft.layer.cornerRadius = 8.0f;
    UIImageView  *backView = [UIImageView new];
    backView.backgroundColor = [UIColor colorWithHexString:@"050013" alpha:0.2f];
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.immediatelyLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8.0f;
    
    UIImageView  *centerImage = [UIImageView new];
    centerImage.image = [UIImage imageNamed:@"附近占位"];
    [self addSubview:centerImage];
    self.videoCenterImage = centerImage;
    
    UIImageView  *centerBg = [UIImageView new];
    centerBg.backgroundColor = [UIColor colorWithHexString:@"050013" alpha:0.2f];
    [self addSubview:centerBg];
    
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(imageLeft.mas_right).offset(10);
        make.centerY.mas_equalTo(imageLeft.mas_centerY);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    centerImage.layer.masksToBounds = YES;
    centerImage.layer.cornerRadius = 8.0f;
    [centerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageLeft.mas_right).offset(10);
        make.centerY.mas_equalTo(imageLeft.mas_centerY);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    centerBg.layer.masksToBounds = YES;
    centerBg.layer.cornerRadius = 8.0f;
    
    UIImageView  *rightImage = [UIImageView new];
    rightImage.image = [UIImage imageNamed:@"附近占位"];
    [self addSubview:rightImage];
    self.videoRightImage = centerImage;
    
    UIImageView  *rightBg = [UIImageView new];
    rightBg.backgroundColor = [UIColor colorWithHexString:@"050013" alpha:0.2f];
    [self addSubview:rightBg];
    
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerImage.mas_right).offset(10);
        make.centerY.mas_equalTo(centerImage.mas_centerY);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    rightImage.layer.masksToBounds = YES;
    rightImage.layer.cornerRadius = 8.0f;
    
    [rightBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerImage.mas_right).offset(10);
        make.centerY.mas_equalTo(centerImage.mas_centerY);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    rightBg.layer.masksToBounds = YES;
    rightBg.layer.cornerRadius = 8.0f;
    
    self.stateImageLeft = [UIImageView new];
    self.stateImageLeft.image = [UIImage imageNamed:@"icon_play_pause"];
    [backView addSubview:self.stateImageLeft];
    [self.stateImageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView);
        make.centerY.mas_equalTo(backView);
        make.width.mas_equalTo(29);
        make.height.mas_equalTo(32);
    }];
//
    self.stateImageCenter = [UIImageView new];
    self.stateImageCenter.image = [UIImage imageNamed:@"icon_play_pause"];
    [centerBg addSubview:self.stateImageCenter];
    [self.stateImageCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(centerBg);
        make.centerY.mas_equalTo(centerBg);
        make.width.mas_equalTo(29);
        make.height.mas_equalTo(32);
    }];
    
    self.stateImageRight = [UIImageView new];
    self.stateImageRight.image = [UIImage imageNamed:@"icon_play_pause"];
    [rightBg addSubview:self.stateImageRight];
    [self.stateImageRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(rightBg);
        make.centerY.mas_equalTo(rightBg);
        make.width.mas_equalTo(29);
        make.height.mas_equalTo(32);
    }];
    
    //图片这种类型的view默认是没有点击事件的，所以要把用户交互的属性打开
    backView.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    [backView addGestureRecognizer:click];
    
    centerBg.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *clickCenter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CenterAction)];
    [centerBg addGestureRecognizer:clickCenter];
    
    rightBg .userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *clickRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RightAction)];
    [rightBg addGestureRecognizer:clickRight];
    
    UITapGestureRecognizer *clickTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeAction:)];
    clickTime.numberOfTapsRequired = 1;
    [self.countdownBtn addGestureRecognizer:clickTime];
    
    [imageLeft addSubview:self.likeImageLeft];
    [centerImage addSubview:self.likeImageCenter];
    [rightImage addSubview:self.likeImageRight];
    [centerImage addSubview:self.countLikeCenter];
    [imageLeft addSubview:self.countLikeLeft];
    [rightImage addSubview:self.countLikeRight];
    
    [imageLeft addSubview:self.titleVideoLeft];
    [centerImage addSubview:self.titleVideoCenter];
    [rightImage addSubview:self.titleVideoRight];
    
    [self.likeImageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(13);
    }];
    [self.countLikeLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.likeImageLeft.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.likeImageLeft.mas_centerY);
        make.height.mas_equalTo(13);
    }];
    [self.likeImageCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(13);
    }];
    [self.countLikeCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.likeImageCenter.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.likeImageCenter.mas_centerY);
        make.height.mas_equalTo(13);
    }];
    [self.likeImageRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(13);
    }];
    [self.countLikeRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.likeImageRight.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.likeImageRight.mas_centerY);
        make.height.mas_equalTo(13);
    }];
    
    [self.titleVideoLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-8);
    }];
    [self.titleVideoRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-8);
    }];
    [self.titleVideoCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-8);
    }];
}

- (void)clickAction {
//    self.bgImgView.hidden = YES;
    [self timeCountdownAction:@"暂停定时器"];
    self.countdownBtn.hidden = YES;
    self.timeDetail.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(hiddenView:)]) {
        [self.delegate hiddenView:@"暂停定时器"];
    }
}

- (void)CenterAction {
//    self.bgImgView.hidden = YES;
    [self timeCountdownAction:@"暂停定时器"];
    self.countdownBtn.hidden = YES;
    self.timeDetail.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(hiddenView:)]) {
        [self.delegate hiddenView:@"暂停定时器"];
    }
}

- (void)RightAction {
//    self.bgImgView.hidden = YES;
    [self timeCountdownAction:@"暂停定时器"];
    self.countdownBtn.hidden = YES;
    self.timeDetail.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(hiddenView:)]) {
        [self.delegate hiddenView:self.stopTimer];
    }
}


- (void)timeAction:(UITapGestureRecognizer*)tap {
    
    
    self.stopTimer = @"暂停定时器";
    [self timeCountdownAction:self.stopTimer];
    self.countdownBtn.hidden = YES;
    self.timeDetail.hidden = YES;
    _timer = nil;
    if ([self.delegate respondsToSelector:@selector(hiddenView:)]) {
        [self.delegate hiddenView:self.stopTimer];
    }
    if (tap) {
        
        //  [self dismissViewControllerAnimated:YES completion:nil];
        //        self.bgImgView.hidden = YES;
        //        self.effectView.hidden = YES;
        //        self.countdownBtn.hidden = YES;
        //        self.timeDetail.hidden = YES;
        //        self.draw.hidden = YES;
        
    }
    
    
}

- (void)timeCountdownAction:(NSString *)stopTimer {
    DLog(@"打印定时器%@",stopTimer);
    @weakify(self)
    __block NSInteger time = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
                    if(time <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(self.timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (stopTimer == nil) {
                            if ([self.delegate respondsToSelector:@selector(hiddenView:)]) {
                                [self.delegate hiddenView:@"定时器结束"];
                            }
                        }
                        @strongify(self)
                        self.countdownBtn.hidden = YES;
                        self.timeDetail.hidden = YES;
                        //设置按钮的样式
//                        [self.countdownBtn setTitle:@"00" forState:UIControlStateNormal];
                        [self.countdownBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                        //                  [self dismissViewControllerAnimated:YES completion:nil];
                        //                self.bgImgView.hidden = YES;
                        //                self.effectView.hidden = YES;
                        ////                self.musicView.hidden = NO;
                        //                self.countdownBtn.hidden = YES;
                        //                self.timeDetail.hidden = YES;
                        //                self.draw.hidden = YES;
                    });
                }else{
                    int seconds = time % 11;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置按钮显示读秒效果
                        [self.countdownBtn setTitle:[NSString stringWithFormat:@"%.2d", seconds] forState:UIControlStateNormal];
                        [self.countdownBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                        //                [self.countdownBtn addTarget:self action:@selector(countdownAction:) forControlEvents:UIControlEventTouchUpInside];
                        self.countdownBtn.userInteractionEnabled = YES;
                        self.countdownBtn.layer.masksToBounds = YES;
                        self.countdownBtn.layer.cornerRadius = self.countdownBtn.height/2.0f;
                        
                    });
                    time--;
                }
               
            });
            dispatch_resume(_timer);
    
    
    
}

- (UIImageView *)likeImageLeft {
    if (!_likeImageLeft) {
        _likeImageLeft = [UIImageView new];
        _likeImageLeft.image = [UIImage imageNamed:@"like"];
    }
    return _likeImageLeft;
}

- (UIImageView *)likeImageRight {
    if (!_likeImageRight) {
        _likeImageRight = [UIImageView new];
        _likeImageRight.image = [UIImage imageNamed:@"like"];
    }
    return _likeImageRight;
}

- (UIImageView *)likeImageCenter {
    
    if (!_likeImageCenter) {
        _likeImageCenter = [UIImageView new];
        _likeImageCenter.image = [UIImage imageNamed:@"like"];
    }
    return _likeImageCenter;
}

- (UILabel *)countLikeRight {
    if (!_countLikeRight) {
        _countLikeRight = [UILabel new];
//        _countLikeRight.text = @"200";
        _countLikeRight.textColor = kWhiteColor;
        _countLikeRight.textAlignment = NSTextAlignmentRight;
        _countLikeRight.font = [UIFont systemFontOfSize:12.f];
    }
    return _countLikeRight;
}

- (UILabel *)countLikeCenter {
    if (!_countLikeCenter) {
        _countLikeCenter = [UILabel new];
//        _countLikeCenter.text = @"200";
        _countLikeCenter.textColor = kWhiteColor;
        _countLikeCenter.textAlignment = NSTextAlignmentRight;
        _countLikeCenter.font = [UIFont systemFontOfSize:12.f];
    }
    return _countLikeCenter;
}

- (UILabel *)countLikeLeft {
    if (!_countLikeLeft) {
        _countLikeLeft = [UILabel new];
//        _countLikeLeft.text = @"200";
        _countLikeLeft.textColor = kWhiteColor;
        _countLikeLeft.textAlignment = NSTextAlignmentRight;
        _countLikeLeft.font = [UIFont systemFontOfSize:12.f];
    }
    return _countLikeLeft;
}

- (UILabel *)titleVideoRight {
    if (!_titleVideoRight) {
        _titleVideoRight = [UILabel new];
//        _titleVideoRight.text = @"这妞屁股翘，逼爽，服不服！";
        _titleVideoRight.textColor = kWhiteColor;
        _titleVideoRight.textAlignment = NSTextAlignmentLeft;
        _titleVideoRight.font = [UIFont systemFontOfSize:9.f];
    }
    return _titleVideoRight;
}

- (UILabel *)titleVideoLeft {
    if (!_titleVideoLeft) {
        _titleVideoLeft = [UILabel new];
//        _titleVideoLeft.text = @"这妞屁股翘，逼爽，服不服！";
        _titleVideoLeft.textColor = kWhiteColor;
        _titleVideoLeft.textAlignment = NSTextAlignmentLeft;
        _titleVideoLeft.font = [UIFont systemFontOfSize:9.f];
    }
    return _titleVideoLeft;
}

- (UILabel *)titleVideoCenter {
    if (!_titleVideoCenter) {
        _titleVideoCenter = [UILabel new];
//        _titleVideoCenter.text = @"这妞屁股翘，逼爽，服不服！";
        _titleVideoCenter.textColor = kWhiteColor;
        _titleVideoCenter.textAlignment = NSTextAlignmentLeft;
        _titleVideoCenter.font = [UIFont systemFontOfSize:9.f];
    }
    return _titleVideoCenter;
}

//倒计时边框
- (UIButton *)countdownBtn {
    if (!_countdownBtn) {
        
        _countdownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_countdownBtn setTitle:@"10" forState:UIControlStateNormal];
        _countdownBtn.font = [UIFont systemFontOfSize:90.0f];
        [_countdownBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _countdownBtn.backgroundColor = kClearColor;
        _countdownBtn.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
        _countdownBtn.layer.borderColor = kWhiteColor.CGColor;
        _countdownBtn.layer.borderWidth = 4.0f;
//        [_countdownBtn addTarget:self action:@selector(countdownAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countdownBtn;
}

//- (UILabel *)timeDetail {
//    if (!_timeDetail) {
//        _timeDetail = [UILabel new];
//        _timeDetail.text = [NSString stringWithFormat:@"点此暂停\n下滑进入下一视频"];
//        _timeDetail.textColor = kWhiteColor;
//        _timeDetail.numberOfLines = 2;
//        _timeDetail.textAlignment = NSTextAlignmentCenter;
//        _timeDetail.font = [UIFont systemFontOfSize:14.0f];
//    }
//    return _timeDetail;
//}

- (UILabel *)willLabel {
    if (!_willLabel) {
        _willLabel = [UILabel new];
//        _willLabel.text = @"即将为您播放下段视频";
        _willLabel.textColor = kWhiteColor;
        _willLabel.font = [UIFont systemFontOfSize:20.0f];
    }
    return _willLabel;
}

- (UILabel *)immediatelyLabel {
    if (!_immediatelyLabel) {
        _immediatelyLabel = [UILabel new];
        _immediatelyLabel.textColor = kWhiteColor;
//        _immediatelyLabel.text = @"即将播放";
        _immediatelyLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _immediatelyLabel;
}
#pragma mark ===================== 通知事件===================================

- (void)stopTimerScroll:(NSNotification *)scroll {
    NSString  *timer = [scroll object];
    if (timer) {
//         dispatch_source_cancel(self.timer);
        _timer = nil;
        
    }
    
}

- (void)notificationPlay:(NSNotification *)noti {
    
    NSString *objectString = [noti object];
    if ([objectString isEqualToString:@"完成"]) {
        self.countdownBtn.hidden = NO;
        self.timeDetail.hidden = NO;
        [self timeCountdownAction:nil];
    }
}
#pragma mark ===================== 代理事件===================================

#pragma mark ===================== 点击事件===================================

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_noty];
    _timer = nil;
}

@end
