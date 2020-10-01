//
//  ZFDouYinCell.m
//  ZFPlayer_Example
//
//  Created by Josee on 2018/6/4.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import "ZFDouYinCell.h"
#import "UIImageView+ZFCache.h"
#import <ZFPlayer/UIScrollView+ZFPlayer.h>
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import "ZFLoadingView.h"
#import "ZMColorDefine.h"
#import "MJExtension.h"
#import "JhPageItemModel.h"

#import "JhScrollActionSheetView.h"
#import "EmitterBtn.h"
#import "TLDisplayView.h"


@interface ZFDouYinCell ()<EdwVideoSoundSliderDelegate,TLDisplayViewDelegate>
{
    int timeDown; //60秒后重新获取验证码
    NSTimer *timer;
}
@property (nonatomic, strong) UIImageView *coverImageView;
//@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton   *userBtn;
@property (nonatomic, strong) UIImageView    *addImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImage *placeholderImage;
//@property (nonatomic, strong) UIImageView *bgImgView;
//@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, strong) UILabel    *nameTitle;
@property (nonatomic, strong) UILabel    *likeCount;
@property (nonatomic, strong) UILabel    *msgCount;
@property (nonatomic, strong) UILabel    *shareCount;

/** item数组 */
@property (nonatomic, strong) NSMutableArray *shareArray;
@property (nonatomic, strong) NSMutableArray *otherArray;
@property (nonatomic, strong) EmitterBtn    *emitterBtn;

/*全文*/
@property (nonatomic, strong) UIButton    *fullText;

@property (nonatomic, strong) NSString    *name;
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, strong) TLDisplayView *displayView;

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *effectView;
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

@end

@implementation ZFDouYinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"050013"];
        CGFloat heightAll = 0.0;
        if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
            heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
        } else if (kiPhone6Plus) {
            heightAll = 736.0f;
        } else {
            heightAll = iPhone5 ? 568 : 667.0f;
        }
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, heightAll);
        [self.contentView addSubview:self.coverImageView];
//        [self.contentView addSubview:self.nameTitle];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.emitterBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.shareBtn];
        [self.contentView addSubview:self.userBtn];
        [self.contentView addSubview:self.addImage];
        [self.contentView addSubview:self.likeCount];
        [self.contentView addSubview:self.msgCount];
        [self.contentView addSubview:self.shareCount];
        [self.contentView addSubview:self.fullText];
        
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.bgImgView addSubview:self.timeCountdown];
        [self.bgImgView addSubview:self.countdownBtn];
        [self.bgImgView addSubview:self.willLabel];
        [self.bgImgView addSubview:self.timeDetail];
        [self.bgImgView addSubview:self.immediatelyLabel];
//        [self.bgImgView addSubview:self.videoImage];
//        [self.bgImgView addSubview:self.videoRightImage];
//        [self.bgImgView addSubview:self.videoCenterImage];
        
        [self.bgImgView addSubview:self.stateImageLeft];
        [self.bgImgView addSubview:self.stateImageCenter];
        [self.bgImgView addSubview:self.stateImageRight];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoStatus:) name:@"playVideoStatus" object:nil];
        
        [self setupView];
    }
    return self;
}
#pragma mark ===================== 通知Delegate===================================
- (void)playVideoStatus:(NSNotification *)play {
    
    NSString *states = [play object];
    if ([states isEqualToString:@"完成"]) {
        self.bgImgView.hidden = NO;
        self.effectView.hidden = NO;
       [self timeCountdownAction];
    }
    
}
#pragma mark ===================== 音乐播放===================================
- (void)setupView {
    
     self.name = @"@Josee";
    _musicView = [[EdwVideoMusicView alloc]init];
    [self addSubview:_musicView];
    [_musicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.mas_equalTo(self.shareCount.mas_bottom).offset(34/667.0f*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.shareBtn.mas_centerX);
    }];
    [self systemSound];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    //注册通知(接收,监听,一个通知)
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"notifyProgress" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPassue:) name:@"notifypassue" object:nil];
    
}

- (void)notificationPassue:(NSNotification *)noti {
    
    //使用object处理消息
    NSString *info = [noti object];
    if ([info isEqualToString:@"Pass"]) {
        [_lanternView startOrResumeAnimate];
        [_musicView startOrResumeAnimate];
       
    } else {
        [_lanternView pauseAnimate];
        [_musicView pauseAnimate];
     
    }
}

