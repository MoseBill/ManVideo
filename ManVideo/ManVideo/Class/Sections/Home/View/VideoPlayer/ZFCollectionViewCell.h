//
//  ZFCollectionViewCell.h
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"

@interface ZFCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)CommonModel *commonModel;

- (void)setCommonModel:(CommonModel *)model
                andTag:(NSIndexPath*)index;

@end
