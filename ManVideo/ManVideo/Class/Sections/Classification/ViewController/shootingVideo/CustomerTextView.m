//
//  CustomerTextView.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CustomerTextView.h"

@interface CustomerTextView (){
    
}

@end

@implementation CustomerTextView

-(instancetype)init{
    if ([super init]) {
    }return self;
}

- (void)deleteBackward {
//    ！！！这里要调用super方法，要不然删不了东西
    [super deleteBackward];
    if ([self.customerTextViewDelegate respondsToSelector:@selector(CustomerTextViewDeleteBackward:)]) {
        [self.customerTextViewDelegate CustomerTextViewDeleteBackward:self];
    }
}

//解决 iOS8.0到iOS8.2 不响应的问题
- (BOOL)keyboardInputShouldDelete:(UITextField *)textField{
    BOOL shouldDelete = YES;
    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }
    BOOL isIos8 = ([[[UIDevice currentDevice] systemVersion] intValue] == 8);
    BOOL isLessThanIos8_3 = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3f);
    if (![textField.text length] && isIos8 && isLessThanIos8_3) {
        [self deleteBackward];
    }return shouldDelete;
}


@end