//实现方法
- (void)notification1:(NSNotification *)noti{
    
    //使用object处理消息
    NSString *info = [noti object];
    if (info) {
        [_lanternView startOrResumeAnimate];
        [_musicView startOrResumeAnimate];
    } else {
        [_lanternView stopAnimate];
        [_musicView stopAnimate];
    }
}
//监听系统声音
- (void)systemSound {
    //添加这个将不会出现系统声音的UI(播放音乐时才有效，目前没有添加音乐)
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, -2000, 0.01, 0.01)];
    [self addSubview:volumeView];
    //监听系统声音
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

//系统声音改变
- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
}

- (void)dealloc {
    NSLog(@"释放 - %@",[self class]);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.coverImageView.frame = self.contentView.bounds;
    self.bgImgView.frame = self.contentView.bounds;
    self.effectView.frame = self.bgImgView.bounds;
    self.bgImgView.hidden = YES;
    self.effectView.hidden = YES;
   
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    CGFloat margin = 30;
    
    min_w = 40;
    min_h = min_w;
    min_x = min_view_w - min_w - 20;
//    min_y = min_view_h - min_h - 80;
    min_y = 472/667.0f*SCREEN_HEIGHT;
    self.shareBtn.frame = CGRectMake(min_x, min_y-38/667.0f*SCREEN_HEIGHT, min_w, min_h);
    
    min_w = CGRectGetWidth(self.shareBtn.frame);
    min_h = min_w;
    min_x = CGRectGetMinX(self.shareBtn.frame);
    min_y = CGRectGetMinY(self.shareBtn.frame) - min_h - margin;
    min_y = 395/667.0f*SCREEN_HEIGHT;
    self.commentBtn.frame = CGRectMake(min_x, min_y-38/667.0f*SCREEN_HEIGHT, min_w, min_h);
    self.emitterBtn.frame = CGRectMake(min_x, 278/667.0f*SCREEN_HEIGHT, min_w, min_h);
    self.userBtn.frame = CGRectMake(min_x-5, 200/667.0f*SCREEN_HEIGHT, min_w+7, min_h+7);
    self.userBtn.layer.cornerRadius = self.userBtn.height/2.0f;
    self.userBtn.layer.masksToBounds = YES;
    [self.addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.userBtn.mas_centerX);
        make.top.mas_equalTo(self).offset(230.0f/667*SCREEN_HEIGHT);
         make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
    }];
    self.addImage.layer.cornerRadius = self.addImage.height/2.0f;
    self.addImage.layer.masksToBounds = YES;
    
    NSMutableAttributedString *stringLike = [[NSMutableAttributedString alloc] initWithString:@"1314" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]}];
    self.likeCount.attributedText = stringLike;
    [self.likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emitterBtn.mas_bottom).offset(12/667.0f*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.emitterBtn.mas_centerX);
        make.width.mas_equalTo(self.emitterBtn.width);
        make.height.mas_equalTo(9);
    }];
    
    NSMutableAttributedString *stringMsg = [[NSMutableAttributedString alloc] initWithString:@"1314" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]}];
    self.msgCount.attributedText = stringMsg;
    [self.msgCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentBtn.mas_bottom).offset(12/667.0f*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.commentBtn.mas_centerX);
        make.width.mas_equalTo(self.commentBtn.width);
        make.height.mas_equalTo(9);
    }];
    
     NSMutableAttributedString *stringShare = [[NSMutableAttributedString alloc] initWithString:@"1314" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]}];
    self.shareCount.attributedText = stringShare;
    [self.shareCount mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.shareBtn.mas_bottom).offset(12/667.0f*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.shareBtn.mas_centerX);
        make.width.mas_equalTo(self.shareBtn.width);
        make.height.mas_equalTo(9);
    }];
    
  

    [self setupVideoRecommended];
}

