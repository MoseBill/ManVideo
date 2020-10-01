//
//  MHVideoTool.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/14.
//  Copyright © 2018年 mh. All rights reserved.
//

#import "MHVideoTool.h"

#define VIDEO_RECORDER_MAX_TIME 10.0f                               // 视频最大时长 (单位/秒)
#define VIDEO_RECORDER_MIN_TIME 1.0f                                // 最短视频时长 (单位/秒)
#define VIDEO_FILEPATH                                              @"video"

@interface MHVideoTool ()
{
    AVURLAsset * inputAudioAsset;
}


@end

@implementation MHVideoTool

#pragma mark - 相册视频保存本地路径
+(NSString *)mh_albumVideoOutTempPath
{
    NSString * tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"albumVideoTemp"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:tempPath]){
            [fileManage createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"VideoCompressionTemp%f.mp4",time];
    NSString *outPath =  [tempPath stringByAppendingPathComponent:fileName];
    if([fileManage fileExistsAtPath:outPath]){
        [fileManage removeItemAtPath:outPath error:nil];
    }
    return outPath;
}
#pragma mark - 获取视频的缩略图方法
+ (UIImage *)mh_getVideoTempImageFromVideo:(NSURL *)videoUrl withTime:(CGFloat)theTime
{
    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    CGFloat timescale = asset.duration.timescale;
    UIImage *shotImage;
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    
    CGFloat width = [UIScreen mainScreen].scale * 100;
    CGFloat height = width * [UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width;
    gen.maximumSize =  CGSizeMake(width, height);
    
    CMTime time = CMTimeMakeWithSeconds(theTime, timescale);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
}
#pragma mark - 获取视频长度
+(CGFloat)mh_getVideolength:(NSURL *)videoUrl
{
    AVURLAsset * asset = [AVURLAsset assetWithURL:videoUrl];
    CGFloat length = (CGFloat)asset.duration.value/(CGFloat)asset.duration.timescale;
    return length;
}
#pragma mark - 视频的旋转角度
+(NSUInteger)mh_getDegressFromVideoWithURL:(NSURL *)url
{
    NSUInteger degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}
#pragma mark - 获取视频尺寸
+(CGSize)mh_getVideoSize:(NSURL *)videoUrl
{
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in asset.tracks) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    return videoSize;
}
#pragma mark - 根据比例调整视频输出的尺寸，width=480
+(CGSize)mh_fixVideoOutPutSize:(CGSize)nomSize
{
    if (nomSize.width <= 480.0) {
        return nomSize;
    }
    CGFloat height = nomSize.height * 480.0 / nomSize.width;
    return CGSizeMake(480.0, height);
}
#pragma mark - 将视频保存到相册
+(void)mh_writeVideoToPhotosAlbum:(NSURL *)videoUrl callBack:(void (^)(BOOL))callBack
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoUrl]) {
        [library writeVideoAtPathToSavedPhotosAlbum:videoUrl completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (callBack) {
                        callBack(NO);
                    }
                } else {
                    DLog(@"已保存到相册");
                    if (callBack) {
                        callBack(YES);
                    }
                }
            });
        }];
    }
}
#pragma mark - 改变视频速度
+(void)changeVideoSpeed:(NSURL *)videoUrl speed:(CGFloat)speed outPutUrl:(NSURL *)outPutUrl callBack:(void (^)(BOOL))callBack
{
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    //添加视频轨道信息
    AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero
                          error:nil];
    
    // 根据速度比率调节音频和视频
    [videoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale))
                    toDuration:CMTimeMake(videoAsset.duration.value * speed , videoAsset.duration.timescale)];
    
    if ([videoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                            ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:nil];
        
        [audioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale))
                        toDuration:CMTimeMake(videoAsset.duration.value * speed, videoAsset.duration.timescale)];
    }
    
    //输出文件
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=outPutUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                callBack(YES);
            }else{
                callBack(NO);
            }
        });
    }];
}
#pragma mark - 将多个视频合成一个视频
+(void)mergeVideosWithPaths:(NSArray *)paths outPutUrl:(NSURL *)outPutUrl callBack:(void (^)(BOOL, NSURL *))callBack
{
    if (paths.count == 0) {
        callBack(NO,nil);
        return;
    }
    
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i < paths.count; i ++) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:paths[i]]];
        
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
        
        NSError *errorVideo = nil;
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetVideoTrack atTime:totalDuration error:&errorVideo];
        
        
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];

        NSError *erroraudio = nil;
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetAudioTrack atTime:totalDuration error:&erroraudio];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    
    //输出文件
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL=outPutUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                callBack(YES,outPutUrl);
            }else{
                callBack(NO,outPutUrl);
            }
        });
    }];
}
#pragma mark - 音频裁剪
+(void)crapMusicWithUrl:(NSURL *)bgmUrl startTime:(CGFloat)startTime length:(CGFloat)length callBack:(void (^)(BOOL, NSURL *))callBack
{
    AVAsset *asset = [AVAsset assetWithURL:bgmUrl];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    //剪辑(设置导出的时间段)
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(length,asset.duration.timescale);
    exporter.timeRange = CMTimeRangeMake(start, duration);
    
    //输出路径
    NSURL * outPutUrl = [NSURL fileURLWithPath:[MHVideoTool musicCrapOutPutTempPath]];
    exporter.outputURL = outPutUrl;
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.shouldOptimizeForNetworkUse= YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.status == AVAssetExportSessionStatusCompleted) {
            DLog(@"音频 裁剪 成功");
            callBack(YES,outPutUrl);
        }else{
            DLog(@"音频 裁剪 失败");
            callBack(NO,nil);
        }
    }];
}
#pragma mark - 裁剪音频时 输出路径(临时文件夹)
+(NSString *)musicCrapOutPutTempPath
{
    NSString * tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"musicTemp"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(![fileManage fileExistsAtPath:tempPath]){
            [fileManage createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"musicCrapTemp%f.m4a",time];
    NSString *outPath =  [tempPath stringByAppendingPathComponent:fileName];
    if([fileManage fileExistsAtPath:outPath]){
        [fileManage removeItemAtPath:outPath error:nil];
    }
    return outPath;
}
#pragma mark - 合并视频+背景音乐 同时调整原始视频的音频和背景音乐的音量
+ (void)mergevideoWithVideoUrl:(NSURL *)videoUrl originalAudioTrackVideoUrl:(NSURL *)originalAudioTrackVideoUrl bgmUrl:(NSURL *)bgmUrl originalVolume:(CGFloat)originalVolume bgmVolume:(CGFloat)bgmVolume outPutUrl:(NSURL *)outPutUrl callBack:(void (^)(BOOL, NSURL *))callBack
{
    CGFloat startTime;
    CGFloat endTime;
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    //创建合并Composition
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    //添加视频轨道信息
    AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero
                          error:nil];
    //添加视频自带的音频轨道信息
    //保存音频音量数据
    NSMutableArray * audioInputParamsArr = [NSMutableArray arrayWithCapacity:0];
    AVURLAsset * originalVideoAsset = [AVURLAsset URLAssetWithURL:originalAudioTrackVideoUrl options:nil];
    if ([originalVideoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[originalVideoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:kCMTimeZero
                              error:nil];
        //调整音量
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
        [audioInputParams setVolumeRampFromStartVolume:originalVolume toEndVolume:.0f timeRange:CMTimeRangeMake(kCMTimeZero, originalVideoAsset.duration)];
        [audioInputParams setTrackID:audioTrack.trackID];
        [audioInputParamsArr addObject:audioInputParams];
    }
    AVURLAsset * inputAudioAsset;
    //添加背景音乐音频轨道信息
    if (bgmUrl && bgmUrl.absoluteString.length > 0) {
        inputAudioAsset  = [AVURLAsset URLAssetWithURL:bgmUrl options:nil];
        if ([inputAudioAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
            AVMutableCompositionTrack * addAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [addAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                   ofTrack:[[inputAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                    atTime:kCMTimeZero
                                     error:nil];
            //调整音量
            AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:addAudioTrack];
            [audioInputParams setVolumeRampFromStartVolume:bgmVolume toEndVolume:.0f timeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)];
            [audioInputParams setTrackID:addAudioTrack.trackID];
            
            [audioInputParamsArr addObject:audioInputParams];
        }
    }
    //处理视频旋转和缩放
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    CGSize videoSize = videoAssetTrack.naturalSize;
    if(videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0)
    {
        videoTransform = CGAffineTransformTranslate(videoTransform,0,videoTransform.tx-videoSize.height);
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    [videolayerInstruction setTransform:videoTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:asset.duration];
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.renderSize = videoSize;
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 40);//fps
    
    //音频调整
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:audioInputParamsArr];
 
    //输出文件
    // 串行队列的创建方法
//    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
 
    CMTime time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    startTime = 0;
    endTime = (CGFloat)seconds;
    DLog(@"视频多长啊%d",seconds);
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:mixComposition];
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        {
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                                                                presetName:AVAssetExportPresetMediumQuality];
        exporter.outputURL=outPutUrl;
        exporter.shouldOptimizeForNetworkUse = YES;
        exporter.videoComposition = mainCompositionInst;
        exporter.audioMix = audioMix;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime-1,asset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    CMTimeShow(duration);
    exporter.timeRange = range;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (exporter.status == AVAssetExportSessionStatusCompleted) {
                    callBack(YES,outPutUrl);
                }else{
                    callBack(NO,nil);
                }
            });
        }];
    }
//        });
}


@end
