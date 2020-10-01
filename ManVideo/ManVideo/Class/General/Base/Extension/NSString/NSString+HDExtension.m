//
//  NSString+HDExtension.m
//  PortableTreasure
//
//  Created by HeDong on 15/5/10.
//  Copyright © 2015年 hedong. All rights reserved.
//

#import "NSString+HDExtension.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (HDExtension)

//简单的MD5加密
+ ( NSString *)md5String:( NSString *)str{
    const char *myPasswd = [str UTF8String];
    unsigned char mdc[16];
    CC_MD5 (myPasswd, (CC_LONG) strlen (myPasswd), mdc);
    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0 ; i < 16 ; i++) {
        [md5String appendFormat : @"%02x" ,mdc[i]];
    } return md5String;
}
//复杂的MD5加密
+( NSString *)md5String2:( NSString *)str{
    const char *myPasswd = [str UTF8String];
    unsigned char mdc[16];
    CC_MD5 (myPasswd, (CC_LONG) strlen (myPasswd), mdc);
    NSMutableString *md5String = [NSMutableString string];
    [md5String appendFormat : @"%02x" ,mdc[0]];
    for ( int i = 1 ; i < 16 ; i++) {
        [md5String appendFormat : @"%02x" ,mdc[i]^mdc[0]];
    }return md5String;
}

#pragma mark - 散列函数
- (instancetype)hd_md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_MD5_DIGEST_LENGTH];
}

- (instancetype)hd_sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA1_DIGEST_LENGTH];
}

- (instancetype)hd_sha224String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(str, (CC_LONG)strlen(str), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA224_DIGEST_LENGTH];
}

- (instancetype)hd_sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA256_DIGEST_LENGTH];
}

- (instancetype)hd_sha384String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(str, (CC_LONG)strlen(str), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA384_DIGEST_LENGTH];
}

- (instancetype)hd_sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - HMAC 散列函数
- (instancetype)hd_hmacMD5StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_MD5_DIGEST_LENGTH];
}

- (instancetype)hd_hmacSHA1StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA1_DIGEST_LENGTH];
}

- (instancetype)hd_hmacSHA256StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA256_DIGEST_LENGTH];
}

- (instancetype)hd_hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 文件散列函数
#define FileHashDefaultChunkSizeForReadingData 4096
- (instancetype)hd_fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) return nil;
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    return [self hd_stringFromBytes:buffer
                             length:CC_MD5_DIGEST_LENGTH];
}

- (instancetype)hd_fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) return nil;
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA1_DIGEST_LENGTH];
}

- (instancetype)hd_fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) return nil;
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA256_DIGEST_LENGTH];
}

- (instancetype)hd_fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) return nil;
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) break;
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self hd_stringFromBytes:buffer
                             length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - Base64编码
