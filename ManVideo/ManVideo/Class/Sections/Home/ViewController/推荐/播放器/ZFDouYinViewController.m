//
//  ZFDouYinViewController.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinViewController.h"
#import "CommentVC.h"
#import "ZFDouYinCell.h"
#import "ZFDouYinControlView.h"
#import "UIViewController+Landscape.h"
#import "CommonModel.h"
#import "MessageModel.h"
#import "ZFDouYinViewController+VM.h"

CGFloat CommentViewHeight;
extern LZTabBarVC *tabBarVC;
extern UINavigationController *rootVC;

@interface ZFDouYinViewController ()
<UITableViewDelegate
,UITableViewDataSource
,VDCommentDelegate
//,JXCategoryListContentViewDelegate
//,AnnouncementSocketDelegate
>{
    CGFloat heightAll;
    CGFloat widthAll;
    NSString *userId;
    NSString *idString;
}

@property(nonatomic,strong)UIView *backgroud;
@property(nonatomic,strong)UILabel *announcementLabel;
@property(nonatomic,strong)UIImageView *imageAnnouncement;
@property(nonatomic,strong)UIActivityViewController *activityVC;
@property(nonatomic,strong)ZFPlayerController *player;
@property(nonatomic,strong)ZFAVPlayerManager *playerManager;
@property(nonatomic,strong)ZFDouYinControlView *controlView;
@property(nonatomic,strong)FLAnimatedImageView *imageView;
@property(nonatomic,strong)VDLoginViewController *loginController;
@property(nonatomic,strong)__block CommentVC *commentVC;
@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;

@property(nonatomic,strong)NSArray *activities;
@property(nonatomic,strong)NSMutableArray *MsgArr;
@property(nonatomic,strong)NSMutableArray *activityItems;

@property(nonatomic,assign)NSInteger countString;
@property(nonatomic,copy)NSString *imageString;
@property(nonatomic,copy)NSString *titleLabel;
@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,copy)NSString *invateCode;
@property(nonatomic,strong)NSTimer *timerAnn;
@property(nonatomic,strong)dispatch_source_t timer;
@property(nonatomic,assign)int ID;
@property(nonatomic,assign)int tolPage;
@property(nonatomic,assign)BOOL isSecondaryPages;//二级页面不允许再点击头像进个人中心
@property(nonatomic,strong)GKDYBaseViewController *pushVC;

@end

@implementation ZFDouYinViewController

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    ZFDouYinViewController *vc = ZFDouYinViewController.new;

    NSLog(@"vc.dataSource = %@",vc.dataSource);
    NSLog(@"vc.urls = %@",vc.urls);
    NSLog(@"vc.indexPathRow = %ld",(long)vc.indexPathRow);
    NSLog(@"vc.indexPathSection = %ld",(long)vc.indexPathSection);

    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.dataSource = requestParams[@"model"];//需要 self.dataSource<CommonModel *>  实际是GKDYVideoModel
    vc.urls = requestParams[@"url"];//需要 self.urls<NSURL *>
    vc.pushVC = requestParams[@"VC"];
    //定位数据 videoUrlPng
    vc.indexPathRow = [requestParams[@"indexRow"] integerValue];
    vc.indexPathSection = [requestParams[@"indexSection"] integerValue];
    //需要 self.userIds<CommonModel *userId>  —— 没有
    vc.isSecondaryPages = YES;//是二级页面
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

