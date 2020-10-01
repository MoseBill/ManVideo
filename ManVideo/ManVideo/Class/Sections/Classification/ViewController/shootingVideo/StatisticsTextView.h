//
//  CustomerTextView.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 字数限制的TextView
 未测试除英文、汉文以外的字符
 限制策略:
 1、一个中文——>字数+1
 2、一个Emoji字符——>字数+1
 3、一个数字——>字数+1
 4、单个英文字母+1
 6、删除键一次——>字数-1
 7、换行+空格——>字数+0
 */
@interface StatisticsTextView : UIView


@end

NS_ASSUME_NONNULL_END
