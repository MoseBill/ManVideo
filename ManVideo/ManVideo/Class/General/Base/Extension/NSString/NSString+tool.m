

#import "NSString+tool.h"
#import <AdSupport/AdSupport.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation NSString (tool)

- (BOOL)isNullString{
    if(self == nil) {
        return YES;
    }
    
    if((NSNull *)self == [NSNull null]) {
        return YES;
    }
    
    if(self.length == 0) {
        return YES;
    }
    
    if([self isEqualToString:@"<null>"]) {
        return YES;
    }
    if([self isEqualToString:@"null"]) {
        return YES;
    }
    if([self isEqualToString:@"(null)"]) {
        return YES;
    }return NO;
}

+ (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return 1;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return 1;
        } else {
            return 0;
        }
    }
}

+ (NSString *) getDeviceIdentifierForVendor{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)getAppVersions{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString *)getWeekDay:(NSTimeInterval)time {
    //创建一个星期数组
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    //将时间戳转换成日期
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

+ (NSString*) format:(NSTimeInterval) time;
{
    if (time < 0)
    {
        return @"";
    }
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return [formatter stringFromDate:date];
}

+(NSString *)formatWithPoint:(NSTimeInterval)time {
    if (time < 0)
    {
        return @"";
    }
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return [formatter stringFromDate:date];
}

+ (NSString*) formatTime:(NSTimeInterval) time;
{
    if (time < 0)
    {
        return @"";
    }
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return [formatter stringFromDate:date];
}

+ (NSString *) formatDateAndTime:(NSTimeInterval)time;{
    if (time < 0) {
        return @"";
    }
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return [formatter stringFromDate:date];
}

+(NSString *)formatPointDateAndTime:(NSTimeInterval)time {
    if (time < 0) {
        return @"";
    }
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return [formatter stringFromDate:date];
}

+ (NSString *) formateDateAndTime:(NSTimeInterval)time formate:(NSString *)formateStr{
    NSDateFormatter *dateFormtter =[[NSDateFormatter alloc] init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSTimeInterval late=[d timeIntervalSince1970]*1;    //转记录的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;   //获取当前时间戳
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    // 发表在一小时之内
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    // 在一小时以上24小以内
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    // 发表时间大于1天
    else
    {
        [dateFormtter setDateFormat:formateStr];
        timeString = [dateFormtter stringFromDate:d];
    }
    
    return timeString;
}
+ (NSString *)timeFromTimestamp:(NSInteger)timestamp{
    
    NSDateFormatter *dateFormtter =[[NSDateFormatter alloc] init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSTimeInterval late=[d timeIntervalSince1970]*1;    //转记录的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;   //获取当前时间戳
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    // 发表在一小时之内
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    // 在一小时以上24小以内
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    // 发表在24以上10天以内
    else if (cha/86400>1&&cha/86400*3<1)     //86400 = 60(分)*60(秒)*24(小时)   3天内
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    // 发表时间大于10天
    else
    {
        [dateFormtter setDateFormat:@"yyyy-MM-dd"];
        timeString = [dateFormtter stringFromDate:d];
    }
    
    return timeString;
}
+ (NSString *)getMonthWithAddNum:(NSInteger)addNum{
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +addNum;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:now options:0];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:newDate];
    NSString *dateMonth = [NSString stringWithFormat:@"%ld-%.2ld", [comp year], [comp month]];
    return dateMonth;
}



- (RangeFormatType)checkRange:(NSRange)range{
    NSInteger loc = range.location;
    NSInteger len = range.length;
    if (loc>=0 && len>0) {
        if (range.location + range.length <= self.length) {
            return RangeCorrect;
        }
        else{
            DLog(@"The range out-of-bounds!");
            return RangeOut;
        }
    }
    else{
        DLog(@"The range format is wrong: NSMakeRange(a,b) (a>=0,b>0). ");
        return RangeError;
    }
}

- (NSMutableAttributedString *)changeColor:(UIColor *)color
                                  andRange:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if ([self checkRange:range] == RangeCorrect) {
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        else{
            DLog(@"color is nil");
        }
        
    }
    return attributedStr;
}


- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                 andRange:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if ([self checkRange:range] == RangeCorrect) {
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
        else{
            DLog(@"font is nil...");
        }
    }
    return attributedStr;
}


- (NSMutableAttributedString *)changeColor:(UIColor *)color
                              andColorRang:(NSRange)colorRange
                                   andFont:(UIFont *)font
                              andFontRange:(NSRange)fontRange{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if ([self checkRange:colorRange] == RangeCorrect) {
        if (color) {
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
        }
        else{
            DLog(@"color is nil");
        }
    }
    if ([self checkRange:fontRange] == RangeCorrect) {
        if (font) {
            [attributedStr addAttribute:NSFontAttributeName value:font range:fontRange];
        }
        else{
            DLog(@"font is nil...");
        }
    }
    return attributedStr;
}

