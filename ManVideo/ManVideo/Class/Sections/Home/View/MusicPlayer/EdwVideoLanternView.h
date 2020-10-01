//
//  EdwVideoLanternView.h
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EdwVideoLanternView : UIControl
@property (nonatomic, copy) NSString *text;

//开始  继续
- (void)startOrResumeAnimate;

//暂停
- (void)pauseAnimate;

//继续
- (void)resumeAnimate;

//停止
- (void)stopAnimate;
@end

NS_ASSUME_NONNULL_END
