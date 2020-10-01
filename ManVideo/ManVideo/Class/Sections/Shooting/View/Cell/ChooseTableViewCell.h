//
//  ChooseTableViewCell.h
//  Clipyeu ++
//
//  Created by Josee on 31/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChooseModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CollectionMusicDelegate <NSObject>

- (void)collectionMusicActionIndex:(NSInteger)index;

@end

@class ChooseModel;
typedef void(^HYBHeaderViewExpandCallback)(BOOL isExpanded);

@interface ChooseTableViewCell : UITableViewHeaderFooterView

@property (nonatomic, strong) id<CollectionMusicDelegate> delegate;

@property (nonatomic, strong) ChooseModel *model;

- (void)loadIndexPath:(NSIndexPath *)index;

@property (nonatomic, copy) HYBHeaderViewExpandCallback expandCallback;

@property (nonatomic, copy) void(^collectionActionBlock)(NSInteger index);

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UIButton    *likeBtn;

@property (nonatomic, strong) NSMutableArray    *dataArr;

@property (nonatomic, strong) NSMutableArray    *collectionArr;

@end

NS_ASSUME_NONNULL_END
