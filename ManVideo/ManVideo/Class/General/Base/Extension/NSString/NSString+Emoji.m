//
//  NSString+Emoji.m
//  ManVideo
//
//  Created by 刘赓 on 2019/10/3.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)

//编码
- (NSString *)emojiEncode{
    NSString *uniStr = [NSString stringWithUTF8String:[self UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *emojiText = [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding];
    return emojiText;
}

//解码
- (NSString *)emojiDecode{
    const char *jsonString = [self UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    NSString *emojiText = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    return emojiText;
}

@end
