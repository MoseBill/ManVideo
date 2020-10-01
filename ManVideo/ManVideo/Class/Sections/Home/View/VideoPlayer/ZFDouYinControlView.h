//
//  ZFDouYinControlView.h
//  ZFPlayer_Example
//
//  Created by 任子丰 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>

@interface ZFDouYinControlView : UIView <ZFPlayerMediaControl>

@property(nonatomic,copy)void (^showAdBlock)(void);
@property(nonatomic,copy)void (^dissmissCommentVC)(void);

- (void)resetControlView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl
               withImageMode:(UIViewContentMode)contentMode;

@end
