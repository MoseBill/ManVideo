//
//  SystemMessageCell.h
//  Clipyeu ++
//
//  Created by Josee on 05/06/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SystemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SystemMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *contentMsg;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (nonatomic, strong) SystemModel *model;

@end

NS_ASSUME_NONNULL_END
