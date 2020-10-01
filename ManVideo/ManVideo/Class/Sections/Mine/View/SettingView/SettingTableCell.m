//
//  SettingTableCell.m
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SettingTableCell.h"

@implementation SettingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.image = [[UIImageView alloc]init];
  
    [self addSubview:self.image];
    self.image.sd_layout.rightSpaceToView(self, 13).widthIs(24).heightIs(24).centerYEqualToView(self);
  
    self.cleanLabel = [[UILabel alloc]init];
    self.cleanLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.cleanLabel];
    [self.cleanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
         make.width.mas_equalTo(67*375.0f/SCREEN_WIDTH);
        make.height.mas_equalTo(23);
    }];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];
}

@end
