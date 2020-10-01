//
//  SDTimeLineCellModel.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import "SDTimeLineCellModel.h"

#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
//extern CGFloat maxContentLabelHeight;

@implementation SDTimeLineCellModel{
    CGFloat _lastContentWidth;
}

@synthesize msgContent = _msgContent;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"ID" : @"id",
             };
}

- (void)setMsgContent:(NSString *)msgContent{
    _msgContent = msgContent;
}

- (NSString *)msgContent{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
//        if (textRect.size.height > maxContentLabelHeight) {
//            _shouldShowMoreButton = YES;
//        } else {
//            _shouldShowMoreButton = NO;
//        }
    }
    
    return _msgContent;
}

- (void)setIsOpening:(BOOL)isOpening{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}

@end

@implementation SDTimeLineCellLikeItemModel

@end

@implementation SDTimeLineCellCommentItemModel


@end
