//
//  EdwVideoMusicView.m
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import "EdwVideoMusicView.h"
#import "UIView+EdwFrame.h"

static NSString *kImgViewVKey = @"imgViewKey_transform_rotation_z";
static NSString *kmusicImgVKey = @"musicImgVKey_transform_rotation_z";
static NSString *kNoteImgOneKey = @"noteImgOne_group_animation";
static NSString *kNoteImgTwoKey = @"noteImgTwo_group_animation";
static NSString *kNoteImgThreeKey = @"noteImgThree_group_animation";

@interface EdwVideoMusicView ()
//碟片
@property (nonatomic, strong) UIImageView *imgView;

//音符
@property (nonatomic, strong) UIImageView *noteImgOne;
@property (nonatomic, strong) UIImageView *noteImgTwo;
@property (nonatomic, strong) UIImageView *noteImgThree;

@property (nonatomic, assign) BOOL isRunning;//是否正在处理动画;
@end

@implementation EdwVideoMusicView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    //音符
    _noteImgOne = [[UIImageView alloc]init];
    _noteImgOne.image = [UIImage imageNamed:@"video_music_note_one"];
    [self addSubview:_noteImgOne];
    
    _noteImgTwo = [[UIImageView alloc]init];
    _noteImgTwo.image = [UIImage imageNamed:@"video_music_note_one"];
    [self addSubview:_noteImgTwo];
    
    _noteImgThree = [[UIImageView alloc]init];
    _noteImgThree.image = [UIImage imageNamed:@"video_music_note_two"];
    [self addSubview:_noteImgThree];
    
    //碟片
    _imgView = [[UIImageView alloc]init];
    _imgView.image = [UIImage imageNamed:@"dynamic_video_music"];
    [self addSubview:_imgView];
    
    //音乐封面
    _musicImgV = [[UIImageView alloc]init];
    _musicImgV.image = [UIImage imageNamed:@"dynamic_video_music"];
    _musicImgV.layer.cornerRadius = 15;
    _musicImgV.layer.masksToBounds = YES;
    [self addSubview:_musicImgV];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    [_musicImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.imgView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
  
    [_noteImgOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [_noteImgTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [_noteImgThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

//旋转动画
- (void)addRotateAnimate:(UIImageView *)imgV key:(NSString *)key{
    CABasicAnimation *baseAnimat = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimat.toValue = [NSNumber numberWithFloat:M_PI *2];
    baseAnimat.repeatCount = MAXFLOAT;//MAXFLOAT;//重复次数
    baseAnimat.duration = 5;//完成动画的时间
    baseAnimat.fillMode = kCAFillModeForwards;
    baseAnimat.removedOnCompletion=NO;
    [imgV.layer addAnimation:baseAnimat forKey:key];
    
    //查看动画是否是暂停状态，是的话恢复播放
    if (imgV.layer.speed != 1.0) {
        CFTimeInterval pausedTime = [imgV.layer timeOffset];
        imgV.layer.speed = 1.0;
        imgV.layer.timeOffset = 0.0;
        imgV.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [imgV.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        imgV.layer.beginTime = timeSincePause;
    }
}


/**
 音符动画
 
 @param imgV 要动画的视图
 @param repeatCount 动画次数
 @param duration 每次动画时长
 @param timeOffset 动画时间偏移量。比如设置动画时长为3秒，当设置timeOffset为1.5时，当前动画会从中间位置开始，并在到达指定位置时，走完之前跳过的前半段动画。
 @param key  CALayer的某个属性名，并通过这个属性的值进行修改，达到相应的动画效果。
 */
- (void)addNoteAimate:(UIImageView *)imgV repeatCount:(float)repeatCount duration:(CFTimeInterval)duration timeOffset:(CFTimeInterval)timeOffset key:(NSString *)key{
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.duration = duration;
    animateGroup.repeatCount = repeatCount;
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion=NO;
    
    //按照圆弧移动动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(self.edw_width * 0.5, self.edw_height + imgV.edw_height * 0.5)];
    [bezierPath addQuadCurveToPoint:CGPointMake(-20, -20) controlPoint:CGPointMake(-self.edw_width * 0.5,self.edw_height)];
    keyAnimation.path = bezierPath.CGPath;
    keyAnimation.timeOffset = timeOffset;
    
    //缩放动画
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:2.0]];
    scaleAnimation.timeOffset = timeOffset;
    
    //透明动画
    CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.0]];
    alphaAnimation.timeOffset = timeOffset;
    
    animateGroup.animations = @[keyAnimation,scaleAnimation,alphaAnimation];
    [imgV.layer addAnimation:animateGroup forKey:key];
    
    //查看动画是否是暂停状态，是的话恢复播放
    if (imgV.layer.speed != 1.0) {
        CFTimeInterval pausedTime = [imgV.layer timeOffset];
        imgV.layer.speed = 1.0;
        imgV.layer.timeOffset = 0.0;
        imgV.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [imgV.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        imgV.layer.beginTime = timeSincePause;
    }
}

//开始动画
- (void)startOrResumeAnimate{
    CAAnimation *baseAnimat = [_imgView.layer animationForKey:kImgViewVKey];
    if (!baseAnimat) {
        _isRunning = YES;
        [self addRotateAnimate:_imgView key:kImgViewVKey];
        [self addRotateAnimate:_musicImgV key:kmusicImgVKey];
        [self addNoteAimate:_noteImgOne repeatCount:MAXFLOAT duration:3.0 timeOffset:0.0f key:kNoteImgOneKey];
        [self addNoteAimate:_noteImgTwo repeatCount:MAXFLOAT duration:3.0 timeOffset:1.0f key:kNoteImgTwoKey];
        [self addNoteAimate:_noteImgThree repeatCount:MAXFLOAT duration:3.0 timeOffset:2.0f key:kNoteImgThreeKey];
    }else{
        //查看动画是否是暂停状态，是的话恢复播放
        if (_imgView.layer.speed != 1.0) {
            [self resumeAnimate];
        }
    }
    
}

//暂停动画
- (void)pauseAnimate{
    self.isRunning = NO;
    CFTimeInterval imgViewPausedTime = [_imgView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.imgView.layer.speed = 0.0;
    self.imgView.layer.timeOffset = imgViewPausedTime;
    
    CFTimeInterval musicImgVPausedTime = [_musicImgV.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.musicImgV.layer.speed = 0.0;
    self.musicImgV.layer.timeOffset = musicImgVPausedTime;
    
    CAAnimation *noteImgOneAnimat = [_noteImgOne.layer animationForKey:kNoteImgOneKey];
    if (noteImgOneAnimat) {
        CFTimeInterval noteImgOnePausedTime = [_noteImgOne.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.noteImgOne.layer.speed = 0.0;
        self.noteImgOne.layer.timeOffset = noteImgOnePausedTime;
    }
    
    
    CAAnimation *noteImgTwoAnimat = [_noteImgTwo.layer animationForKey:kNoteImgTwoKey];
    if (noteImgTwoAnimat) {
        CFTimeInterval noteImgTwoPausedTime = [_noteImgTwo.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.noteImgTwo.layer.speed = 0.0;
        self.noteImgTwo.layer.timeOffset = noteImgTwoPausedTime;
    }
    
    CAAnimation *noteImgThreeAnimat = [_noteImgThree.layer animationForKey:kNoteImgThreeKey];
    if (noteImgThreeAnimat) {
        CFTimeInterval noteImgThreePausedTime = [_noteImgThree.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.noteImgThree.layer.speed = 0.0;
        self.noteImgThree.layer.timeOffset = noteImgThreePausedTime;
    }
}

//恢复动画
- (void)resumeAnimate{
    self.isRunning = YES;
    CFTimeInterval imgViewPausedTime = [_imgView.layer timeOffset];
    _imgView.layer.speed = 1.0;
    _imgView.layer.timeOffset = 0.0;
    _imgView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_imgView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - imgViewPausedTime;
    _imgView.layer.beginTime = timeSincePause;
    
    CFTimeInterval musicImgVpausedTime = [_musicImgV.layer timeOffset];
    _musicImgV.layer.speed = 1.0;
    _musicImgV.layer.timeOffset = 0.0;
    _musicImgV.layer.beginTime = 0.0;
    CFTimeInterval musicImgVTimeSincePause = [_musicImgV.layer convertTime:CACurrentMediaTime() fromLayer:nil] - musicImgVpausedTime;
    _musicImgV.layer.beginTime = musicImgVTimeSincePause;
    
    CAAnimation *noteImgOneAnimat = [_noteImgOne.layer animationForKey:kNoteImgOneKey];
    if (noteImgOneAnimat) {
        CFTimeInterval noteImgOnepausedTime = [_noteImgOne.layer timeOffset];
        _noteImgOne.layer.speed = 1.0;
        _noteImgOne.layer.timeOffset = 0.0;
        _noteImgOne.layer.beginTime = 0.0;
        CFTimeInterval _noteImgOneTimeSincePause = [_noteImgOne.layer convertTime:CACurrentMediaTime() fromLayer:nil] - noteImgOnepausedTime;
        _noteImgOne.layer.beginTime = _noteImgOneTimeSincePause;
    }
    
    CAAnimation *noteImgTwoAnimat = [_noteImgTwo.layer animationForKey:kNoteImgTwoKey];
    if (noteImgTwoAnimat) {
        CFTimeInterval noteImgTwopausedTime = [_noteImgTwo.layer timeOffset];
        _noteImgTwo.layer.speed = 1.0;
        _noteImgTwo.layer.timeOffset = 0.0;
        _noteImgTwo.layer.beginTime = 0.0;
        CFTimeInterval _noteImgTwoTimeSincePause = [_noteImgTwo.layer convertTime:CACurrentMediaTime() fromLayer:nil] - noteImgTwopausedTime;
        _noteImgTwo.layer.beginTime = _noteImgTwoTimeSincePause;
    }
    
    CAAnimation *noteImgThreeAnimat = [_noteImgThree.layer animationForKey:kNoteImgThreeKey];
    if (noteImgThreeAnimat) {
        CFTimeInterval noteImgThreepausedTime = [_noteImgThree.layer timeOffset];
        _noteImgThree.layer.speed = 1.0;
        _noteImgThree.layer.timeOffset = 0.0;
        _noteImgThree.layer.beginTime = 0.0;
        CFTimeInterval _noteImgThreeTimeSincePause = [_noteImgThree.layer convertTime:CACurrentMediaTime() fromLayer:nil] - noteImgThreepausedTime;
        _noteImgThree.layer.beginTime = _noteImgThreeTimeSincePause;
    }
}

//停止动画
- (void)stopAnimate{
    [_imgView.layer removeAnimationForKey:kImgViewVKey];
    [_musicImgV.layer removeAnimationForKey:kmusicImgVKey];
    [_noteImgOne.layer removeAnimationForKey:kNoteImgOneKey];
    [_noteImgTwo.layer removeAnimationForKey:kNoteImgTwoKey];
    [_noteImgThree.layer removeAnimationForKey:kNoteImgThreeKey];
}

@end
