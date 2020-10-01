//
//  PersonalCenterVC.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/24.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "GKDYVideoModel.h"
#import "GKDYPersonalModel.h"
#import "GKDYHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCenterVC : GKDYBaseViewController

@property(nonatomic,strong)GKDYHeaderView *headerView;//上部承接
@property(nonatomic,strong)JXCategoryBaseView *categoryView;
@property(nonatomic,strong)JXCategoryListContainerView *listContainerView;
@property(nonatomic,strong)NSMutableDictionary *dic;
@property(nonatomic,assign)BOOL isNeedIndicatorPositionChangeItem;
@property(nonatomic,copy)NSString *personString;
@property(nonatomic,copy)NSString *tokenString;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *byId;
@property(nonatomic,assign)int likeCount;/*喜欢数量*/
@property(nonatomic,assign)int videoCount;/*作品数量*/
@property(nonatomic,assign)int dynamicCountString;/*动态数量*/
@property(nonatomic,strong)GKDYPersonalModel *modelPersonal;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;
//网络请求
- (void)loadDataView;

@end

NS_ASSUME_NONNULL_END
