//
//  PersonalCenterVC.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/24.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "PersonalCenterVC.h"
#import "PersonalCenterVC+VM.h"
#import "MyLikeVC.h"
#import "SettingVC.h"
#import "UserDataController.h"
#import "QuestRewardsController.h"
#import "MembershipController.h"

#import "JXCategoryTitleAttributeView.h"

#import "MyProductsVC.h"//作品
#import "MyDynamicVC.h"//动态
#import "MyLikeVC.h"//喜欢

extern LZTabBarVC *tabBarVC;
extern UINavigationController *rootVC;
PersonalCenterVC *personalCenterVC;

@interface PersonalCenterVC ()
<
//GKPageScrollViewDelegate,
//,UIScrollViewDelegate
//,UIGestureRecognizerDelegate
JXCategoryViewDelegate
,JXCategoryListContainerViewDelegate
,GKDYHeaderDelegate
,UITableViewDataSource
,UITableViewDelegate
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableViewCell *tableViewCell;
@property(nonatomic,strong)UILabel *titleView;
@property(nonatomic,strong)UIButton *settingBtn;/*设置*/
@property(nonatomic,strong)JXCategoryIndicatorLineView *lineView;
@property(nonatomic,strong)JXCategoryTitleAttributeView *myCategoryView;
@property(nonatomic,strong)MembershipController *member;
@property(nonatomic,strong)SettingVC *settingVC;
@property(nonatomic,copy)id<UIGestureRecognizerDelegate> restoreInteractivePopGestureDelegate;

@property(nonatomic,strong)NSMutableArray <NSAttributedString *>*attributedStringArray;
@property(nonatomic,strong)NSMutableArray <NSAttributedString *>*selectedAttributedStringArray;
@property(nonatomic,strong)NSMutableArray <NSString *>*titlesMutArr;
@property(nonatomic,strong)NSMutableArray <NSNumber *>*counts;
@property(nonatomic,strong)NSMutableArray *listArr;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)NSArray *childVCs;
@property(nonatomic,copy)NSString *idString;

@end

@implementation PersonalCenterVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{//推到本页面
    PersonalCenterVC *vc = PersonalCenterVC.new;
    NSLog(@"传入个人中心的参数 : %@ _ %@",requestParams[@"userId"],requestParams[@"idString"]);
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.userId = requestParams[@"userId"];
    vc.headerView.userId = requestParams[@"userId"];
    vc.byId = requestParams[@"byId"];
    if (rootVC.navigationController) {
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
        vc.isPush = YES;
        vc.headerView.isPush = YES;
        vc.isPresent = NO;
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

-(instancetype)init{//第一次进程序
    if (self = [super init]) {
        self.tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
        self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ? : @"";
        self.isRequestFinish = NO;//刚进入界面是没有完成请求数据的
        personalCenterVC = self;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.alpha = 1;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    [self NSNotification];
////    [self createAnimaition];
//    self.listContainerView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navigationBar.hidden = NO;
    self.gk_navLineHidden = YES;
    self.gk_navBackgroundColor = kClearColor;
    //每次进页面都要重新请求
    extern LZTabBarVC *tabBarVC;
    if (self.isPush) {
        self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
        self.gk_navTitle =  @"Clipyeu++";
        self.gk_navBarAlpha = 0;
        tabBarVC.tabBar.hidden = YES;//隐藏 LZTabBarVC
        if ([self.userId isNullString]) {
            self.userId = @"";
        }
    }else{
        tabBarVC.tabBar.hidden = NO;//显示 LZTabBarVC
//        self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.settingBtn];
        self.settingBtn.alpha = 1;
        self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ? : @"";
       
    }
    self.tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
    [self loadDataView_VM];//每次进页面都要重新请求数据进行刷新
    rootVC.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.listContainerView.alpha = 1;
}

- (NSAttributedString *)attributedText:(NSString *)title
                                 count:(NSNumber *)count
                            isSelected:(BOOL)isSelected {
    NSString *countString = [[NSString alloc] initWithFormat:@"(%@)", count];
    NSString *allString = [NSString stringWithFormat:@"%@%@", title, countString];
    UIColor *tintColor = nil;
    if (isSelected) {
        tintColor = kWhiteColor;
    }else {
        tintColor = kGrayColor;
    }
    NSMutableAttributedString *attrubtedText = [[NSMutableAttributedString alloc] initWithString:allString
                                                                                      attributes:@{
                                                                                                   NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                                                                   NSForegroundColorAttributeName : tintColor}
                                                ];
    [attrubtedText addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:12]
                          range:[allString rangeOfString:countString]];
    //让数量对齐
    [attrubtedText addAttribute:NSBaselineOffsetAttributeName
                          value:@(([UIFont systemFontOfSize:15].lineHeight - [UIFont systemFontOfSize:12].lineHeight)/2 + (([UIFont systemFontOfSize:15].descender - [UIFont systemFontOfSize:12].descender)))
                          range:[allString rangeOfString:countString]];
    return attrubtedText;
}

#pragma mark
- (void)Login_Success:(NSNotification *)noti{
    //通知接受以后刷新数据，重新赋值
    self.tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ? : @"";
    [self loadDataView];
}

#pragma mark —— UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    [self.headerView updateHeaderImageViewFrameWithOffsetY:offsetY];
}
#pragma mark —— UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT * 2 / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.tableViewCell) {
        self.tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:ReuseIdentifier];
    } return self.tableViewCell;
}