- (NSMutableAttributedString *)changeColor:(UIColor *)color andRanges:(NSArray<NSValue *> *)ranges{
    __block NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if (color) {
        [ranges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [(NSValue *)obj rangeValue];
            if ([self checkRange:range] == RangeCorrect) {
                [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
            else{
              DLog(@"index:%ld",idx);
            }
            
        }];
    }
    else{
   DLog(@"color is nil...");
    }
    return attributedStr;
}

- (NSMutableAttributedString *)changeFont:(UIFont *)font andRanges:(NSArray<NSValue *> *)ranges{
    __block NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    if (font) {
        [ranges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [(NSValue *)obj rangeValue];
            if ([self checkRange:range] == RangeCorrect) {
                [attributedStr addAttribute:NSFontAttributeName value:font range:range];
            }
            else{
            DLog(@"index:%ld",idx);
            }
            
        }];
    }
    else{
        DLog(@"font is nil...");
    }
    return attributedStr;
}

- (NSMutableAttributedString *)changeColorAndFont:(NSArray<NSDictionary *> *)changes{
    __block NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    [changes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *color = obj[XCColorKey];
        UIFont *font = obj[XCFontKey];
        NSArray<NSValue *> *ranges = obj[XCRangeKey];
        if (!color) {
            DLog(@"warning: NSColorKey -> nil! index:%ld",idx);
        }
        if (!font) {
        DLog(@"warning: NSFontKey -> nil! index:%ld",idx);
        }
        if (ranges.count>0) {
            [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSRange range = [obj rangeValue];
                if ([self checkRange:range] == RangeCorrect) {
                    if (color) {
                        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
                    }
                    if (font) {
                        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
                    }
                }
                else{
                   DLog(@"index:%ld",idx);
                }
                
            }];
        }
        else{
            DLog(@"warning: NSRangeKey -> nil! index:%ld",idx);
        }
    }];
    return attributedStr;
    
}

- (NSMutableAttributedString *)changeWithStr:(NSString *)str andColor:(UIColor *)color andFont:(UIFont *)font{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    NSUInteger length = self.length;
    while (length > str.length) {
        NSRange range = [self rangeOfString:str options:NSBackwardsSearch range:NSMakeRange(0, length)];
        if ([self checkRange:range] == RangeCorrect) {
            if (color) {
                [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
            if (font) {
                [attributedStr addAttribute:NSFontAttributeName value:font range:range];
            }
            length = range.location;
        }
        else{
            length = str.length-1;
        }
    }
    return attributedStr;
}
- (NSMutableAttributedString *)addCenterLine{
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    return attributeStr;
}
- (NSMutableAttributedString *)addDownLine{
    
     NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    return attributeStr;
}

+ (NSString *)appendingAddressOfString:(NSString *)village :(NSString *)building :(NSString *)unit :(NSString *)room {
    NSString *addressStr = [NSString stringWithFormat:@"%@%@幢%@单元%@室",village, building, unit, room];
    return addressStr;
}

+ (NSString *)transfomStringToUTF8:(NSString *)string {
    NSString *inputText = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //转特殊符号: % @ $等
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)inputText, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}

+(NSString *)transfomStringToShowText:(NSString *)string {
    NSString *showText = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return showText;
}
+(NSString *)getIosIdentify
{
    NSString *macStr=[NSString new];
    macStr = [macStr macaddress];
    NSString *IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString];
    NSString *systemStr=[[UIDevice currentDevice] systemVersion];
    
    if ([systemStr integerValue]>=7) {
        return IDFA;
    }else
        return macStr;
}

- (NSString *) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}


+(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}


//iOS 判断字符串是否为中文
-(BOOL)isChinese:(NSString *)str{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}
/*
 *利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 * 判断 输入字符是否为 Emoji表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring,
                                         NSRange substringRange,
                                         NSRange enclosingRange,
                                         BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                // surrogate pair
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    // non surrogate
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs &&
                                               hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs &&
                                               hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs &&
                                               hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 ||
                                               hs == 0xae ||
                                               hs == 0x303d ||
                                               hs == 0x3030 ||
                                               hs == 0x2b55 ||
                                               hs == 0x2b1c ||
                                               hs == 0x2b1b ||
                                               hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];return returnValue;
}
//正则表达式判断是否是输入得是数字
- (BOOL)deptNumInputShouldNumber:(NSString *)str{
    if (str.length == 0) return NO;
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) return YES;
    return NO;
}
//判断输入的是否是英文字符（不区分大小写）
-(BOOL)isEnglish:(NSString *)str {
    if (str) {
        NSCharacterSet *set = [NSCharacterSet alphanumericCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else return false;
    } else return true;
}
//判断输入的是否为换行符
-(BOOL)isNewline:(NSString *)str {
    if (str) {
        NSCharacterSet *set = [NSCharacterSet newlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else return false;
    } else return true;
}
//判断是否全是空格
-(BOOL)isWhitespace:(NSString *)str {
    if (str) {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else return false;
    } else return true;
}
//判断是否全是标点符号
-(BOOL)isPunctuation:(NSString *)str {
    if (str) {
        NSCharacterSet *set = [NSCharacterSet punctuationCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else return false;
    } else return true;
}


@end
