//
//  UIColor+FKColor.h
//  FXXKBaseMVVM
//
//  Created by Jacky-song on 2017/12/10.
//  Copyright © 2017年 madao. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#undef  HEX_RGB
#define HEX_RGB(V)        [UIColor colorWithRGBHex:V]

// 其他UI 控件都可以使用此方法
typedef NS_ENUM(NSInteger, ZHYButtonCornerRadiusType) {
  /** 没有圆角 */
  ZHYButtonCornerRadiusTypeNone,
  /** 圆角为高度一半 */
  ZHYButtonCornerRadiusTypeHalf,
  /** 圆角为一点点圆 7.5*/
  ZHYButtonCornerRadiusTypePoint,
  /** 圆角为一点点圆 3*/
  ZHYButtonCornerRadiusTypeThreePoint
};

@interface UIColor (FKColor)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

//将16进制色值转化成UIColor
+ (UIColor *)sf_colorWithHexString:(NSString *)hexString;
//+ (UIColor *)colorWithCssName:(NSString *)cssColorName;

+ (UIColor *)bgColor_nav;
+ (UIColor *)bgColor_view;
+ (UIColor *)bgColor_cell;

+ (UIColor *)textColor_dark;
+ (UIColor *)textColor_light;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//绘制按钮的渐变色颜色的方法
//+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromHexColorStr toColor:(UIColor *)toHexColorStr radius:(ZHYButtonCornerRadiusType)type;

/** 渐变 */
+(UIColor*)je_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

@end
