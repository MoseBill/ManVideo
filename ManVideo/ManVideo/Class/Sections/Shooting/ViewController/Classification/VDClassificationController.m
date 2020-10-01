//
//  VDClassificationController.m
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//
#import "VDClassificationController.h"
#import "ClassCollectionTBVCell.h"
#import "LGLSearchBar.h"
#import "ZFCollectionViewListController.h"
#import "PYSearchViewController.h"
#import "PYSearch.h"
#import "TPLChooseCell.h"
#import "HXTagsCell.h"
#import "ZFDouYinViewController.h"
#import "VDClassificationController+VM.h"

typedef void(^FinishNetwork)(void);

@interface VDClassificationController ()
<
UITableViewDelegate
,UITableViewDataSource
//,UICollectionViewDelegate
//,UICollectionViewDataSource
,PYSearchViewControllerDelegate
,PYSearchViewControllerDelegate
,VDClassCollectionDelegate
>
{
    HXTagsCell *cell;
}

//@property(nonatomic,strong)UICollectionView *collectionV;
//@property(nonatomic,strong)UICollectionView *chooseView;

@property(nonatomic,strong)UILabel *titleView;
@property(nonatomic,strong)UILabel *classLabel;
@property(nonatomic,strong)UILabel *labelHot;
@property(nonatomic,strong)UIView *backgroudView;
@property(nonatomic,strong)UIView *backgroudSearch;
@property(nonatomic,strong)UIView *logoView;
@property(nonatomic,strong)UIView *tableHeadView;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)PYSearchViewController *searchViewController;
@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;
@property(nonatomic,strong)HXTagCollectionViewFlowLayout *layout;

@property(nonatomic,strong)NSMutableArray *TaskMarr;//存放任务的数组
@property(nonatomic,strong)NSMutableArray <NSURL *>*urlArr;
@property(nonatomic,strong)NSMutableArray *videoArr;
@property(nonatomic,strong)NSMutableArray *selectedTags;
@property(nonatomic,strong)NSMutableArray *searchSuggestionsM;

@property(nonatomic,strong)NSArray *selectTags;
@property(nonatomic,strong)NSArray *dataArr;


@end

@implementation VDClassificationController

-(instancetype)init{
    if (self = [super init]) {
        @weakify(self);
        self.UnknownNetWorking = ^{
            //            @strongify(self)
        };
        self.NotReachableNetWorking = ^{
            //            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
        };
        self.ReachableViaWWANNetWorking = ^{
            @strongify(self)
            [self netWorkLoadData];
        };
        self.ReachableViaWiFiNetWorking = ^{
            @strongify(self)
            [self netWorkLoadData];
        };
        self.isRequestFinish = NO;//刚进入界面是没有完成请求数据的
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.page = 0;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.alpha = 1;
    self.backgroudSearch.alpha = 1;
    self.imageView.alpha = 1;
    self.classLabel.alpha = 1;
    self.backgroudView.alpha = 1;
    self.tableView.alpha = 1;
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor,
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self AFNReachability];
    extern LZTabBarVC *tabBarVC;
    tabBarVC.tabBar.hidden = NO;//显示 LZTabBarVC
}

//下拉刷新
- (void)pullToRefresh {
    [self.sectionDataMutArr removeAllObjects];
    [self.videoArr removeAllObjects];
    [self.labelArr removeAllObjects];
    [self.valueArr removeAllObjects];
    [self netWorkLoadData];
}

#pragma mark —— 存取请求的数据
-(void)storageDataToFMDB{

}

-(void)getDataFromFMDB{

}

-(void)endRefreshing:(BOOL)refreshing{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.refreshBtn.hidden = refreshing;
    self.nonetLabel.hidden = refreshing;
    self.noNetImage.hidden = refreshing;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.classTotalDatamutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassCollectionTBVCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[ClassCollectionTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:ReuseIdentifier];
    }
    cell.backgroundColor = kClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
    cell.delegate = self;
    cell.row = indexPath.row;
    cell.section = indexPath.section;

    if (self.classTotalDatamutArr > 0) {
        ClassTotalDataModel *classTotalDataModel = self.classTotalDatamutArr[indexPath.section];
        cell.classTotalDataModel = classTotalDataModel;
    }

    if ([self.sectionDataMutArr[indexPath.section] count] > 0) {
        cell.rowDataMutArr = self.sectionDataMutArr[indexPath.section];
    }

    if (self.sectionDataMutArr.count > 0) {
        cell.videoArr = self.videoUrlSectionMutArr[indexPath.section];
    }

    if (indexPath.section == 0) {
        cell.colorView.backgroundColor = [UIColor colorWithHexString:@"DC4E61"];
    } else {
        cell.colorView.backgroundColor = [UIColor colorWithHexString:@"6F3DD8"];
    }return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALING_RATIO(210.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGFloat heightAll = isiPhoneX_series() ? 812.0f : 896.0f;
    cell = [[HXTagsCell alloc]initWithFrame:CGRectMake(0,
                                                       0,
                                                       SCREEN_WIDTH,
                                                       200 * 667.0f / heightAll)];
    if (self.labelArr.count >0) {
         cell.tags = self.labelArr;
    }
    cell.backgroundColor = kClearColor;
    cell.layout = self.layout;
    @weakify(self)
    cell.completion = ^(NSArray *selectTags,
                        NSInteger currentIndex) {
        @strongify(self);
        self.selectTags = selectTags;
        if (self.valueArr.count > 0) {
            [ZFCollectionViewListController pushFromVC:self_weak_
                                         requestParams:self.valueArr[currentIndex]
                                               success:^(id  _Nonnull data) {}
                                              animated:YES];
        }
    };
    [cell reloadData];
    self.logoView.alpha = 1;
    self.labelHot.alpha = 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.sectionDataMutArr.count - 1) {
        return kiPhone5 ? HEIGHT_SCREEN + 150 : HEIGHT_SCREEN;
    } else return 0;
}

