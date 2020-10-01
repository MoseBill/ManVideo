//
//  DynamicTableCell.h
//  Clipyeu ++
//
//  Created by Josee on 15/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicTableCell : UITableViewCell

@property (nonatomic, strong) GKDYVideoModel    *model;

@property (nonatomic, strong) NSIndexPath    *indexPath;

@end

NS_ASSUME_NONNULL_END