- (void)timeCountdownAction {
    
    timeDown = 59;
    [self handleTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self.bgImgView selector:@selector(handleTimer) userInfo:nil repeats:YES];
 
//    __block NSInteger time = 10; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//
//        if(time <= 0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置按钮的样式
//                //                [self.coedBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                //                [self.coedBtn setTitleColor:[UIColor colorWithHexString:@"8191eb"] forState:UIControlStateNormal];
//                //                self.coedBtn.userInteractionEnabled = YES;
////                self.timeCountdown.textColor = kWhiteColor;
////                self.countdownBtn.userInteractionEnabled = YES;
//            });
//        }else{
//            int seconds = time % 10;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置按钮显示读秒效果
////                self.timeCountdown.text = [NSString stringWithFormat:@"%.2ds", seconds];
////                self.timeCountdown.textColor = kWhiteColor;
////                self.countdownBtn.userInteractionEnabled = YES;
////                [self.countdownBtn setTitle:[NSString stringWithFormat:@"%.2ds", seconds] forState:UIControlStateNormal];
////                [self.countdownBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
//                //                self.coedBtn.userInteractionEnabled = NO;
////                self.countdownBtn.userInteractionEnabled = NO;
////                [self layoutIfNeeded];
//            });
//            time--;
//        }
//    });
//    dispatch_resume(_timer);
    
}

-(void)handleTimer
{
    
    if(timeDown>=0)
    {
        [self.countdownBtn setUserInteractionEnabled:NO];
        [self.countdownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        int sec = ((timeDown%(24*3600))%3600)%60;
        [self.countdownBtn setTitle:[NSString stringWithFormat:@"%d",sec] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.countdownBtn setUserInteractionEnabled:YES];
        [self.countdownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.countdownBtn setTitle:@"" forState:UIControlStateNormal];
        
        [timer invalidate];
        
    }
    timeDown = timeDown - 1;
}

- (void)setupVideoRecommended {
    
    [self.willLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //         make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(89/667.0f*SCREEN_HEIGHT);
        //         make.width.mas_equalTo(200);
        make.left.mas_equalTo(87);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(27);
    }];
    [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.willLabel.mas_bottom).offset(33);
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(175);
    }];
    self.countdownBtn.layer.masksToBounds = YES;
    self.countdownBtn.layer.cornerRadius = _countdownBtn.height/2.0f;
    [self.timeCountdown mas_makeConstraints:^(MASConstraintMaker *make) {
        //         make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.countdownBtn.mas_top).offset(23);
        make.left.mas_equalTo(self.countdownBtn.mas_left).offset(35);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(101);
    }];
    [self.timeDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countdownBtn.mas_top).offset(114);
        //         make.width.mas_equalTo(112);
        make.height.mas_equalTo(36);
        make.centerX.mas_equalTo(self);
    }];
    [self.immediatelyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(49);
        make.top.mas_equalTo(self.countdownBtn.mas_bottom).offset(35);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(22);
    }];
    
    UIImageView  *imageLeft = [[UIImageView alloc]init];
    imageLeft.image = [UIImage imageNamed:@"美女"];
    [self.bgImgView addSubview:imageLeft];
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
    [self.bgImgView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.immediatelyLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(145);
    }];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8.0f;
    
    UIImageView  *centerImage = [UIImageView new];
    centerImage.image = [UIImage imageNamed:@"美女"];
    [self.bgImgView addSubview:centerImage];
    self.videoCenterImage = centerImage;
    
    UIImageView  *centerBg = [UIImageView new];
    centerBg.backgroundColor = [UIColor colorWithHexString:@"050013" alpha:0.2f];
    [self.bgImgView addSubview:centerBg];
    
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
    rightImage.image = [UIImage imageNamed:@"美女"];
    [self.bgImgView addSubview:rightImage];
    self.videoRightImage = centerImage;
    
    UIImageView  *rightBg = [UIImageView new];
    rightBg.backgroundColor = [UIColor colorWithHexString:@"050013" alpha:0.2f];
    [self.bgImgView addSubview:rightBg];
    
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

}

- (void)clickAction {
    self.bgImgView.hidden = YES;
    
}

- (void)CenterAction {
      self.bgImgView.hidden = YES;
}

- (void)RightAction {
      self.bgImgView.hidden = YES;
}

- (NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,self.name.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(self.name.length,needText.length-self.name.length)];
    
    return attrString;
}

- (void)updateConstraints {
//     这里使用update也是一样的。
//     remake会将之前的全部移除，然后重新添加
    
    [self.fullText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(17);
        make.bottom.mas_equalTo(-Height_TabBar-30);
    }];
    self.fullText.layer.masksToBounds = YES;
    self.fullText.layer.cornerRadius = self.fullText.height/2.0f;
    NSString *title = @"中国共产党在社会主义初级阶段的基本路线是：领导和团结全国各族人民，以经济建设为中心，坚持四项基本原则，坚持改革开放，自力更生，艰苦创业，为把我国建设成为富强民主文明和谐的社会主义现代化国家而奋斗.";
    self.titleLabel.attributedText = [self changeLabelWithText:[NSString stringWithFormat:@"%@\n\n%@",self.name,title]];
    self.titleLabel.numberOfLines = 5;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
         make.width.mas_equalTo(250);
        make.bottom.mas_equalTo(self.fullText.mas_top).offset(-12);
    }];
    
    [super updateConstraints];

}

