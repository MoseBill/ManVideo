//
//  MARFaceBeautyController.m
//  MARFaceBeauty
//
//  Created by Maru on 2016/11/12.
//  Copyright © 2016年 Maru. All rights reserved.
//

#import "MARFaceBeautyVC.h"
#import "GPUImageLineGenerator.h"
#import "GPUImageBeautifyFilter.h"
#import <Photos/Photos.h>
#import "CustomerAVPlayer.h"

extern UINavigationController *rootVC;

#define kLimitRecLen (60.0f*15)//15mins
#define kRecordW 54
#define kRecordCenter CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - Height_TabBar)

@interface MARFaceBeautyVC ()
<
CAAnimationDelegate
,TZImagePickerControllerDelegate
//,SSAddImageDelegate
>
{
    BOOL _containFilter;
    BOOL _containBeautify;
}

@property(nonatomic,strong)UIButton *flashSwitch;
@property(nonatomic,strong)UIButton *cameraSwitch;
@property(nonatomic,strong)UIButton *recordButton;//录制⏺
@property(nonatomic,strong)UIButton *downButton;
@property(nonatomic,strong)UIButton *promptBtn;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)MMButton *uploadBtn;//上传 （先跳相册选视频，再跳发布页面）
@property(nonatomic,strong)MMButton *filterSwitch;//美颜
@property(nonatomic,strong)MMButton *releaseBtn;//发布
@property(nonatomic,strong)MMButton *saveBtn;//保存
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIImage *_tempImg;
@property(nonatomic,strong)UIView *animationView;
@property(nonatomic,strong)UISlider *slider;//滤镜控制
@property(nonatomic,strong)CustomerAVPlayer *customerAVPlayer;
@property(nonatomic,strong)UIPanGestureRecognizer *panGesture;
@property(nonatomic,strong)TZImagePickerController *imagePickerVc;
@property(nonatomic,strong)VideoReleaseVC *videoReleaseVC;

@property(nonatomic,strong)CAKeyframeAnimation *animation;
@property(nonatomic,strong)CAShapeLayer *cycleLayer;
@property(nonatomic,strong)CAShapeLayer *progressLayer;
@property(nonatomic,strong)CAShapeLayer *ballLayer;

//响应链
@property(nonatomic,strong)GPUImageVideoCamera *videoCamera;
@property(nonatomic,strong)GPUImageOutput<GPUImageInput> *filter;
@property(nonatomic,strong)GPUImageMovieWriter *movieWriter;
@property(nonatomic,strong)GPUImageView *filterView;

@property(nonatomic,assign)MHShootSpeedType videoSpeedType;//当前选择拍摄速度 默认标准速度
@property(nonatomic,strong)NSTimer *mTimer;
@property(nonatomic,assign)long mLabelTime;
@property(nonatomic,assign)__block BOOL isOpenCamera;
@property(nonatomic,assign)__block BOOL isOpenMicrophone;
@property(nonatomic,assign)__block BOOL isRecording;
//@property(nonatomic,assign)__block BOOL isRelease;
//@property(nonatomic,strong)PostVideoModel *_Nullable videoModel;//保存视频信息的模型
//@property(nonatomic,strong)ShootSubVideo *subModel;

@end

@implementation MARFaceBeautyVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    MARFaceBeautyVC *vc = MARFaceBeautyVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

