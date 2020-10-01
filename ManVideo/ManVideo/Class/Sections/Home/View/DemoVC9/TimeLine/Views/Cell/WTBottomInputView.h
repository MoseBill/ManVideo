//
//  WTBottomInputView.h
//  zkjkClient
//
//  Created by Tao on 2018/7/6.
//  Copyright © 2018年 Tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTBottomInputViewDelegate <NSObject>
-(void)WTBottomInputViewSendTextMessage:(NSString *)message;
@end

@protocol ReplyInformationDelegate <NSObject>
- (void)replyInformationMessage:(NSDictionary *)dict;
- (void)replyMyMessage:(NSString *)message;
@end

@interface WTBottomInputView : UIView

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,weak)id<WTBottomInputViewDelegate>delegate;
@property(nonatomic,weak)id<ReplyInformationDelegate> delegateReply;
@property(nonatomic,copy)void (^MyBlock)(void);

- (void)showView;
- (void)hideView;

@end
