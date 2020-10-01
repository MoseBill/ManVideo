//
//  UIView + LZExtension.h
//  JKCollectionViewMoreCurve
//
//  Created by Josee on 2019/1/24.
//  Copyright © 2019年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LZExtension) 
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic) CGPoint origin;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;


//判断一个view是否在window上面
-(BOOL)isShowingOnWindow;
@end

NS_ASSUME_NONNULL_END
