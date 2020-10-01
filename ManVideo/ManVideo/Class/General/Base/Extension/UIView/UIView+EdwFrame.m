//
//  UIView+EdwFrame.m
//  Imitate Animation Of DouYin
//
//  Created by EdwardCheng on 2018/10/24.
//  Copyright © 2018年 EdwardCheng. All rights reserved.
//

#import "UIView+EdwFrame.h"

@implementation UIView (EdwFrame)
- (CGFloat)edw_x {
    return self.frame.origin.x;
}

- (void)setEdw_x:(CGFloat)edw_x {
    CGRect frame = self.frame;
    frame.origin.x = edw_x;
    self.frame = frame;
}

- (CGFloat)edw_left {
    return self.frame.origin.x;
}

- (void)setEdw_left:(CGFloat)edw_left {
    CGRect frame = self.frame;
    frame.origin.x = edw_left;
    self.frame = frame;
}

- (CGFloat)edw_y {
    return self.frame.origin.y;
}

- (void)setEdw_y:(CGFloat)edw_y {
    CGRect frame = self.frame;
    frame.origin.y = edw_y;
    self.frame = frame;
}

- (CGFloat)edw_top {
    return self.frame.origin.y;
}

- (void)setEdw_top:(CGFloat)edw_top {
    CGRect frame = self.frame;
    frame.origin.y = edw_top;
    self.frame = frame;
}

- (CGFloat)edw_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setEdw_right:(CGFloat)edw_right {
    CGRect frame = self.frame;
    frame.origin.x = edw_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)edw_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setEdw_bottom:(CGFloat)edw_bottom {
    
    CGRect frame = self.frame;
    
    frame.origin.y = edw_bottom - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)edw_width {
    return self.frame.size.width;
}

- (void)setEdw_width:(CGFloat)edw_width {
    CGRect frame = self.frame;
    frame.size.width = edw_width;
    self.frame = frame;
}

- (CGFloat)edw_height {
    return self.frame.size.height;
}

- (void)setEdw_height:(CGFloat)edw_height {
    CGRect frame = self.frame;
    frame.size.height = edw_height;
    self.frame = frame;
}

- (CGFloat)edw_centerX {
    return self.center.x;
}

- (void)setEdw_centerX:(CGFloat)edw_centerX {
    self.center = CGPointMake(edw_centerX, self.center.y);
}

- (CGFloat)edw_centerY {
    return self.center.y;
}

- (void)setEdw_centerY:(CGFloat)edw_centerY {
    self.center = CGPointMake(self.center.x, edw_centerY);
}

- (CGPoint)edw_origin {
    return self.frame.origin;
}

- (void)setEdw_origin:(CGPoint)edw_origin {
    CGRect frame = self.frame;
    frame.origin = edw_origin;
    self.frame = frame;
}

- (CGSize)edw_size {
    return self.frame.size;
}

- (void)setEdw_size:(CGSize)edw_size {
    CGRect frame = self.frame;
    frame.size = edw_size;
    self.frame = frame;
}

@end
