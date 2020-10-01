//
//  EdwVideoSoundSlider.h
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EdwVideoSoundSlider;

@protocol EdwVideoSoundSliderDelegate <NSObject>
- (void)edw_VideoSoundSlider:(EdwVideoSoundSlider *)slider isShow:(BOOL)show;
@end

@interface EdwVideoSoundSlider : UIView
@property (nonatomic, weak) id<EdwVideoSoundSliderDelegate> delegate;

- (void)setValue:(float)value animate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
