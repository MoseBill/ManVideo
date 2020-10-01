//
//  SystemMessageCell.m
//  Clipyeu ++
//
//  Created by Josee on 05/06/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SystemMessageCell.h"

@implementation SystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SystemModel *)model {
    
    _model = model;
    
    self.logoImage.image = [UIImage imageNamed:@"logo"];
    self.userName.text = [NSString stringWithFormat:@"%@",model.theme];
    self.contentMsg.text = [NSString stringWithFormat:@"%@",model.text];
    self.createTime.text = [NSString stringWithFormat:@"%ld",(long)model.createTime];
    
}

@end
