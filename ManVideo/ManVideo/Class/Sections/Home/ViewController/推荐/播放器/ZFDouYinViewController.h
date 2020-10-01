//
//  ZFDouYinViewController.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"

@interface ZFDouYinViewController : GKDYBaseViewController

@property(nonatomic,strong)UITableView * _Nullable tableView;
@property(nonatomic,assign)__block BOOL isFirstRequestData;
@property(nonatomic,assign)long dataSourceCount;
@property(nonatomic,assign)bool isPullToRefresh;
@property(nonatomic,strong)CommonModel * _Nullable commonModel;
@property(nonatomic,copy)NSString * _Nullable tokenString;
@property(nonatomic,copy)NSString * _Nullable userString;
@property(nonatomic,copy)NSString * _Nullable videoUrl;
@property(nonatomic,assign)int currentIndex;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger indexPathRow;
@property(nonatomic,assign)NSInteger indexPathSection;
@property(nonatomic,strong)NSMutableDictionary * _Nullable dict;
@property(nonatomic,strong)NSMutableArray <CommonModel *>* _Nullable dataSource;
@property(nonatomic,strong)NSMutableArray <NSURL *>* _Nullable urls;
@property(nonatomic,strong)NSMutableArray <NSString *>* _Nullable userIds;
@property(nonatomic,copy)void(^ _Nullable douYinBlock)(NSString * _Nullable videoHeight);
@property(nonatomic,copy)void(^ _Nullable likeCountBlock)(int like);
@property(nonatomic,copy)void(^ _Nullable shareCountBlock)(int share);
@property(nonatomic,copy)void(^ _Nullable messageCountBlock)(int message);
@property(nonatomic,copy)void(^ _Nullable UuidStringBlock)(NSString * _Nullable uuid);


+(instancetype _Nonnull)pushFromVC:(UIViewController *_Nullable)rootVC
                     requestParams:(nullable id)requestParams
                           success:(DataBlock _Nullable)block
                          animated:(BOOL)animated;
-(void)playTheVideoAtIndexPath:(NSIndexPath *_Nonnull)indexPath
                    scrollToTop:(BOOL)scrollToTop;
-(void)findAvailableResourceAndPlay;
-(void)playTheIndex:(NSInteger)index;
-(void)refreshAction:(UIButton *_Nonnull)sender;
-(void)endRefreshing:(BOOL)refreshing;

@end
