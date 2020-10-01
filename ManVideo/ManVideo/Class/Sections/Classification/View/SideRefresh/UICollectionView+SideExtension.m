//
//  UICollectionView+SideExtension.m
//  CollectionViewSideRefresh
//
//  Created by dangercheng on 2018/9/12.
//  Copyright © 2018年 DandJ. All rights reserved.
//

#import "UICollectionView+SideExtension.h"

@implementation UICollectionView (SideExtension)
static BOOL respondsToAdjustedContentInset_;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        respondsToAdjustedContentInset_ = [self instancesRespondToSelector:@selector(adjustedContentInset)];
    });
}

- (UIEdgeInsets)side_inset
{
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        if (@available(iOS 11.0, *)) {
            return self.adjustedContentInset;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    return self.contentInset;
}

- (CGFloat)side_insetL
{
    return self.side_inset.left;
}

- (void)setSide_insetL:(CGFloat)side_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = side_insetL;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        if (@available(iOS 11.0, *)) {
            inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)side_insetR {
    return self.side_inset.right;
}

- (void)setSide_insetR:(CGFloat)side_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = side_insetR;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        if (@available(iOS 11.0, *)) {
            inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    self.contentInset = inset;
}

@end