#pragma mark —— 点击事件
- (void)searchBtnClick:(UIButton *)sender {
     [self.navigationController pushViewController:self.searchViewController
                                          animated:YES];
}

- (void)refreshAction:(UIButton *)sender {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self netWorkLoadData];
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)seachBar
                  searchText:(NSString *)searchText{
    if (searchText.length) {
        for (int i = 0; i < self.labelArr.count; i++) {
            NSString *searchSuggestion = [self.labelArr objectAtIndex:i];
            [self.searchSuggestionsM addObject:searchSuggestion];
        }
        searchViewController.searchSuggestions = self.searchSuggestionsM;
    }
}

//推到播放器页面进行播放
- (void)videoClickIndexPathRow:(NSInteger)row
              IndexPathSection:(NSInteger)section
                     actionArr:(NSMutableArray *)videoArr
                      modelArr:(NSMutableArray <ClassModel *>*)modelArr{
    for (int t = 0; t < videoArr.count; t++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VedioBaseUrl,videoArr[t]]];
        [self.urlArr addObject:url];
    }
    if (self.urlArr) {
        @weakify(self)
        [ZFDouYinViewController pushFromVC:self_weak_
                             requestParams:@{
                                             @"indexRow":@(row),
                                             @"indexSection":@(section),
                                             @"model":modelArr,
                                             @"url":self.urlArr
                                             }
                                   success:^(id  _Nonnull data) {
                                   }
                                  animated:YES];
    }
}



#pragma mark —— lazyLoad
- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = HXTagCollectionViewFlowLayout.new;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }return _layout;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =  kClearColor;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        [_tableView registerClass:[ClassCollectionTBVCell class]
           forCellReuseIdentifier:@"VDClassCollectionViewCell"];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        [self.backgroudView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.backgroudSearch.mas_bottom).offset(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT-Height_TabBar*2-30);
        }];
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
        [_tableViewHeader setTitle:@"Click or drag down to refresh"
                          forState:MJRefreshStateIdle];
        [_tableViewHeader setTitle:@"Loading more ..."
                          forState:MJRefreshStateRefreshing];
        [_tableViewHeader setTitle:@"No more data"
                          forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewHeader.stateLabel.textColor = KLightGrayColor;
    }return _tableViewHeader;
}

-(MJRefreshAutoGifFooter *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                             refreshingAction:@selector(netWorkLoadData)];
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
        [_tableViewFooter setTitle:@"Click or drag up to refresh"
                          forState:MJRefreshStateIdle];
        [_tableViewFooter setTitle:@"Loading more ..."
                          forState:MJRefreshStateRefreshing];
        [_tableViewFooter setTitle:@"No more data"
                          forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewFooter.stateLabel.textColor = KLightGrayColor;
    }return _tableViewFooter;
}

-(PYSearchViewController *)searchViewController{
    if (!_searchViewController) {
        _searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:self.labelArr
                                                                       searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言")
                                                                             didSearchBlock:^(PYSearchViewController *searchViewController,
                                                                                              UISearchBar *searchBar,
                                                                                              NSString *searchText) {
            @weakify(searchViewController)
            
                                                                                 [ZFCollectionViewListController pushFromVC:searchViewController_weak_.navigationController
                                                                                                              requestParams:@"搜索"
                                                                                                                    success:^(id  _Nonnull data) {}
                                                                                                                   animated:YES];
                                                                             }];
        _searchViewController.hotSearchStyle = 3;
        _searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
        _searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
        _searchViewController.delegate = self;
    }return _searchViewController;
}

