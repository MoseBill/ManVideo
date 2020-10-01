//
//  UIView+EdwFrame.h
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (EdwFrame)
@property (nonatomic, assign) CGFloat edw_x;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign) CGFloat edw_y;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign) CGFloat edw_left;        //便于理解
@property (nonatomic, assign) CGFloat edw_top;         //便于理解
@property (nonatomic, assign) CGFloat edw_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat edw_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat edw_width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign) CGFloat edw_height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign) CGFloat edw_centerX;     ///< Shortcut for center.x
@property (nonatomic, assign) CGFloat edw_centerY;     ///< Shortcut for center.y
@property (nonatomic, assign) CGPoint edw_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  edw_size;        ///< Shortcut for frame.size.
@end

NS_ASSUME_NONNULL_END
