//
//  NSString+Emoji.h
//  ManVideo
//
//  Created by 刘赓 on 2019/10/3.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Emoji)

- (NSString *)emojiEncode;
- (NSString *)emojiDecode;

@end

NS_ASSUME_NONNULL_END
