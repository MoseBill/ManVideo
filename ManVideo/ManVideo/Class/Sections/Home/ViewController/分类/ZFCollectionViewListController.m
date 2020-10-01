//
//  ZFCollectionViewListController.m
//  ZFPlayer_Example
//
//  Created by Josee on 2018/7/19.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import "ZFCollectionViewListController.h"
#import "ZFCollectionViewListController+VM.h"
#import "ZFCollectionViewCell.h"
#import "ZFDouYinViewController.h"
#import "EdwPlayerProgressView.h"
#import "EdwVideoLanternView.h"
#import "EdwVideoMusicView.h"
#import "EdwVideoSoundSlider.h"
#import "LMHWaterFallLayout.h"
#import "CommonModel.h"
#import "RecommendedModel.h"

extern LZTabBarVC *tabBarVC;

@interface ZFCollectionViewListController ()
<
UICollectionViewDelegate
,UICollectionViewDataSource
//,EdwVideoSoundSliderDelegate
//,JXCategoryListContentViewDelegate
,LMHWaterFallLayoutDeleaget
>{
    NSMutableArray * _attributeArray;
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)EdwVideoMusicView *musicView;
@property(nonatomic,strong)EdwPlayerProgressView *progressView;
@property(nonatomic,strong)EdwVideoSoundSlider *slider;
@property(nonatomic,strong)EdwVideoLanternView *lanternView;
@property(nonatomic,strong)LMHWaterFallLayout *waterFallLayout;

@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int totalPage;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSMutableArray <NSURL *>*urls;
@property(nonatomic,strong)NSMutableArray <RecommendedModel *>*dataSource;
@property(nonatomic,copy)NSString *classificationString;
@property(nonatomic,copy)NSString *searchString;

@end

@implementation ZFCollectionViewListController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    ZFCollectionViewListController *vc = ZFCollectionViewListController.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.classificationString = requestParams;
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
        @weakify(self);
        self.UnknownNetWorking = ^{
            @strongify(self)
            self.refreshBtn.hidden = NO;
            self.nonetLabel.hidden = NO;
            self.noNetImage.hidden = NO;
        };
        self.NotReachableNetWorking = ^{
            @strongify(self)
            self.refreshBtn.hidden = NO;
            self.nonetLabel.hidden = NO;
            self.noNetImage.hidden = NO;
        };
        self.ReachableViaWWANNetWorking = ^{
            //        @strongify(self)
        };
        self.ReachableViaWiFiNetWorking = ^{
            //        @strongify(self)
        };
        self.isRequestFinish = NO;//刚进入界面是没有完成请求数据的
        self.page = 0;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];

    self.gk_navigationBar.hidden = YES;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;

    [self AFNReachability];
    [self setupView];
    //解决:Mj.header有一段距离显示出来
    self.view.bounds = CGRectMake(0,
                                  SCALING_RATIO(13),
                                  SCREEN_WIDTH,
                                  SCREEN_HEIGHT);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    tabBarVC.tabBar.hidden = NO;
}

#pragma mark —— JXCategoryListContentViewDelegate
/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear{
    NSLog(@"开始播放此页视频");
    tabBarVC.tabBar.hidden = NO;
}
/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear{
    NSLog(@"停止本页的");
}

- (void)setupView {
    self.collectionView.alpha = 1;
    if (self.classificationString) {
        self.gk_navTitle = self.classificationString;
        [self fuzzySearchLoadData:self.classificationString];
        self.backBtn.hidden = NO;
    } else {
        self.gk_navTitle =  NSLocalizedString(@"VDclassification", nil);
        [self.collectionView.mj_header beginRefreshing];
        self.backBtn.hidden = YES;
    }
}

#pragma mark ===================== 下拉刷新===================================
- (void)pullToRefresh {
    DLog(@"下拉刷新");
    self.isRequestFinish = YES;
//    self.page = 1;
       self.page++;
    if (self.classificationString) {
        [self fuzzySearchLoadData:self.classificationString];
    } else {
        [self.dataSource removeAllObjects];
        [self.urls removeAllObjects];
        [self requestData];
    }
}

#pragma mark ===================== 上拉加载更多===================================
- (void)loadMoreRefresh {
    NSLog(@"上拉加载更多");
//    self.isRequestFinish = NO;
    self.page++;
    if (self.classificationString) {
        [self fuzzySearchLoadData:self.classificationString];
    } else {
        [self requestData];
    }
}

#pragma mark —— 点击事件
- (void)backBtnClickEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshAction:(UIButton *)sender {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self requestData];
}

#pragma mark =====================网络请求 —— 模糊查询===================================
- (void)fuzzySearchLoadData:(NSString *)searchObject {
    int size = 18;
    NSMutableDictionary *dict = NSMutableDictionary.dictionary;
    dict[@"title"] = searchObject;
    dict[@"pageSize"] = @(size);
    dict[@"pageNum"] = @(self.page);
    DLog(@"模糊查询%@",dict);
    
    [CMRequest requestNetSecurityGET:@"/videoUploading/vagueList"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
                            NSArray *array = [RecommendedModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
                            if (array) {
                                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                                    NSUInteger idx,
                                                                    BOOL * _Nonnull stop) {
                                    RecommendedModel *model = array[idx];
                                    [self.dataSource addObject:model];
                                    if (model.videoUrl) {
                                        NSString *noPasswordUrl = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.videoUrl];
                                        NSURL *url =  [NSURL URLWithString:noPasswordUrl];
                                        [self.urls addObject:url];
                                    }
                                }];
                            } else return;
                            [self.collectionView reloadData];
                            [self.collectionView.mj_header endRefreshing];
                            [self.collectionView.mj_footer endRefreshing];
                            DLog(@"模糊查询%@",dict);
    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"模糊查询%@",message);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } failBlock:^(NSError * _Nonnull error) {
        DLog(@"模糊查询%@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
        self.refreshBtn.hidden = NO;
        self.nonetLabel.hidden = NO;
        self.noNetImage.hidden = NO;
    }];
}

