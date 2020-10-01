//
//  SDTimeLineCellCommentView.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#import "GlobalDefines.h"

@protocol ReplyActionDelegate <NSObject>

- (void)replyClickView:(UIButton *)sender;
- (void)replyTapClick:(UITapGestureRecognizer*)tap;

@end

@interface SDTimeLineCellCommentView : UIView

@property (nonatomic, weak) id<ReplyActionDelegate> delegate;

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray
              commentItemsArray:(NSArray *)commentItemsArray;

@end
