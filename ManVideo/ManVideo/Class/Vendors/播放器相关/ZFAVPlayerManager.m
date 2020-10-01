//
//  ZFAVPlayerManager.m
//  ZFPlayer
//
// Copyright (c) 2016年 Jose
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.


#import "ZFAVPlayerManager.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ZFPlayer/ZFPlayer.h>
#import "ZFDouYinViewController.h"
#import "ZFDouYinControlView.h"
#import "YGPlayInfo.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

/*!
 *  Refresh interval for timed observations of AVPlayer
 */
static float const kTimeRefreshInterval          = 0.1;
static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";

@interface YGPreviewView : UIView

@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UILabel *previewtitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
+ (instancetype)sharedPreviewView;
@property (nonatomic, strong) NSMutableArray *playInfos;

@end

@implementation YGPreviewView
// 单例
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedPreviewView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 懒加载
// 视频缩略图
- (UIImageView *)previewImageView
{
    if (_previewImageView == nil) {
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.layer.cornerRadius = 5;
        _previewImageView.clipsToBounds = YES;
        _previewImageView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.5f];
        [self addSubview:_previewImageView];
    }
    return _previewImageView;
}

// 进度标签
- (UILabel *)previewtitleLabel
{
    if (_previewtitleLabel == nil) {
        _previewtitleLabel = [[UILabel alloc] init];
        _previewtitleLabel.font = [UIFont systemFontOfSize:20];
        _previewtitleLabel.textColor = [UIColor whiteColor];
        _previewtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_previewtitleLabel];
    }
    return _previewtitleLabel;
}

// 等待菊花
- (UIActivityIndicatorView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] init];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _loadingView.hidesWhenStopped = YES;
        [self.previewImageView addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.previewtitleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (image == nil) {
        [self.loadingView startAnimating];
        self.previewImageView.image = nil;
    } else {
        [self.loadingView stopAnimating];
        self.previewImageView.image = image;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(self).multipliedBy(9/16.0);
    }];
    
    [self.previewtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.previewImageView).offset(110.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.previewImageView);
        make.width.height.mas_equalTo(20);
    }];
}
@end

@interface ZFPlayerPresentView : ZFPlayerView

@property (nonatomic, strong) AVPlayer *player;
/// default is AVLayerVideoGravityResizeAspect.
@property (nonatomic, strong) AVLayerVideoGravity videoGravity;
@property (nonatomic, strong) NSMutableArray *playInfos;

@end

@implementation ZFPlayerPresentView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)avLayer {
    return (AVPlayerLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setPlayer:(AVPlayer *)player {
    if (player == _player) return;
    self.avLayer.player = player;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if (videoGravity == self.videoGravity) return;
    [self avLayer].videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return [self avLayer].videoGravity;
}

@end

@interface ZFAVPlayerManager () {
    id _timeObserver;
    id _itemEndObserver;
    ZFKVOController *_playerItemKVO;
}
@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;
@property (nonatomic, strong) YGPreviewView *previewView;
//@property (nonatomic, strong) NSMutableArray *thumbImages;
@property (nonatomic, strong) NSMutableArray *playInfos;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;


@end

@implementation ZFAVPlayerManager

@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize presentationSizeChanged        = _presentationSizeChanged;

- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = ZFPlayerScalingModeAspectFill;
        //注册通知(接收,监听,一个通知)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBegin:) name:@"valueChangeBlock" object:nil];
        //注册通知(接收,监听,一个通知)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnd:) name:@"finishChangeBlock" object:nil];
      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationVideoPlay:) name:@"hotVideoUrl" object:nil];
//        [self  playWithPlayInfo];
    }
    return self;
}

