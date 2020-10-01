//
//  EdwPlayerProgressView.m
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import "EdwPlayerProgressView.h"
#import "UIView+EdwFrame.h"
@interface EdwPlayerProgressView ()

@property (nonatomic, strong) UIImageView *burfferImgV;

@end

@implementation EdwPlayerProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tintColor = [UIColor whiteColor];
        self.burfferTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        self.playingTintColor = [UIColor redColor];
        self.burfferImgV = [[UIImageView alloc]init];
        self.burfferImgV.image = [UIImage imageNamed:@"video_burffering"];
        self.burfferImgV.contentMode = UIViewContentModeScaleToFill;
        self.burfferImgV.hidden = YES;
        [self addSubview:self.burfferImgV];
        
        [self.burfferImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
    }
    return self;
}

- (void)setPlayingProgress:(CGFloat)playingProgress
{
    if (!self.burfferImgV.isHidden) {
        [self stopBurfferAnimate];
    }
    _playingProgress = playingProgress;
   
    [self setNeedsDisplay];
}

- (void)setBurfferProgress:(CGFloat)burfferProgress{
    _burfferProgress = burfferProgress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    //burffer
    [[self bezierPathWithPoint:CGPointMake(0, self.edw_height * 0.5) endPoint:CGPointMake(self.edw_width * self.burfferProgress, self.edw_height * 0.5) lineColor:self.burfferTintColor lineWidth:self.edw_height] stroke];
    
    //playing
    [[self bezierPathWithPoint:CGPointMake(0, self.edw_height * 0.5) endPoint:CGPointMake(self.edw_width * self.playingProgress, self.edw_height * 0.5) lineColor:self.playingTintColor lineWidth:self.edw_height] stroke];
    
}

- (UIBezierPath *)bezierPathWithPoint:(CGPoint)startPoint endPoint:(CGPoint) endPoint lineColor:(UIColor*)lineColor lineWidth:(CGFloat)lineWidth{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [lineColor setStroke];
    path.lineWidth = lineWidth;
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    return path;
}

- (void)startBurfferAnimate{
    _playingProgress = 0.0;
    [self setNeedsDisplay];
    self.burfferImgV.hidden = NO;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basicAnimation.duration = 0.8;//完成动画的时间
    basicAnimation.fromValue = @(0.1f); // 起始角度
    basicAnimation.toValue = @(1.0f);
    basicAnimation.repeatCount = MAXFLOAT;//重复次数
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.burfferImgV.layer addAnimation:basicAnimation forKey:@"QLPlayerProgressViewBurffer"];
}

- (void)stopBurfferAnimate{
    if (!self.burfferImgV.isHidden) {
        [self.burfferImgV.layer removeAnimationForKey:@"QLPlayerProgressViewBurffer"];
        self.burfferImgV.hidden = YES;
    }
}

@end
