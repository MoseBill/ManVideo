//
//  InviteFriendsController.h
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "HistoryModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteFriendsController : GKDYBaseViewController

@property(nonatomic,strong)HistoryModel *modelHistory;
@property(nonatomic,strong)UILabel *codeLabel;

@end

NS_ASSUME_NONNULL_END