//实现方法
-(void)notificationBegin:(NSNotification *)noti{
    
    //使用object处理消息
    NSString *info = [noti object];

    // 取消之前的隐藏播放控制面板的操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.player pause];
    [self removeTimeObserver];
//    self.currentPlayerManager.currentTime = [info floatValue];
//    self.seekTime = [info doubleValue];
    int imageIndex = [info floatValue] / 10;
    self.previewView.alpha = 1.f;
    self.previewView.title = info;
//    if (imageIndex < self.thumbImages.count) {
//        self.previewView.image = self.thumbImages[imageIndex];
//    } else {
//        self.previewView.image = nil;
//    }
//        DLog(@"拖动中：%@ = 图片%@",info,self.thumbImages);
}
// 移除时间OB
- (void)removeTimeObserver
{
    if (_timeObserver) {
        [self.player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}
//实现方法
- (void)notificationEnd:(NSNotification *)noti {
    
    //使用object处理消息
    NSString *info = [noti object];
    DLog(@"拖动结束：%@",info);
    [UIView animateWithDuration:.5f animations:^{
        self.previewView.alpha = .0f;
    }];
//    [self.player seekToTime:CMTimeMake([info floatValue], 1.0)];
//    [self.player seekToTime:CMTimeMake([info floatValue], 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player seekToTime:CMTimeMake([info floatValue], 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:nil];
    [self addTimerObserver:info];
//    [self reloadPlayer];
//    [self.player play];
    [self reloadPlayer];
    [self bufferingSomeSecond];
    
}
// 给进度条Slider添加时间OB
- (void)addTimerObserver:(NSString *)slider
{
    __weak typeof(self) weakSelf = self;
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        weakSelf.currentTimeLabel.text = [NSString stringWithTime:CMTimeGetSeconds(weakSelf.player.currentTime)];
        
//           weakSelf.progressSlider.value = CMTimeGetSeconds(weakSelf.player.currentTime);
//        slider.value = CMTimeGetSeconds(weakSelf.player.currentTime);

        CGFloat timeShow =  CMTimeGetSeconds(weakSelf.player.currentTime);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"timeCurrent" object:[NSString stringWithFormat:@"%f",timeShow]];
//        CMTimeShow(time);
        
    }];
}

- (void)prepareToPlay {
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    [self initializePlayer];
    [self play];
    self.loadState = ZFPlayerLoadStatePrepare;
    if (_playerPrepareToPlay) _playerPrepareToPlay(self, self.assetURL);
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.rate = self.rate;
        self->_isPlaying = YES;
        self.playState = ZFPlayerPlayStatePlaying;
    }
}

- (void)pause {
    
    [self.player pause];
    self->_isPlaying = NO;
    self.playState = ZFPlayerPlayStatePaused;
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
    
}

- (void)stop {
    
    [_playerItemKVO safelyRemoveAllObservers];
    self.playState = ZFPlayerPlayStatePlayStopped;
    self.loadState = ZFPlayerLoadStateUnknown;
    if (self.player.rate != 0) [self.player pause];
    [self.player removeTimeObserver:_timeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    _timeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    _itemEndObserver = nil;
    _isPlaying = NO;
    _player = nil;
//    if (_assetURL != nil) {
        _assetURL = nil;
//    }
    
    _playerItem = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
    
}

- (void)replay {
    @weakify(self)
  
    [self seekToTime:self.timeSeek completionHandler:^(BOOL finished) {
        @strongify(self)
        [self play];
    }];
}

/// Replace the current playback address
- (void)replaceCurrentAssetURL:(NSURL *)assetURL {
    
    self.assetURL = assetURL;
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    
    CMTime seekTime = CMTimeMake(time, 1);
    [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    
}

- (UIImage *)thumbnailImageAtCurrentTime {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_asset];
    CMTime expectedTime = _playerItem.currentTime;
    CGImageRef cgImage = NULL;
    
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    
    if (!cgImage) {
        imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CFRelease(cgImage);
    
    return image;
}

#pragma mark - private method
#pragma mark - UITableView DataSource 实现数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"episode";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    YGPlayInfo *playInfo = self.playInfos[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentPlayingUrl = [defaults objectForKey:@"currentPlayingUrl"];
    if ([currentPlayingUrl isEqualToString:playInfo.url]) {
        cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", playInfo.artist, playInfo.title];
    
    return cell;
}

#pragma mark - UITableView Delegate 实现代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YGPlayInfo *playInfo = self.playInfos[indexPath.row];
//    [self removeEpisodeCover:self.episodeCover];
//    [self playWithPlayInfo:playInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)playWithPlayInfo
{
    // 清空缩略图数组
//    [self.thumbImages removeAllObjects];
    
    // 重置player
//    [self reloadPlayer];
    
    // 设置预览缩略图透明度为0
//    self.previewView.alpha = .0f;
    
    // 存储当前播放URL到本地 以便后面选集时比较哪个是当前播放的曲目
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:playInfo.url forKey:@"currentPlayingUrl"];
    
    // 因为replaceCurrentItemWithPlayerItem在使用时会卡住主线程 重新创建player解决
//    self.player = [self initializePlayer];
//    self.asset = [AVURLAsset assetWithURL:[NSURL URLWithString:playInfo.url]];
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
//
//    // 添加时间周期OB、OB和通知
//    [self addTimerObserver];
//    [self addPlayItemObserverAndNotification];
//
//    // 设置播放器标题
//    self.titleLabel.text = playInfo.title;
//    self.placeHolderView.hidden = NO;
//    self.placeHolderView.image = [UIImage imageNamed:playInfo.placeholder];
//
//    [self.waitingView startAnimating];
    
//    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    // 获取视频时长 网速慢可能会需要等待 卡住主线程
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval totalTime = CMTimeGetSeconds(self.asset.duration);
//        // 截屏次数
//        int captureTimes = (totalTime / 10);
//
//        for (int i = 0; i < captureTimes; i++) {
//            UIImage *image = [self thumbImageForVideo:[NSURL URLWithString:playInfo.url] atTime:10 * i];
//            if (image) {
//                [[self mutableArrayValueForKey:@"thumbImages"] addObject:image];
//            }
//        }
        // 添加视频最后一帧缩略图到数组
        UIImage *lastImage = [self thumbImageForVideo:self.assetURL atTime:totalTime];
//        if (lastImage) {
//            [[self mutableArrayValueForKey:@"thumbImages"] addObject:lastImage];
//        }
        DLog(@"最后一针图片%@",lastImage);
//    });
}

// 获取AVURLAsset的任意一帧图片
- (UIImage *)thumbImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    [self.imageGenerator cancelAllCGImageGeneration];
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    self.imageGenerator.maximumSize = CGSizeMake(160, 90);
    
    CGImageRef thumbImageRef = NULL;
    NSError *thumbImageGenerationError = nil;
    thumbImageRef = [self.imageGenerator copyCGImageAtTime:CMTimeMake(time, 1) actualTime:NULL error:&thumbImageGenerationError];
    //    NSLog(@"%@", thumbImageGenerationError);
    if (thumbImageRef) {
        return [[UIImage alloc] initWithCGImage:thumbImageRef];
    } else {
        return nil;
    }
}