- (instancetype)init{
    if (self = [super init]) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;//阻止iOS设备锁屏
        self.videoSpeedType = MHShootSpeedTypeNomal;//默认拍摄速度
        self.isOpenCamera = NO;
        self.isOpenMicrophone = NO;
        self.mLabelTime = 0;
        self.isRecording = NO;
//        self.isRelease = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(FileUrl:)
                                                     name:@"FileUrl"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(SaveRes_success:)
                                                     name:@"saveRes_success"
                                                   object:nil];
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        @weakify(self)
        [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Microphone
                                              accessStatus:^(ECAuthorizationStatus status,
                                                             ECPrivacyType type) {
                                                  @strongify(self)
                                                  // status 即为权限状态，
                                                  //状态类型参考：ECAuthorizationStatus
                                                  NSLog(@"%lu",(unsigned long)status);
                                                  if (status == ECAuthorizationStatus_Authorized) {
                                                      self.isOpenMicrophone = YES;
                                                  }else{
                                                      NSLog(@"麦克风不可用:%lu",(unsigned long)status);
                                                      [self showAlertViewTitle:NSLocalizedString(@"MicrophonePermissions", nil)
                                                                       message:@""
                                                                alertBtnAction:@[@"pushToSysConfig"]];
                                                  }
                                              }];
        [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Camera
                                              accessStatus:^(ECAuthorizationStatus status,
                                                             ECPrivacyType type) {
                                                  @strongify(self)
                                                  // status 即为权限状态，
                                                  //状态类型参考：ECAuthorizationStatus
                                                  NSLog(@"%lu",(unsigned long)status);
                                                  if (status == ECAuthorizationStatus_Authorized) {
                                                      self.isOpenCamera = YES;
                                                      if (self.isOpenCamera &&
                                                          self.isOpenMicrophone ) {
                                                          [self.videoCamera startCameraCapture];
                                                      }
                                                      [self UIState:NO];
                                                  }else{
    //                                                  NSLog(@"摄像头不可用:%lu",status)
                                                      [self showAlertViewTitle:NSLocalizedString(@"CameraPermissions", nil)
                                                                       message:@""
                                                                alertBtnAction:@[@"pushToSysConfig"]];
                                                      [self UIState:YES];
                                                  }
                                              }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification//设置通知监听屏幕的旋转（在旋转的瞬间触发该方法）
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          @strongify(self)
                                                          self.videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
                                                      }];
    GPUImageSepiaFilter *sepiaFilter = (GPUImageSepiaFilter *)self.filter;
    sepiaFilter.intensity = 0;
    rootVC.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}
//保存文件 + 转码 是耗时过程，多线程结束以后，发通知，所以在此通知里面进行推VideoReleaseVC
-(void)FileUrl:(NSNotification *)noti{
    __block NSURL *info = [noti object];
//    NSLog(@"%@",info);
//    NSLog(@"%lld",[VideoHandleTool fileSizeAtPath:info.path]);
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        self.videoReleaseVC = [VideoReleaseVC pushFromVC:self_weak_
                                           requestParams:info
                                                 success:^(id  _Nonnull data) {}
                                                animated:YES];
    });
}
//视频保存成功 回调
-(void)SaveRes_success:(NSNotification *)noti{

//    [self uploadClick:nil];

}

-(void)UIStateWhenRecording:(BOOL)state{
    self.cameraSwitch.hidden = state;
    self.flashSwitch.hidden = state;
    self.uploadBtn.hidden = state;
    self.filterSwitch.hidden = state;
    self.releaseBtn.hidden = state;
    self.saveBtn.hidden = state;
    self.promptBtn.hidden = state;
}

-(void)UIState:(BOOL)state{
    self.backBtn.hidden = state;
    self.cameraSwitch.hidden = state;
    self.flashSwitch.hidden = state;

    self.gk_statusBarHidden = NO;
    self.gk_navLineHidden = YES;
    self.gk_navBackgroundColor = kClearColor;

    [self.view addSubview:self.cameraSwitch];
    [self.view addSubview:self.flashSwitch];

    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.cameraSwitch],
                                       [[UIBarButtonItem alloc] initWithCustomView:self.flashSwitch]];

    self.tabBarController.tabBar.hidden = !state;
    self.uploadBtn.hidden = state;
    self.filterSwitch.hidden = state;
    self.releaseBtn.hidden = state;
    self.saveBtn.hidden = state;
    self.recordButton.hidden = state;
    self.promptBtn.hidden = state;
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

