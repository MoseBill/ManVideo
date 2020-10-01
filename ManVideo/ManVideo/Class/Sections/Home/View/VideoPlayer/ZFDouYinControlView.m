//
//  ZFDouYinControlView.m
//  ZFPlayer_Example
//
//  Created by 任子丰 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinControlView.h"
#import "ZFSliderView.h"

@interface ZFDouYinControlView ()
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) ZFSliderView *sliderView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *effectView;

@end

@implementation ZFDouYinControlView
@synthesize player = _player;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.playBtn];
        [self addSubview:self.sliderView];
        [self resetControlView];
    }return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.player.currentPlayerManager.view.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.mj_w;
    CGFloat min_view_h = self.mj_h;
    
    min_w = 100;
    min_h = 100;
    self.playBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playBtn.center = self.center;
    
    min_x = 0;
    min_y = min_view_h - 80;
    min_w = min_view_w;
    min_h = 1;
    self.sliderView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgImgView.frame = self.bounds;
    self.effectView.frame = self.bgImgView.bounds;
}

- (void)resetControlView {
    self.playBtn.hidden = YES;
    self.sliderView.value = 0;
    self.sliderView.bufferValue = 0;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
    } else if (state == ZFPlayerLoadStatePlaythroughOK ||
               state == ZFPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
        self.effectView.hidden = NO;
    }
    if ((state == ZFPlayerLoadStateStalled ||
         state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        [self.sliderView startAnimating];
    } else {
        [self.sliderView stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer
        currentTime:(NSTimeInterval)currentTime
          totalTime:(NSTimeInterval)totalTime {
    self.sliderView.value = videoPlayer.progress;
}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    
    if (self.dissmissCommentVC) {
        self.dissmissCommentVC();
    }
    if (self.showAdBlock) {//点击广告页到网页
        self.showAdBlock();
    }
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
        self.playBtn.hidden = NO;
        self.playBtn.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        [UIView animateWithDuration:0.2f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.playBtn.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                            }];
    } else {
        [self.player.currentPlayerManager play];
        self.playBtn.hidden = YES;
    }
}

- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
    [player.currentPlayerManager.view insertSubview:self.bgImgView
                                            atIndex:0];
    [self.bgImgView addSubview:self.effectView];
    [player.currentPlayerManager.view insertSubview:self.coverImageView
                                            atIndex:1];
}

- (void)showCoverViewWithUrl:(NSString *)coverUrl withImageMode:(UIViewContentMode)contentMode {
    self.coverImageView.contentMode = contentMode;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverUrl]
                           placeholderImage:kIMG(@"img_video_loading")];
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]
                      placeholderImage:kIMG(@"img_video_loading")];
}

#pragma mark - getter
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = UIImageView.new;
        _bgImgView.userInteractionEnabled = YES;
    }return _bgImgView;
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
    }return _effectView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:[UIImage imageNamed:@"icon_play_pause"] forState:UIControlStateNormal];
    }return _playBtn;
}

- (ZFSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[ZFSliderView alloc] init];
        _sliderView.maximumTrackTintColor = [UIColor colorWithRed:1
                                                            green:1
                                                             blue:1
                                                            alpha:0.2];
        _sliderView.minimumTrackTintColor = kWhiteColor;
        _sliderView.bufferTrackTintColor  = kClearColor;
        _sliderView.sliderHeight = 1;
        _sliderView.isHideSliderBlock = NO;
    }return _sliderView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = UIImageView.new;
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.clipsToBounds = YES;
    }return _coverImageView;
}

@end
