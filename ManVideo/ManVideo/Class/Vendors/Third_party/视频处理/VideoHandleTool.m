//
//  VideoHandleTool.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/18.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VideoHandleTool.h"
#define VideoSizeMax  209715200 //200*1024*1024 B 字节

@implementation VideoHandleTool
//转码 + 转码后的视频获取——01
+(void)sourceAssets:(PHAsset *)asset{
    /// 包含该视频的基础信息
    PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: asset] firstObject];
    NSString *string1 = [resource.description stringByReplacingOccurrencesOfString:@"{"
                                                                        withString:@""];
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"}"
                                                           withString:@""];
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@", "
                                                           withString:@","];
    NSMutableArray *resourceArray =  [NSMutableArray arrayWithArray:[string3 componentsSeparatedByString:@" "]];
    [resourceArray removeObjectAtIndex:0];
    [resourceArray removeObjectAtIndex:0];
    for (NSInteger index = 0; index < resourceArray.count; index++) {
        NSString *string = resourceArray[index];
        NSString *ret = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        resourceArray[index] = ret;
    }
    NSMutableDictionary *videoInfo = NSMutableDictionary.dictionary;
    for (NSString *string in resourceArray) {
        NSArray *array = [string componentsSeparatedByString:@"="];
        videoInfo[array[0]] = array[1];
    }
    NSLog(@"%@",videoInfo);
    PHVideoRequestOptions *options = PHVideoRequestOptions.new;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset
                            options:options
                      resultHandler:^(AVAsset * _Nullable asset,
                                      AVAudioMix * _Nullable audioMix,
                                      NSDictionary * _Nullable info) {
                          NSString *sizeString = videoInfo[@"size"];
                          NSArray *array = [sizeString componentsSeparatedByString:@","];
                          CGSize size = CGSizeMake([array[0] floatValue], [array[1] floatValue]);
                          [VideoHandleTool choseVedioCompeletWithVedioAsset:(AVURLAsset *)asset
                                                              andAVAudioMix:audioMix
                                                               andVedioInfo:info
                                                               andImageSize:size];
                      }];
}
//转码 + 转码后的视频获取——02
+ (void)choseVedioCompeletWithVedioAsset:(AVURLAsset *)urlAsset
                           andAVAudioMix:(AVAudioMix *)audioMix
                            andVedioInfo:(NSDictionary *)vedioInfo
                            andImageSize:(CGSize)size{
    [VideoHandleTool convertMovToMp4FromAVURLAsset:urlAsset
                               andCompeleteHandler:^(NSURL * _Nonnull fileUrl) {
                                   NSLog(@"%lld",[VideoHandleTool fileSizeAtPath:fileUrl.path]);
                                   BOOL y = [VideoHandleTool addVideoToTableCompeletWithVedioAsset:urlAsset
                                                                                     andAVAudioMix:audioMix
                                                                                      andVedioInfo:vedioInfo
                                                                                      andImageSize:size
                                                                                     andMP4FileUrl:fileUrl];
                                   if (y) {
                                       //视频保存 + 转码成功
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"FileUrl"
                                                                                           object:fileUrl];
                                       
                                   }
                               }];
}
//苹果自研格式MOV转Mp4
+ (void)convertMovToMp4FromAVURLAsset:(AVURLAsset*)urlAsset
                  andCompeleteHandler:(void(^)(NSURL *fileUrl))fileUrlHandler{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlAsset.URL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        //  在Documents目录下创建一个名为FileData的文件夹
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/VideoData"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
        if(!(isDirExist && isDir)) {
            BOOL bCreateDir = [fileManager createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
            if(!bCreateDir){
                NSLog(@"创建文件夹失败！%@",path);
            }
            NSLog(@"创建文件夹成功，文件路径%@",path);
        }
        NSDateFormatter *formatter = NSDateFormatter.new;
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"]; //每次启动后都保存一个新的日志文件中
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        NSString *resultPath = [path stringByAppendingFormat:@"/%@.mp4",dateStr];
        NSLog(@"file path:%@",resultPath);
        NSLog(@"resultPath = %@",resultPath);
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset
                                                                               presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     fileUrlHandler(nil);
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     fileUrlHandler(nil);
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     fileUrlHandler(nil);
                     break;
                 case AVAssetExportSessionStatusCompleted:
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     fileUrlHandler(exportSession.outputURL);
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     fileUrlHandler(nil);
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     fileUrlHandler(nil);
                     break;
             }
         }];
    }
}
//视频获取
+ (BOOL)addVideoToTableCompeletWithVedioAsset:(AVURLAsset *)urlAsset
                                andAVAudioMix:(AVAudioMix *)audioMix
                                 andVedioInfo:(NSDictionary *)vedioInfo
                                 andImageSize:(CGSize)size
                                andMP4FileUrl:(NSURL *)MP4FileUrl{
    NSLog(@"%lld",[VideoHandleTool fileSizeAtPath:MP4FileUrl.path]);
    if (!MP4FileUrl ||
        !MP4FileUrl.path) {
        NSLog(@"视频获取失败");
        [SVProgressHUD showErrorWithStatus:@"视频获取失败"];
        return NO;
    }
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    NSError *mp4Rrror = nil;
    // 检查文件属性 查看文件大小 是否超标
    NSDictionary *infoDict = [[NSFileManager defaultManager]attributesOfItemAtPath:MP4FileUrl.path
                                                                             error:&mp4Rrror];
    NSString *fileSizeString = infoDict[@"NSFileSize"];
    if (fileSizeString &&
        !error) {
        NSInteger fileSize = fileSizeString.integerValue;
        if (fileSize > VideoSizeMax) {
            NSLog(@"视频最大不能超过30M");
            [SVProgressHUD showErrorWithStatus:@"视频最大不能超过30M"];
            [[NSFileManager defaultManager] removeItemAtPath:MP4FileUrl.path
                                                       error:&error];
            return NO;
        }else return YES;
    }else{
        NSLog(@"视频获取失败");
        [SVProgressHUD showErrorWithStatus:@"视频获取失败"];
        [[NSFileManager defaultManager] removeItemAtPath:MP4FileUrl.path
                                                   error:&error];
        return NO;
    }
}
//iOS 获取指定路径文件大小
+(long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath
                                          error:nil] fileSize];
    }return 0;
}
//获取相册最新加载（录制、拍摄）的资源
+(PHAsset *)gettingLastResource{
    //获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = PHFetchOptions.new;
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    //这里取得的结果 assetsFetchResults 其实可以当做一个数组。
    //获取最新一张照片
    PHAsset *d = [assetsFetchResults firstObject];
    return d;
}
//创建相册
+(void)createFolder:(NSString *)folderName {
    if (![self isExistFolder:folderName]) {
        [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:folderName];
        } completionHandler:^(BOOL success,
                              NSError * _Nullable error) {
            if (success) {
                NSLog(@"创建相册文件夹成功!");
                [VideoHandleTool saveRes:[VideoHandleTool pathToMovieURL]];
            } else {
                NSLog(@"创建相册文件夹失败:%@", error);
            }
        }];
    }else [VideoHandleTool saveRes:[VideoHandleTool pathToMovieURL]];
}
//保存视频资源文件
+(void)saveRes:(NSURL *)movieURL{
    __block NSString *localIdentifier = Nil;//标识保存到系统相册中的标识
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];//首先获取相册的集合
    [collectonResuts enumerateObjectsUsingBlock:^(id obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {//对获取到集合进行遍历
        PHAssetCollection *assetCollection = obj;
        NSLog(@"LLL %@",assetCollection.localizedTitle);
        if ([assetCollection.localizedTitle isEqualToString:HDAppDisplayName])  {
            [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:movieURL];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加视频
                [collectonRequest addAssets:@[placeHolder]];
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success,
                                  NSError *error) {
                if (success) {
                    NSLog(@"保存视频成功!");
                    //保存视频成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveRes_success"
                                                                        object:nil];
                } else {
                    NSLog(@"保存视频失败:%@", error);
                }
            }];
        }
    }];
}
//是否存在此相册判断逻辑依据
+ (BOOL)isExistFolder:(NSString *)folderName {
    __block BOOL isExisted = NO;
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        if ([assetCollection.localizedTitle isEqualToString:folderName])  {
            isExisted = YES;
        }
    }]; return isExisted;
}