-(instancetype)init{
    if (self = [super init]) {
        self.currentIndex = 0;
        self.isFirstRequestData = NO;
        self.isPullToRefresh = NO;
        self.isSecondaryPages = NO;//不是二级页面
        self.pageNum = 1;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    [self setupView];
    [self NSNotification];
    self.fd_prefersNavigationBarHidden = YES;//??
}

-(void)viewWillAppear:(BOOL)animated{//再次进页面会走 viewWillAppear
    [super viewWillAppear:animated];
    if (self.isSecondaryPages) {//是二级页面
        self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
        //透明
        self.gk_navigationBar.hidden = !self.isSecondaryPages;
    }else{//不是二级页面
        self.gk_navigationBar.hidden = self.isSecondaryPages;
    }
    self.gk_navLineHidden = YES;
    self.gk_navBackgroundColor = kClearColor;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
}

#pragma mark —— JXCategoryListContentViewDelegate
/**
 可选实现，列表显示的时候调用

 ——第一次进此页面，只会走listDidAppear，而不会走viewWillAppear
 ——第二次进此页面，也会走listDidAppear，但是会走viewWillAppear
 */
- (void)listDidAppear{
    NSLog(@"开始播放此页视频");
    self.tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
    self.userString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ? : @"";
    [self findAvailableResourceAndPlay];//优先本地读取 KKK
    if (self.isSecondaryPages) {//是二级页面
        self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
        //透明
        self.gk_navigationBar.hidden = !self.isSecondaryPages;
    }else{//不是二级页面
        self.gk_navigationBar.hidden = self.isSecondaryPages;
    }
    self.gk_navLineHidden = YES;
    self.gk_navBackgroundColor = kClearColor;
    tabBarVC.tabBar.hidden = self.isPush;
    [self.player playTheIndex:self.currentIndex];//退回自动播放之前的
    //关键代码
//    [self.tableView selectRowAtIndexPath:indexPath
//                                animated:YES
//                          scrollPosition:UITableViewScrollPositionTop];

//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex
//                                                            inSection:0]
//                                animated:YES
//                          scrollPosition:UITableViewScrollPositionTop];
}
/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear{
    NSLog(@"停止播放此页视频");
    [self.player stop];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return _player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    if (_commentVC) {
        [self dissmissCommentVC];
    }
}

-(void)dissmissCommentVC{
    @weakify(self);
    [UIView animateWithDuration:0.25f
                     animations:^{
                         @strongify(self)
                         self->_commentVC.view.mj_y = SCREEN_HEIGHT;
                         tabBarVC.tabBar.hidden = NO;//显示 LZTabBarVC
                     }
                     completion:^(BOOL finished) {
                         @strongify(self)
                         self->_commentVC = Nil;
                     }];
}

- (void)setupView {
    if (self.dataSource.count > 0) {//从其他类（页面）push过来的
//        有且只有一个数据
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.indexPathRow
                                                    inSection:self.indexPathSection];
        [self playTheVideoAtIndexPath:indexPath
                          scrollToTop:NO];
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)NSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendMessageSocketModel:)
                                                 name:@"SocketMessage"
                                               object:nil];
}

- (void)doRotateAction:(NSNotification *)notification {
    self.bl_shouldAutoLandscape = NO;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait ||
        [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        [self.player enterFullScreen:NO
                            animated:NO];

    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
               [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        DLog(@"首页监听到横屏");
        [kAPPWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj,
                                                          NSUInteger idx,
                                                          BOOL * _Nonnull stop) {
            UIView *viewH = kAPPWindow.subviews[2];
            viewH.hidden = NO;
            UIView *viewHBackgroud = kAPPWindow.subviews[4];
            viewHBackgroud.hidden = NO;
        }];
        [self.player enterFullScreen:YES
                            animated:NO];
    }
}

