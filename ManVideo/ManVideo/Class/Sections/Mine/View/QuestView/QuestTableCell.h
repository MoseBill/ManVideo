//
//  QuestTableCell.h
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYPersonalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestTableCell : UITableViewCell

@property(weak,nonatomic)IBOutlet UILabel *titleLabel;
@property(weak,nonatomic)IBOutlet UILabel *questCount;
@property(weak,nonatomic)IBOutlet UIButton *successBtn;
@property(weak,nonatomic)IBOutlet UILabel *detailLabel;
@property(nonatomic,strong)NSIndexPath *indexPath;

- (void)richElementsInCellWithModel:(GKDYPersonalModel *)model
                      WithIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
