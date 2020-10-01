//
//  VDListTableViewCell.h
//  iOSMovie
//
//  Created by Josee on 10/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

//#import "VDTableViewCell.h"
#import <UIKit/UIKit.h>
#import "VDCircleCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VDListTableViewCell : UITableViewCell

@property (nonatomic,strong) VDCircleCellViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
