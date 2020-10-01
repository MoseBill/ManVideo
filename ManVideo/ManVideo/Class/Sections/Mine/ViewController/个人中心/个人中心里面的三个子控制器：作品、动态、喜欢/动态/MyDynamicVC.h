//
//  GKDYDynamicController.h
//  Clipyeu ++
//
//  Created by Josee on 15/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDynamicVC : GKDYBaseViewController

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *dynamicString;
@property(nonatomic,assign)NSInteger indexType;
//@property(nonatomic,copy)void(^pageListBlock)(NSString *status);
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray <GKDYVideoModel *>*videoArr;
@property(nonatomic,strong)NSMutableArray <NSURL *>*urlsArr;
//@property(nonatomic,copy)NSString * _Nullable tokenString;
@property(nonatomic,copy)NSString * _Nullable userIdString;

-(void)refreshData:(NSInteger)index;
-(void)refreshAction:(UIButton *_Nonnull)sender;
-(void)endRefreshing:(BOOL)refreshing;

-(void)pullToRefresh;//下拉刷新
-(void)loadMoreRefresh;//上拉加载

-(instancetype)initWithRequestParams:(id _Nullable)requestParams;

@end

NS_ASSUME_NONNULL_END
