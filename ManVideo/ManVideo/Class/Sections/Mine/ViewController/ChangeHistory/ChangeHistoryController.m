//
//  ChangeHistoryController.m
//  Clipyeu ++
//
//  Created by Josee on 28/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChangeHistoryController.h"
#import "ChangeHistoryCell.h"
#import "HistoryModel.h"

@interface ChangeHistoryController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableV;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)NSMutableArray *arrayData;

@end

@implementation ChangeHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRequestFinish = NO;//刚进入界面是没有完成请求数据的
    self.gk_navTitle =  NSLocalizedString(@"VDChangeText", nil);
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    [self setupView];
    [self exampleRefresh];
     [self netWorkLoad];
}

- (void)setupView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TabBar-20) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableV = tableView;
    tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"ChangeHistoryCell" bundle:nil] forCellReuseIdentifier:@"ChangeHistoryCell"];
    
}
- (void)exampleRefresh
{
    
    @weakify(self)
    // 下拉刷新
    self.tableV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        //        self.page = 1;
         [self netWorkLoad];
        [self.tableV reloadData];
        // 结束刷新
        [self.tableV.mj_header endRefreshing];
    }];
    [self.tableV.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //        self.page += 1;
       [self netWorkLoad];
         [self.tableV reloadData];
        //        // 结束刷新
        [self.tableV.mj_footer endRefreshing];
    }];
    // 默认先隐藏footer
    self.tableV.mj_footer.hidden = YES;
}

- (void)netWorkLoad {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userId = [user objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
    int userIdInt = [userId intValue];
    NSNumber *number = [NSNumber numberWithInt:userIdInt];
    NSDictionary *dict = @{@"userId":number,@"token":token};
    DLog(@"兑换历史%@",dict);
    [self.arrayData removeAllObjects];
    [CMRequest requestNetSecurityGET:@"/videoUploading/exchangeRecords" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
    
        NSArray *array = [HistoryModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        for (int i =0; i <array.count; i++) {
            HistoryModel *model = array[i];
              [self.arrayData addObject:model];
        }
        if (dict[@"data"]) {
            self.tableV.hidden = NO;
        } else {
            self.tableV.hidden = YES;
        }
        [self.tableV reloadData];
        [self.tableV.mj_header endRefreshing];
      
    } errorBlock:^(NSString * _Nonnull message) {
            [self.tableV.mj_header endRefreshing];
    } failBlock:^(NSError * _Nonnull error) {
            [self.tableV.mj_header endRefreshing];
    }];
}
#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark ===================== 系统代理Delegate===================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangeHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeHistoryCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangeHistoryCell" owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
   HistoryModel *model = self.arrayData[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.changeGift.text = NSLocalizedString(@"VDCashprizesText", nil);
        cell.countLabel.text = NSLocalizedString(@"VDamountText", nil);
        cell.timeIntail.text = NSLocalizedString(@"VDTime/integralText", nil);
    } else {
//        if (model.status) {
            if (model.status == 1) {
                 cell.changeGift.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"VDcashText", nil)];
            } else if (model.status == 2) {
                cell.changeGift.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"VDPhoneCardText", nil)];
            }
        NSString *currentTime = [model.createDate substringToIndex:19];
        
        NSString *stringModel = [currentTime substringToIndex:10];
      
        NSString *timeLater = [currentTime substringFromIndex:14];
            cell.changeGift.font = [UIFont systemFontOfSize:14.0f];
            cell.countLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.countLabel.text = model.money;
            cell.timeIntail.text = [NSString stringWithFormat:@"%@%@\n消耗积分%ld",stringModel,timeLater,(long)model.integral];
            cell.timeIntail.font = [UIFont systemFontOfSize:10.0f];
            cell.countLabel.textAlignment = NSTextAlignmentLeft;
            cell.changeGift.textAlignment = NSTextAlignmentCenter;
//        }
      
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];//透明颜色
    self.footerView = view;
    UILabel  *header = [UILabel new];
    header.text = NSLocalizedString(@"VDNomoreText", nil);
    header.textColor = [UIColor colorWithHexString:@"E5E5E5"];
    header.font = [UIFont systemFontOfSize:12.0f];
    header.textAlignment = NSTextAlignmentCenter;
    [view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.width.mas_equalTo(100);
        make.centerY.mas_equalTo(view);
    }];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
   
        return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 165;
    } else {
        return 44;
    }
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}

@end