/// Calculate buffer progress
- (NSTimeInterval)availableDuration {
    NSArray *timeRangeArray = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange aTimeRange = {0};
    if (timeRangeArray.count) {
        aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        if (CMTimeRangeContainsTime(aTimeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(aTimeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}

- (void)initializePlayer {
   
    NSString *url = [NSString stringWithFormat:@"%@",self.assetURL];
    
    NSURL *playerURL = nil;
//    BOOL status = [self videoStatusForVideo:url];
//
//    NSArray *arr = [url componentsSeparatedByString:@"/"];
//    self.videoUrl = [arr objectAtIndex:5];
//    if(status ==  NO) {
//        /** Open local server */
//        [self openHttpServer];
//        NSString *localServerURL = [NSString stringWithFormat:@"http://127.0.0.1:12345/%@.m3u8",self.videoUrl];
////          NSString *destinationPath = [self.documentPath stringByAppendingPathComponent:self.videoUrl.lastPathComponent];
//        playerURL = [NSURL URLWithString:localServerURL];
////        playerURL = [NSURL fileURLWithPath:destinationPath];
//    } else {
        playerURL = [NSURL URLWithString:url];
//    }
//      DLog(@"播放的视频%@ ",playerURL);
    _asset = [AVURLAsset assetWithURL:playerURL];
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    [self enableAudioTracks:YES inPlayerItem:_playerItem];
   
    
    ZFPlayerPresentView *presentView = (ZFPlayerPresentView *)self.view;
    presentView.player = _player;
    presentView.contentMode = UIViewContentModeScaleAspectFill;
    self.scalingMode = _scalingMode;
    
    if (@available(iOS 9.0, *)) {
        _playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
    }
    if (@available(iOS 10.0, *)) {
        _playerItem.preferredForwardBufferDuration = 5;
        _player.automaticallyWaitsToMinimizeStalling = NO;
    }
   
    [self itemObserving];
}

// 沙盒 document 路径
- (NSString *)documentPath  {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return docDir;
}

- (void)notificationVideoPlay:(NSNotification *)notifiaction  {
    
    NSString *heightString = [notifiaction object];
    CGFloat heightFloat = [heightString floatValue];
    ZFPlayerPresentView *presentView = (ZFPlayerPresentView *)self.view;
    if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
         if (heightFloat/2 >= 812.0f) {
            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
            } else {
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            }
    }
}

+(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

+(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    
    return isExist;
}

- (NSArray *)lookDownloadsName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES) firstObject];
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:docDir error:&error];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    //        以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDoc = NO;
    for (NSString *file in fileList) {
        NSString *path = [docDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDoc)];
        if (isDoc) {
            [dirArray addObject:file];
        }
        isDoc = NO;
    }
    
    return dirArray;
}

/// Playback speed switching method
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem {
    for (AVPlayerItemTrack *track in playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]) {
            track.enabled = enable;
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    if (self.isBuffering) return;
    self.isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying) {
            self.isBuffering = NO;
            return;
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) [self bufferingSomeSecond];
    });
}

