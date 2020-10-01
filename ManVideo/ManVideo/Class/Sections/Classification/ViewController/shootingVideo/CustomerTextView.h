//
//  CustomerTextView.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerTextView;

@protocol CustomerTextViewDelegate <NSObject>

- (void)CustomerTextViewDeleteBackward:(CustomerTextView *)textView;

@end

/**
 可以监听 删除键的 UITextView子类
 */
@interface CustomerTextView : UITextView

@property(nonatomic,assign)id<CustomerTextViewDelegate> customerTextViewDelegate;

@end

NS_ASSUME_NONNULL_END
