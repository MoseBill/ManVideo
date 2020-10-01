//
//  GKDYWorksController.m
//  Clipyeu ++
//
//  Created by Josee on 06/06/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MyProductsVC.h"
#import "GKDYListCollectionViewCell.h"
#import "ZFDouYinViewController.h"
#import "MyProductsVC+VM.h"
extern LZTabBarVC *tabBarVC;
extern PersonalCenterVC *personalCenterVC;
extern UINavigationController *rootVC;

@interface MyProductsVC ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,strong)MJRefreshAutoGifFooter *collectionViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *collectionViewHeader;

@property(nonatomic,strong)NSMutableArray *likeArr;
@property(nonatomic,strong)NSMutableArray *worksArr;
@property(nonatomic,strong)NSNumber *num;

@property(nonatomic,assign)int totalPage;
@property(nonatomic,assign)int likeTotal;
@property(nonatomic,copy)void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation MyProductsVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithRequestParams:(id _Nullable)requestParams{
    if (self = [super init]) {
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
        self.userIdString = requestParams[@"userId"];
        self.byId = requestParams[@"byId"];
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
//    self.gk_navigationBar.backgroundColor = kClearColor;
    self.noContent.alpha = 1;
    [self.collectionView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AFNReachability];
    rootVC.navigationBarHidden = YES;
}

#pragma mark - GKPageListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark ===================== 下拉刷新===================================
- (void)pullToRefresh {
    [self.videos removeAllObjects];
    [self.urlsArr removeAllObjects];
    [self loadDataView];
}
#pragma mark ===================== 上拉加载更多===================================
- (void)loadMoreRefresh {
    self.page++;
    [self loadDataView];
}

-(void)endRefreshing:(BOOL)refreshing{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    self.refreshBtn.hidden = refreshing;
    self.nonetLabel.hidden = refreshing;
    self.noNetImage.hidden = refreshing;
    self.noContent.hidden = refreshing;
}

- (void)refreshNetworkData:(NSInteger)index {
    if (index == 2) {
    } else if (index == 0){
         [self.collectionView.mj_header beginRefreshing];
    }
}

#pragma mark —— 点击事件
- (void)refreshAction:(UIButton *)sender {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self pullToRefresh];
}

- (void)refreshData:(NSInteger)index {
    if (self.isRefresh) return;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GKDYListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GKDYListCollectionViewCell"
                                                                                 forIndexPath:indexPath];
    if (self.videos.count > 0) {
        cell.model = self.videos[indexPath.row];
        cell.indexPath = indexPath;
        [cell taskImageToCell:cell
                       andTag:indexPath];
    }return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"KKK1 = %@",personalCenterVC.navigationController);
//    NSLog(@"KKK2 = %@",personalCenterVC);

    @weakify(tabBarVC)
    [ZFDouYinViewController pushFromVC:tabBarVC_weak_
                         requestParams:@{
                                         @"indexRow":@(indexPath.row),
                                         @"indexSection":@(indexPath.section),
                                         @"model":self.videos,
                                         @"url":self.urlsArr,
                                         @"VC":self
                                         }
                               success:^(id _Nonnull data) {}
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
        _layout.itemSize = CGSizeMake((SCREEN_WIDTH - 5) / 3, 170);
        _layout.minimumLineSpacing = 3.0f;
        _layout.minimumInteritemSpacing = 0.0f;
    }return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             5,
                                                                             SCREEN_WIDTH,
                                                                             SCREEN_HEIGHT - Height_TabBar * 3 - 20)
                                             collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        [_collectionView registerClass:[GKDYListCollectionViewCell class]
            forCellWithReuseIdentifier:@"GKDYListCollectionViewCell"];
        _collectionView.mj_footer = self.collectionViewFooter;
        _collectionView.mj_header = self.collectionViewHeader;
        _collectionView.mj_footer.hidden = YES;
         [self.view addSubview:_collectionView];
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

