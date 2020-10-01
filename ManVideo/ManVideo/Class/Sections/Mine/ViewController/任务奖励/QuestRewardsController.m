//
//  QuestRewardsController.m
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "QuestRewardsController.h"
#import "QuestRewardsController+VM.h"
#import "QuestTableCell.h"
#import "PointsForController.h"

extern UINavigationController *rootVC;

@interface QuestRewardsController ()
<UITableViewDelegate,UITableViewDataSource>
{
    ViewForHeader *viewForHeader;
    ViewForFooter *viewForFooter;
}

@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIBarButtonItem *rightItem;
@property(nonatomic,strong)UILabel *currentLabel;
@property(nonatomic,strong)UILabel *integralLabel;
@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;
@property(nonatomic,strong)UIImageView *tableHeaderView;

@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)NSArray *arrTitle;
@property(nonatomic,strong)NSArray *headerArr;

@end

@implementation QuestRewardsController

-(void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    QuestRewardsController *vc = [[QuestRewardsController alloc] initWithRequestParams:requestParams
                                                                       success:block];
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

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block{
    if (self = [super init]) {
        self.successBlock = block;
        self.requestParams = requestParams;
        self.arrTitle = @[@[@"",
                            @"",
                            NSLocalizedString(@"VDthumbText",nil),//其他用户点赞.
                            NSLocalizedString(@"VDFocusText",nil),//关注.
                            NSLocalizedString(@"VDDayEverText",nil),//每天登录.
                            NSLocalizedString(@"VDuploadText",nil),//上传.
                            NSLocalizedString(@"VDInviteText",nil)],//邀请好友.
                          @[NSLocalizedString(@"VDconsecutiveText",nil),//连续上传7天
                            NSLocalizedString(@"VDUploadText",nil)],//连续登录7天
                          @[NSLocalizedString(@"VDLogincontinuouslyText",nil),//连续登录30天
                            NSLocalizedString(@"VDUploadLogincontinuouslyText",nil),//连续上传30天
                            NSLocalizedString(@"VDUpload150Text",nil),//上传150个视频
                            NSLocalizedString(@"VDUpload300Text",nil),//上传300个视频
                            NSLocalizedString(@"VDUpload450Text",nil)]];//上传450个视频
            self.headerArr = @[NSLocalizedString(@"VDtaskText", nil),//每日任务
                               NSLocalizedString(@"VDWeeklyText", nil),//每周任务
                               NSLocalizedString(@"VDMonthText", nil)];//每月任务
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navTitle =  NSLocalizedString(@"VDQuestText", nil);
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"1A142D"];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
//    self.gk_navTitleView = self.titleView;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.gk_navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
    rootVC.navigationBarHidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)rightBtnAction:(UIButton *)action {
    GKDYPersonalModel *model = [self.arrRewards firstObject];
    PointsForController *points = [[PointsForController alloc]init];
    points.totalScore = [NSString stringWithFormat:@"%ld",(long)model.totalScore];
   [self.navigationController pushViewController:points
                                        animated:YES];
}

- (void)leftBtnAction:(UIButton *)action {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark —— 上拉加载 & 下拉刷新
-(void)pullToRefresh{
    [self netWork];
}

-(void)netWorkLoadData{
    [self netWork];
}

#pragma mark ===================== 系统代理Delegate===================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 7;
            break;
        case 1:return 2;
            break;
        default:
            return 5;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QuestTableCell"
                                              owner:nil
                                            options:nil]
                lastObject];
    }

    GKDYPersonalModel *personalModel = [self.arrRewards firstObject];
    cell.titleLabel.text = self.arrTitle[indexPath.section][indexPath.row];
    self.integralLabel.text = [NSString stringWithFormat:@"%ld",(long)personalModel.totalScore];
    [cell richElementsInCellWithModel:personalModel
                        WithIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"viewForHeader"];
    if (section == 0) {
        self.currentLabel.alpha = 1;
        self.integralLabel.alpha = 1;
    }
    viewForHeader.header.text = self.headerArr[section];
    return viewForHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 44;
    } else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    viewForFooter = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"viewForFooter"];
    return viewForFooter;
}

#pragma mark —— lazyLoad
-(UILabel *)currentLabel{
    if (!_currentLabel) {
        _currentLabel = UILabel.new;
        _currentLabel.text = NSLocalizedString(@"VDintegralText", nil);//当前积分
        _currentLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _currentLabel.font = [UIFont systemFontOfSize:12.0f];
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        [self.tableHeaderView addSubview:_currentLabel];
        [_currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.tableHeaderView);
            make.height.mas_equalTo(SCALING_RATIO(16));
        }];
    }return _currentLabel;
}

-(UILabel *)integralLabel{
    if (!_integralLabel) {
        _integralLabel = UILabel.new;
        _integralLabel.textColor = kWhiteColor;
        _integralLabel.textAlignment = NSTextAlignmentCenter;
        _integralLabel.font = [UIFont systemFontOfSize:30.0f];
        [self.tableHeaderView  addSubview:_integralLabel];
        [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentLabel.mas_bottom).offset(SCALING_RATIO(4));
            make.centerX.mas_equalTo(self.tableHeaderView);
            make.height.mas_equalTo(SCALING_RATIO(34));
        }];
    }return _integralLabel;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:NSLocalizedString(@"VDPointsText", nil)
                   forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"BE3462"]
                        forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_rightBtn addTarget:self
                      action:@selector(rightBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.frame = CGRectMake(0,
                                     0,
                                     70,
                                     44);
    }return _rightBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:[ViewForHeader class] forHeaderFooterViewReuseIdentifier:@"viewForHeader"];
        [_tableView registerClass:[ViewForFooter class] forHeaderFooterViewReuseIdentifier:@"viewForFooter"];
        [_tableView registerNib:[UINib nibWithNibName:@"QuestTableCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"QuestTableCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIImageView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = UIImageView.new;
        _tableHeaderView.frame = CGRectMake(0,
                                            0,
                                            SCREEN_WIDTH,
                                            SCALING_RATIO(150));
        _tableHeaderView.backgroundColor = kGrayColor;
        _tableHeaderView.image = kIMG(@"图层 764");
    }return _tableHeaderView;
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

- (NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure = NSMutableArray.array;
    }return _dataSoure;
}

-(NSMutableArray<GKDYPersonalModel *> *)arrRewards{
    if (!_arrRewards) {
        _arrRewards = NSMutableArray.array;
    }return _arrRewards;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_return"]
                     forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(0,
                                       32+(IS_IPHONE_X ? 20 : 0),
                                       40,
                                       30);
        [_backButton setTitle:NSLocalizedString(@"VDBack", nil)
                     forState:UIControlStateNormal];
        [_backButton setTitleColor:kWhiteColor
                          forState:UIControlStateNormal];
        [_backButton sizeToFit];
        [_backButton addTarget:self
                        action:@selector(leftBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }return _backButton;
}

@end
