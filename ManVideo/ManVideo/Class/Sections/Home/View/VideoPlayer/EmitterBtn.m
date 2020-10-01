//
//  EmitterBtn.m
//  CABasic
//
//  Created by zhangwei on 17/4/28.
//  Copyright © 2017年 jyall. All rights reserved.
//

#import "EmitterBtn.h"

@interface EmitterBtn ()

@property(nonatomic,strong)CAEmitterLayer *explosionLayer;
@property(nonatomic,strong)CAKeyframeAnimation *animation;
@property(nonatomic,strong)CAEmitterCell *explosionCell;

@end

@implementation EmitterBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.explosionLayer];
    }return self;
}

-(CAEmitterLayer *)explosionLayer{
    if (!_explosionLayer) {
        _explosionLayer = [CAEmitterLayer layer];
        _explosionLayer.name = @"explosionLayer";
        _explosionLayer.emitterShape = kCAEmitterLayerCircle;//发射源的形状
        _explosionLayer.emitterMode = kCAEmitterLayerOutline;//发射模式
//        _explosionLayer.emitterSize = CGSize.init(width: 10, height: 0);
        _explosionLayer.emitterSize = CGSizeMake(5, 0);//发射源大小
        _explosionLayer.emitterCells = @[self.explosionCell];//发射源包含的粒子
        _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;//渲染模式
        _explosionLayer.masksToBounds = false;
        _explosionLayer.birthRate = 0;
        _explosionLayer.zPosition = 0;
    }return _explosionLayer;
}

-(CAEmitterCell *)explosionCell{
    if (!_explosionCell) {
        _explosionCell = [CAEmitterCell emitterCell];
        _explosionCell.name = @"explosion";
        _explosionCell.alphaRange = 0.10;//设置粒子颜色alpha能改变的范围
        _explosionCell.alphaSpeed = -1.0;//粒子alpha的改变速度
        _explosionCell.lifetime = 0.7;//粒子的生命周期
        _explosionCell.lifetimeRange = 0.3;//粒子生命周期的范围;
        _explosionCell.birthRate = 2500;//粒子发射的初始速度
        _explosionCell.velocity = 40.00;//粒子的速度
        _explosionCell.velocityRange = 10.00;//粒子速度范围
        _explosionCell.scale = 0.03;//粒子的缩放比例
        _explosionCell.scaleRange = 0.02;//缩放比例范围
        _explosionCell.contents = (id)([[UIImage imageNamed:@"sparkle"] CGImage]);//粒子要展现的图片
    }return _explosionCell;
}

-(CAKeyframeAnimation *)animation{
    if (!_animation) {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        _animation.calculationMode = kCAAnimationCubic;
        [self.layer addAnimation:_animation
                          forKey:@"transform.scale"];
        if (self.selected) {
            _animation.values = @[@1.5,@0.8,@1.0,@1.2,@1.0];
            _animation.duration = 0.5;
        }else{
            _animation.values = @[@0.8,@1.0];
            _animation.duration = 0.4;
        }
    }return _animation;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.explosionLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)startAnimation{
    _explosionLayer.beginTime = CACurrentMediaTime();
    //每秒生成多少个粒子
    _explosionLayer.birthRate = 1;
//    perform(#selector(STPraiseEmitterBtn.stopAnimation), with: nil, afterDelay: 0.15);
    [self performSelector:@selector(stopAnimation)
               withObject:self
               afterDelay:0.15f];
}

- (void)stopAnimation {
    _explosionLayer.birthRate = 0;
}

@end
