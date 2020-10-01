//
//  GKDYWorksController.h
//  Clipyeu ++
//
//  Created by Josee on 06/06/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyProductsVC : GKDYBaseViewController

@property(nonatomic,strong)UICollectionView  *collectionView;
//@property(nonatomic,copy)void(^pageListBlock)(NSString *status);
@property(nonatomic,assign)NSInteger indexType;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,strong)NSMutableArray <GKDYVideoModel *>*videos;
@property(nonatomic,strong)NSMutableArray <NSURL *>*urlsArr;
//@property(nonatomic,copy)NSString * _Nullable tokenString;
@property(nonatomic,copy)NSString * _Nullable userIdString;
@property(nonatomic,copy)NSString *_Nullable byId;

-(void)refreshData:(NSInteger)index;
-(void)refreshNetworkData:(NSInteger)index;
-(void)pullToRefresh;//下拉刷新
-(void)loadMoreRefresh;//上拉加载

-(void)refreshAction:(UIButton *_Nonnull)sender;
-(void)endRefreshing:(BOOL)refreshing;

-(instancetype)initWithRequestParams:(id _Nullable)requestParams;

@end

NS_ASSUME_NONNULL_END