-(void)sendMessageSocketModel:(NSNotification *)model {
    MessageModel *modelMsg = [model object];
    if (IS_IPHONE_X == YES ||
        IS_IPHONE_Xr == YES ||
        IS_IPHONE_Xs == YES ||
        IS_IPHONE_Xs_Max == YES) {
        heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812.0f : 896.0f;
        widthAll = IS_IPHONE_X || IS_IPHONE_Xs ? 375.0f : 414.0f;
    } else if (kiPhone6Plus) {
        heightAll = 736.0f;
        widthAll = 414.0f;
    } else {
        widthAll  = kiPhone5 ? 320.0f : 375.0f;
        heightAll = kiPhone5 ? 568.0f : 667.0f;
    }
    self.backgroud.hidden = NO;
    self.imageAnnouncement.alpha = 1;
    [self.backgroud addSubview:self.imageAnnouncement];
    [self.MsgArr addObject:modelMsg.text];
    dispatch_queue_t queen = dispatch_get_global_queue(0, 0);
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(600.0 * NSEC_PER_SEC)),
                   queen, ^{
                       dispatch_async(dispatch_get_main_queue(), ^{
                           @strongify(self)
                           self.backgroud.hidden = YES;
                       });
                   });
}
#pragma mark ===================== 下拉刷新===================================
- (void)pullToRefresh {
    DLog(@"下拉刷新");
    self.isPullToRefresh = YES;
    [self.dataSource removeAllObjects];
    [self.urls removeAllObjects];
    self.pageNum = 1;
    if (self.pushVC) {
        if ([self.pushVC isKindOfClass:[MyProductsVC class]]) {
            MyProductsVC *vc = (MyProductsVC *)self.pushVC;
            [vc pullToRefresh];
        }else if([self.pushVC isKindOfClass:[MyDynamicVC class]]){
            MyDynamicVC *vc = (MyDynamicVC *)self.pushVC;
            [vc pullToRefresh];
        }else if ([self.pushVC isKindOfClass:[MyLikeVC class]]){
            MyLikeVC *vc = (MyLikeVC *)self.pushVC;
            [vc pullToRefresh];
        }
    }else{
        [self loadNewData];
    }
}
#pragma mark ===================== 上拉加载更多===================================
- (void)loadMoreRefresh {
    DLog(@"上拉加载更多");
    self.pageNum ++;
    if (self.pushVC) {
        if ([self.pushVC isKindOfClass:[MyProductsVC class]]) {
            MyProductsVC *vc = (MyProductsVC *)self.pushVC;
            [vc loadMoreRefresh];
        }else if([self.pushVC isKindOfClass:[MyDynamicVC class]]){
            MyDynamicVC *vc = (MyDynamicVC *)self.pushVC;
            [vc loadMoreRefresh];
        }else if ([self.pushVC isKindOfClass:[MyLikeVC class]]){
            MyLikeVC *vc = (MyLikeVC *)self.pushVC;
            [vc loadMoreRefresh];
        }
    }else{
        [self requestData];
    }
}

- (void)loadNewData {
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       @strongify(self)
                       // 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
                       [self->_player stopCurrentPlayingCell];
                       [self requestData];
                       [self.tableView reloadData];
                       [self findAvailableResourceAndPlay];
                   });
}

-(void)endRefreshing:(BOOL)refreshing{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.refreshBtn.hidden = refreshing;
    self.nonetLabel.hidden = refreshing;
    self.noNetImage.hidden = refreshing;
}

/// 找到可以播放的视频并播放
-(void)findAvailableResourceAndPlay{
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath
                          scrollToTop:NO];
    }];
}

//外部调用
- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath
                          scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据 tableView.footer 也可以
    if (index == self.dataSource.count - 1) {
        /// 加载下一页数据
        [self requestData];
        self.player.assetURLs = self.urls;
        [self.tableView reloadData];
    }
}

-(void)ad:(CommonModel *)model{
    NSLog(@"KKK = %@",model.advertUrl);

    if (![model.advertUrl isNullString]) {
        @weakify(self);
        self.controlView.showAdBlock = ^{
//            @strongify(self);
//            //App内部打开
//            [webVC pushFromVC:self_weak_
//                requestParams:model.advertUrl
//                      success:^(id  _Nonnull data) {
//                      }];
            //调用系统浏览器打开 标准写法
            if (@available(iOS 10.0, *)) {
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.advertUrl]
                                                       options:@{}
                                             completionHandler:^(BOOL success) {
                               }];
                           }
            }else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.advertUrl]];
        };
    }else {
        self.controlView.showAdBlock = NULL;
    }
}

