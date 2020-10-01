//
//  VDClassificationController.h
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "VDViewController.h"
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VDClassificationController : GKDYBaseViewController

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray <ClassTotalDataModel *>*classTotalDatamutArr;
@property(nonatomic,strong)NSMutableArray *sectionDataMutArr;
@property(nonatomic,strong)NSMutableArray <NSMutableArray *>*videoUrlSectionMutArr;
@property(nonatomic,strong)NSMutableArray *labelArr;
@property(nonatomic,strong)NSMutableArray *valueArr;

- (void)refreshAction:(UIButton *)sender;
-(void)endRefreshing:(BOOL)refreshing;

@end

NS_ASSUME_NONNULL_END