-(void)uploadClick:(UIButton *)sender{
    [self presentViewController:self.imagePickerVc
                       animated:YES
                     completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    if (!self.isRecording) {
        self.backBtn.hidden = !self.backBtn.hidden;
        self.slider.hidden = YES;
    }
}
//发布
//1、未录制时：检索本地有无发布的文件，有（上传），没有（提示录制）
//2、录制时：关闭录制、保存视频文件、检索到有文件以后，再发布上传
-(void)releaseBtnClickEvent:(UIButton *)sender{
    if (self.isRecording) {
        //保存 ＋ 转码 是耗时操作，多线程结束以后再通知里面进行回调操作（推VideoReleaseVC） -(void)FileUrl:(NSNotification *)noti
        [self saveBtnClickEvent:sender];
    }else{
        if ([VideoHandleTool fileSizeAtPath:[[VideoHandleTool pathToMovieURL] absoluteString]]) {
            //上传 获取到相册里面最新鲜的数据进行上传
            [VideoHandleTool sourceAssets:[VideoHandleTool gettingLastResource]];
        }else [SVProgressHUD showSuccessWithStatus:@"请先进行录制"];
    }
}
//保存
-(void)saveBtnClickEvent:(UIButton *)sender{
    if (self.isRecording) {
//        [self cancelBtnClickEvent:sender];
        [self endRecordAndPlay];
        [self sureBtnClickEvent:sender];
    }else  [SVProgressHUD showSuccessWithStatus:@"请先进行录制"];
}

-(void)sureBtnClickEvent:(UIButton *)sender{
    [self cancelBtnClickEvent:sender];
    [self prepareSave];
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    [self.customerAVPlayer stop];
    [self.customerAVPlayer removeFromSuperview];
    [self.sureBtn removeFromSuperview];
    [self.cancelBtn removeFromSuperview];
    self.customerAVPlayer = Nil;
    self.sureBtn = Nil;
    self.cancelBtn = Nil;
}

-(void)panGestureAction:(UIPanGestureRecognizer *)sender{
    CGPoint translatePoint = [sender translationInView:self.view];
    self.customerAVPlayer.center = CGPointMake(self.customerAVPlayer.center.x + translatePoint.x, self.customerAVPlayer.center.y + translatePoint.y);
    self.cancelBtn.mj_y = self.customerAVPlayer.mj_y + self.customerAVPlayer.mj_h + SCALING_RATIO(5);
    self.cancelBtn.mj_x = self.customerAVPlayer.mj_x + self.customerAVPlayer.mj_w - self.cancelBtn.mj_w;
    self.sureBtn.mj_y = self.customerAVPlayer.mj_y + self.customerAVPlayer.mj_h + SCALING_RATIO(5);
    self.sureBtn.mj_x = self.customerAVPlayer.mj_x;
    [sender setTranslation:CGPointZero inView:self.view];
}

-(void)filterAction:(UIButton *)sender{
    self.slider.hidden = !self.slider.hidden;
    sender.selected = !sender.selected;
}

- (void)updateSliderValue:(id)sender{
    NSLog(@"KKK = %f",[(UISlider *)sender value]);
    [(GPUImageSepiaFilter *)_filter setIntensity:[(UISlider *)sender value]];
}

-(void)recordBtnClickEvent:(UIButton *)sender{
    NSLog(@"HGHG1 = %lld",[VideoHandleTool fileSizeAtPath:[VideoHandleTool pathToMovieStr]]);
    self.promptBtn.hidden = YES;
    if (!sender.selected) {
        NSLog(@"KKK Start recording");
        [self cancelBtnClickEvent:sender];
        [self startRecord];
    }else{
        NSLog(@"KKK End recording");
        [self endRecordAndPlay];
    }sender.selected = !sender.selected;
}

-(void)startRecord{
    unlink([[VideoHandleTool pathToMovieStr] UTF8String]); // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
    NSLog(@"HGHG2 = %lld",[VideoHandleTool fileSizeAtPath:[VideoHandleTool pathToMovieStr]]);
    [self.view.layer addSublayer:self.cycleLayer];
    [self.view.layer addSublayer:self.progressLayer];
    [self.view.layer addSublayer:self.ballLayer];
    self.isRecording = YES;
    [self.movieWriter startRecording];//开始录制
    [self UIStateWhenRecording:YES];
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                               target:self
                                             selector:@selector(onTimer:)
                                             userInfo:nil
                                              repeats:YES];
}

