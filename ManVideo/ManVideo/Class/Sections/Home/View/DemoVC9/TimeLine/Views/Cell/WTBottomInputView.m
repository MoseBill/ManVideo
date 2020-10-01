
//
//  WTBottomInputView.m
//  zkjkClient
//
//  Created by Tao on 2018/7/6.
//  Copyright © 2018年 Tao. All rights reserved.
//

#import "WTBottomInputView.h"
#import "UIView+Ext.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
#define TAB_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)

@interface WTBottomInputView ()
<
UITextViewDelegate
//,ReplyActionViewDelegate
>

@property(nonatomic,strong)UIView *bottomBgView;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,copy)NSString *stringEditing;
@property(nonatomic,assign)int index;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *articId;
@property(nonatomic,copy)NSString *reply;
@property(nonatomic,copy)NSString *replyMessage;
@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;

@end

@implementation WTBottomInputView

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@""];
        self.bottomBgView.alpha = 1;
        self.textView.alpha = 1;
        self.tapGesture.numberOfTapsRequired = 1;
        [self addNotification];
    }return self;
}
#pragma mark--添加通知---
- (void)addNotification {
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardWillChangeFrame:)
//                                                name:UIKeyboardWillChangeFrameNotification
//                                              object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardDidChangeFrame:)
//                                                name:UIKeyboardDidChangeFrameNotification
//                                              object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillhide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationComment:)
                                                 name:@"comment"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationReply:)
                                                 name:@"Reply"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotificationFirst:)
                                                 name:@"commentFirst"
                                               object:@"FirstComment"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationSendMessage:)
                                                 name:@"sendReplyMessage"
                                               object:nil];
}

#pragma mark —— 内部调用
- (void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer{
    [self endEditing:YES];
}

- (void)senderBtnClick{
    if (self.ID||
        self.articId) {
        if (self.textView.text.length <= 0) return;
        [self endEditing:YES];
        NSDictionary *dic = @{@"articId":self.articId,
                              @"Id":self.ID,
                              @"message":self.textView.text};
        // 发送通知.
        if ([self.delegateReply respondsToSelector:@selector(replyInformationMessage:)]) {
            [self.delegateReply replyInformationMessage:dic];
        }
    } else if  (self.replyMessage) {
        if ([self.delegateReply respondsToSelector:@selector(replyMyMessage:)]) {
            [self.delegateReply replyMyMessage:self.textView.text];
        }
      } else {
    if (self.textView.text.length <= 0) return;
    if ([self.delegate respondsToSelector:@selector(WTBottomInputViewSendTextMessage:)]) {
        [self.delegate WTBottomInputViewSendTextMessage:self.textView.text];
     }
  }
}
#pragma mark —— UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    DLog(@"===>>");
}

- (void)textViewDidChange:(UITextView *)textView{
    DLog(@"===>>");
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    DLog(@"===>>");
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    DLog(@"===>>");
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"按下发送键");
        if (self.MyBlock) {
            self.MyBlock();
        }
    }return YES;
}

#pragma mark —— 通知方法
//- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    NSDictionary *userInfo = notification.userInfo;
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyboardY = keyboardF.origin.y;
//    @weakify(self)
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         @strongify(self)
//                         self.bottomBgView.Y = keyboardY - 49;
//                     }];
//}//896

//- (void)keyboardDidChangeFrame:(NSNotification *)notification{
//}

//- (void)keyboardWillShow:(NSNotification *)notification{
//    NSDictionary *userInfo = notification.userInfo;
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyboardY = keyboardF.origin.y;
//    self.Y = 0;
//    self.height = 0;
//    self.bottomBgView.Y = SCREEN_HEIGHT-TAB_HEIGHT;
//    @weakify(self)
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         @strongify(self)
//                         self.bottomBgView.Y = keyboardY - 49;
//                     }];
//}
//
- (void)keyboardWillhide:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    self.Y = isiPhoneX_series() ? SCREEN_HEIGHT-TAB_HEIGHT - 30 : SCREEN_HEIGHT-TAB_HEIGHT;


//    self.height = TAB_HEIGHT;
//    self.bottomBgView.Y = 0;
    [self.textView endEditing:YES];
    [self senderBtnClick];
//    @weakify(self)
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         @strongify(self)
//                         self.bottomBgView.Y = 0;
//                     }];
}

- (void)notificationSendMessage:(NSNotification *)message {
    self.ID = nil;
    self.articId = nil;
    [self.textView becomeFirstResponder];
    self.replyMessage = @"1010";
}

// @selector(receiveNotification:)方法， 即受到通知之后的事件
- (void)receiveNotificationComment:(NSNotification *)noti{
    // NSNotification 有三个属性，name, object, userInfo，其中最关键的object就是从第三个界面传来的数据。name就是通知事件的名字， userInfo一般是事件的信息。
    [self.textView becomeFirstResponder];
    self.articId = noti.userInfo[@"articId"];
    self.ID = noti.userInfo[@"Id"];
//    JMLog(@"评论%@  == %d",self.stringEditing,self.index);
}
//
- (void)receiveNotificationReply:(NSNotification *)noti {
    [self.textView becomeFirstResponder];
    NSString *placeString = [NSString stringWithFormat:@"回复%@",noti.userInfo[@"cretaeBy"]];
    self.textView.placeholder = placeString;
    self.articId = noti.userInfo[@"articId"];
    self.ID = noti.userInfo[@"Id"];
}

- (void)receiveNotificationFirst:(NSNotification *)noti {
    [self.textView becomeFirstResponder];
    self.textView.placeholder = NSLocalizedString(@"VDcommentsText", nil);
    self.articId = noti.userInfo[@"articId"];
    self.ID = noti.userInfo[@"Id"];
}

#pragma mark —— 外部访问
- (void)showView{
    [self setHidden:NO];
}

- (void)hideView{
    [self setHidden:YES];
}

#pragma mark —— lazyload
- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        _bottomBgView = UIView.new;
        _bottomBgView.backgroundColor = [UIColor colorWithHexString:@"19132B"];
        [self addSubview:_bottomBgView];
        [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _bottomBgView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = UITextView.new;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = kWhiteColor;
        _textView.backgroundColor = kClearColor;
        _textView.layer.masksToBounds = YES;
        _textView.placeholder = NSLocalizedString(@"VDWantSay", nil);
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor= kClearColor.CGColor;
        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
        [self.bottomBgView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomBgView);
        }];
    }return _textView;
}

-(UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTapPress:)];
        [self addGestureRecognizer:self.tapGesture];
    }return _tapGesture;
}

#pragma mark —— 疑似被遗弃
- (void)endEiet:(NSString *)eidtString {
    if ([eidtString isEqualToString:@"回复成功"]) {
        [self.textView endEditing:YES];
    }
}

@end