#pragma mark ===================== 开始播放视频===================================
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath
                    scrollToTop:(BOOL)scrollToTop {
    NSLog(@"DDD = %ld",(long)indexPath.row);
    [self.player playTheIndexPath:indexPath
                      scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    CommonModel *model = self.dataSource[indexPath.row];
    [self ad:model];
    UIViewContentMode imageMode;
    if (SCREEN_WIDTH >= model.videoHeight) {
        imageMode = UIViewContentModeScaleAspectFit;
    } else {
        imageMode = UIViewContentModeScaleAspectFill;
    }

//    [self.tableView selectRowAtIndexPath:indexPath
//                                animated:YES
//                          scrollPosition:UITableViewScrollPositionTop];

//    [self.controlView showCoverViewWithUrl:[NSString stringWithFormat:@"%@%@",REQUEST_URL,model.videoUrlPng]
//                             withImageMode:imageMode];
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = (int)self.tableView.contentOffset.y / SCREEN_HEIGHT;
    NSLog(@"GGG self.currentIndex = %d",self.currentIndex);
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFDouYinCell *cell = [ZFDouYinCell cellWith:tableView];
    cell.backgroundColor = RandomColor;
    cell.delegate = self;
    cell.commonModel = self.dataSource[indexPath.row];
    cell.index = indexPath;
    [cell richElementsInCellWithModel:cell.commonModel
                     isSecondaryPages:self.isSecondaryPages];
    @weakify(cell)
    self.likeCountBlock = ^(int like) {
        @strongify(cell)
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.likeCount setAttributedText:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",like] ? :@""
                                                                                     attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold"
                                                                                                                                       size: 12],
                                                                                                  NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0
                                                                                                                                                  green:239/255.0
                                                                                                                                                   blue:239/255.0
                                                                                                                                                  alpha:1.0]}]];
        });
    };
    self.shareCountBlock = ^(int share) {
        @strongify(cell)
        cell.shareCountString = [NSString stringWithFormat:@"%d",share];
    };
    self.messageCountBlock = ^(int message) {
        @strongify(cell)
        cell.messageCountString = [NSString stringWithFormat:@"%d",message];
    };return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath
                      scrollToTop:NO];
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
}

#pragma mark - ZFTableViewCellDelegate
- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath
                      scrollToTop:NO];
}

#pragma mark —— VDCommentDelegate
- (void)upCommentId:(NSArray *)idArr {
    //     // 先判断有无存储账号信息
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){
        self.commentVC.idString = [idArr[0] intValue];
        self.commentVC.videoUserId = [idArr[1] intValue];
        @weakify(self)
        [UIView animateWithDuration:0.25f
                         animations:^{
                             @strongify(self)
                             self.commentVC.view.mj_y = SCREEN_HEIGHT - CommentViewHeight;
                         }];
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

- (void)focusOnAction:(UIButton *)action {
    // 先判断有无存储账号信息
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){ // 之前没有登录成功
        if (self.dataSource.count > 0) {
            self.commonModel = self.dataSource[self.currentIndex];
            extern HomeVC *homeVC;
#warning 如果用本类来push那么将会影响JXCategoryListContentViewDelegate，因为需要监听生命周期

//            PersonalCenterVC *vc = PersonalCenterVC.new;
//            vc.userId = self.userIds[self.currentIndex];
//            [rootVC pushViewController:vc
//                              animated:YES];
            @weakify(homeVC)
            [PersonalCenterVC pushFromVC:homeVC_weak_
                           requestParams:@{
                               @"userId":self.userIds[self.currentIndex],
                               @"byId":@""//self.commonModel

                               //[NSString stringWithFormat:@"%ld",(long)self.commonModel.userId],
//                               @"idString":[NSString stringWithFormat:@"%ld",(long)self.commonModel.ID]
                           }
                                 success:^(id  _Nonnull data) {

                }
                                animated:YES];
        }else return;
    } else {
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

#pragma mark —— 点击事件
- (void)backBtnClickEvent:(UIButton *)sender {
    [self.player stopCurrentPlayingCell];
    if (self.isPush &&
        !self.isPresent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (!self.isPush &&
              self.isPresent){
        tabBarVC.selectedIndex = 0;//跳到首页
        [self dismissViewControllerAnimated:YES
                                    completion:^{
            NSLog(@"1234");
        }];
    }
}

-(void)refreshAction:(UIButton *)sender {
     NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self requestData];
}

- (void)likeClickDelegate:(EmitterBtn *)click
                    Index:(NSInteger)index {
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){
        //        click.selected = !click.selected;//取消点赞
        click.selected = YES;//没有取消
        [self LikeNetWorking:click];
    }else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

- (void)shareClickDelegate:(UIButton *)sender {
    NSString *invateCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"inviteCode"];
    NSInteger userId = 0;
    // 先判断有无存储账号信息
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){// 登录成功
        if (self.dataSource.count > 0) {
            self.commonModel = self.dataSource[self.currentIndex];
            if (self.commonModel.videoUrl) {
                self.imageString = [NSString stringWithFormat:@"%@%@", REQUEST_URL,self.commonModel.videoUrlGif];
                self.urlString  =  [NSString stringWithFormat:@"%@/?inviteCode=%@&videoUrl=%@", INVITE_URL,invateCode,self.commonModel.videoUrl];
                self.titleLabel = self.commonModel.videoType;
                self.ID = (int)self.commonModel.ID;
                userId = self.commonModel.userId;
            }
        }
        //要分享的内容，加在一个数组里边，初始化UIActivityViewController
        NSString *titleVideo = [NSString stringWithFormat:@"%@%@",self.titleLabel,self.urlString];
        if (self.imageString &&
            self.urlString) {
            NSURL *url = [NSURL URLWithString:self.imageString];
            NSError *error = nil;
            NSData *dataImg = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe
                                                      error:&error];
            UIImage *image = [UIImage imageWithData:dataImg];
            NSURL *urlToShare = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlString]];

            if (image) {
                [self.activityItems addObject:urlToShare];
                [self.activityItems addObject:titleVideo];
                [self.activityItems addObject:image];
            }
            @weakify(self)
            self.activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType,
                                                           BOOL completed,
                                                           NSArray * _Nullable returnedItems,
                                                           NSError * _Nullable activityError) {
                NSLog(@"returnedItems = %@",returnedItems);
                @strongify(self)
                DLog(@"分享平台成功%@ == %@",returnedItems,activityType);
                if (completed){
                    DLog(@"分享成功");
                    [self shareNetWork:[NSString stringWithFormat:@"%d",self.ID]
                                userID:userId
                           platformNet:returnedItems.lastObject];//!!!!!!!!!!!!!!
                }else{
                    DLog(@"cancel");
                }
            };
            //Activity 类型又分为“操作”和“分享”两大类
            //     分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
            //    关闭系统的一些activity类型
            self.activityVC.excludedActivityTypes = @[];
            //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
            [self presentViewController:self.activityVC
                               animated:YES
                             completion:nil];
        }
    } else{
        // 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        _tableView.pagingEnabled = YES;//这个属性为YES会使得Tableview一格一格的翻动
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight=0 ;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        // 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            NSLog(@"开始播放视频:%ld",(long)indexPath.row);
            [self playTheVideoAtIndexPath:indexPath
                              scrollToTop:NO];
        };
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
    }return _tableView;
}

