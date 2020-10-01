//
//  GKDYHeaderView.m
//  GKPageScrollView
//
//  Created by QuintGao on 2018/10/28.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYHeaderView.h"

@interface GKDYHeaderView()

@property (nonatomic, assign) CGRect        bgImgFrame;
@property (nonatomic, strong) UIImageView   *bgImgView;

@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, strong) UIImageView   *iconImgView;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *dyIdLabel;
/*编辑*/
@property (nonatomic, strong) UIButton     *editorBtn;
/*签名*/
@property (nonatomic, strong) UILabel    *signatureLabel;
/*性别*/
@property (nonatomic, strong) UILabel    *genderLabel;
/*年龄*/
@property (nonatomic, strong) UILabel    *ageLabel;
/*所在城市*/
@property (nonatomic, strong) UILabel    *cityLabel;
/*关注*/
@property (nonatomic, strong) UILabel    *focusLabel;
@property (nonatomic, strong) UILabel    *focusCount;
/*获赞*/
@property (nonatomic, strong) UILabel    *praiseLabel;
@property (nonatomic, strong) UILabel    *praiseCount;
/*粉丝*/
@property (nonatomic, strong) UILabel    *fansLabel;
@property (nonatomic, strong) UILabel    *fansCount;
/*积分兑换*/
@property (nonatomic, strong) UILabel    *pointsLabel;
/*VIP会员*/
@property (nonatomic, strong) UILabel    *vipLabel;

/*设置*/
@property (nonatomic, strong) UIButton    *setBtn;

@end

@implementation GKDYHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImgView];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.dyIdLabel];
     
        [self.contentView addSubview:self.editorBtn];
        [self.contentView addSubview:self.signatureLabel];
        [self.contentView addSubview:self.genderLabel];
        [self.contentView addSubview:self.ageLabel];
        [self.contentView addSubview:self.cityLabel];
        
        [self.contentView addSubview:self.focusCount];
        [self.contentView addSubview:self.focusLabel];
        
        [self.contentView addSubview:self.praiseCount];
        [self.contentView addSubview:self.praiseLabel];
        
        [self.contentView addSubview:self.fansCount];
        [self.contentView addSubview:self.fansLabel];
        [self.contentView addSubview:self.pointsLabel];
        [self.contentView addSubview:self.vipLabel];
        
        [self.contentView addSubview:self.setBtn];
        
        self.bgImgFrame = CGRectMake(0, 0, frame.size.width, 333/667.0f*SCREEN_HEIGHT);
        self.bgImgView.frame = self.bgImgFrame;
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13.0f);
            make.top.equalTo(self).offset(75.0f);
            make.width.height.mas_equalTo(96.0f);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.iconImgView.mas_centerX);
            make.left.equalTo(self.contentView).offset(13.0f);
            make.top.equalTo(self.iconImgView.mas_bottom).offset(6.0f);
        }];
        [self.editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(self.nameLabel.mas_right).offset(9);
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
             make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        
        [self.dyIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(13);
            make.centerX.mas_equalTo(self.nameLabel.mas_centerX);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6.0f);
        }];
        [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(13);
            make.top.mas_equalTo(self.dyIdLabel.mas_bottom).offset(20);
             make.height.mas_equalTo(13);
            
        }];
        
        [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.left.mas_equalTo(13);
             make.top.mas_equalTo(self.signatureLabel.mas_bottom).offset(10);
             make.width.mas_equalTo(40);
             make.height.mas_equalTo(30);
            
        }];
        
        [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.left.mas_equalTo(self.genderLabel.mas_right).offset(7);
             make.centerY.mas_equalTo(self.genderLabel.mas_centerY);
             make.width.mas_equalTo(58);
             make.height.mas_equalTo(30);
        }];
        
        [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ageLabel.mas_right).offset(7);
            make.centerY.mas_equalTo(self.ageLabel.mas_centerY);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(-170);
        }];
        
        [self.focusCount mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(14);
            make.top.mas_equalTo(self.genderLabel.mas_bottom).offset(13);
             make.height.mas_equalTo(14);
        }];
        [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.left.mas_equalTo(self.focusCount.mas_right).offset(10);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        [self.praiseCount  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.focusLabel.mas_right).offset(20);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.praiseCount.mas_right).offset(10);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        [self.fansCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.praiseLabel.mas_right).offset(20);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansCount.mas_right).offset(10);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
        
        [self.pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(109/667.0f*SCREEN_HEIGHT);
            make.right.mas_equalTo(-14/375.0f*SCREEN_WIDTH);
             make.width.mas_equalTo(85);
            make.height.mas_equalTo(30);
        }];
        
        [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.pointsLabel.mas_centerY);
            make.right.mas_equalTo(self.pointsLabel.mas_left).offset(-7);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(30);
        }];
        
        [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(31);
            make.right.mas_equalTo(-15);
             make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
        }];
    }
    return self;
}

- (void)setModel:(GKDYVideoModel *)model {
    _model = model;
    
//    self.nameLabel.text = model.author.name_show;
    self.nameLabel.text = @"@Josee";
    
    self.dyIdLabel.text = [NSString stringWithFormat:@"ID号：%@", model.author.user_id];
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.author.portrait] placeholderImage:[UIImage imageNamed:@"center_man"]];
}

- (void)scrollViewDidScroll:(CGFloat)offsetY {
    CGRect frame = self.bgImgFrame;
    // 上下放大
    frame.size.height -= offsetY;
    frame.origin.y = offsetY;
    
    // 左右放大
    if (offsetY <= 0) {
        frame.size.width = frame.size.height * self.bgImgFrame.size.width / self.bgImgFrame.size.height;
        frame.origin.x   = (self.frame.size.width - frame.size.width) / 2;
    }
    
    self.bgImgView.frame = frame;
}

