

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString  *const XCColorKey = @"color";
static NSString  *const XCFontKey = @"font";
static NSString  *const XCRangeKey = @"range";
/**
 range的校验结果
 */
typedef enum
{
    RangeCorrect = 0,
    RangeError = 1,
    RangeOut = 2,
    
}RangeFormatType;

@interface NSString (tool)

/**
 *  空判断
 *
 *  @return 是否为空
 */
- (BOOL) isNullString;

+ (BOOL) isEmpty:(NSString *) str;

#pragma mark - 常用工具
/**
 *  获取当前设备deviceId
 *
 *  @return deviceId
 */
+ (NSString *) getDeviceIdentifierForVendor;
/**
 *  获取当前版本号
 *
 *  @return 版本号
 */
+ (NSString *) getAppVersions;

/**
 *  转换为周X
 *
 *  @param time 时间戳
 *
 *  @return 周几
 */
+ (NSString *) getWeekDay:(NSTimeInterval) time;

/**
 *  转换为XXXX年XX月XX日
 *
 *  @param time 时间戳
 *
 *  @return 年-月-日
 */
+ (NSString*) format:(NSTimeInterval) time;
/**
 *  转换为XXXX年XX月XX日
 *
 *  @param time 时间戳
 *
 *  @return 年.月.日
 */
+ (NSString*) formatWithPoint:(NSTimeInterval) time;
/**
 *  转化为XX时XX分XX秒
 *
 *  @param time 时间戳
 *
 *  @return 时:分:秒
 */
+ (NSString*) formatTime:(NSTimeInterval) time;

/**
 *  转化为XXXX年XX月XX日XX时XX分XX秒
 *
 *  @param time 时间戳
 *
 *  @return 年-月-日 时:分:秒
 */
+ (NSString *) formatDateAndTime:(NSTimeInterval)time;
/**
 *  转化为XXXX年XX月XX日XX时XX分XX秒
 *
 *  @param time 时间戳
 *
 *  @return 年.月.日 时:分:秒
 */
+ (NSString *) formatPointDateAndTime:(NSTimeInterval)time;
/**
 *  转化为XX月XX日XX时XX分
 *
 *  @param time 时间戳
 *  @param formateStr 返回的日期格式
 *  @return 日期
 */
+ (NSString *) formateDateAndTime:(NSTimeInterval)time formate:(NSString *)formateStr;

/**
 *  获取与当前的时间差
 *
 *  @param timestamp 时间戳
 *
 *  @return 时间差
 */
+ (NSString *)timeFromTimestamp:(NSInteger)timestamp;
/**
 *  根据当前月份获取addNum后的月份信息
 *
 *  @param addNum 增加的月份
 *
 *  @return 年-月
 */
+ (NSString *)getMonthWithAddNum:(NSInteger)addNum;
#pragma mark - 校验NSRange
/**
 *  校验范围（NSRange）
 *
 *  @param range Range
 *
 *  @return 校验结果：RangeFormatType
 */
- (RangeFormatType)checkRange:(NSRange)range;

#pragma mark - 改变单个范围字体的大小和颜色
/**
 *  改变字体的颜色
 *
 *  @param color 颜色（UIColor）
 *  @param range 范围（NSRange）
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeColor:(UIColor *)color
                                  andRange:(NSRange)range;


/**
 *  改变字体大小
 *
 *  @param font  字体大小(UIFont)
 *  @param range 范围(NSRange)
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                 andRange:(NSRange)range;


/**
 *   改变字体的颜色和大小
 *
 *  @param color      字符串的颜色
 *  @param colorRange 需要改变颜色的字符串范围
 *  @param font       字体大小
 *  @param fontRange  需要改变字体大小的字符串范围
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */

- (NSMutableAttributedString *)changeColor:(UIColor *)color
                              andColorRang:(NSRange)colorRange
                                   andFont:(UIFont *)font
                              andFontRange:(NSRange)fontRange;

#pragma mark - 改变多个范围内的字体和颜色

/**
 *  改变多段字符串为一种颜色
 *
 *  @param color  字符串的颜色
 *  @param ranges 范围数组:[NSValue valueWithRange:NSRange]
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeColor:(UIColor *)color andRanges:(NSArray<NSValue *> *)ranges;

/**
 *  改变多段字符串为同一大小
 *
 *  @param font   字体大小
 *  @param ranges 范围数组:[NSValue valueWithRange:NSRange]
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font andRanges:(NSArray<NSValue *> *)ranges;
/**
 *  用于多个位置颜色和大小改变
 *
 *  @param changes 对应属性改变的数组.示例:@[@{XCColorKey:UIColor,XCFontKey:UIFont,XCRangeKey:NSArray<NSValue *>}];
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeColorAndFont:(NSArray<NSDictionary *> *)changes;


#pragma mark - 对特定字符进行改变
/**
 *  对相应的字符串进行改变
 *
 *  @param str   需要改变的字符串
 *  @param color 字体颜色
 *  @param font  字体大小
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeWithStr:(NSString *)str andColor:(UIColor *)color andFont:(UIFont *)font;

#pragma mark - 给字符串添加中划线
/**
 *  添加中划线
 *
 *  @return 富文本
 */
- (NSMutableAttributedString *)addCenterLine;

#pragma mark - 给字符串添加下划线
/**
 *  添加下划线
 *
 *  @return 富文本
 */
- (NSMutableAttributedString *)addDownLine;

/**
 *  地址拼接
 */
+ (NSString *)appendingAddressOfString: (NSString *)village : (NSString *)building : (NSString *)unit : (NSString *)room;

/**
 表情转码
 */
+ (NSString *)transfomStringToUTF8: (NSString *)string;

/**
 UTF8转显示文字
 */
+ (NSString *)transfomStringToShowText: (NSString *)string;

/**
 获取手机imei

 */
+(NSString *)getIosIdentify;

/**
 每三个字符串添加一个逗号
 */
+(NSString *)countNumAndChangeformat:(NSString *)num;

@end
