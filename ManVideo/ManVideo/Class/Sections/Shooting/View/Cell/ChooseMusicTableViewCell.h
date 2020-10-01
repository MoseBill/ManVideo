//
//  ChooseMusicTableViewCell.h
//  ManVideo
//
//  Created by Josee on 20/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseMusicTableViewCell : VDTableViewCell

@property (nonatomic, copy) void(^musicBtnBlock)(NSInteger index);

- (void)cellSelectClick:(UIButton *)click Indexpath:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END