#pragma mark —— GKDYHeaderDelegate
- (void)clickQuestDelegateButton:(UIButton *)btn {
//    [[kAPPWindow subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj,
//                                                        NSUInteger idx,
//                                                        BOOL * _Nonnull stop) {
//        UIView *view = kAPPWindow.subviews[1];
//        [view removeFromSuperview];
//    }];

//    [self.navigationController pushViewController:self.quest
//                                         animated:YES];

    @weakify(self)
    [QuestRewardsController pushFromVC:self_weak_
                         requestParams:Nil
                               success:^(id  _Nonnull data) {}
                              animated:YES];
}

- (void)tapActionDelegateClick:(UITapGestureRecognizer *)click {
    [self.navigationController pushViewController:self.member
                                         animated:YES];
}

- (void)focusOnActionDelegate:(UIButton *)sender {
    //        NSString *userId = [token objectForKey:@"userId"];
    if(![self.tokenString isEqualToString:@""]){
        sender.selected = !sender.selected;
        if (sender.selected) {
            [self loadNetWorkFocusOn];
        } else {
            [self cancelFocusonNetWork];
        }
    }else{
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

- (void)userPushViewDelegate:(UIButton *)sender {
    @weakify(self)
    [UserDataController pushFromVC:self_weak_
                     requestParams:self.modelPersonal
                           success:^(id  _Nonnull data) {}
                          animated:YES];
}

#pragma mark JXCategoryListContainerViewDelegate
/**
 返回list的数量

 @param listContainerView 列表的容器视图
 @return list的数量
 */
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView{
    return self.titles.count;
}

/**
 根据index初始化一个对应列表实例，需要是遵从`JXCategoryListContentViewDelegate`协议的对象。
 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXCategoryListContentViewDelegate`协议，该方法返回自定义UIView即可。
 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXCategoryListContentViewDelegate`协议，该方法返回自定义UIViewController即可。

 @param listContainerView 列表的容器视图
 @param index 目标下标
 @return 遵从JXCategoryListContentViewDelegate协议的list实例
 */
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView
                                          initListForIndex:(NSInteger)index{
    return self.childVCs[index];
}

#pragma mark JXCategoryViewDelegate
//传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

//传递scrolling事件给listContainerView，必须调用！！！
- (void)categoryView:(JXCategoryBaseView *)categoryView
scrollingFromLeftIndex:(NSInteger)leftIndex
        toRightIndex:(NSInteger)rightIndex
               ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex
                                      toRightIndex:rightIndex
                                             ratio:ratio
                                     selectedIndex:categoryView.selectedIndex];
}

-(void)NSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Login_Success:)
                                                 name:@"Login_Success"
                                               object:nil];
}

- (void)loadDataView{
    [self loadDataView_VM];
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)backBtnClickEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)settingClick:(UIButton *)click {
    @weakify(self)
    [SettingVC pushFromVC:self_weak_
            requestParams:nil
                  success:^(id  _Nonnull data) {}
                 animated:YES];
}

#pragma mark —— lazyLoad
-(GKDYHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[GKDYHeaderView alloc]initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT / 2)];
        _headerView.delegate = self;
        _headerView.userInteractionEnabled = YES;
    }return _headerView;
}

-(NSMutableDictionary *)dic{
    if (!_dic) {
        _dic = NSMutableDictionary.dictionary;
    }return _dic;
}

