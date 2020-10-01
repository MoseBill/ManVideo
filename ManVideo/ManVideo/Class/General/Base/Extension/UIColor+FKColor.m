//
//  UIColor+FKColor.m
//  FXXKBaseMVVM
//
//  Created by Jacky-song on 2017/12/10.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "UIColor+FKColor.h"

@implementation UIColor (FKColor)

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

+ (UIColor *)bgColor_nav
{
    return RGBCOLOR(235, 235, 235);
}

+ (UIColor *)bgColor_view
{
    return RGBCOLOR(235, 235, 235);
}

+ (UIColor *)bgColor_cell
{
    return RGBCOLOR(255, 255, 255);
}

+ (UIColor *)textColor_dark
{
    return RGBCOLOR(0x44, 0x44, 0x44);
}

+ (UIColor *)textColor_light
{
    return RGBCOLOR(0x88, 0x88, 0x88);
}

//将16进制色值转化成UIColor
+ (UIColor *)sf_colorWithHexString:(NSString *)hexString {
  
  if ([hexString isEqualToString:@""]) {
    return [UIColor clearColor];
  }
  
  NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
  if ([cString length] != 6) return [UIColor blackColor];
  
  // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [cString substringWithRange:range];
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  // Scan values
  unsigned int r, g, b;
  
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  
  return [UIColor colorWithRed:((float) r / 255.0f)
                         green:((float) g / 255.0f)
                          blue:((float) b / 255.0f)
                         alpha:1.0f];
}


//获取16进制颜色的方法
+ (UIColor *)colorWithHexNewColor:(NSString *)hexColor {
  hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if ([hexColor length] < 6) {
    return nil;
  }
  if ([hexColor hasPrefix:@"#"]) {
    hexColor = [hexColor substringFromIndex:1];
  }
  NSRange range;
  range.length = 2;
  range.location = 0;
  NSString *rs = [hexColor substringWithRange:range];
  range.location = 2;
  NSString *gs = [hexColor substringWithRange:range];
  range.location = 4;
  NSString *bs = [hexColor substringWithRange:range];
  unsigned int r, g, b, a;
  [[NSScanner scannerWithString:rs] scanHexInt:&r];
  [[NSScanner scannerWithString:gs] scanHexInt:&g];
  [[NSScanner scannerWithString:bs] scanHexInt:&b];
  if ([hexColor length] == 8) {
    range.location = 4;
    NSString *as = [hexColor substringWithRange:range];
    [[NSScanner scannerWithString:as] scanHexInt:&a];
  } else {
    a = 255;
  }
  return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}

//绘制按钮的渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr radius:(ZHYButtonCornerRadiusType)type{
  
  //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  gradientLayer.frame = view.bounds;
  
  //  创建渐变色数组，需要转换为CGColor颜色
  gradientLayer.colors = @[(__bridge id)fromHexColorStr.CGColor,(__bridge id)toHexColorStr.CGColor];
  float radiusSize = 0.0f;
  switch (type) {
    case ZHYButtonCornerRadiusTypeNone:
      radiusSize = 0.0f;
      break;
    case ZHYButtonCornerRadiusTypeHalf:
      radiusSize = view.bounds.size.height/2;
      break;
    case ZHYButtonCornerRadiusTypePoint:
      radiusSize = 7.5f;
      break;
      case ZHYButtonCornerRadiusTypeThreePoint:
      radiusSize = 3.0f;
      break;
    default:
      break;
  }
  gradientLayer.cornerRadius = radiusSize;
  gradientLayer.masksToBounds = YES;
  //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
  gradientLayer.startPoint = CGPointMake(0, 0);
  gradientLayer.endPoint = CGPointMake(1.0, 0);
  //  设置颜色变化点，取值范围 0.0~1.0
  //    gradientLayer.locations = @[@0,@1];
  gradientLayer.locations = @[@0.3, @1.0];
  
  return gradientLayer;
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
  //删除字符串中的空格
  NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  // String should be 6 or 8 characters
  if ([cString length] < 6)
  {
    return [UIColor clearColor];
  }
  // strip 0X if it appears
  //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
  if ([cString hasPrefix:@"0X"])
  {
    cString = [cString substringFromIndex:2];
  }
  //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
  if ([cString hasPrefix:@"#"])
  {
    cString = [cString substringFromIndex:1];
  }
  if ([cString length] != 6)
  {
    return [UIColor clearColor];
  }
  
  // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  //r
  NSString *rString = [cString substringWithRange:range];
  //g
  range.location = 2;
  NSString *gString = [cString substringWithRange:range];
  //b
  range.location = 4;
  NSString *bString = [cString substringWithRange:range];
  
  // Scan values
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];
  return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor*)je_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

@end