-(void)endRecord{
    if (_mTimer) {
        [_mTimer invalidate];
        _mLabelTime = 0;
    }
    [_filter removeTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = nil;
    [_movieWriter finishRecording];//停止录制
    self.isRecording = NO;
    [self UIStateWhenRecording:NO];
    [self.cycleLayer removeFromSuperlayer];
    [self.progressLayer removeFromSuperlayer];
    [self.ballLayer removeFromSuperlayer];
    _movieWriter = nil;//必须强制置空，否则第二次录制会崩溃
}

-(void)endRecordAndPlay{
    [self endRecord];
    //缓存策略:先播放，觉得可以再进行保存本地相册，否则删除
    [self.customerAVPlayer play];
}

-(void)prepareSave{
    @weakify(self)
    [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Photos
                                          accessStatus:^(ECAuthorizationStatus status,
                                                         ECPrivacyType type) {
                                              @strongify(self)
                                              // status 即为权限状态，
                                              //状态类型参考：ECAuthorizationStatus
                                              NSLog(@"%lu",(unsigned long)status);
                                              if (status == ECAuthorizationStatus_Authorized) {
                                                  [VideoHandleTool createFolder:HDAppDisplayName];//
                                              }else{
                                                  NSLog(@"相册不可用:%lu",(unsigned long)status);
                                                  [self showAlertViewTitle:NSLocalizedString(@"PhotoAlbumPermissions", nil)
                                                                   message:@""
                                                            alertBtnAction:@[@"pushToSysConfig"]];
                                              }
                                          }];
}

- (void)onTimer:(id)sender {
    self.backBtn.hidden = NO;
    [self.backBtn setTitle:[NSString stringWithFormat:@"%@:%lds",NSLocalizedString(@"RecordingTime", nil),_mLabelTime++]
                  forState:UIControlStateNormal];
    [self updateProgress:self.mLabelTime / kLimitRecLen];
}
//进度条
- (void)updateProgress:(CGFloat)value {
    DLog(@"进度条%lf",value * 1000);
    NSLog(@"self.mLabelTime = %ld",self.mLabelTime);
    if (value > 1.0) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"录制完成", nil)];
        [self endRecordAndPlay];
    }else {
        //中间的红色圆点
        self.ballLayer.path = [UIBezierPath bezierPathWithArcCenter:kRecordCenter
                                                             radius:(kRecordW / 2  - 10) * value
                                                         startAngle:0
                                                           endAngle:2 * M_PI
                                                          clockwise:YES].CGPath;
        //进度条
        self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:kRecordCenter
                                                                 radius:kRecordW / 2
                                                             startAngle:- M_PI_2
                                                               endAngle:2 * M_PI * (value) - M_PI_2
                                                              clockwise:YES].CGPath;
    }
}

- (void)promptAction:(UIButton *)action {
    action.hidden = YES;
}

- (void)backBtnClickEvent:(UIButton *)sender{
    self.uploadBtn.hidden = !sender.selected;
    self.filterSwitch.hidden = !sender.selected;
    self.releaseBtn.hidden = !sender.selected;
    self.saveBtn.hidden = !sender.selected;
    self.slider.hidden = !sender.selected;
    self.recordButton.hidden = !sender.selected;
    self.promptBtn.hidden = !sender.selected;
    self.tabBarController.tabBar.hidden = sender.selected;
    sender.selected = !sender.selected;
    [self endRecord];//停止
    extern LZTabBarVC *tabBarVC;
    tabBarVC.selectedIndex = 0;
}

- (void)flashAction:(UIButton *)sender {
    if (self.flashSwitch.selected) {
        self.flashSwitch.selected = NO;
        if ([self.videoCamera.inputCamera lockForConfiguration:nil]) {
            [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            [self.videoCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
            [self.videoCamera.inputCamera unlockForConfiguration];
        }
    }else {
        self.flashSwitch.selected = YES;
        if ([self.videoCamera.inputCamera lockForConfiguration:nil]) {
            [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self.videoCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
            [self.videoCamera.inputCamera unlockForConfiguration];
        }
    }
}
//https://cocoapods.org/pods/PKShortVideo
- (void)turnAction:(UIButton *)sender {
//    [self.videoCamera pauseCameraCapture];
//    if (self.videoCamera.cameraPosition == AVCaptureDevicePositionBack) {
//        self.flashSwitch.hidden = YES;
//    }else {
//        self.flashSwitch.hidden = NO;
//    }
//    @weakify(self)
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        @strongify(self)
//        [self.videoCamera rotateCamera];
//        [self.videoCamera resumeCameraCapture];
//    });
}

#pragma mark —— lazyLoad
-(GPUImageMovieWriter *)movieWriter{
    if (!_movieWriter) {
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[VideoHandleTool pathToMovieURL]
                                                                size:CGSizeMake(480.0, 640.0)];
        _movieWriter.encodingLiveVideo = YES;
        [self.filter addTarget:_movieWriter];
        self.videoCamera.audioEncodingTarget = _movieWriter;
    }return _movieWriter;
}

-(GPUImageVideoCamera *)videoCamera{
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset3840x2160
                                                           cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
        [_videoCamera addTarget:self.filter];
    }return _videoCamera;
}

-(GPUImageOutput<GPUImageInput> *)filter{
    if (!_filter) {
        _filter = GPUImageSepiaFilter.new;
        [_filter addTarget:self.filterView];
    }return _filter;
}

-(GPUImageView *)filterView{
    if (!_filterView) {
        _filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
        _filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;//保持原宽高比，并且图像要铺满整个屏幕。那么图像大小为准
        self.view = _filterView;
    }return _filterView;
}

-(UIButton *)promptBtn{
    if (!_promptBtn) {
        _promptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_promptBtn setImage:[UIImage imageNamed:NSLocalizedString(@"VDPersonTanchuang", nil)]
                    forState:UIControlStateNormal];
        [_promptBtn addTarget:self
                       action:@selector(promptAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [_promptBtn.layer addAnimation:self.animation
                                forKey:@"kViewShakerAnimationKey"];
        [self.view addSubview:_promptBtn];
        [_promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.recordButton.mas_top);
            make.centerX.equalTo(self.recordButton);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 6));
        }];
    }return _promptBtn;
}