-(UIView *)backgroudSearch{
    if (!_backgroudSearch) {
        _backgroudSearch = UIView.new;
        _backgroudSearch.layer.masksToBounds = YES;
        _backgroudSearch.layer.cornerRadius = 10.0f / 667.0f * (SCREEN_HEIGHT + Height_NavBar + Height_TabBar);
        _backgroudSearch.backgroundColor = [UIColor colorWithHexString:@"221c31"];
        [self.view addSubview:_backgroudSearch];
        [_backgroudSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALING_RATIO(15));
            make.top.mas_equalTo(Height_NavBar);
            make.right.mas_equalTo(-17 / 375.0f * SCREEN_WIDTH);
            make.height.mas_equalTo(SCALING_RATIO(36));
        }];
    }return _backgroudSearch;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.image = [UIImage imageNamed:@"Search"];
        [self.backgroudSearch addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALING_RATIO(9));
            make.centerY.mas_equalTo(self.backgroudSearch.centerY);
            make.width.mas_equalTo(SCALING_RATIO(14));
            make.height.mas_equalTo(SCALING_RATIO(14));
        }];
    }return _imageView;
}

-(UILabel *)classLabel{
    if (!_classLabel) {
        _classLabel = UILabel.new;
        _classLabel.text = NSLocalizedString(@"VDSearchText", nil);
        _classLabel.textColor =  kWhiteColor;
        _classLabel.font = [UIFont systemFontOfSize:17.0f];
        _classLabel.textAlignment = NSTextAlignmentLeft;
        [self.backgroudSearch addSubview:_classLabel];
        [_classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).offset(SCALING_RATIO(8));
            make.centerY.mas_equalTo(self.backgroudSearch.centerY);
            make.height.mas_equalTo(SCALING_RATIO(13));
        }];
    }return _classLabel;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self
                       action:@selector(searchBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.backgroudSearch addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }return _searchBtn;
}

-(UIView *)backgroudView{
    if (!_backgroudView) {
        _backgroudView = UIView.new;
        _backgroudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone Xs Max"]];
        _backgroudView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_backgroudView];
        [_backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.backgroudSearch.mas_bottom).offset(SCALING_RATIO(25));
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.bottom.mas_equalTo(0);
        }];
    }return _backgroudView;
}

-(UIView *)logoView{
    if (!_logoView) {
        _logoView = UIView.new;
        _logoView.backgroundColor = [UIColor colorWithHexString:@"DC4E61"];
        [cell addSubview:_logoView];
        [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCALING_RATIO(13));
            make.top.mas_equalTo(10 / 667.0f * SCREEN_HEIGHT);
            make.width.mas_equalTo(SCALING_RATIO(10));
            make.height.mas_equalTo(15 / 667.0f * SCREEN_HEIGHT);
        }];
    }return _logoView;
}

-(UILabel *)labelHot{
    if (!_labelHot) {
        _labelHot = UILabel.new;
        _labelHot.text = NSLocalizedString(@"VDHotLabelsText", nil);
        _labelHot.textColor = kWhiteColor;
        _labelHot.font = [UIFont systemFontOfSize:15.0f];
        [cell addSubview:_labelHot];
        [_labelHot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.logoView.mas_right).offset(SCALING_RATIO(13));
            make.centerY.mas_equalTo(self.logoView.mas_centerY);
            make.height.mas_equalTo(15/667.0f*SCREEN_HEIGHT);
        }];
    }return _labelHot;
}

-(UILabel *)titleView{
    if (!_titleView) {
        _titleView = UILabel.new;
        _titleView.text = NSLocalizedString(@"VDclassification", nil);
        _titleView.textColor = kWhiteColor;
    }return _titleView;
}

-(NSMutableArray *)selectedTags{
    if (!_selectedTags) {
        _selectedTags = NSMutableArray.array;
    }return _selectedTags;
}

-(NSMutableArray *)searchSuggestionsM{
    if (!_searchSuggestionsM) {
        _searchSuggestionsM = NSMutableArray.array;
    }return _searchSuggestionsM;
}

- (NSMutableArray *)valueArr {
    if (!_valueArr) {
        _valueArr = NSMutableArray.array;
    }return _valueArr;
}

-(NSMutableArray<NSURL *> *)urlArr{
    if (!_urlArr) {
        _urlArr = NSMutableArray.array;
    }return _urlArr;
}

-(NSMutableArray *)videoArr{
    if (!_videoArr) {
        _videoArr = NSMutableArray.array;
    }return _videoArr;
}

-(NSMutableArray *)labelArr{
    if (!_labelArr) {
        _labelArr = NSMutableArray.array;
    }return _labelArr;
}

-(NSMutableArray<ClassTotalDataModel *> *)classTotalDatamutArr{
    if (!_classTotalDatamutArr) {
        _classTotalDatamutArr = NSMutableArray.array;
    }return _classTotalDatamutArr;
}

-(NSMutableArray *)sectionDataMutArr{
    if (!_sectionDataMutArr) {
        _sectionDataMutArr = NSMutableArray.array;
    }return _sectionDataMutArr;
}

-(NSMutableArray<NSMutableArray *> *)videoUrlSectionMutArr{
    if (!_videoUrlSectionMutArr) {
        _videoUrlSectionMutArr = NSMutableArray.array;
    }return _videoUrlSectionMutArr;
}

@end