-(MJRefreshGifHeader *)tableViewHeader{
    if (!_tableViewHeader) {
        _tableViewHeader =  [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                       refreshingAction:@selector(pullToRefresh)];
        // 设置普通状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewHeader setTitle:@"Click or drag down to refresh" forState:MJRefreshStateIdle];
        [_tableViewHeader setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_tableViewHeader setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewHeader.stateLabel.textColor = KLightGrayColor;
    }return _tableViewHeader;
}

-(MJRefreshAutoGifFooter *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadMoreRefresh)];
        // 设置普通状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewFooter setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
        [_tableViewFooter setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_tableViewFooter setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewFooter.stateLabel.textColor = KLightGrayColor;
    }return _tableViewFooter;
}

-(ZFAVPlayerManager *)playerManager{
    if (!_playerManager) {
        _playerManager = ZFAVPlayerManager.new;
    }return _playerManager;
}

-(ZFPlayerController *)player{
    if (!_player) {
        _player = [ZFPlayerController playerWithScrollView:self.tableView
                                             playerManager:self.playerManager
                                          containerViewTag:100];
        _player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap |
        ZFPlayerDisableGestureTypesPan |
        ZFPlayerDisableGestureTypesPinch;
        _player.playerDisapperaPercent = 1.0;
        _player.controlView = self.controlView;
        _player.allowOrentitaionRotation = NO;
        _player.orientationObserver.supportInterfaceOrientation = ZFInterfaceOrientationMaskLandscape;
        _player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        _player.WWANAutoPlay = YES;
        _player.assetURLs = self.urls;
        @weakify(self)
        _player.playerDidToEnd = ^(id  _Nonnull asset) {
            @strongify(self)
            [self->_player.currentPlayerManager replay];
        };
        _player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
            @strongify(self)
            if (size.width >= size.height) {
                self->_player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
            } else {
                self->_player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
            }
        };
    }return _player;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = ZFDouYinControlView.new;
        @weakify(self)
        _controlView.dissmissCommentVC = ^{
            @strongify(self);
            [self dissmissCommentVC];
        };
