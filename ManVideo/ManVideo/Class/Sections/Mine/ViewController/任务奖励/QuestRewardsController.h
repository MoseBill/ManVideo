//
//  QuestRewardsController.h
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 积分兑换 —— 任务奖励
@interface QuestRewardsController : GKDYBaseViewController

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <GKDYPersonalModel *>*arrRewards;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