#pragma mark - 懒加载
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"背景图user"];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
    }
    return _bgImgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = kClearColor;
    }
    return _contentView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"center_man"];
        _iconImgView.layer.cornerRadius = 48.0f;
        _iconImgView.layer.masksToBounds = YES;
//        _iconImgView.layer.borderColor = [UIColor].CGColor;
//        _iconImgView.layer.borderWidth = 3;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIButton *)editorBtn {
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editorBtn setImage:[UIImage imageNamed:@"eide"] forState:UIControlStateNormal];
        _editorBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorBtn;
}

- (UILabel *)dyIdLabel {
    if (!_dyIdLabel) {
        _dyIdLabel = [UILabel new];
        _dyIdLabel.textColor = [UIColor whiteColor];
        _dyIdLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _dyIdLabel;
}

- (UILabel *)signatureLabel {
    if (!_signatureLabel) {
        _signatureLabel = [UILabel new];
        _signatureLabel.text = @"这个人很懒，没有任何留下签名";
        _signatureLabel.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:123/255.0 alpha:1.0];
        _signatureLabel.font =  [UIFont systemFontOfSize:13.0f];
    }
    return _signatureLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = [UILabel new];
        _genderLabel.text = @"男";
        _genderLabel.textAlignment = NSTextAlignmentCenter;
        _genderLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _genderLabel.font = [UIFont systemFontOfSize:13.0f];
        _genderLabel.backgroundColor = [UIColor colorWithRed:62/255.0 green:57/255.0 blue:75/255.0 alpha:1.0];
        _genderLabel.layer.masksToBounds = YES;
        _genderLabel.layer.cornerRadius = 15.0f;
    }
    return _genderLabel;
}



- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = [UILabel new];
        _ageLabel.text = @"20岁";
        _ageLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _ageLabel.font = [UIFont systemFontOfSize:13.0f];
        _ageLabel.backgroundColor =  [UIColor colorWithRed:62/255.0 green:57/255.0 blue:75/255.0 alpha:1.0];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.layer.masksToBounds = YES;
        _ageLabel.layer.cornerRadius = 15.0f;
    }
    return _ageLabel;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [UILabel new];
        _cityLabel.text = @"所在城市";
        _cityLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _cityLabel.font = [UIFont systemFontOfSize:13.0f];
        _cityLabel.backgroundColor =  [UIColor colorWithRed:62/255.0 green:57/255.0 blue:75/255.0 alpha:1.0];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        _cityLabel.layer.masksToBounds = YES;
        _cityLabel.layer.cornerRadius = 15.0f;
    }
    return _cityLabel;
}

- (UILabel *)focusCount {
    if (!_focusCount) {
        _focusCount = [UILabel new];
        _focusCount.text = @"0";
        _focusCount.textColor = kWhiteColor;
        _focusCount.textAlignment = NSTextAlignmentRight;
        _focusCount.font = [UIFont systemFontOfSize:15.0f];
    }
    return _focusCount;
}

- (UILabel *)focusLabel {
    if (!_focusLabel) {
        _focusLabel = [UILabel new];
        _focusLabel.text = @"关注";
        _focusLabel.textColor = kWhiteColor;
        _focusLabel.textAlignment = NSTextAlignmentLeft;
        _focusLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _focusLabel;
}

- (UILabel *)praiseCount {
    if (!_praiseCount) {
        _praiseCount = [UILabel new];
        _praiseCount.text = @"0";
        _praiseCount.textColor = kWhiteColor;
         _focusCount.textAlignment = NSTextAlignmentRight;
        _praiseCount.font = [UIFont systemFontOfSize:15.0f];
    }
    return _praiseCount;
}

- (UILabel *)praiseLabel {
    if (!_praiseLabel) {
        _praiseLabel = [UILabel new];
        _praiseLabel.text = @"获赞";
        _praiseLabel.textColor = kWhiteColor;
        _praiseLabel.textAlignment = NSTextAlignmentLeft;
        _praiseLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _praiseLabel;
}

- (UILabel *)fansCount {
    if (!_fansCount) {
        _fansCount = [UILabel new];
        _fansCount.text = @"0";
        _fansCount.textColor = kWhiteColor;
        _fansCount.textAlignment = NSTextAlignmentRight;
           _fansCount.font = [UIFont systemFontOfSize:15.0f];
    }
    return _fansCount;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [UILabel new];
        _fansLabel.text = @"粉丝";
        _fansLabel.textColor = kWhiteColor;
        _fansLabel.textAlignment = NSTextAlignmentLeft;
        _fansLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _fansLabel;
}

- (UILabel *)pointsLabel {
    if (!_pointsLabel) {
        _pointsLabel = [UILabel new];
        _pointsLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
        _pointsLabel.text = @"积分兑换";
        _pointsLabel.backgroundColor = [UIColor colorWithHexString:@"3E394B"];
        _pointsLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:15];
        _pointsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pointsLabel;
}

- (UILabel *)vipLabel {
    if (!_vipLabel) {
        _vipLabel = [UILabel new];
        _vipLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
        _vipLabel.text = @"VIP";
        _vipLabel.backgroundColor = [UIColor colorWithHexString:@"3E394B"];
        _vipLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:15];
        _vipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vipLabel;
}

- (UIButton *)setBtn {
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [_setBtn addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

- (void)editorBtnClick:(UIButton *)sender {
    
    
}

- (void)setClick:(UIButton *)click {
    
}

@end
