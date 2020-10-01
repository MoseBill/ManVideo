//
//  ZFDouYinControlView.h
//  ZFPlayer_Example
//
//  Created by Josee on 2018/6/4.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>
#import "ZFPortraitControlView.h"
#import "ZFLandScapeControlView.h"
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFSpeedLoadingView.h"

@protocol ZFDouYinDelegate <NSObject>

- (void)playerValue:(CGFloat)value indexPath:(NSIndexPath *)index;

@end

@interface ZFDouYinControlView : UIView <ZFPlayerMediaControl>
//{
//    XLSlider *_slider;
//}
@property (nonatomic, strong)  id<ZFDouYinDelegate> delegate;

@property (nonatomic, strong) NSIndexPath    *indexPath;

- (void)resetControlView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl;

/// 竖屏控制层的View
@property (nonatomic, strong, readonly) ZFPortraitControlView *portraitControlView;
/// 横屏控制层的View
@property (nonatomic, strong, readonly) ZFLandScapeControlView *landScapeControlView;
/// 加载loading
@property (nonatomic, strong, readonly) ZFSpeedLoadingView *activity;
/// 快进快退View
@property (nonatomic, strong, readonly) UIView *fastView;
/// 快进快退进度progress
@property (nonatomic, strong, readonly) ZFSliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong, readonly) UILabel *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong, readonly) UIImageView *fastImageView;
/// 加载失败按钮
@property (nonatomic, strong, readonly) UIButton *failBtn;
/// 底部播放进度
@property (nonatomic, strong, readonly) ZFSliderView *bottomPgrogress;
/// 封面图
@property (nonatomic, strong, readonly) UIImageView *coverImageView;
/// 高斯模糊的背景图
@property (nonatomic, strong, readonly) UIImageView *bgImgView;
/// 高斯模糊视图
@property (nonatomic, strong, readonly) UIView *effectView;
/// 占位图，默认是灰色
@property (nonatomic, strong) UIImage *placeholderImage;
/// 快进视图是否显示动画，默认NO.
@property (nonatomic, assign) BOOL fastViewAnimated;
/// 视频之外区域是否高斯模糊显示，默认YES.
@property (nonatomic, assign) BOOL effectViewShow;
/// 直接进入全屏模式，只支持全屏模式
@property (nonatomic, assign) BOOL fullScreenOnly;
/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;
/// 返回按钮点击回调
@property (nonatomic, copy) void(^backBtnClickCallback)(void);
/// 控制层显示或者隐藏
@property (nonatomic, readonly) BOOL controlViewAppeared;
/// 控制层显示或者隐藏的回调
@property (nonatomic, copy) void(^controlViewAppearedCallback)(BOOL appeared);
/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;
/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

/// 设置标题、封面、全屏模式
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/// 设置标题、UIImage封面、全屏模式
- (void)showTitle:(NSString *)title coverImage:(UIImage *)image fullScreenMode:(ZFFullScreenMode)fullScreenMode;

/// 重置控制层
- (void)resetControlView;

@end
