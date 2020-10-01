//
//  BlockTableViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "BlockTableViewCell.h"

@interface BlockTableViewCell ()

@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UILabel    *timeLabel;
@property (nonatomic, strong) UIButton    *delegateBtn;
@property (nonatomic, strong) UIImageView  *headerImage;

@end

@implementation BlockTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"050013"];
        
        [self.contentView addSubview:self.headerImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.delegateBtn];
        
       
       
    }
    return self;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//   
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
        //        make.top.mas_equalTo(5);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        
    }];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = self.headerImage.height/2.0f;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.headerImage.mas_right).offset(11);
        make.top.mas_equalTo(7);
         make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(17);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {

         make.left.mas_equalTo(self.headerImage.mas_right).offset(11);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(7);
         make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(11);
    }];

    [self.delegateBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-13);
         make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);

    }];
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [UIImageView new];
        _headerImage.image = [UIImage imageNamed:@"defaultUserIcon"];
        
    }
    return _headerImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
//        _nameLabel.text = @"手机用户";
        _nameLabel.textColor = [UIColor colorWithHexString:@"D0D1D2"];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
//        _timeLabel.text = @"2019-01-23";
        _timeLabel.textColor = [UIColor colorWithHexString:@"D0D1D2"];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _timeLabel;
}

- (UIButton *)delegateBtn {
    if (!_delegateBtn) {
        _delegateBtn = [UIButton new];
        [_delegateBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_delegateBtn addTarget:self action:@selector(delegateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delegateBtn;
}

- (void)delegateClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(blockClick:)]) {
        [self.delegate blockClick:sender];
    }
}

@end
