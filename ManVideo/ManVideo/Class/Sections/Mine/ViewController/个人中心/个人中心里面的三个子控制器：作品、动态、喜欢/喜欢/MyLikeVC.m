//
//  GKDYListViewController.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "MyLikeVC.h"
#import "GKDYListCollectionViewCell.h"
#import "ZFDouYinViewController.h"
#import "MyLikeVC+VM.h"
//#import "GKDYPlayerViewController.h"
extern LZTabBarVC *tabBarVC;
extern PersonalCenterVC *personalCenterVC;
extern UINavigationController *rootVC;

@interface MyLikeVC ()
<UICollectionViewDataSource
,UICollectionViewDelegate>

@property(nonatomic,strong)MJRefreshAutoGifFooter *collectionViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *collectionViewHeader;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;

@property(nonatomic,assign)int totalPage;
@property(nonatomic,strong)NSNumber *num;
@property(nonatomic,strong)NSMutableArray *likeArr;
@property(nonatomic,strong)NSMutableArray *worksArr;
@property(nonatomic,copy)void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation MyLikeVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(instancetype)initWithRequestParams:(id _Nullable)requestParams{
    if (self = [super init]) {
        //        GKDYVideoModel;
        //        @weakify(self);
        self.UnknownNetWorking = ^{
            //            @strongify(self)
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"videosNotification"
//                                                                object:@"有值"];
        };
        self.NotReachableNetWorking = ^{
            //            @strongify(self)
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"videosNotification"
//                                                                object:@"有值"];
        };
        self.ReachableViaWWANNetWorking = ^{
            //            @strongify(self)
        };
        self.ReachableViaWiFiNetWorking = ^{
            //            @strongify(self)
        };
        self.isRequestFinish = NO;//刚进入界面是没有完成请求数据的
        self.page = 0;
//        self.tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
        self.userIdString = requestParams;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
//    self.gk_navigationBar.backgroundColor = kClearColor;
//    self.gk_navTintColor = kClearColor;
//    self.gk_navTitleColor = kClearColor;
//    self.gk_navBarTintColor = kClearColor;
    [self.collectionView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AFNReachability];
    rootVC.navigationBarHidden = YES;
//    [self.collectionView.mj_header beginRefreshing];
}

//-(void)NSNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(clickActionNoti:)
//                                                 name:@"clickActionNotification"
//                                               object:nil];
//}

#pragma mark - GKPageListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

//#pragma mark ===================== 通知===================================
//- (void)clickActionNoti:(NSNotification *)noti {
//    NSInteger index = [[noti object] integerValue];
//    self.page = 1;
//    if (index == 1) {
//    } else [self pullToRefresh];
//}
#pragma mark ===================== 下拉刷新===================================
- (void)pullToRefresh {
    DLog(@"下拉刷新");
    [self.videoArr removeAllObjects];
    [self.urlsArr removeAllObjects];
    [self loadLikeData];
//    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark ===================== 上拉加载更多===================================
- (void)loadMoreRefresh {
    DLog(@"上拉加载更多");
    self.page++;
//    [self loadLikeData];
}

- (void)refreshNetworkData:(NSInteger)index {
    DLog(@"点击%ld",(long)index);
    if (index == 2) {
        [self pullToRefresh];
    }
}

-(void)endRefreshing:(BOOL)refreshing{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    if (refreshing) {
        self.refreshBtn.hidden = refreshing;
        self.nonetLabel.hidden = refreshing;
        self.noNetImage.hidden = refreshing;
    }
}

- (void)refreshData:(NSInteger)index {
    [self.likeArr removeAllObjects];
    [self.videoArr removeAllObjects];
    [self.urlsArr removeAllObjects];
    [self.worksArr removeAllObjects];
    if (self.isRefresh) return;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark —— 点击事件
- (void)refreshAction:(UIButton *)sender {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self pullToRefresh];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
         return self.videoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GKDYListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GKDYListCollectionViewCell"
                                                                                 forIndexPath:indexPath];
    if (self.videoArr.count > 0) {
        cell.model = self.videoArr[indexPath.row];
        cell.indexPath = indexPath;
        [cell taskImageToCell:cell
                       andTag:indexPath];
    }return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(tabBarVC)
    [ZFDouYinViewController pushFromVC:tabBarVC_weak_
                         requestParams:@{
                                         @"indexRow":@(indexPath.row),
                                         @"indexSection":@(indexPath.section),
                                         @"model":self.videoArr,
                                         @"url":self.urlsArr,
                                         @"VC":self
                                         }
                               success:^(id  _Nonnull data) {
                               }
                              animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ? : self.scrollCallback(scrollView);
}

#pragma mark - lazyLoad
-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = UICollectionViewFlowLayout.new;
        CGFloat width = (SCREEN_WIDTH - 5) / 3;
        _layout.itemSize = CGSizeMake(width, 170);
        _layout.minimumLineSpacing = 3.0f;
        _layout.minimumInteritemSpacing = 0.0f;
    }return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             5,
                                                                             SCREEN_WIDTH,
                                                                             SCREEN_HEIGHT-Height_TabBar*3-20)
                                             collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        [_collectionView registerClass:[GKDYListCollectionViewCell class]
            forCellWithReuseIdentifier:@"GKDYListCollectionViewCell"];
        _collectionView.mj_header = self.collectionViewHeader;
        _collectionView.mj_footer = self.collectionViewFooter;
        _collectionView.mj_footer.hidden = YES;
        [self.view addSubview:self.collectionView];
    }return _collectionView;
}

-(MJRefreshGifHeader *)collectionViewHeader{
    if (!_collectionViewHeader) {
        _collectionViewHeader =  [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                          refreshingAction:@selector(pullToRefresh)];
        // 设置普通状态的动画图片
        [_collectionViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_collectionViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_collectionViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_collectionViewHeader setTitle:@"Click or drag down to refresh" forState:MJRefreshStateIdle];
        [_collectionViewHeader setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_collectionViewHeader setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _collectionViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _collectionViewHeader.stateLabel.textColor = KLightGrayColor;
    }return _collectionViewHeader;
}

-(MJRefreshAutoGifFooter *)collectionViewFooter{
    if (!_collectionViewFooter) {
        _collectionViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                             refreshingAction:@selector(loadMoreRefresh)];
        // 设置普通状态的动画图片
        [_collectionViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_collectionViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_collectionViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_collectionViewFooter setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
        [_collectionViewFooter setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_collectionViewFooter setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _collectionViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _collectionViewFooter.stateLabel.textColor = KLightGrayColor;
    }return _collectionViewFooter;
}

-(NSMutableArray<NSURL *> *)urlsArr{
    if (!_urlsArr) {
        _urlsArr = NSMutableArray.array;
    }return _urlsArr;
}

-(NSMutableArray<GKDYVideoModel *> *)videoArr{
    if (!_videoArr) {
        _videoArr = NSMutableArray.array;
    }return _videoArr;
}

- (NSMutableArray *)likeArr {
    if (!_likeArr) {
        _likeArr = NSMutableArray.array;
    }return _likeArr;
}

- (NSMutableArray *)worksArr {
    if (!_worksArr) {
        _worksArr = NSMutableArray.array;
    }return _worksArr;
}

@end