- (instancetype)hd_base64Encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (instancetype)hd_base64Decode {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

#pragma mark - 路径方法
+ (instancetype)hd_pathForDocuments {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathAtDocumentsWithFileName:(NSString *)fileName {
    return  [[self hd_pathForDocuments] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForCaches {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathAtCachesWithFileName:(NSString *)fileName {
    return [[self hd_pathForCaches] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForMainBundle {
    return [NSBundle mainBundle].bundlePath;
}

+ (instancetype)hd_filePathAtMainBundleWithFileName:(NSString *)fileName {
    return [[self hd_pathForMainBundle] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForTemp {
    return NSTemporaryDirectory();
}

+ (instancetype)hd_filePathAtTempWithFileName:(NSString *)fileName {
    return [[self hd_pathForTemp] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForPreferences {
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathAtPreferencesWithFileName:(NSString *)fileName {
    return [[self hd_pathForPreferences] stringByAppendingPathComponent:fileName];
}

+ (instancetype)hd_pathForSystemFile:(NSSearchPathDirectory)directory {
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
}

+ (instancetype)hd_filePathForSystemFile:(NSSearchPathDirectory)directory
                            withFileName:(NSString *)fileName {
    return [[self hd_pathForSystemFile:directory] stringByAppendingPathComponent:fileName];
}

#pragma mark - 文本计算方法
- (CGSize)hd_sizeWithSystemFont:(UIFont *)font
              constrainedToSize:(CGSize)size
                  lineBreakMode:(NSLineBreakMode)mode {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = mode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

- (CGSize)hd_sizeWithSystemFont:(UIFont *)font
              constrainedToSize:(CGSize)size
                  lineBreakMode:(NSLineBreakMode)mode
                   numberOfLine:(NSInteger)numberOfLine {
    CGSize maxSize = [self hd_sizeWithSystemFont:font constrainedToSize:size lineBreakMode:mode];
    CGFloat oneLineHeight = [self hd_sizeWithSystemFont:font
                                      constrainedToSize:CGSizeMake(size.width, font.lineHeight)
                                          lineBreakMode:NSLineBreakByTruncatingTail].height;
    CGFloat height = 0;
    CGFloat limitHeight = oneLineHeight * numberOfLine;
    
    if (maxSize.height > limitHeight) {
        height = limitHeight;
    } else {
        height = maxSize.height;
    }
    
    return CGSizeMake(maxSize.width, height);
}

- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self hd_sizeWithSystemFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)hd_sizeWithText:(NSString *)text systemFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [text hd_sizeWithSystemFont:font constrainedToSize:size];
}

- (CGSize)hd_sizeWithBoldFont:(UIFont *)font
            constrainedToSize:(CGSize)size
                lineBreakMode:(NSLineBreakMode)mode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = mode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle};

    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

- (CGSize)hd_sizeWithBoldFont:(UIFont *)font
            constrainedToSize:(CGSize)size {
    return [self hd_sizeWithBoldFont:font
                   constrainedToSize:size
                       lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)hd_sizeWithBoldFont:(UIFont *)font
            constrainedToSize:(CGSize)size
                lineBreakMode:(NSLineBreakMode)mode
                 numberOfLine:(NSInteger)numberOfLine {
    CGSize maxSize = [self hd_sizeWithBoldFont:font constrainedToSize:size lineBreakMode:mode];
    CGFloat oneLineHeight = [self hd_sizeWithBoldFont:font
                                    constrainedToSize:CGSizeMake(size.width, font.lineHeight)
                                        lineBreakMode:NSLineBreakByTruncatingTail].height;
    CGFloat height = 0;
    CGFloat limitHeight = oneLineHeight * numberOfLine;
    
    if (maxSize.height > limitHeight) {
        height = limitHeight;
    } else {
        height = maxSize.height;
    }return CGSizeMake(maxSize.width, height);
}


#pragma mark - 富文本相关
- (NSAttributedString *)hd_conversionToAttributedStringWithLineSpeace:(CGFloat)lineSpacing
                                                                 kern:(CGFloat)kern
                                                        lineBreakMode:(NSLineBreakMode)lineBreakMode
                                                            alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSKernAttributeName:@(kern)};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self
                                                                                         attributes:attributes];
    return attributedString;
}

- (CGSize)hd_sizeWithAttributedStringLineSpeace:(CGFloat)lineSpeace
                                           kern:(CGFloat)kern
                                           font:(UIFont *)font
                                           size:(CGSize)size
                                  lineBreakMode:(NSLineBreakMode)lineBreakMode
                                      alignment:(NSTextAlignment)alignment {
    if (!font) {
        NSLog(@"font不能为空");
        return CGSizeMake(0, 0);
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    paraStyle.lineBreakMode = lineBreakMode;
    paraStyle.alignment = alignment;
    
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@(kern)};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

- (CGSize)hd_sizeWithAttributedStringLineSpeace:(CGFloat)lineSpeace
                                           kern:(CGFloat)kern
                                           font:(UIFont *)font
                                           size:(CGSize)size
                                  lineBreakMode:(NSLineBreakMode)lineBreakMode
                                      alignment:(NSTextAlignment)alignment
                                   numberOfLine:(NSInteger)numberOfLine {
    CGSize maxSize = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace
                                                            kern:kern
                                                            font:font
                                                            size:size
                                                   lineBreakMode:lineBreakMode
                                                       alignment:alignment];
    CGFloat oneLineHeight = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace
                                                                   kern:kern
                                                                   font:font
                                                                   size:CGSizeMake(size.width, font.lineHeight)
                                                          lineBreakMode:NSLineBreakByTruncatingTail alignment:alignment].height;
    CGFloat height = 0;
    CGFloat limitHeight = oneLineHeight * numberOfLine;
    
    if (maxSize.height > limitHeight) {
        height = limitHeight;
    } else {
        height = maxSize.height;
    }
    
    return CGSizeMake(maxSize.width, height);
}

- (BOOL)hd_numberOfLineWithLineSpeace:(CGFloat)lineSpeace
                                 kern:(CGFloat)kern
                                 font:(UIFont *)font
                                 size:(CGSize)size
                        lineBreakMode:(NSLineBreakMode)lineBreakMode
                            alignment:(NSTextAlignment)alignment {
    CGFloat oneHeight = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace
                                                               kern:kern font:font
                                                               size:CGSizeMake(size.width, font.lineHeight)
                                                      lineBreakMode:NSLineBreakByTruncatingTail alignment:alignment].height;
    CGFloat maxHeight = [self hd_sizeWithAttributedStringLineSpeace:lineSpeace
                                                               kern:kern
                                                               font:font size:size
                                                      lineBreakMode:lineBreakMode
                                                          alignment:alignment].height;
    if (maxHeight > oneHeight) {
        return NO;
    }return YES;
}

#pragma mark - 效验相关
- (BOOL)hd_isValidEmail {
    NSString *emailRegex = @"((?<![0-9])([A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4})(?![0-9]))";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)hd_isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)hd_isValidUrl {
    NSString *regex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#;$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^;&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)hd_isValidateMobile {
    if (self.length < 1) {
        return NO;
    } return YES; // 现在新增手机号段很多_国际别的手机不一定11位_手机号其实没必要限制死!
}

#pragma mark - 限制相关
- (instancetype)hd_limitLength:(NSInteger)length {
    NSString *str = self;
    if (str.length > length) {
        str = [str substringToIndex:length];
    }return str;
}

- (NSUInteger)hd_length {
    float number = 0.0;
    
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number + 0.5;
        }
    }return ceil(number);
}

- (instancetype)hd_substringMaxLength:(NSUInteger)maxLength {
    NSMutableString *ret = [[NSMutableString alloc] init];
    float number = 0.0;
    
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number + 0.5;
        }
        
        if (number <= maxLength) {
            [ret appendString:character];
        } else {
            break;
        }
    }return [ret copy];
}

#pragma mark - 其他
/**
 *  返回二进制 Bytes 流的字符串表示形式
 *
 *  @param bytes  二进制 Bytes 数组
 *  @param length 数组长度
 *
 *  @return 字符串表示形式
 */
- (instancetype)hd_stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }return [strM copy];
}

@end
