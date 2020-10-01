//
//  EdwPlayerProgressView.h
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EdwPlayerProgressView : UIView
///播放进度
@property (nonatomic, assign) CGFloat playingProgress;

///缓冲进度
@property (nonatomic, assign) CGFloat burfferProgress;


///播放进度颜色
@property(nonatomic, strong) UIColor* playingTintColor;

///缓冲进度颜色
@property(nonatomic, strong) UIColor* burfferTintColor;

- (void)startBurfferAnimate;

- (void)stopBurfferAnimate;
@end

NS_ASSUME_NONNULL_END