#pragma mark —— 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                              error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr){
        filePath = [path stringByAppendingPathComponent:subPath];
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:&error];
        if (error) return NO;
    }return YES;
}

+(NSString *)pathToMovieStr{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/ZBMovied.mp4"]];
}

+(NSURL *)pathToMovieURL{
    return [NSURL fileURLWithPath:[VideoHandleTool pathToMovieStr]];
}

//- (NSArray *)searchAllImagesInCollection:(PHAssetCollection *)collection{
//    // 采取同步获取图片（只获得一次图片）
//    PHImageRequestOptions *imageOptions = PHImageRequestOptions.new;
//    imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
//    imageOptions.synchronous = YES;
//    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//    PHVideoRequestOptions *videoOptions = PHVideoRequestOptions.new;
//    videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
//    // 遍历这个相册中的所有资源
//    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:collection
//                                                                          options:nil];
//    NSMutableArray *dataMutArr = NSMutableArray.array;
//    for (PHAsset *asset in assetResult) {
//        if (asset.mediaType == PHAssetMediaTypeVideo) {
//            [dataMutArr addObject:asset];
//        }
//    }return dataMutArr;
//}
//
//-(void)getSystemPhotos{
//    // 获取所有资源的集合，并按资源的创建时间排序
//    PHFetchOptions *options = PHFetchOptions.new;
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
//                                                              ascending:YES]];
////    dispatch_async(dispatch_get_global_queue(0,0), ^{
////
////    });
//
//    // 获得相机胶卷的图片
//    PHFetchResult<PHAssetCollection *> *collectionResult1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
//                                                                                                     subtype:PHAssetCollectionSubtypeAlbumRegular
//                                                                                                     options:nil];
//
//    for (PHAssetCollection *collection in collectionResult1) {
//        if (![collection.localizedTitle isEqualToString:@"Camera Roll"]) continue;
//        [self.dataMutArr addObject:[self searchAllImagesInCollection:collection]];
//        break;
//    }
//}
//
//-(NSMutableArray *)dataMutArr{
//    if (!_dataMutArr) {
//        _dataMutArr = NSMutableArray.array;
//    }return _dataMutArr;
//}

@end
