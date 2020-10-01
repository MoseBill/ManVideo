//
//  CustomerAVPlayer.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CustomerAVPlayer.h"

@interface CustomerAVPlayer ()
//<UIGestureRecognizerDelegate>
{
    
}

@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)UITapGestureRecognizer *tapGR;
@property(nonatomic,strong)NSURL *movieURL;
@property(nonatomic,assign)BOOL isTap;

@end

@implementation CustomerAVPlayer

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(instancetype)initWithURL:(NSURL *)movieURL{
    if (self = [super init]) {
        self.movieURL = movieURL;
        [self addGestureRecognizer:self.tapGR];
        self.isTap = NO;
    }return self;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

-(void)layoutSubviews{
    self.playerLayer.hidden = NO;
}

-(void)play{
    [self.player play];
}

-(void)stop{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.playerLayer = nil;
}

#pragma mark —— lazyLoad
-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;//设置播放视频的内容拉伸度
        _playerLayer.frame = self.bounds;
        [self.layer addSublayer:_playerLayer];
    }return _playerLayer;
}

-(AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithURL:self.movieURL];
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        //avplayer 重复播放
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_player currentItem]];
    }return _player;
}

-(UITapGestureRecognizer *)tapGR{
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                        action:@selector(tapGRClickEvent:)];
        _tapGR.numberOfTouchesRequired = 1;//手指数
        _tapGR.numberOfTapsRequired = 1;//tap次数
//        _tapGR.delegate = self;
    }return _tapGR;
}

-(void)tapGRClickEvent:(UITapGestureRecognizer *)sender{
    if (self.block) {
        self.block(@(self.isTap));
    }
    self.isTap = !self.isTap;
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

@end
