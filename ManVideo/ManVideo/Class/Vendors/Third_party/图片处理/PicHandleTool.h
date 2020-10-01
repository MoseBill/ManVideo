//
//  PicHandleTool.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/24.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicHandleTool : NSObject

/// 修正照片方向(手机转90度方向拍照)
/// @param aImage 处理后的图像
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/// 缩放图片
/// @param image <#image description#>
/// @param scaleSize <#scaleSize description#>
+ (UIImage *)scaleImage:(UIImage *)image
                toScale:(float)scaleSize;

//压缩图片方法
+ (UIImage*)imageWithImageSimple:(UIImage*)image
                    scaledToSize:(CGSize)newSize;

//保存照片到沙盒路径(保存)
+ (void)saveImage:(UIImage *)image
             name:(NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
