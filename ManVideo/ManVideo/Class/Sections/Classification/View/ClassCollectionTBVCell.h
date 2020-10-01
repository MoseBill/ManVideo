//
//  VDClassCollectionViewCell.h
//  Clipyeu ++
//
//  Created by Josee on 24/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDCollectionViewCell.h"
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VDClassCollectionDelegate <NSObject>

- (void)videoClickIndexPathRow:(NSInteger)row
              IndexPathSection:(NSInteger)section
                     actionArr:(NSMutableArray *)videoArr
                      modelArr:(NSMutableArray <ClassModel *>*)modelArr;

@end

@interface ClassCollectionTBVCell : UITableViewCell

@property(nonatomic,strong)UIView *colorView;
@property(nonatomic,strong)ClassTotalDataModel *classTotalDataModel;
@property(nonatomic,strong)NSMutableArray <NSString *>*videoArr;
@property(nonatomic,strong)NSMutableArray *rowDataMutArr;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,copy)void(^classCollectionBlock)(NSMutableArray *videos);
@property(nonatomic,weak)id<VDClassCollectionDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
