//
//  TPLChooseCell.m
//  WelfarePlatform
//
//  Created by 万佳阳 on 2018/4/15.
//  Copyright © 2018年 JYWan. All rights reserved.
//

#import "TPLChooseCell.h"
#import "ClassModel.h"

@interface TPLChooseCell()

@property (weak, nonatomic) IBOutlet UILabel *hotTitle;

//@property (weak, nonatomic) IBOutlet UILabel *hotlabel;

@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@end

@implementation TPLChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hotLabel.layer.masksToBounds = YES;
    self.hotLabel.layer.cornerRadius = self.hotLabel.height/2.0f;
    self.hotLabel.layer.borderColor = [UIColor colorWithHexString:@"D32EA6"].CGColor;
    self.hotLabel.layer.borderWidth = 1.0f;
    self.hotLabel.text = NSLocalizedString(@"VDHotLabelsText", nil);
}

- (void)setItem:(Data *)item {
    
  _item = item;
  
//  [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.imgUrl]];
//  self.titleLab.text = @"巨乳";
}

- (void)loadDataArr:(NSArray *)array indexPath:(NSIndexPath *)index {
    self.hotLabel.text = array[index.row];

}

@end
