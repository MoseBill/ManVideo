//
//  BlackListViewController.m
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "BlackListViewController.h"
#import "BlockTableViewCell.h"

static  NSString * BlockCellID  = @"BlockTableViewCell";

@interface BlackListViewController ()
<UITableViewDelegate
,UITableViewDataSource
,BlockTableDelegate
,UIGestureRecognizerDelegate>

/** tableView  */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray   *dataArr;

@end

@implementation BlackListViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate =self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
       self.view.backgroundColor = kWhiteColor;
    self.gk_navTitle =  @"黑名单";
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
 
    self.dataArr = @[@"Josee",@"Armani",@"Jordan",@"papapa",@"Fucking"];
    [self setupView];
}

- (void)setupView {
    
    // 整体布局是一个tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT - Height_TabBar) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
    [self.view addSubview:tableView];
    //预估高度
//    tableView.estimatedRowHeight = 200.0f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.userInteractionEnabled = YES;
    
    [tableView registerClass:[BlockTableViewCell class] forCellReuseIdentifier:BlockCellID];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f/667.0f*SCREEN_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSString*cellID = [NSString stringWithFormat:@"%@%zd", BlockCellID, indexPath.row];
    BlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.backgroundColor = [UIColor colorWithHexString:@"050013"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.dataArr = self.dataArr;
    if(cell == nil) {
        cell = [[BlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //因为reuseIdentifier属性是readonly的，使用kvc赋值
        [cell setValue:cellID forKey:@"reuseIdentifier"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)blockClick:(UIButton *)sender {
//    [self.dataArr removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray new];
    }
    return _dataArr;
}

@end