-(MembershipController *)member{
    if (!_member) {
        _member = MembershipController.new;
    }return _member;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        _titleView.font = [UIFont systemFontOfSize:18.0f];
        _titleView.textColor = [UIColor whiteColor];
        _titleView.alpha = 0;
        _titleView.textAlignment = NSTextAlignmentCenter;
        //        _titleView.text = self.model.author.name_show;
        _titleView.text = [NSString stringWithFormat:@"Clipyeu++"];
    }return _titleView;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"setting"]
                     forState:UIControlStateNormal];
        [_settingBtn addTarget:self
                        action:@selector(settingClick:)
              forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.frame = CGRectMake(0,
                                       0,
                                       60,
                                       24);
//        [self.view addSubview:_settingBtn];
        [self.headerView addSubview:_settingBtn];
        [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(rectOfStatusbar + SCALING_RATIO(SCALING_RATIO(10)));
            make.right.equalTo(self.view).offset(SCALING_RATIO(-10));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(60), SCALING_RATIO(60)));
        }];
    }return _settingBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.array;
    }return _dataSource;
}

-(NSMutableArray<NSAttributedString *> *)attributedStringArray{
    if (!_attributedStringArray) {
        _attributedStringArray = NSMutableArray.array;
    }return _attributedStringArray;
}

-(NSMutableArray<NSAttributedString *> *)selectedAttributedStringArray{
    if (!_selectedAttributedStringArray) {
        _selectedAttributedStringArray = NSMutableArray.array;
    }return _selectedAttributedStringArray;
}

-(NSMutableArray<NSString *> *)titlesMutArr{
    if (!_titlesMutArr) {
        _titlesMutArr = NSMutableArray.array;
        [_titlesMutArr addObject:NSLocalizedString(@"VDworksText", nil)];
        [_titlesMutArr addObject:NSLocalizedString(@"VDActive", nil)];
        [_titlesMutArr addObject:NSLocalizedString(@"VDLike", nil)];
    }return _titlesMutArr;
}

-(NSMutableArray<NSNumber *> *)counts{
    if (!_counts) {
        _counts = NSMutableArray.array;
        [_counts addObject:@(self.likeCount)];/*喜欢数量*/
        [_counts addObject:@(self.videoCount)];/*作品数量*/
        [_counts addObject:@(self.dynamicCountString)];/*动态数量*/
    }return _counts;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        [self.view addSubview:_tableView];
    }return _tableView;
}

-(JXCategoryTitleAttributeView *)myCategoryView{
    if (!_myCategoryView) {
        _myCategoryView = JXCategoryTitleAttributeView.new;
        _myCategoryView.delegate = self;
        _myCategoryView.backgroundColor = [UIColor colorWithHexString:@"1A142D"];
        for (NSInteger index = 0; index < self.titlesMutArr.count; index++) {
            [self.attributedStringArray addObject:[self attributedText:self.titlesMutArr[index]
                                                                 count:self.counts[index]
                                                            isSelected:NO]];
            [self.selectedAttributedStringArray addObject:[self attributedText:self.titlesMutArr[index]
                                                                         count:self.counts[index]
                                                                    isSelected:YES]];
        }
        self.myCategoryView.attributeTitles = self.attributedStringArray;
        self.myCategoryView.selectedAttributeTitles = self.selectedAttributedStringArray;
        self.myCategoryView.titleLabelZoomEnabled = YES;
        [self.view layoutIfNeeded];
        [self.tableView addSubview:_myCategoryView];
        [_myCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCALING_RATIO(50));
            make.top.equalTo(self.headerView.mas_bottom);
        }];
    }return _myCategoryView;
}

-(JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
        [self.tableViewCell addSubview:_listContainerView];
        [self.view layoutIfNeeded];
        [_listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.myCategoryView.mas_bottom);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        self.myCategoryView.contentScrollView = _listContainerView.scrollView;//关联cotentScrollView，关联之后才可以互相联动！！！
        [self.view layoutIfNeeded];
    }return _listContainerView;
}

-(JXCategoryIndicatorLineView *)lineView{
    if (!_lineView) {
        _lineView = JXCategoryIndicatorLineView.new;
        _lineView.indicatorLineViewColor = kRedColor;
        _lineView.indicatorLineWidth = 80.0f;
        _lineView.indicatorLineViewCornerRadius = 0;
        _lineView.lineStyle = JXCategoryIndicatorLineStyle_Normal;
    }return _lineView;
}

