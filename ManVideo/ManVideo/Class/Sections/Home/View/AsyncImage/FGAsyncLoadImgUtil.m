//
//  FGAsyncLoadImgUtil.m
//  FGAsyncLoadImgUtil
//
//  Created by fengle on 2019/1/28.
//  Copyright © 2019年 fengle. All rights reserved.
//

#import "FGAsyncLoadImgUtil.h"
//#import <YYKit.h>

@interface FGAsyncLoadImgUtil()

@property(nonatomic, strong) NSOperationQueue *operationQueue;
//@property(nonatomic, strong) YYThreadSafeDictionary *safeImgDict;

@end

static FGAsyncLoadImgUtil *asyncLoadImgUtil = nil;

@implementation FGAsyncLoadImgUtil

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asyncLoadImgUtil = [[[self class] alloc] init];
    });
    return asyncLoadImgUtil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // 根据测试数据以及项目线程控制,自行设置线程数量
        NSInteger queueCount = 6;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.name = @"com.FGAsyncLoadImgUtil.www";
        self.operationQueue.maxConcurrentOperationCount = queueCount;
//        self.safeImgDict = [YYThreadSafeDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
//    [self.safeImgDict removeAllObjects];
}

+ (void)asyncLoadImgWithimgName:(NSString *)imgName block:(void(^)(UIImage *image))block
{
    [[FGAsyncLoadImgUtil shareInstance] asyncLoadImgWithimgName:imgName block:block];
}

- (void)asyncLoadImgWithimgName:(NSString *)imgName block:(void(^)(UIImage *image))block
{
    if (!imgName || imgName.length == 0)
    {
        return;
    }
//    UIImage *image = [self.safeImgDict objectForKey:imgName];
//    if (image)
//    {
//        !block ? :block(image);
//    }
//    else
//    {
//        __weak typeof(self)wSelf = self;
//        [self.operationQueue addOperationWithBlock:^{
//            __strong typeof(wSelf) strongSelf = wSelf;
//            UIImage *image = [FGAsyncLoadImgUtil preDrawImageWithName:imgName];
//            if (image)
//            {
//                UIImage *storeImage = [strongSelf.safeImgDict objectForKey:imgName];
//                if (!storeImage)
//                {
//                    [strongSelf.safeImgDict setObject:image forKey:imgName];
//                }
//                else
//                {
//                    image = storeImage;
//                }
//                if (block)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        block(image);
//                    });
//                }
//            }
//        }];
//    }
}

+ (UIImage *)preDrawImageWithName:(NSString *)name
{
    NSString *imgName = nil;
    UIImage *img = nil;
    if (!name || name.length == 0)
    {
        return img;
    }
    if (3 == [UIScreen mainScreen].scale)
    {
        imgName = [NSString stringWithFormat:@"%@@3x.png",name];
        img = [FGAsyncLoadImgUtil _preDrawImageWithName:imgName];
    }
    if (img==nil)//没有3x图，可以尝试获取2x图片
    {
        imgName = [NSString stringWithFormat:@"%@@2x.png",name];
        img = [FGAsyncLoadImgUtil _preDrawImageWithName:imgName scale:2.0];
        if (img == nil)
        {
            imgName = [NSString stringWithFormat:@"%@.png",name];
            img = [FGAsyncLoadImgUtil _preDrawImageWithName:imgName scale:1.0];
        }
    }
    return img;
}

+ (UIImage *)_preDrawImageWithName:(NSString *)imgName
{
    NSString *imgPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:imgName];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    if (data)
    {
        UIImage *image = [[UIImage alloc] initWithData:data scale:[UIScreen mainScreen].scale];
//        image = [image imageByDecoded];
        return image;
    }
    else
    {
        return nil;
    }
}

/**
 根据指定的scale加载图片
 */
+ (UIImage *)_preDrawImageWithName:(NSString *)imgName scale:(CGFloat)scale
{
    NSString *imgPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:imgName];
    NSData *data = [NSData dataWithContentsOfFile:imgPath];
    if (data)
    {
        UIImage *image = [[UIImage alloc] initWithData:data scale:scale];
//        image = [image imageByDecoded];
        return image;
    }
    else
    {
        return nil;
    }
}

@end
