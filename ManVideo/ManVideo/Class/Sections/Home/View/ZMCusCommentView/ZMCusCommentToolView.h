//
//  ZMCusCommentToolView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Josee. All rights reserved.
//  底部回复工具条

#import <UIKit/UIKit.h>

@interface ZMCusCommentToolView : UIView
@property (nonatomic, copy) void(^sendBtnBlock)(void);
@property (nonatomic, copy) void(^changeTextBlock)(NSString *text,CGRect frame);

- (void)showTextView;
- (void)hideTextView;
- (void)resetView;
@end
