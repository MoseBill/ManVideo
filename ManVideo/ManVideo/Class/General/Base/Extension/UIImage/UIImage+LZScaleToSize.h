//
//  LZScaleToSize.h
//  WebViewTest
//
//  Created by Josee on 2019/3/4.
//  Copyright © 2019年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LZScaleToSize)

/**
 重新绘制图片大小
 
 @param image 原始图片
 @param size  需要的大小
 
 @return 返回改变大小后图片
 */
+ (UIImage*) originImage:(UIImage*)image scaleToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
