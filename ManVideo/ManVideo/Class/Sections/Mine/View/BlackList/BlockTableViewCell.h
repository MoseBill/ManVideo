//
//  BlockTableViewCell.h
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BlockTableDelegate <NSObject>

- (void)blockClick:(UIButton *)sender;

@end


@interface BlockTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BlockTableDelegate > delegate;

@property (nonatomic, strong) NSArray    *dataArr;

@end

NS_ASSUME_NONNULL_END
