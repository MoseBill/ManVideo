//
//  EdwVideoSoundSlider.m
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import "EdwVideoSoundSlider.h"

@interface EdwVideoSoundSlider ()
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation EdwVideoSoundSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _sliderView = [[UIView alloc]init];
    _sliderView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_sliderView];
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(@0.01);
    }];
}

- (void)setValue:(float)value animate:(BOOL)animate{
    self.hidden = NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(edw_VideoSoundSlider:isShow:)]) {
        [self.delegate edw_VideoSoundSlider:self isShow:YES];
    }
    CGFloat width = self.frame.size.width * value;
    [_sliderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    
    if (animate) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setSliderHidden) object:nil];
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self performSelector:@selector(setSliderHidden) withObject:nil afterDelay:1];
        }];
    }
}

- (void)setSliderHidden{
    self.hidden = YES;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(edw_VideoSoundSlider:isShow:)]) {
        [self.delegate edw_VideoSoundSlider:self isShow:NO];
    }
}

@end
