//
//  VDClassificationController.m
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDClassificationController.h"
#import "MXNavigationBarManager.h"
#import "VDClassCollectionViewCell.h"
#import "LGLSearchBar.h"
#import "ZFCollectionViewListController.h"
#import "PYSearchViewController.h"

#import "PYSearch.h"
#import "TPLChooseCell.h"

#import "ZFCollectionViewListController.h"
#import "HXTagsCell.h"

#import "ZFDouYinViewController.h"

static NSString *const kChooseCellID = @"kChooseCell";

@interface VDClassificationController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,PYSearchViewControllerDelegate,PYSearchViewControllerDelegate,VDClassCollectionDelegate>
{
    NSMutableArray *selectedTags;
}

@property (nonatomic, strong) UICollectionView    *collectionV;
/** tableView  */
@property (nonatomic, weak) UITableView *tableView;

/** 轮播图 */
@property (nonatomic, weak) UIView *tableHeadView;

/** 菜单 */
@property (nonatomic, weak) UICollectionView *chooseView;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic,strong) HXTagCollectionViewFlowLayout *layout;//布局layout
@property (nonatomic,strong) NSArray *selectTags;


@end

@implementation VDClassificationController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MXNavigationBarManager reStoreToSystemNavigationBar];
}

- (void)initBarManager {
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    //optional
    [MXNavigationBarManager setTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self initBarManager];
    
}

- (void)vd_addSubviews {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupView];
    self.dataArr = @[@"巨乳",@"单体作品女优的哈哈",@"高画质",@"国产",@"无码",@"自拍",@"美乳",@"美女",@"一本道",@"后入",@"中出",@"业余",@"美少女",@"口交",@"人妻",@"自慰"];
  selectedTags = [NSMutableArray array];
}

- (void)setupView {
    
    // 整体布局是一个tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar+10, SCREEN_WIDTH, SCREEN_HEIGHT - Height_TabBar*2) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
    [self.view addSubview:tableView];
    //预估高度
    tableView.estimatedRowHeight = 200.0f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.userInteractionEnabled = YES;
    
    [tableView registerClass:[VDClassCollectionViewCell class] forCellReuseIdentifier:@"VDClassCollectionViewCell"];
//     [tableView registerClass:HXTagsCell.class forHeaderFooterViewReuseIdentifier:@"cellId"];
   
    UIView *backgroudSearch = [UIView new];
    backgroudSearch.layer.masksToBounds = YES;
    backgroudSearch.layer.cornerRadius = 10.0f/667.0f*(SCREEN_HEIGHT+Height_NavBar+Height_TabBar);
    backgroudSearch.backgroundColor = [UIColor colorWithHexString:@"221c31"];
    [self.view addSubview:backgroudSearch];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"Search"];
    [backgroudSearch addSubview:imageView];
    
    UILabel *classLabel = [UILabel new];
    classLabel.text = @"Search";
    classLabel.textColor =  kWhiteColor;
    classLabel.font = [UIFont systemFontOfSize:17.0f];
    classLabel.textAlignment = NSTextAlignmentLeft;
    [backgroudSearch addSubview:classLabel];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroudSearch addSubview:searchBtn];
    
    [backgroudSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(15);
         make.top.mas_equalTo(Height_NavBar);
//         make.width.mas_equalTo(SCREEN_WIDTH-20);
         make.right.mas_equalTo(-17/375.0f*SCREEN_WIDTH);
         make.height.mas_equalTo(36);
        
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(9);
//        make.top.mas_equalTo(80);
        make.centerY.mas_equalTo(backgroudSearch.centerY);
         make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(imageView.mas_right).offset(8);
        make.centerY.mas_equalTo(backgroudSearch.centerY);
        make.height.mas_equalTo(13);
         make.width.mas_equalTo(60);
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
  
}


- (void)vd_layoutNavigation {
    
    
    self.title = @"分类";
    
}

- (HXTagCollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [HXTagCollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VDClassCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VDClassCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
    if (indexPath.section == 0) {
        cell.colorView.backgroundColor = [UIColor colorWithHexString:@"DC4E61"];
        cell.classificationLabel.text = @"亚洲精品";
    } else {
        cell.colorView.backgroundColor = [UIColor colorWithHexString:@"6F3DD8"];
        cell.classificationLabel.text = @"欧洲优选";
    }
    
//    cell.homeModel = self.dataArrayM[indexPath.row];
//    cell.delegate = self;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    HXTagsCell *cell = [[HXTagsCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    cell.tags = self.dataArr;
    cell.selectedTags = [NSMutableArray arrayWithArray:_selectTags];
    cell.layout = self.layout;
    @weakify(self)
    cell.completion = ^(NSArray *selectTags,NSInteger currentIndex) {
        @strongify(self);
        NSLog(@"selectTags:%@ currentIndex:%ld",selectTags, (long)currentIndex);
        self.selectTags = selectTags;
        ZFCollectionViewListController *collection = [[ZFCollectionViewListController alloc]init];
        collection.classificationString = self.dataArr[currentIndex];
        [self.navigationController pushViewController:collection animated:YES];
    };
    [cell reloadData];
    UIView *logoView = [UIView new];
    logoView.backgroundColor = [UIColor colorWithHexString:@"B11D6D"];
    [cell addSubview:logoView];
    
    UILabel *labelHot = [UILabel new];
    labelHot.text = @"热门标签";
    labelHot.textColor = kWhiteColor;
    labelHot.font = [UIFont systemFontOfSize:15.0f];
    [cell addSubview:labelHot];
    
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(10/667.0f*SCREEN_HEIGHT);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(15/667.0f*SCREEN_HEIGHT);
    }];
    
    [labelHot mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(logoView.mas_right).offset(13);
        //        make.top.mas_equalTo(10/667.0f*SCREEN_HEIGHT);
        make.centerY.mas_equalTo(logoView.mas_centerY);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(15/667.0f*SCREEN_HEIGHT);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFCollectionViewListController *collection = [[ZFCollectionViewListController alloc]init];
    collection.classificationString = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:collection animated:YES];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 200.0f;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
       float height = [HXTagsCell getCellHeightWithTags:self.dataArr layout:self.layout tagAttribute:nil width:tableView.frame.size.width];
    if (section == 1) {
        return height;
    } else {

        return 0;
    }
}

#pragma mark ===================== 点击事件===================================
- (void)searchBtnClick:(UIButton *)sender {
    
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索编程语言") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        [searchViewController.navigationController pushViewController:[[ZFCollectionViewListController alloc] init] animated:YES];
//        UIViewController *peopleInfo=[[CTMediator sharedInstance] yt_mediator_ZFCollectionViewListControllerWithParams:@{}];
//        [self.navigationController pushViewController:peopleInfo animated:YES];
    }];
    // 3. Set style for popular search and search history
  
    searchViewController.hotSearchStyle = 3;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // Push
    // Set mode of show search view controller, default is `PYSearchViewControllerShowModeModal`
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    //    // Push search view controller
//    UIViewController *peopleInfo=[[CTMediator sharedInstance] yt_mediator_PYSearchViewControllerWithParams:@{}];
//    [self.navigationController pushViewController:peopleInfo animated:YES];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
    
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

#pragma mark ===================== 自定义代理===================================

- (void)videoClickDelegate:(NSInteger)index {
    
    ZFDouYinViewController *dou = [[ZFDouYinViewController alloc]init];
    
    [self.navigationController pushViewController:dou animated:YES];
}

@end
