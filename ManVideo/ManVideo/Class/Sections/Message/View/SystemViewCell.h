//
//  SystemViewCell.h
//  Clipyeu ++
//
//  Created by Josee on 27/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemViewCell : UITableViewCell


@property (nonatomic, strong) SystemModel    *model;

@property (nonatomic, strong) NSString    *typeString;

@end

NS_ASSUME_NONNULL_END
