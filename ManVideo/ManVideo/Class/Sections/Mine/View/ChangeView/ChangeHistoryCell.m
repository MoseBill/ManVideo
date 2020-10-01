//
//  ChangeHistoryCell.m
//  Clipyeu ++
//
//  Created by Josee on 28/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChangeHistoryCell.h"

@interface ChangeHistoryCell ()



@end

@implementation ChangeHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (kiPhone5) {
        self.changeGift.font = [UIFont systemFontOfSize:9.0f];
    } else if (kiPhone6) {
        self.changeGift.font = [UIFont systemFontOfSize:15.0f];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
