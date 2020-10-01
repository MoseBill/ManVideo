//
//  ChangeHistoryCell.h
//  Clipyeu ++
//
//  Created by Josee on 28/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *changeGift;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeIntail;

@end

NS_ASSUME_NONNULL_END