-(MMButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = MMButton.new;
        _uploadBtn.imageAlignment = MMImageAlignmentTop;
        _uploadBtn.spaceBetweenTitleAndImage = 50;
        [_uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload"]
                              forState:UIControlStateNormal];
        [_uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload_red"]
                              forState:UIControlStateSelected];
        [_uploadBtn addTarget:self
                       action:@selector(uploadClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [_uploadBtn setTitle:NSLocalizedString(@"VDuploadText", nil)
                    forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.view addSubview:_uploadBtn];
        [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(22.0f/375.0f*SCREEN_WIDTH);
            make.bottom.mas_equalTo(-Height_TabBar);
            make.width.mas_equalTo(31);
            make.height.mas_equalTo(28);
        }];
    }return _uploadBtn;
}

-(MMButton *)filterSwitch{
    if (!_filterSwitch) {
        _filterSwitch = MMButton.new;
        _filterSwitch.imageAlignment = MMImageAlignmentTop;
        _filterSwitch.spaceBetweenTitleAndImage = 50;
        [_filterSwitch setTitle:NSLocalizedString(@"VDSkincare", nil)
                       forState:UIControlStateNormal];
        [_filterSwitch setBackgroundImage:[UIImage imageNamed:@"_classification_unselected"]
                                 forState:UIControlStateNormal];
        [_filterSwitch setBackgroundImage:[UIImage imageNamed:@"_classification_selected"]
                                 forState:UIControlStateSelected];
        _filterSwitch.selected = YES;
        [_filterSwitch addTarget:self
                          action:@selector(filterAction:)
                forControlEvents:UIControlEventTouchUpInside];
        _filterSwitch.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.view addSubview:_filterSwitch];
        [_filterSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(98/375.0f*SCREEN_WIDTH);
            make.bottom.mas_equalTo(-Height_TabBar);
            make.width.mas_equalTo(31);
            make.height.mas_equalTo(28);
        }];
    }return _filterSwitch;
}

-(MMButton *)releaseBtn{
    if (!_releaseBtn) {
        _releaseBtn = MMButton.new;
        _releaseBtn.imageAlignment = MMImageAlignmentTop;
        _releaseBtn.spaceBetweenTitleAndImage = 50;
        [_releaseBtn setBackgroundImage:[UIImage imageNamed:@"message_unselected"]
                               forState:UIControlStateNormal];
        [_releaseBtn setBackgroundImage:[UIImage imageNamed:@"message_selected"]
                               forState:UIControlStateSelected];
        [_releaseBtn addTarget:self
                        action:@selector(releaseBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [_releaseBtn setTitle:NSLocalizedString(@"VDrelease", nil)
                     forState:UIControlStateNormal];
        _releaseBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.view addSubview:_releaseBtn];
        [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-97/375.0f*SCREEN_WIDTH);
            make.bottom.mas_equalTo(-Height_TabBar);
            make.centerY.mas_equalTo(self.filterSwitch.mas_centerY);
            make.width.mas_equalTo(31);
            make.height.mas_equalTo(28);
        }];
    }return _releaseBtn;
}

