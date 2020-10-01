//
//  VideoHandleTool.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/18.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoHandleTool : NSObject

@property(nonatomic,strong)NSMutableArray *dataMutArr;

+(void)sourceAssets:(PHAsset *)asset;//转码 + 转码后的视频获取
+(long long)fileSizeAtPath:(NSString *)filePath;//iOS 获取指定路径文件大小
+(BOOL)clearCacheWithFilePath:(NSString *)path;//清除path文件夹下缓存大小
+(PHAsset *)gettingLastResource;//获取相册最新加载（录制、拍摄）的资源
+(void)createFolder:(NSString *)folderName;//创建相册
+(void)saveRes:(NSURL *)movieURL;//保存视频资源文件
+(BOOL)isExistFolder:(NSString *)folderName;//是否存在此相册判断逻辑依据
+(NSURL *)pathToMovieURL;
+(NSString *)pathToMovieStr;

+ (void)convertMovToMp4FromAVURLAsset:(AVURLAsset*)urlAsset
                  andCompeleteHandler:(void(^)(NSURL *fileUrl))fileUrlHandler;//苹果自研格式MOV转Mp4

@end

NS_ASSUME_NONNULL_END