- (UILabel *)likeCount {
    if (!_likeCount) {
        _likeCount = [UILabel new];
        _likeCount.textAlignment = NSTextAlignmentCenter;
    }
    return _likeCount;
}

- (UILabel *)msgCount {
    if (!_msgCount) {
        _msgCount = [UILabel new];
        _msgCount.textAlignment = NSTextAlignmentCenter;
    }
    return _msgCount;
}

- (UILabel *)shareCount {
    if (!_shareCount) {
        _shareCount = [UILabel new];
        _shareCount.textAlignment = NSTextAlignmentCenter;
    }
    return _shareCount;
}

- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userBtn setImage:[UIImage imageNamed:@"center1"] forState:UIControlStateNormal];
        _userBtn.layer.borderWidth = 1.0f;
        _userBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _userBtn;
}

- (UIButton *)fullText {
    if (!_fullText) {
        _fullText = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullText setTitle:@"Toàn văn" forState:UIControlStateNormal];
        [_fullText setTitleColor:[UIColor colorWithHexString:@"EFF1F2"] forState:UIControlStateNormal];
        _fullText.backgroundColor = [UIColor colorWithHexString:@"000000"];
        _fullText.font = [UIFont systemFontOfSize:14.0f];
        _fullText.alpha = 0.2f;
        [_fullText addTarget:self action:@selector(fullAction:) forControlEvents:UIControlEventTouchUpInside];
        self.isExpanded = NO;
    }
    return _fullText;
}

- (UIImageView *)addImage {
    if (!_addImage) {
        _addImage = [UIImageView new];
        _addImage.image = [UIImage imageNamed:@"+图"];
    }
    return _addImage;
}

