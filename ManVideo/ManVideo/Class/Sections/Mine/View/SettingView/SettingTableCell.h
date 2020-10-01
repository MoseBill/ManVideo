//
//  SettingTableCell.h
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingTableCell : UITableViewCell

@property(weak,nonatomic)IBOutlet UILabel *mbLabel;
@property(weak,nonatomic)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UILabel *cleanLabel;

@end

NS_ASSUME_NONNULL_END
