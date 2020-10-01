//
//  CustomerTextView.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "StatisticsTextView.h"
#import "CustomerTextView.h"

#define num 500//字符限制最高

@interface StatisticsTextView ()
<UITextViewDelegate
,CustomerTextViewDelegate>

@property(nonatomic,strong)CustomerTextView *textView;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSMutableAttributedString *string;


@end

@implementation StatisticsTextView

-(instancetype)init{
    if (self = [super init]) {
        self.textView.alpha = 1;
        self.str = [NSString stringWithFormat:@"0/%d",num];
        self.lab.alpha = 1;
    }return self;
}

#pragma mark —— CustomerTextViewDelegate
- (void)CustomerTextViewDeleteBackward:(CustomerTextView *)textView{//已经删除过后的TextView.text
}

#pragma mark —— UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return textView.text.length < num ? YES :NO;;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
//    NSLog(@"%@",textView.text);//2
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text{//在此进行过滤操作
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
}

- (void)textViewDidChange:(UITextView *)textView{
    self.str = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length,num];
    self.lab.attributedText = [[NSMutableAttributedString alloc] initWithString:self.str
                                                                     attributes:@{
                                                                                  NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 15],
                                                                                  NSForegroundColorAttributeName: [UIColor colorWithRed:176/255.0
                                                                                                                                  green:176/255.0
                                                                                                                                   blue:176/255.0
                                                                                                                                  alpha:1.0]}];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Text"
                                                        object:textView.text];
    
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
     interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment
         inRange:(NSRange)characterRange
     interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0){
    return YES;
}

#pragma mark —— lazyLoad
-(CustomerTextView *)textView{
    if (!_textView) {
        _textView = CustomerTextView.new;
        _textView.delegate = self;
        _textView.backgroundColor = kClearColor;
        _textView.textColor = kWhiteColor;
        _textView.placeholder = NSLocalizedString(@"VedioDescribe", nil);
        _textView.customerTextViewDelegate = self;
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _textView;
}

-(NSMutableAttributedString *)string{
    if (!_string) {
        _string = [[NSMutableAttributedString alloc] initWithString:self.str
                                                         attributes:@{
                                                                      NSFontAttributeName: [UIFont fontWithName:@"PingFang SC"
                                                                                                           size: 15],
                                                                      NSForegroundColorAttributeName: [UIColor colorWithRed:176/255.0
                                                                                                                      green:176/255.0
                                                                                                                       blue:176/255.0
                                                                                                                      alpha:1.0]}];
    }return _string;
}

-(UILabel *)lab{
    if (!_lab) {
        _lab = UILabel.new;
        _lab.attributedText = self.string;
        _lab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_lab];
        [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(80), SCALING_RATIO(14)));
        }];
    }return _lab;
}

@end



