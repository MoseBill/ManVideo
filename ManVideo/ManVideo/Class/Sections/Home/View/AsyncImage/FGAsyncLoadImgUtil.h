//
//  FGAsyncLoadImgUtil.h
//  FGAsyncLoadImgUtil
//
//  Created by fengle on 2019/1/28.
//  Copyright © 2019年 fengle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 异步加载本地图片
@interface FGAsyncLoadImgUtil : NSObject

+ (void)asyncLoadImgWithimgName:(NSString *)imgName block:(void(^)(UIImage *image))block;

@end