- (UILabel *)nameTitle {
    if (!_nameTitle) {
        _nameTitle = [UILabel new];
        _nameTitle.textColor = [UIColor whiteColor];
        _nameTitle.font = [UIFont systemFontOfSize:15];
    }
    return _nameTitle;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _titleLabel;
}
//倒计时数
//- (UILabel *)timeCountdown {
//    if (!_timeCountdown) {
//        _timeCountdown = [UILabel new];
//        _timeCountdown.text = @"10";
//        _timeCountdown.textColor = kWhiteColor;
//        _timeCountdown.font = [UIFont systemFontOfSize:90.0f];
//    }
//    return _timeCountdown;
//}
//倒计时边框
- (UIButton *)countdownBtn {
    if (!_countdownBtn) {
        
        _countdownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countdownBtn setTitle:@"10" forState:UIControlStateNormal];
        _countdownBtn.font = [UIFont systemFontOfSize:90.0f];
//        _countdownBtn.alignmentRectInsets = UIEdgeInsetsMake(23, 0, 0, 0);
        [_countdownBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _countdownBtn.backgroundColor = kClearColor;
        _countdownBtn.layer.borderWidth = 4.0f;
        _countdownBtn.layer.borderColor  = kWhiteColor.CGColor;
        _countdownBtn.titleEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
        [_commentBtn addTarget:self action:@selector(countdownAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countdownBtn;
}



- (UILabel *)timeDetail {
    if (!_timeDetail) {
        _timeDetail = [UILabel new];
        _timeDetail.text = @"下滑进入下一视频";
        _timeDetail.textColor = kWhiteColor;
        _timeDetail.font = [UIFont systemFontOfSize:14.0f];
    }
    return _timeDetail;
}

- (UILabel *)willLabel {
    if (!_willLabel) {
        _willLabel = [UILabel new];
        _willLabel.text = @"即将为您播放下段视频";
        _willLabel.textColor = kWhiteColor;
        _willLabel.font = [UIFont systemFontOfSize:20.0f];
    }
    return _willLabel;
}

- (UILabel *)immediatelyLabel {
    if (!_immediatelyLabel) {
        _immediatelyLabel = [UILabel new];
        _immediatelyLabel.textColor = kWhiteColor;
        _immediatelyLabel.text = @"即将播放";
        _immediatelyLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _immediatelyLabel;
}



- (EmitterBtn *)emitterBtn {
    if (!_emitterBtn) {
       _emitterBtn = [EmitterBtn buttonWithType:UIButtonTypeCustom];
        
        [_emitterBtn setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
//        [_emitterBtn setImage:[UIImage imageNamed:@"love1"]  forState:UIControlStateSelected];
        [_emitterBtn addTarget:self action:@selector(emitterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emitterBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}
#pragma mark ===================== 点击事件===================================
- (void)countdownAction:(UIButton *)action {
    
    
}

- (void)fullAction:(UIButton *)click {
    
    click.selected = !click.selected;
    if (click.selected) {
        [self.fullText setTitle:@"Toàn văn" forState:UIControlStateNormal];
        self.titleLabel.numberOfLines = 30;
    } else {
        self.titleLabel.numberOfLines = 5;
        [self.fullText setTitle:@"Thu lại" forState:UIControlStateNormal];
    }
    
}

- (void)commentClick:(UIButton *)click {
    
    if ([self.delegate respondsToSelector:@selector(upComment:)]) {
        [self.delegate upComment:click];
    }
}

- (void)emitterClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
    
          [btn setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
    
    } else {

          [btn setImage:[UIImage imageNamed:@"loveMain"] forState:UIControlStateNormal];
    }
    
}

- (void)shareClick:(UIButton *)click {
    
//    JhScrollActionSheetView *actionSheet = [[JhScrollActionSheetView alloc]initWithTitle:@"分享到"  shareDataArray:self.shareArray otherDataArray:self.otherArray];
//    actionSheet.clickShareBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
//        NSLog(@" 点击分享 index %ld ",(long)index);
//    };
//    actionSheet.clickOtherBlock = ^(JhScrollActionSheetView *actionSheet, NSInteger index) {
//        NSLog(@" 点击其他 index %ld ",(long)index);
//    };
//    [actionSheet show];
    
    if ([self.delegate respondsToSelector:@selector(shareClickDelegate:)]) {
        [self.delegate shareClickDelegate:click];
    }
}

- (void)setData:(ZFTableData *)data {
    
    _data = data;
    [self.coverImageView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"loading_bgView"]];
//    [self.bgImgView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"loading_bgView"]];
//     [self.bgImgView setImageWithURLString:nil placeholder:[UIImage imageNamed:@"huazai"]];
    self.bgImgView.image = [UIImage imageNamed:@"美女"];
//    self.titleLabel.text = data.title;
      NSString *vHeight = [NSString stringWithFormat:@"%f",data.video_height];
    if ([vHeight doubleValue] >360) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
         self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *videoHeight = [NSString stringWithFormat:@"%f",data.video_height];
    [user setObject:videoHeight forKey:@"video_Height"];
    [user synchronize];
    
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
}

- (NSMutableArray *)shareArray {
    if (!_shareArray) {
        _shareArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"内容转播",
                              @"img" : @"bb",
                              },
                          @{
                              @"text" : @"Viber",
                              @"img" : @"Viber",
                              },
                          @{
                              @"text" : @"Messenger",
                              @"img" : @"Facebook Messenger",
                              },
                          @{
                              @"text" : @"WhatsApp",
                              @"img" : @"WhatsApp",
                              },
                          @{
                              @"text" : @"Facebook",
                              @"img" : @"fb",
                              },
                          @{
                              @"text" : @"instagram",
                              @"img" : @"图层 2023",
                              },
                          @{
                              @"text" : @"email",
                              @"img" : @"email",
                              },
                          @{
                              @"text" : @"FB story",
                              @"img" : @"camera story",
                              },
                          @{
                              @"text" : @"message",
                              @"img" : @"图层 2029",
                              }];
        
        self.shareArray = [JhPageItemModel mj_objectArrayWithKeyValuesArray:data];
        
        
    }
    return _shareArray;
}

- (NSMutableArray *)otherArray {
    if (!_otherArray) {
        _otherArray = [NSMutableArray new];
        
        NSArray *data = @[
                          @{
                              @"text" : @"举报",
                              @"img" : @"jubao_share",
                              },
                          @{
                              @"text" : @"复制",
                              @"img" : @"shaver11",
                              },
                          @{
                              @"text" : @"保存",
                              @"img" : @"save",
                              }];
        
        self.otherArray = [JhPageItemModel mj_objectArrayWithKeyValuesArray:data];
        
        
    }
    return _otherArray;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

@end