- (NSArray *)childVCs {
    if (!_childVCs) {
        _childVCs = @[
                      [[MyProductsVC alloc]initWithRequestParams:@{
                          @"userId":self.userId,
                          @"byId":[NSString stringWithFormat:@"%ld",(long)self.modelPersonal.byId]
                      }],
                      [[MyDynamicVC alloc]initWithRequestParams:self.userId],
                      [[MyLikeVC alloc]initWithRequestParams:self.userId],
                      ];
    }return _childVCs;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @(self.videoCount),
                    @(self.dynamicCountString),
                    @(self.likeCount)
                    ];
    }return _titles;
}

#pragma mark —— 值得商榷的
//- (GKPageScrollView *)pageScrollView {
//    if (!_pageScrollView) {
//        _pageScrollView = [[GKPageScrollView alloc] initWithDelegate:self];
//        _pageScrollView.isAllowListRefresh = YES;   // 允许列表刷新
//        _pageScrollView.backgroundColor = [UIColor colorWithHexString:@"1A142D"];
//        [self.view addSubview:_pageScrollView];
//        [_pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//    }
//    return _pageScrollView;
//}
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        CGFloat scrollW = SCREEN_WIDTH;
//        CGFloat scrollH = SCREEN_HEIGHT - Height_NavBar - 40.0f;
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, scrollW, scrollH)];
//        _scrollView.pagingEnabled = YES;
//        _scrollView.bounces = NO;
//        _scrollView.delegate = self;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        @weakify(self)
//        [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc,
//                                                    NSUInteger idx,
//                                                    BOOL * _Nonnull stop) {
//            @strongify(self)
//            [self addChildViewController:vc];
//            [self.scrollView addSubview:vc.view];
//            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
//        }];
//        _scrollView.contentSize = CGSizeMake(self.childVCs.count * scrollW, 0);
//        // 下拉刷新
//        _scrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            @strongify(self)
//            //         self.imageView.hidden = NO;
//            //        self.page = 1;
//            [self loadDataView];
//            // 结束刷新
//            [self->_scrollView.mj_header endRefreshing];
//        }];
//
//        // 上拉刷新
//        _scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            //        self.page += 1;
//            //         self.imageView.hidden = NO;
//            [self loadDataView];
//            //        // 结束刷新
//            [self->_scrollView.mj_footer endRefreshing];
//        }];
//    }return _scrollView;
//}
//- (void)mainTableViewDidScroll:(UIScrollView *)scrollView
//               isMainCanScroll:(BOOL)isMainCanScroll {
//    // 导航栏显隐
//    CGFloat offsetY = scrollView.contentOffset.y;
//    // 0-200 0
//    // 200 - KDYHeaderHeigh - kNavBarheight 渐变从0-1
//    // > KDYHeaderHeigh - kNavBarheight 1
//    CGFloat alpha = 0;
//    if (offsetY < 200) {
//        alpha = 0;
//    }else if (offsetY > (kDYHeaderHeight - Height_NavBar)) {
//        alpha = 1;
//    }else {
//        alpha = (offsetY - 200) / (kDYHeaderHeight - Height_NavBar - 200);
//    }
//    self.gk_navBarAlpha = alpha;
//    self.titleView.alpha = alpha;
//    [self.headerView scrollViewDidScroll:offsetY];
//}
//
//#pragma mark - JXCategoryViewDelegate
//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
////    MyLikeVC *listVC = self.childVCs[index];
//////    [listVC refreshData:index];
////    if (index == 1) {
////      self.animationView.hidden = YES;
////    } else if (index == 2) {
//////          [[NSNotificationCenter defaultCenter] postNotificationName:@"clickActionNotification" object:[NSString stringWithFormat:@"%ld",(long)index]];
////             [listVC refreshNetworkData:index];
////         self.animationView.hidden = YES;
////    } else {
////        if (listVC) {
////            @weakify(self)
////            listVC.pageListBlock = ^(NSString * _Nonnull status) {
////                @strongify(self)
////                if (status) {
////                    self.animationView.hidden = YES;
////                }
////            };
////        } else {
////              self.animationView.hidden = NO;
////        }
////    }listVC.indexType = index;
//}
//
////#pragma mark - UIScrollViewDelegate
////- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
////    [self.pageScrollView horizonScrollViewWillBeginScroll];
////}
////
////- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
////    [self.pageScrollView horizonScrollViewDidEndedScroll];
////}
////#pragma mark ===================== 代理Delegate===================================
////- (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView {
////    return YES;
////}
//

