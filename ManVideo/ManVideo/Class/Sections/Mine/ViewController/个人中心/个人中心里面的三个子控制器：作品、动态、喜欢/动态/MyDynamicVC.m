//
//  GKDYDynamicController.m
//  Clipyeu ++
//
//  Created by Josee on 15/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MyDynamicVC.h"
#import "ZFDouYinViewController.h"
#import "DynamicTableCell.h"
#import "MyDynamicVC+VM.h"
extern LZTabBarVC *tabBarVC;
extern PersonalCenterVC *personalCenterVC;
extern UINavigationController *rootVC;

@interface MyDynamicVC ()
<UITableViewDataSource
,UITableViewDelegate>

@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)int totalPage;
@property(nonatomic,copy)void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation MyDynamicVC

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
//    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AFNReachability];
    rootVC.navigationBarHidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//- (void)listDidAppear{
//    NSLog(@"");
//}

//#pragma mark - GKPageListViewDelegate
//- (UIScrollView *)listScrollView {
//    return self.tableView;
//}
//
//- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
//    self.scrollCallback = callback;
//}

- (void)refreshData:(NSInteger)index {
    if (self.isRefresh) return;
    [self.tableView.mj_header beginRefreshing];
}

-(void)endRefreshing:(BOOL)refreshing{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.refreshBtn.hidden = refreshing;
    self.nonetLabel.hidden = refreshing;
    self.noNetImage.hidden = refreshing;
    self.noContent.hidden = refreshing;
}

-(void)loadMoreRefresh{
    self.page++;
    [self netWorkLoadData];
}

-(void)pullToRefresh{
    self.page = 1;
    [self.videoArr removeAllObjects];
    [self.urlsArr removeAllObjects];
    [self netWorkLoadData];
}

#pragma mark —— 点击事件
- (void)refreshAction:(UIButton *)sender {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ? : self.scrollCallback(scrollView);
}

#pragma mark —— UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALING_RATIO(375.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicTableCell" forIndexPath:indexPath];
    if (self.videoArr.count > 0) {
         cell.model = self.videoArr[indexPath.row];
    }
//    cell.indexPath = indexPath;
    cell.backgroundColor = [UIColor colorWithHexString:@"050013"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    @weakify(personalCenterVC)
    [ZFDouYinViewController pushFromVC:personalCenterVC_weak_
                         requestParams:@{
                                         @"indexRow":@(indexPath.row),
                                         @"indexSection":@(indexPath.section),
                                         @"model":self.videoArr,
                                         @"url":self.urlsArr,
                                         @"VC":self
                                         }
                               success:^(id  _Nonnull data) {}
                              animated:YES];
}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                   SCREEN_HEIGHT - Height_TabBar*3-20)
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
        [self.view addSubview:_tableView];
        //预估高度
        //    tableView.estimatedRowHeight = 200.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[DynamicTableCell class]
           forCellReuseIdentifier:@"DynamicTableCell"];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
    }return _tableView;
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



@end