-(MMButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = MMButton.new;
        _saveBtn.imageAlignment = MMImageAlignmentTop;
        _saveBtn.spaceBetweenTitleAndImage = 50;
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"download"]
                            forState:UIControlStateNormal];
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"download_selected"]
                            forState:UIControlStateSelected];
        [_saveBtn addTarget:self
                     action:@selector(saveBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitle:NSLocalizedString(@"VDbaocun", nil)
                     forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.view addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-22/375.0f*SCREEN_WIDTH);
            make.centerY.mas_equalTo(self.releaseBtn.mas_centerY);
            make.bottom.mas_equalTo(-Height_TabBar);
            make.width.mas_equalTo(31);
            make.height.mas_equalTo(28);
        }];
    }return _saveBtn;
}

-(UIButton *)flashSwitch{
    if (!_flashSwitch) {
        _flashSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashSwitch setImage:[UIImage imageNamed:@"record_light_off"]
                      forState:UIControlStateNormal];
        [_flashSwitch setImage:[UIImage imageNamed:@"record_light_on"]
                      forState:UIControlStateSelected];
        [_flashSwitch addTarget:self
                         action:@selector(flashAction:)
               forControlEvents:UIControlEventTouchUpInside];

        _flashSwitch.frame = CGRectMake(SCREEN_WIDTH -SCALING_RATIO((10 + 60) * 2),
                                                SCALING_RATIO(10),
                                                SCALING_RATIO(60),
                                                SCALING_RATIO(60));


//[self.view addSubview:_flashSwitch];
//        [_flashSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.backBtn);
//            make.right.equalTo(self.cameraSwitch.mas_left).offset(SCALING_RATIO(-10));
//            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(24), SCALING_RATIO(24)));
//        }];
    }return _flashSwitch;
}

-(UIButton *)cameraSwitch{
    if (!_cameraSwitch) {
        _cameraSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraSwitch setImage:[UIImage imageNamed:@"相机图标"]
                       forState:UIControlStateNormal];
        [_cameraSwitch setImage:[UIImage imageNamed:@"相机图标"]
                       forState:UIControlStateSelected];
        [_cameraSwitch addTarget:self
                          action:@selector(turnAction:)
                forControlEvents:UIControlEventTouchUpInside];

        _cameraSwitch.frame = CGRectMake(SCREEN_WIDTH - SCALING_RATIO(10 + 60),
                                         SCALING_RATIO(10),
                                         SCALING_RATIO(60),
                                         SCALING_RATIO(60));
//        [self.view addSubview:_cameraSwitch];
//        [_cameraSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.backBtn);
//            make.right.equalTo(self.view).offset(SCALING_RATIO(-10));
//            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(54), SCALING_RATIO(24)));
//        }];
    }return _cameraSwitch;
}

-(UIButton *)recordButton{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_shutter_untouch"]
                                 forState:UIControlStateNormal];
        [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_shutter_touching"]
                                 forState:UIControlStateHighlighted];
        [_recordButton addTarget:self
                          action:@selector(recordBtnClickEvent:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recordButton];
        _recordButton.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - Height_TabBar);
        _recordButton.bounds = CGRectMake(0,
                                          0,
                                          kRecordW,
                                          kRecordW);
    }return _recordButton;
}

-(UISlider *)slider{
    if (!_slider) {
        _slider = UISlider.new;
        _slider.hidden = YES;
        [_slider addTarget:self
                    action:@selector(updateSliderValue:)
          forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.uploadBtn);
            make.bottom.equalTo(self.uploadBtn.mas_top).offset(-10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 3, SCALING_RATIO(40)));
        }];
    }return _slider;
}

-(CAKeyframeAnimation *)animation{
    if (!_animation) {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        CGFloat duration = 1.f;
        CGFloat height = 7.f;
        _animation.duration = duration;
        CGFloat currentY = self.animationView.transform.ty;
        _animation.values = @[@(currentY),
                              @(currentY - height/4),
                              @(currentY - height/4*2),
                              @(currentY - height/4*3),
                              @(currentY - height),
                              @(currentY - height/ 4*3),
                              @(currentY - height/4*2),
                              @(currentY - height/4),
                              @(currentY)];
        _animation.keyTimes = @[ @(0),
                                 @(0.025),
                                 @(0.085),
                                 @(0.2),
                                 @(0.5),
                                 @(0.8),
                                 @(0.915),
                                 @(0.975),
                                 @(1) ];
        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _animation.repeatCount = HUGE_VALF;
    }return _animation;
}