- (void)itemObserving {
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[ZFKVOController alloc] initWithTarget:_playerItem];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kStatus
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackBufferEmpty
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackLikelyToKeepUp
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kLoadedTimeRanges
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPresentationSize
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    CMTime interval = CMTimeMakeWithSeconds(kTimeRefreshInterval, NSEC_PER_SEC);
    @weakify(self)
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self)
        if (!self) return;
        NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
        /// 大于0才把状态改为可以播放，解决黑屏问题
        if (CMTimeGetSeconds(time) > 0 && !self.isReadyToPlay) {
            self.isReadyToPlay = YES;
            self.loadState = ZFPlayerLoadStatePlaythroughOK;
        }
        if (loadedRanges.count > 0) {
            if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
        }
    }];
    
    _itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        if (!self) return;
        self.playState = ZFPlayerPlayStatePlayStopped;
        if (self.playerDidToEnd) self.playerDidToEnd(self);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kStatus]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                /// 第一次初始化
                if (self.loadState == ZFPlayerLoadStatePrepare) {
                    if (self.playerPrepareToPlay) self.playerReadyToPlay(self, self.assetURL);
                }
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                    self.seekTime = 0;
                }
                if (self.isPlaying) [self play];
                self.player.muted = self.muted;
                NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
                if (loadedRanges.count > 0) {
                    
                    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playState = ZFPlayerPlayStatePlayFailed;
                NSError *error = self.player.currentItem.error;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
//                UILabel *busyLabel = [[UILabel alloc] init];
//                busyLabel.font = [UIFont systemFontOfSize:13];
//                busyLabel.textColor = [UIColor whiteColor];
//                busyLabel.backgroundColor = [UIColor clearColor];
//                busyLabel.textAlignment = NSTextAlignmentCenter;
////                busyLabel.text = @"资源不存在...";
//                [self.view addSubview:busyLabel];
//                [busyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.center.width.equalTo(self.view);
//                    make.height.mas_equalTo(30);
//                }];
            }
        } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
            // When the buffer is empty
            if (self.playerItem.playbackBufferEmpty) {
                self.loadState = ZFPlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
            // When the buffer is good
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = ZFPlayerLoadStatePlayable;
                if (self.isPlaying) [self play];
            }
        } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {

            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
        } else if ([keyPath isEqualToString:kPresentationSize]) {
            self->_presentationSize = self.playerItem.presentationSize;
            if (self.presentationSizeChanged) {
                self.presentationSizeChanged(self, self->_presentationSize);
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

#pragma mark - getter

- (UIView *)view {
    if (!_view) {
        _view = [[ZFPlayerPresentView alloc] init];
    }
    return _view;
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.playerItem.currentTime);
    if (isnan(sec) || sec < 0) {
        return 0;
    }
    return sec;
}

#pragma mark - setter

- (void)setPlayState:(ZFPlayerPlaybackState)playState {
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(ZFPlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSURL *)assetURL {
    if (self.player) [self stop];
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.player && fabsf(_player.rate) > 0.00001f) {
        self.player.rate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

- (void)setScalingMode:(ZFPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
//    DLog(@"图的尺寸%@",NSStringFromCGRect(presentView.frame));
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *videoHeight = [user objectForKey:@"video_Height"];
//    if ([videoHeight doubleValue] >360) {
//            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    } else {
//        presentView.videoGravity = AVLayerVideoGravityResizeAspect;
//    presentView.videoGravity = AVLayerVideoGravityResize;
//    }
    
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.volume = volume;
}

- (YGPreviewView *)previewView
{
    if (_previewView == nil) {
        _previewView = [YGPreviewView sharedPreviewView];
        [self.view addSubview:_previewView];
    }
    return _previewView;
}

//- (NSMutableArray *)thumbImages
//{
//    if (_thumbImages == nil) {
//        _thumbImages = [NSMutableArray array];
//        [self addObserver:self forKeyPath:@"thumbImages" options:NSKeyValueObservingOptionNew context:NULL];
//    }
//    return _thumbImages;
//}

#pragma mark - 懒加载
- (AVAssetImageGenerator *)imageGenerator {
    if (!_imageGenerator) {
        _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    }
    return _imageGenerator;
}

- (NSMutableArray *)playInfos
{
    if (_playInfos == nil) {
        _playInfos = [YGPlayInfo mj_objectArrayWithFilename:@"playList.plist"];
    }
    return _playInfos;
}

- (void)dealloc {
    
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"valueChangeBlock" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishChangeBlock" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hotVideoUrl" object:nil];
//    [self removePlayItemObserverAndNotification];
    [self removeTimeObserver];
//    [self removeObserver:self forKeyPath:@"thumbImages"];
}

@end

#pragma clang diagnostic pop
