//
//  GKDYListViewController.h
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "GKDYVideoModel.h"
//#import "QQtableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLikeVC : GKDYBaseViewController

@property(nonatomic,strong)UICollectionView  *collectionView;
//@property(nonatomic,copy)void(^pageListBlock)(NSString *status);//?
@property(nonatomic,assign)NSInteger indexType;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,strong)NSMutableArray <GKDYVideoModel *>*videoArr;
@property(nonatomic,strong)NSMutableArray <NSURL *>*urlsArr;
//@property(nonatomic,copy)NSString * _Nullable tokenString;
@property(nonatomic,copy)NSString * _Nullable userIdString;

-(void)refreshData:(NSInteger)index;
-(void)refreshNetworkData:(NSInteger)index;//??

-(void)pullToRefresh;//下拉刷新
-(void)loadMoreRefresh;//上拉加载

-(void)refreshAction:(UIButton *_Nonnull)sender;
-(void)endRefreshing:(BOOL)refreshing;

-(instancetype)initWithRequestParams:(id _Nullable)requestParams;

@end

NS_ASSUME_NONNULL_END
  