- (void)requestData {
    NSMutableDictionary *dict = NSMutableDictionary.dictionary;
    int num = self.page;
    int size = 18;
    dict[@"pageNum"] = [NSNumber numberWithInt:num];;
    dict[@"pageSize"] = [NSNumber numberWithInt:size];;
    @weakify(self)
    [CMRequest requestNetSecurityGET:@"/videoUploading/popular"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
                            @strongify(self)
                            self.collectionView.hidden = NO;

                            NSArray *array = [RecommendedModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                            if (array) {
                                NSSet *set = [NSSet setWithArray:array];
                                NSArray *setArray = [set allObjects];
                                @weakify(self)
                                [setArray enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                                       NSUInteger idx,
                                                                       BOOL * _Nonnull stop) {
                                    @strongify(self)
                                    RecommendedModel *recommend = setArray[idx];
                                    [self.dataSource addObject:recommend];
                                    if (recommend.videoUrl) {
                                        NSString *noPasswordUrl = [NSString stringWithFormat:@"%@%@",REQUEST_URL,recommend.videoUrl];
                                        NSURL *url = [NSURL URLWithString:noPasswordUrl];
                                        [self.urls addObject:url];
                                    }
                                }];
                            } else return;
                            [self.collectionView reloadData];
                            [self.collectionView.mj_header endRefreshing];
                            [self.collectionView.mj_footer endRefreshing];
        } errorBlock:^(NSString * _Nonnull message) {
            @strongify(self)
            DLog(@"参数错误");
//              self.collectionView.hidden = YES;
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        } failBlock:^(NSError * _Nonnull error) {
             @strongify(self)
//            self.collectionView.hidden = YES;
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
            self.refreshBtn.hidden = NO;
            self.nonetLabel.hidden = NO;
            self.noNetImage.hidden = NO;
        }];
}
#pragma mark  - <LMHWaterFallLayoutDeleaget>
- (CGFloat)waterFallLayout:(LMHWaterFallLayout *)waterFallLayout
  heightForItemAtIndexPath:(NSUInteger)indexPath
                 itemWidth:(CGFloat)itemWidth{
    switch (indexPath % 2) {
        case 0:{
            return SCALING_RATIO(389.f);
        }
            break;
        case 1:{
            return SCALING_RATIO(320.0f);
        }
            break;
        default:
            return 0.0f;
            break;
    }
}

- (CGFloat)rowMarginInWaterFallLayout:(LMHWaterFallLayout *)waterFallLayout{
    return SCALING_RATIO(20);
}

- (NSUInteger)columnCountInWaterFallLayout:(LMHWaterFallLayout *)waterFallLayout{
    return 2;
}

#pragma mark —— UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self.collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = self.dataSource.count == 0;
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier
                                                                           forIndexPath:indexPath];
    NSLog(@"BBB = %ld",indexPath.row);
    if (self.dataSource.count > 0) {
        [cell setCommonModel:self.dataSource[indexPath.row]
                      andTag:indexPath];
    }return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.item = %ld",indexPath.item);
    NSLog(@"self.dataSource[indexPath.item] = %@",self.dataSource[indexPath.item]);
    self.indexPath = indexPath;
    if (self.indexPath.row < self.dataSource.count) {
#warning 如果用本类来push那么将会影响JXCategoryListContentViewDelegate，因为需要监听生命周期
        extern HomeVC *homeVC;
        @weakify(homeVC)
        [ZFDouYinViewController pushFromVC:homeVC_weak_
                             requestParams:@{
                                             @"indexRow":@(indexPath.row),
                                             @"indexSection":@(indexPath.section),
                                             @"model":self.dataSource,
                                             @"url":self.urls
                                             }
                                   success:^(id  _Nonnull data) {
                                   }
                                  animated:YES];
    }
}

#pragma mark —— lazyLoad
-(LMHWaterFallLayout *)waterFallLayout{
    if (!_waterFallLayout) {
        _waterFallLayout = LMHWaterFallLayout.new;
        _waterFallLayout.delegate = self;
    }return _waterFallLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             SCREEN_WIDTH,
                                                                             SCREEN_HEIGHT - Height_TabBar)
                                             collectionViewLayout:self.waterFallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        [_collectionView registerClass:[ZFCollectionViewCell class]
            forCellWithReuseIdentifier:ReuseIdentifier];
        [self.view addSubview:_collectionView];
        if ([_collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
            if (@available(iOS 10.0, *)) {
                _collectionView.prefetchingEnabled = NO;
            } else {
                // Fallback on earlier versions
            }
        }
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(pullToRefresh)];
//        _collectionView.mj_header.backgroundColor = KYellowColor;
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(loadMoreRefresh)];
//        _collectionView.mj_footer.backgroundColor = kRedColor;
        _collectionView.mj_footer.hidden = YES;
    }return _collectionView;
}

-(NSMutableArray<RecommendedModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = NSMutableArray.array;
    }return _dataSource;
}

-(NSMutableArray<NSURL *> *)urls{
    if (!_urls) {
        _urls = NSMutableArray.array;
    }return _urls;
}

@end
