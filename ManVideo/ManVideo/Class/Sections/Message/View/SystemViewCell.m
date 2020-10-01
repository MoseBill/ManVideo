//
//  SystemViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 27/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SystemViewCell.h"

@interface SystemViewCell()


@property (nonatomic, strong) UILabel    *titleLabel;
@property (nonatomic, strong) UILabel    *contentMsg;
@property (nonatomic, strong) UILabel    *timeLabel;
@property (nonatomic, strong) UIButton    *focusOn;
@property (nonatomic, strong) UIImageView  *logoImage;

@end

@implementation SystemViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//
//    self.enterGame.layer.masksToBounds = YES;
//    self.enterGame.layer.cornerRadius = 5.0f;
//    self.msgImage.hidden = YES;
//    self.enterGame.hidden = YES;
//
//    self.focusOn.layer.masksToBounds = YES;
//    self.focusOn.layer.cornerRadius = 4.0f;
//
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.logoImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.focusOn];
        [self.contentView addSubview:self.contentMsg];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
        CGFloat heightAll = 0.0;
        if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
            heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
        } else if (kiPhone6Plus) {
            heightAll = 736.0f;
        } else {
            heightAll = kiPhone5 ? 568 : 667.0f;
        }
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(11);
//        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(39);
    }];
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.layer.cornerRadius = 39/2.0f;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.logoImage.mas_right).offset(10);
        make.top.mas_equalTo(11);
       
        make.height.mas_equalTo(19);
    }];
    
    [self.contentMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.logoImage.mas_right).offset(10);
        make.top.mas_equalTo(26/667.0f*heightAll);
         make.right.mas_equalTo(-60);
//        make.height.mas_equalTo(16);
          make.bottom.mas_equalTo(-8);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentMsg.mas_bottom).offset(8);
         make.left.mas_equalTo(62);
         make.width.mas_equalTo(70);
        make.height.mas_equalTo(11);
        make.bottom.mas_equalTo(-4);
    }];
    
    [self.focusOn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
         make.width.mas_equalTo(80);
        make.height.mas_equalTo(22);
//          make.bottom.mas_equalTo(-29);
    }];
    self.focusOn.layer.masksToBounds = YES;
    self.focusOn.layer.cornerRadius = 3.0f;
    
}

- (void)setModel:(SystemModel *)model {
    
    _model = model;
    if (model.headerImage != nil) {
          [self.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_URL,model.headerImage]] placeholderImage:[UIImage imageNamed:@"userImage"]];
    }
    if (model.text) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",model.text];
    }
//    if (model.headerImage) {
    if (model.userName) {
         self.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)model.userName];
    }
    if (model.theme) {
        self.contentMsg.text = [NSString stringWithFormat:@"%@",model.theme];
    }
    if (model.createDate) {
        NSString *string = [NSString stringWithFormat:@"%@",model.createDate];
        NSString *time = [string substringToIndex:10];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",time];
    }
    if (self.typeString.length != 0) {
        if ([self.typeString isEqualToString:NSLocalizedString(@"VDlikeText", nil)]) {
            self.contentMsg.text = NSLocalizedString(@"VDzanleni", nil);
            self.focusOn.hidden = YES;
        } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDShare", nil)]) {
            self.contentMsg.text = NSLocalizedString(@"VDfenxiangzuop", nil);
            self.focusOn.hidden = YES;
        } else if ([self.typeString isEqualToString:NSLocalizedString(@"VDcommentsText", nil)]) {
            self.contentMsg.text = NSLocalizedString(@"VDpinglunlni", nil);
            self.focusOn.hidden = YES;
        } else {
            self.focusOn.hidden = NO;
            self.contentMsg.text = NSLocalizedString(@"VDguanzhu", nil);
        }
    }

//    }
}

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [UIImageView new];
        _logoImage.image = [UIImage imageNamed:@"logo"];
    }
    return _logoImage;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = [NSString stringWithFormat:@"Clipyeu++"];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _titleLabel;
}

- (UILabel *)contentMsg {
    if (!_contentMsg) {
        _contentMsg = [[UILabel alloc]init];
        _contentMsg.text = [NSString stringWithFormat:NSLocalizedString(@"VDguanzhu", nil)];
        _contentMsg.textColor = kWhiteColor;
        _contentMsg.font = [UIFont systemFontOfSize:15];
    }
    return _contentMsg;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor= [UIColor colorWithHexString:@"B0B0B0"];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.text = @"";
    }
    return  _timeLabel;
}

- (UIButton *)focusOn {
    if (!_focusOn) {
        _focusOn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_focusOn setTitle:NSLocalizedString(@"VDFocusText", nil) forState:UIControlStateNormal];
        [_focusOn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_focusOn setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
        _focusOn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_focusOn addTarget:self action:@selector(focusOnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusOn;
}

- (void)focusOnAction:(UIButton*)action {
    
    action.selected = !action.selected;
    if (action.selected) {
        [action setTitle:NSLocalizedString(@"VDhuxiang", nil) forState:UIControlStateNormal];
        action.backgroundColor = [UIColor colorWithHexString:@"B0B0B0"];
    } else {
        [action setTitle:NSLocalizedString(@"VDFocusText", nil) forState:UIControlStateNormal];
        action.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    }
}



@end