-(NSMutableArray<GKDYVideoModel *> *)videos{
    if (!_videos) {
        _videos = NSMutableArray.array;
    }return _videos;
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

#pragma mark —— 疑似被遗弃的
//- (void)loadDataViewCenter {
//
//    if (self.page == 1) {
//        [self.videos removeAllObjects];
//        [self.urlsArr removeAllObjects];
//    }
//    //    GKDYPersonalViewController *personal = [[GKDYPersonalViewController alloc]init];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *userString = [user objectForKey:@"userId"];
//      NSString *token = [user objectForKey:@"token"];
//    @weakify(self)
//    NSNumber *num;
//    if (self.userIdString.length != 0) {
//        int userId = [self.userIdString intValue];
//        num  = [NSNumber numberWithInt:userId];
//    } else {
//        int userId = [userString intValue];
//        num  = [NSNumber numberWithInt:userId];
//    }
//
//    if (self.totalPage != 0) {
//        if (self.page > self.totalPage) {
//            return;
//        }
//    }
//    int type = 1;
//    NSNumber *typeNum = [NSNumber numberWithInt:type];
//    int pageSize = 18;
//    NSNumber *page = [NSNumber numberWithInt:self.page];
//    NSNumber *size = [NSNumber numberWithInt:pageSize];
//    NSDictionary *dict = @{@"userId":num,@"typeNew":typeNum,@"pageNum":page,@"pageSize":size,@"token":token};
//    DLog(@"个人作品请求参数%@",dict);
//    //    @weakify(self)
//    [CMRequest requestNetSecurityGET:@"/member/works" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
//        @strongify(self)
//        self.totalPage = [dict[@"data"][@"totalPage"] intValue];
//        DLog(@"个人作品数据%@",dict);
//        self.refreshBtn.hidden = YES;
//        self.nonetLabel.hidden = YES;
//        self.noNetImage.hidden = YES;
//        NSArray *array = [GKDYVideoModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
//
//        for (int i =0; i < array.count; i++) {
//            GKDYVideoModel *model = array[i];
//            [self.videos addObject:model];
//            NSString *signstr=@"Kef9lkpzEBQD8WSged";
//            NSString *md5String = [NSString stringWithFormat:@"%@%@",model.videoUrl,signstr];
//            NSString *signUrl =[self md5:md5String];
//            NSString *imageString = [NSString stringWithFormat:@"%@%@?secretKeyStr=%@",REQUEST_URL,model.videoUrl,signUrl];
//            DLog(@"播放地址%@",imageString);
//            NSURL *url = [NSURL URLWithString:imageString];
//            [self.urlsArr addObject:url];
//        }
//        if (self.urlsArr.count  == 0) {
//            self.noContent.hidden = NO;
//        } else {
//            self.noContent.hidden = YES;
//        }
//        self.isRefresh = YES;
//        [self.collectionView reloadData];
//        [self.collectionView.mj_header endRefreshing];
//
//        if (self.videos) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"videosNotification" object:@"有值"];
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"videosNotification" object:@"无值"];
//        }
//        DLog(@"个人作品%@",self.videos);
//    } errorBlock:^(NSString * _Nonnull message) {
//        DLog(@"参数错误");
//        if (self.pageListBlock) {
//            self.pageListBlock(@"参数错误");
//        }
//        [self.collectionView.mj_header endRefreshing];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"videosNotification" object:@"有值"];
//    } failBlock:^(NSError * _Nonnull error) {
//        if (self.pageListBlock) {
//            self.pageListBlock(@"网络异常");
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"videosNotification" object:@"有值"];
//        ShowMessage(NSLocalizedString(@"VDNoNetwork", nil));
//        [self.collectionView.mj_header endRefreshing];
//        self.refreshBtn.hidden = NO;
//        self.nonetLabel.hidden = NO;
//        self.noNetImage.hidden = NO;
//    }];
//
//}

//- (void)timerMethod{
//    //不干任何事情!
//}

//- (void)netWorkData {
//    @weakify(self)
//
//    // 下拉刷新
//    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self)
//                self.page = 1;
//
//
//
//        // 结束刷新
//        [self.collectionView.mj_header endRefreshing];
//    }];
//    [self.collectionView.mj_header beginRefreshing];
//
//    // 上拉刷新
//    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                self.page++;
//
//        if (self.indexType == 2) {
//            [self loadLikeData];
//        } else {
//            [self loadDataView];
//        }
//
//        //        // 结束刷新
//        [self.collectionView.mj_footer endRefreshing];
//    }];
//    // 默认先隐藏footer
//    self.collectionView.mj_footer.hidden = YES;
//}

@end