//        _controlView.delegate = self;
    }return _controlView;
}

-(NSMutableArray<CommonModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = NSMutableArray.array;
    }return _dataSource;
}

-(NSMutableArray<NSURL *> *)urls{
    if (!_urls) {
        _urls = NSMutableArray.array;
    }return _urls;
}

-(NSMutableArray<NSString *> *)userIds{
    if (!_userIds) {
        _userIds = NSMutableArray.array;
    }return _userIds;
}

-(VDLoginViewController *)loginController{
    if (!_loginController) {
        _loginController = VDLoginViewController.new;
    }return _loginController;
}
/**
 创建分享视图控制器
 ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
 Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
 */
-(UIActivityViewController *)activityVC{
    if (!_activityVC) {
        _activityVC = [[UIActivityViewController alloc] initWithActivityItems:self.activityItems
                                                        applicationActivities:self.activities];
    }return _activityVC;
}

//自定义Activity
-(NSArray *)activities{
    if (!_activities) {
        _activities = NSArray.array;
    }return _activities;
}

-(CommentVC *)commentVC{
    if (!_commentVC) {
        _commentVC = CommentVC.new;
        CommentViewHeight = isiPhoneX_series() ? SCREEN_HEIGHT / 3 :  SCREEN_HEIGHT / 2;
        @weakify(self)
        [_commentVC actionBlock:^(id  _Nonnull data) {
            @strongify(self)
            self->_commentVC.view.frame = CGRectMake(0,
                                               SCREEN_HEIGHT,
                                               SCREEN_WIDTH,
                                               CommentViewHeight);
            [self.commentVC removeFromParentViewController];
            [self.commentVC.view removeFromSuperview];
            self.commentVC = Nil;
        }];
        _commentVC.view.frame = CGRectMake(0,
                                           SCREEN_HEIGHT,
                                           SCREEN_WIDTH,
                                           CommentViewHeight);
        [self.view addSubview:_commentVC.view];
    }return _commentVC;
}

-(UIView *)backgroud{
    if (!_backgroud) {
        _backgroud = UIView.new;
        _backgroud.backgroundColor = [UIColor colorWithRed:190/255.0
                                                     green:52/255.0
                                                      blue:98/255.0
                                                     alpha:0.5];
        [kAPPDelegate.window addSubview:_backgroud];
        [_backgroud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70/667.0f*self->heightAll);
            make.left.mas_equalTo(0/375.0f*self->widthAll);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(self->widthAll);
            make.height.mas_equalTo(20/667.0f*self->heightAll);
        }];
    }return _backgroud;
}

-(UIImageView *)imageAnnouncement{
    if (!_imageAnnouncement) {
        _imageAnnouncement = UIImageView.new;
        _imageAnnouncement.image = kIMG(@"图层 1");
        [self.backgroud addSubview:_imageAnnouncement];
        [_imageAnnouncement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.centerY.mas_equalTo(self.backgroud);
            make.width.mas_equalTo(20/375.0f*self->widthAll);
            make.height.mas_equalTo(15/667.0f*self->heightAll);
        }];
    }return _imageAnnouncement;
}

-(UILabel *)announcementLabel{
    if (!_announcementLabel) {
        _announcementLabel = UILabel.new;
        _announcementLabel.text = NSLocalizedString(@"VDgonggao", nil);
        _announcementLabel.textColor = [UIColor colorWithHexString:@"FFFC00"];
        _announcementLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.backgroud addSubview:_announcementLabel];
        [_announcementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageAnnouncement.mas_right).offset(8);
            make.centerY.mas_equalTo(self.imageAnnouncement.mas_centerY);
            //            make.width.mas_equalTo(36/375.0f*widthAll);
            make.height.mas_equalTo(16/667.0f*self->heightAll);
        }];
    }return _announcementLabel;
}

-(NSMutableArray *)MsgArr{
    if (!_MsgArr) {
        _MsgArr = NSMutableArray.array;
    }return _MsgArr;
}

-(NSMutableArray *)activityItems{
    if (!_activityItems) {
        _activityItems = NSMutableArray.array;
    }return _activityItems;
}

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = NSMutableDictionary.dictionary;
    }return _dict;
}







@end