-(CAShapeLayer *)cycleLayer{
    if (!_cycleLayer) {
        _cycleLayer = CAShapeLayer.layer;
        _cycleLayer.lineWidth = 5.0f;
        _cycleLayer.path = [UIBezierPath bezierPathWithArcCenter:kRecordCenter
                                                          radius:kRecordW / 2
                                                      startAngle:0
                                                        endAngle:2 * M_PI
                                                       clockwise:YES].CGPath;
        _cycleLayer.fillColor = nil;
        _cycleLayer.strokeColor = [UIColor whiteColor].CGColor;
    }return _cycleLayer;
}

-(CAShapeLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = CAShapeLayer.layer;
        _progressLayer.lineWidth = 5.0f;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor colorWithHexString:@"E61870"].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
    }return _progressLayer;
}

-(CAShapeLayer *)ballLayer{
    if (!_ballLayer) {
        _ballLayer = CAShapeLayer.layer;
        _ballLayer.lineWidth = 1.0f;
        _ballLayer.fillColor = [UIColor colorWithHexString:@"E61870"].CGColor;
        _ballLayer.strokeColor = [UIColor colorWithHexString:@"E61870"].CGColor;
        _ballLayer.lineCap = kCALineCapRound;
    }return _ballLayer;
}

-(CustomerAVPlayer *)customerAVPlayer{
    if (!_customerAVPlayer) {
        _customerAVPlayer = [[CustomerAVPlayer alloc] initWithURL:[VideoHandleTool pathToMovieURL]];
        [_customerAVPlayer addGestureRecognizer:self.panGesture];
//        _customerAVPlayer.backgroundColor = kRedColor;
        @weakify(self)
        [_customerAVPlayer actionBlock:^(id  _Nonnull data) {
            @strongify(self)
            self.sureBtn.hidden = [data boolValue];
            self.cancelBtn.hidden = [data boolValue];
        }];
        [self.view insertSubview:_customerAVPlayer
                    aboveSubview:self.filterView];
        //全屏模式
        _customerAVPlayer.frame = self.view.bounds;
        NSLog(@"播放地址%@",[VideoHandleTool pathToMovieURL]);
        //小窗模式
//        [_customerAVPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset(SCALING_RATIO(-35));
//            make.left.equalTo(self.view).offset(SCALING_RATIO(10));
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 2/ 3, SCREEN_HEIGHT * 2/ 3));
//        }];

    }return _customerAVPlayer;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        [_sureBtn setImage:kIMG(@"勾")
                    forState:UIControlStateNormal];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_sureBtn
                    aboveSubview:self.filterView];
        _sureBtn.mj_y = self.customerAVPlayer.mj_y + self.customerAVPlayer.mj_h - SCALING_RATIO(100);
        _sureBtn.mj_x = self.customerAVPlayer.mj_x +  SCALING_RATIO(100);
        _sureBtn.size = CGSizeMake(SCALING_RATIO(30), SCALING_RATIO(30));
    }return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setImage:kIMG(@"叉")
                    forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_cancelBtn
                    aboveSubview:self.filterView];
        _cancelBtn.mj_y = self.customerAVPlayer.mj_y + self.customerAVPlayer.mj_h - SCALING_RATIO(100);
        _cancelBtn.mj_x = self.customerAVPlayer.mj_x + self.customerAVPlayer.mj_w - SCALING_RATIO(100);
        _cancelBtn.size = CGSizeMake(SCALING_RATIO(30), SCALING_RATIO(30));
    }return _cancelBtn;
}

-(UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(panGestureAction:)];
        [self.customerAVPlayer addGestureRecognizer:_panGesture];
    }return _panGesture;
}

-(TZImagePickerController *)imagePickerVc{
    if (!_imagePickerVc) {
        _imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9
                                                                        delegate:self];
        [_imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage,
                                                         PHAsset *asset) {
            [VideoHandleTool sourceAssets:asset];
        }];
    }return _imagePickerVc;
}


@end
