//
//  FourMessageController.m
//  Clipyeu ++
//
//  Created by Josee on 10/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "FourMessageController.h"

#import "SystemViewCell.h"

#import "SystemModel.h"


@interface FourMessageController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView *tableV;
@property(nonatomic,strong)UIView *tabView;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int totalPage;

@end

static NSString *ID = @"SystemViewCell";

@implementation FourMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navTitle =  self.typeString;
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
#pragma mark =====================  评论===================================
- (void)netCommentWork {
    [self.datas removeAllObjects];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userString = [user objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
    int userId = [userString intValue];
    NSNumber *number = [NSNumber numberWithInt:userId];
    NSDictionary *dict = @{@"id":number,@"commentStatus":@"2",@"token":token};
    [CMRequest requestNetSecurityGET:@"/videoUploading/commentList" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"查看评论%@",dict);
        NSArray *modelArr = [SystemModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        for (int i =0; i < modelArr.count; i++) {
            SystemModel *model = modelArr[i];
            [self.datas addObject:model];
        }
        [self.tableV reloadData];
    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"查看评论错误%@",message);
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
}
#pragma mark ===================== 分享===================================
- (void)netWorkShare {
    
    [self.datas removeAllObjects];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userString = [user objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
   int userId = [userString intValue];
    NSNumber *number = [NSNumber numberWithInt:userId];
    NSDictionary *dict = @{@"id":number,@"shareStatus":@"2",@"token":token};
    [CMRequest requestNetSecurityGET:@"/videoUploading/shareList" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"查看分享成功%@",dict);
        NSArray *modelArr = [SystemModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        for (int i =0; i < modelArr.count; i++) {
            SystemModel *model = modelArr[i];
            [self.datas addObject:model];
        }
        [self.tableV reloadData];
    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"查看分享错误%@",message);
    } failBlock:^(NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark ===================== 点赞===================================
- (void)netWorkLike {
    
    [self.datas removeAllObjects];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userString = [user objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
    int userId = [userString intValue];
    NSNumber *number = [NSNumber numberWithInt:userId];
    NSDictionary *dict = @{@"id":number,@"spotStatus":@"2",@"token":token};
    
    [CMRequest requestNetSecurityGET:@"/videoUploading/spotFabulousList"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
        
                            DLog(@"查看点赞成功%@",dict);
                            NSArray *modelArr = [SystemModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                            for (int i =0; i < modelArr.count; i++) {
                                SystemModel *model = modelArr[i];
                                [self.datas addObject:model];
                            }
                            [self.tableV reloadData];
    } errorBlock:^(NSString * _Nonnull message) {
         DLog(@"查看点赞错误%@",message);
    } failBlock:^(NSError * _Nonnull error) {}];
    
}

#pragma mark ===================== 粉丝===================================
- (void)netWorkLoadData {
    
    [self.datas removeAllObjects];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userString = [user objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
    int userId = [userString intValue];
    NSNumber *number = [NSNumber numberWithInt:userId];
    NSDictionary *dict = @{@"id":number,@"followStatus":@"2",@"token":token};
    [CMRequest requestNetSecurityGET:@"/member/followList/"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
                            NSArray *modelArr = [SystemModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                            for (int i =0; i < modelArr.count; i++) {
                                SystemModel *model = modelArr[i];
                                [self.datas addObject:model];
                            }
                            [self.tableV reloadData];
    } errorBlock:^(NSString * _Nonnull message) {
    } failBlock:^(NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
    }];
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
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)setupView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT- (kiPhone5 ? 39*2 : Height_TabBar*2)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableV = tableView;
    tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    tableView.separatorColor = [UIColor colorWithHexString:@"1a142d"];//设置线的颜色
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
//    [tableView registerNib:[UINib nibWithNibName:@"SystemViewCell" bundle:nil] forCellReuseIdentifier:@"SystemViewCell"];
//    [tableView registerClass:[SystemViewCell class] forCellReuseIdentifier:ID];

    ///KKK
//    __weak typeof(self) wself = self;
//    [tableView addInfiniteScrolling:^{
//        [wself  loadMoreRefresh];
//    }];
//
//    [tableView addPullToRefresh:[LNHeaderDIYAnimator createAnimator] block:^{
//        [wself pullToRefresh];
//    }];
//    [tableView startRefreshing];
}

#pragma mark ===================== 下拉刷新===================================

- (void)pullToRefresh {
    DLog(@"下拉刷新");
    
    if ([self.typeString isEqualToString:NSLocalizedString(@"VDlikeText", nil)]) {
        [self netWorkLike];
    } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDfansText", nil)]) {
        [self netWorkLoadData];
    } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDShare", nil)]) {
        [self netWorkShare];
    } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDcommentsText", nil)]) {
        [self netCommentWork];
    }

    ///KKK
//    __weak UITableView *wtableView = self.tableV;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        self.page++;
//        [wtableView pullDownDealFooterWithItemCount:self.datas.count cursor:@"11"];
//    });
//

}

#pragma mark ===================== 上拉加载更多===================================
static NSUInteger num = 0;
- (void)loadMoreRefresh {
    //    NSLog(@"上拉加载更多");
  
    __weak UITableView *wtableView = self.tableV;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        if (self.totalPage != 0) {
        //            if (self.page > self.totalPage) {
        //
        //                [wtableView noticeNoMoreData];
        //                return;
        //            }
        //        }
        //        //                [self playTheIndex:0];
        //        self.page++;
        //        if (self.classificationString != nil) {
        //            [self fuzzySearchLoadData:self.classificationString];
        //        } else {
        //
        if ([self.typeString isEqualToString:NSLocalizedString(@"VDlikeText", nil)]) {
            [self netWorkLike];
        } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDfansText", nil)]) {
            [self netWorkLoadData];
        } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDShare", nil)]) {
            [self netWorkShare];
        } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDcommentsText", nil)]) {
            [self netCommentWork];
        }
        //        }
        //                [wtableView reloadData];
        ///KKK
//        [wtableView endLoadingMore];
    });
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightAll = 0.0;
        if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
            heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
        } else if (kiPhone6Plus) {
            heightAll = 736.0f;
        } else {
            heightAll = kiPhone5 ? 568 : 667.0f;
        }
    return 70/667.0f*heightAll;
}
/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = [NSString stringWithFormat:@"%@%zd",ID,indexPath.row];
    SystemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       if (!cell) {
             cell=[[SystemViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
              [cell setValue:cellID forKey:@"reuseIdentifier"];
        }
    cell.typeString = self.typeString;
//    [cell.enterGame setTitle:NSLocalizedString(@"VDenterGameText", nil) forState:UIControlStateNormal];
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



@end
