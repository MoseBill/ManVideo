//
//  UIControl+controlButton.h
//  Clipyeu ++
//
//  Created by Josee on 21/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define defaultInterval .5//默认时间间隔

@interface UIControl (controlButton)

@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击

@end

NS_ASSUME_NONNULL_END
