//
//  SystemMessageController.m
//  Clipyeu ++
//
//  Created by Josee on 27/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SystemMessageController.h"
#import "SystemViewCell.h"
#import "SystemMessageCell.h"
#import "SystemModel.h"

@interface SystemMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView    *tableV;

@property (nonatomic, strong)  UIView *tabView;

@property(nonatomic,strong)  NSMutableArray *datas;

@property (nonatomic, assign) int  page;

@property (nonatomic, assign) int   totalPage;

@end

static NSString *ID = @"SystemMessageCell";

@implementation SystemMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navTitle =  NSLocalizedString(@"VDsystemText", nil);
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
        self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    [self setupView];

}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark ===================== 网络数据===================================
- (void)netWorkLoadData {
    
    if(self.page == 1) {
            [self.datas removeAllObjects];
    }
    NSUserDefaults *message = [NSUserDefaults standardUserDefaults];
    NSString *dictString = [message objectForKey:@"message"];
    if (dictString != nil) {
        NSDictionary *dict =  [self dictionaryWithJsonString:dictString];
        DLog(@"推送信息%@",dict);
        NSArray *arrMessage = [SystemModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        [arrMessage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SystemModel *model = arrMessage[idx];
            [self.datas addObject:model];
        }];
        [self.tableV reloadData];
    } else {
        
        [self.datas removeAllObjects];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *token = [user objectForKey:@"token"];
        dict[@"token"] = token;
        [CMRequest requestNetSecurityGET:@"/member/messageList" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
            NSArray *arrMessage = [SystemModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
            [arrMessage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SystemModel *model = arrMessage[idx];
                [self.datas addObject:model];
            }];
            [self.tableV reloadData];
            DLog(@"系统消息推送%@",dict);
            
        } errorBlock:^(NSString * _Nonnull message) {
            DLog(@"系统消息错误%@",message);
        } failBlock:^(NSError * _Nonnull error) {
            DLog(@"系统消息网络请求%@",error);
        }];
       
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)setupView {

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar-40, SCREEN_WIDTH, SCREEN_HEIGHT- (kiPhone5 ? 39*2 : Height_TabBar*2)) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableV = tableView;
    tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 220;
    tableView.separatorColor = [UIColor colorWithHexString:@"1a142d"];//设置线的颜色
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"SystemMessageCell" bundle:nil] forCellReuseIdentifier:@"SystemMessageCell"];

    //KKK
//    __weak typeof(self) wself = self;
//    [tableView addInfiniteScrolling:^{
//        [wself  loadMoreRefresh];
//    }];
//    [tableView addPullToRefresh:[LNHeaderDIYAnimator createAnimator] block:^{
//        [wself pullToRefresh];
//    }];
//    [tableView startRefreshing];

}

#pragma mark ===================== 下拉刷新===================================

- (void)pullToRefresh {
    DLog(@"下拉刷新");
    
    //    [self.player stopCurrentPlayingCell];
     self.page++;
    [self netWorkLoadData];
    __weak UITableView *wtableView = self.tableV;


    ///KKK
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [wtableView pullDownDealFooterWithItemCount:self.datas.count cursor:@"11"];
//    });

    
}

#pragma mark ===================== 上拉加载更多===================================

- (void)loadMoreRefresh {
    //    NSLog(@"上拉加载更多");


    ///KKK
//    __weak UITableView *wtableView = self.tableV;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        if (self.totalPage != 0) {
////            if (self.page > self.totalPage) {
////
////                [wtableView noticeNoMoreData];
////                return;
////            }
////        }
////        //                [self playTheIndex:0];
//        self.page++;
////        if (self.classificationString != nil) {
////            [self fuzzySearchLoadData:self.classificationString];
////        } else {
//            [self netWorkLoadData];
////        }
////                [wtableView reloadData];
//        [wtableView endLoadingMore];
//
//    });
}

#pragma mark ===================== 系统协议===================================
/**
 *  告诉tableView一共有多少组数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
/**
 *  告诉tableView第section组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return self.datas.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat heightAll = 0.0;
//    if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
//        heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
//    } else if (kiPhone6Plus) {
//        heightAll = 736.0f;
//    } else {
//        heightAll = iPhone5 ? 568 : 667.0f;
//    }
//    return 60/667.0f*heightAll;
//}
/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   NSString *cellID = [NSString stringWithFormat:@"%@%zd",ID,indexPath.row];
   SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
       cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemMessageCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
    SystemModel *model = self.datas[indexPath.row];
    cell.model = model;
  
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
       SystemModel *model = self.datas[indexPath.row];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link]];
    
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

#pragma mark ===================== 通知===================================

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