//
//

//- (void)exampleRefresh{//??
//    [self.scrollView.mj_header beginRefreshing];
//    self.scrollView.mj_footer.hidden = YES;// 默认先隐藏footer
//}
//
//
//- (void)createAnimaition {
//    kAPPWindow.windowLevel = 2000;
//    self.promptBtn.alpha = 1;
//    [self.animationView.layer addAnimation:self.animation
//                                    forKey:@"kViewShakerAnimationKey"];
//}

//-(CAKeyframeAnimation *)animation{
//    if (!_animation) {
//        _animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
//        CGFloat duration = 1.f;
//        CGFloat height = 7.f;
//        CGFloat currentY = self.animationView.transform.ty;
//        _animation.duration = duration;
//        _animation.values = @[@(currentY),
//                              @(currentY - height/4),
//                              @(currentY - height/4*2),
//                              @(currentY - height/4*3),
//                              @(currentY - height),
//                              @(currentY - height/ 4*3),
//                              @(currentY - height/4*2),
//                              @(currentY - height/4),
//                              @(currentY)];
//        _animation.keyTimes = @[@(0),
//                                @(0.025),
//                                @(0.085),
//                                @(0.2),
//                                @(0.5),
//                                @(0.8),
//                                @(0.915),
//                                @(0.975),
//                                @(1)];
//        _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        _animation.repeatCount = HUGE_VALF;
//    }return _animation;
//}

//-(UIView *)animationView{
//    if (!_animationView) {
//        _animationView = [[UIView alloc] initWithFrame:CGRectMake(115/375.0f*SCREEN_WIDTH,
//                                                                  0/667.0f*SCREEN_HEIGHT,
//                                                                  140,
//                                                                  112)];
//        _animationView.backgroundColor = [UIColor clearColor];
//        _animationView.userInteractionEnabled = YES;
//        [self.view addSubview:_animationView];
//        [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.view);
//            make.bottom.mas_equalTo(-Height_TabBar-12);
//            make.width.mas_equalTo(140);
//            make.height.mas_equalTo(112);
//        }];
//    }return _animationView;
//}
//
//-(UIButton *)promptBtn{
//    if (!_promptBtn) {
//        _promptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_promptBtn setImage:[UIImage imageNamed:NSLocalizedString(@"VDPersonTanchuang", nil)]
//                    forState:UIControlStateNormal];
//        [_promptBtn addTarget:self
//                       action:@selector(promptAction:)
//             forControlEvents:UIControlEventTouchUpInside];
//        [self.animationView addSubview:_promptBtn];
//        [_promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
//    }return _promptBtn;
//}
////- (void)videoAction:(NSNotification *)noti {
////    NSString *title = [noti object];
////    if ([title isEqualToString:@"有值"]) {
////        self.animationView.hidden = YES;
////    } else {
////        self.animationView.hidden = NO;
////    }
////}
////- (void)personalNotication:(NSNotification *)noti {
////    [self loadDataView];
////}
//
////- (void)pushNextLike:(NSNotification *)noti {
////    NSInteger likeCount = [[noti object] integerValue];
////    self.likeCount = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"VDLike", nil),(long)likeCount];
////    [self.titlesArr replaceObjectAtIndex:2
////                              withObject:self.likeCount];
////    [self.pageScrollView reloadData];
////    [self.view layoutIfNeeded];
////}
//- (void)promptAction:(UIButton *)action {
//    self.animationView.hidden = YES;
//    action.hidden = YES;
//}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = ![self.userId isEqualToString:@""];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenViewPhoto"
//                                                        object:nil];
//    tabBarVC.tabBar.hidden = NO;
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = _restoreInteractivePopGestureDelegate;
//    };
//    if (![self.userId isEqualToString:@""]) {
//        self.backBtn.hidden = YES;
//    }
//}
//- (void)setupView {
//
////    if (![self.userId isEqualToString:@""]) {
////        self.backBtn.hidden = NO;
////        self.settingBtn.hidden = YES;
////        self.headerView.userBtn.userInteractionEnabled = NO;
////        self.headerView.userId = self.userId;
////    } else {
////        self.backBtn.hidden = YES;
////        self.settingBtn.hidden = NO;
////        self.headerView.userBtn.userInteractionEnabled = YES;
////    }
//}

@end
