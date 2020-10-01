//
//  GKDYHeaderView.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/21.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYHeaderView.h"

@interface GKDYHeaderView (){
    
}

@property(nonatomic,assign)CGRect bgImgFrame;
@property(nonatomic,strong)UIImageView *editorIMGV;/*编辑*/
@property(nonatomic,strong)UILabel *vipLabel;/*VIP会员*/
@property(nonatomic,strong)UITapGestureRecognizer *tap;

@end

@implementation GKDYHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame
                               type:ZoomHeaderViewTypeCodeConstraint]) {
         [self setupUI];
    }return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor colorWithHexString:@"050013"];

    self.contentView.alpha = 1;
    self.userIconBtn.alpha = 1;
    self.nameLabel.alpha = 1;
    self.dyIdLabel.alpha = 1;
    self.editorIMGV.alpha = 1;
    self.signatureLabel.alpha = 1;
    self.genderLabel.alpha = 1;
    self.ageLabel.alpha = 1;
//    self.cityLabel.alpha = 1;
    self.focusCount.alpha = 1;//
    self.focusLabel.alpha = 1;//
    self.praiseCount.alpha = 1;//
    self.praiseLabel.alpha = 1;//
    self.fansCount.alpha = 1;//
    self.fansLabel.alpha = 1;//
    self.pointsBtn.alpha = 1;//
    self.vipLabel.alpha = 1;
//    self.userBtn.alpha = 1;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    if (self.userId) {
//        //        [self.pointsBtn setTitle:NSLocalizedString(@"VDFocusText", nil) forState:UIControlStateNormal];
//    } else {
//        [self.pointsBtn setTitle:NSLocalizedString(@"VDPointsText", nil)
//                        forState:UIControlStateNormal];
//    }
//}

#pragma mark —— 点击事件
- (void)pointsAction:(UIButton *)sender {

//    [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
    if (![self.userId isEqualToString:@"0"] && self.userId) {//发布者 —— 关注 & 未关注
        [sender setTitle:NSLocalizedString(@"VDyiguanzhu", nil)
                forState:UIControlStateSelected];
        [sender setTitle:NSLocalizedString(@"VDFocusText", nil)
                forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(focusOnActionDelegate:)]) {
            [self.delegate focusOnActionDelegate:sender];
        }
    } else {//本人 —— 积分兑换 self.userId = 0 
        if ([self.delegate respondsToSelector:@selector(clickQuestDelegateButton:)]) {
            [self.delegate clickQuestDelegateButton:sender];
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(tapActionDelegateClick:)]) {
        [self.delegate tapActionDelegateClick:sender];
    }
}

-(void)userIconBtnClickEvent:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(userPushViewDelegate:)]) {
        [self.delegate userPushViewDelegate:sender];
    }
}

-(UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                      action:@selector(tapAction:)];
    }return _tap;
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    NSLog(@"b %@",userId);
    NSLog(@"a %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
//    if ([userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]]) {
//        NSLog(@"1");
//    }else{
//        NSLog(@"2");
//    }
}

- (void)setUserModel:(GKDYPersonalModel *)userModel {
    _userModel = userModel;
    DLog(@"头像%@",userModel.headerImage);
    NSString *headerImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"];
    NSString *imageString;
    if (userModel.headerImage) {
        imageString  = [NSString stringWithFormat:@"%@%@",REQUEST_URL,userModel.headerImage];
    } else {
        imageString  = [NSString stringWithFormat:@"%@%@",REQUEST_URL,headerImage];
    }

    [self.userIconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageString]
                                          forState:UIControlStateNormal
                                  placeholderImage:[UIImage imageNamed:@"userCenter_selected"]];

    if (userModel.username) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",userModel.username];
    }
    if (userModel.sex.length != 0) {
        self.genderLabel.text = [NSString stringWithFormat:@"%@",userModel.sex];
    } else {
        self.genderLabel.text = NSLocalizedString(@"VDgenderText", nil);
    }
    if (userModel.birthday.length != 0) {
        int  ageString = [[userModel.birthday substringToIndex:5] intValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeString = [formatter stringFromDate:[NSDate date]];
        int age = [[timeString substringToIndex:4] intValue];
        int sum = age - ageString;

        DLog(@"当前时间 %d", ageString);
        self.ageLabel.text = [NSString stringWithFormat:@"%d",sum];
    }
//    if (userModel.loginAddress) {
//        self.cityLabel.text =  [NSString stringWithFormat:@"%@",userModel.loginAddress];
//    }
    if (userModel.followCount) {
        self.fansCount.text = [NSString stringWithFormat:@"%@",userModel.followCount];
    }
    if (userModel.floowCount) {
        self.focusCount.text = [NSString stringWithFormat:@"%@",userModel.floowCount];
    }
    if (userModel.praiseCount) {
        self.praiseCount.text = [NSString stringWithFormat:@"%@",userModel.praiseCount];
    }
    if (userModel.agentAcct) {
        self.signatureLabel.text = [NSString stringWithFormat:@"%@",userModel.agentAcct];
    }
    if (userModel.ID) {
        self.dyIdLabel.text = [NSString stringWithFormat:@"ID：%ld", (long)userModel.ID];
    }
    if ([userModel.vipLevel intValue] == 1) {
        self.vipLabel.text = NSLocalizedString(@"VDsilver", nil);
    } else if ([userModel.vipLevel intValue] == 2) {
        self.vipLabel.text = NSLocalizedString(@"VDGold", nil);
    } else if ([userModel.vipLevel intValue] == 3) {
        self.vipLabel.text = NSLocalizedString(@"VDdiamond", nil);
    } else if ([userModel.vipLevel intValue] == 4) {
        self.vipLabel.text = NSLocalizedString(@"VDsuper", nil);
    } else {
        self.vipLabel.text = NSLocalizedString(@"VDmembers", nil);
    }

    if (self.isPush) {
        if (userModel.follwStatus == 2) {
            [self.pointsBtn setTitle:NSLocalizedString(@"VDFocusText", nil)
                            forState:UIControlStateNormal];//关注
        } else {
            [self.pointsBtn setTitle:NSLocalizedString(@"VDyiguanzhu", nil)
                            forState:UIControlStateNormal];//已关注
        }
    }else{
        [self.pointsBtn setTitle:NSLocalizedString(@"VDPointsText", nil)
                        forState:UIControlStateNormal];//积分兑换
    }
}

- (UIImage *)imageForKey:(NSString *)key{
    UIImage *image = [self.dictionary objectForKey:key];
    if (!image) {
        NSString *path = [self imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            [self.dictionary setObject:image forKey:key];
        }else{
            DLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }return image;
}

-(NSString *)imagePathForKey:(NSString *)key{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

#pragma mark - LazyLoad
-(NSMutableDictionary *)dictionary{
    if (!_dictionary) {
        _dictionary = NSMutableDictionary.dictionary;
    }return _dictionary;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
        _contentView.backgroundColor = kClearColor;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }return _contentView;
}

- (UIButton *)userIconBtn {
    if (!_userIconBtn) {
        _userIconBtn = UIButton.new;
        _userIconBtn.layer.masksToBounds = YES;
        _userIconBtn.layer.cornerRadius = 48.0f;
        [_userIconBtn addTarget:self
                         action:@selector(userIconBtnClickEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_userIconBtn];
        [_userIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13.0f);
            make.top.equalTo(self).offset(IS_IPHONE_X ? 104 : 84.0f);
            make.width.height.mas_equalTo(96.0f);
        }];
    }return _userIconBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.new;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size: 18];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = [NSString stringWithFormat:@"Clipyeu++"];
        [self.contentView addSubview:_nameLabel];//
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.userIconBtn.mas_centerX);
            make.left.equalTo(self.contentView).offset(13.0f);
            make.top.equalTo(self.userIconBtn.mas_bottom).offset(6.0f);
        }];
    }return _nameLabel;
}

- (UIImageView *)editorIMGV {
    if (!_editorIMGV) {
        _editorIMGV = UIImageView.new;
        _editorIMGV.image = kIMG(@"eide");
        _editorIMGV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_editorIMGV];
        [_editorIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(9);
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
    }return _editorIMGV;
}

- (UILabel *)dyIdLabel {
    if (!_dyIdLabel) {
        _dyIdLabel = UILabel.new;
        _dyIdLabel.textColor = kWhiteColor;
        _dyIdLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_dyIdLabel];//
        [_dyIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.nameLabel.mas_centerX);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6.0f);
        }];
    }return _dyIdLabel;
}

- (UILabel *)signatureLabel {
    if (!_signatureLabel) {
        _signatureLabel = UILabel.new;
        _signatureLabel.text = NSLocalizedString(@"VDsignatureContentText", nil);
        _signatureLabel.textColor = [UIColor colorWithRed:125/255.0
                                                    green:125/255.0
                                                     blue:123/255.0
                                                    alpha:1.0];
        _signatureLabel.font =  [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_signatureLabel];//
        [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(self.dyIdLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(13);
        }];
    }return _signatureLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = UILabel.new;
        _genderLabel.text = NSLocalizedString(@"VDgenderText", nil);
        _genderLabel.textAlignment = NSTextAlignmentCenter;
        _genderLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _genderLabel.font = [UIFont systemFontOfSize:13.0f];
        _genderLabel.backgroundColor = [UIColor colorWithRed:62/255.0
                                                       green:57/255.0
                                                        blue:75/255.0
                                                       alpha:1.0];
        _genderLabel.layer.masksToBounds = YES;
        _genderLabel.layer.cornerRadius = 15.0f;
        [self.contentView addSubview:_genderLabel];//
        [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(self.signatureLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
    }return _genderLabel;
}

- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = UILabel.new;
        _ageLabel.text = NSLocalizedString(@"VDageText", nil);
        _ageLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _ageLabel.font = [UIFont systemFontOfSize:13.0f];
        _ageLabel.backgroundColor =  [UIColor colorWithRed:62/255.0
                                                     green:57/255.0
                                                      blue:75/255.0
                                                     alpha:1.0];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.layer.masksToBounds = YES;
        _ageLabel.layer.cornerRadius = 15.0f;
        [self.contentView addSubview:_ageLabel];//
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.genderLabel.mas_right).offset(7);
            make.centerY.mas_equalTo(self.genderLabel.mas_centerY);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
    }return _ageLabel;
}

//- (UILabel *)cityLabel {
//    if (!_cityLabel) {
//        _cityLabel = UILabel.new;
//        _cityLabel.text = NSLocalizedString(@"VDcityText", nil);
//        _cityLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
//        _cityLabel.font = [UIFont systemFontOfSize:13.0f];
//        _cityLabel.backgroundColor =  [UIColor colorWithRed:62/255.0
//                                                      green:57/255.0
//                                                       blue:75/255.0
//                                                      alpha:1.0];
//        _cityLabel.textAlignment = NSTextAlignmentCenter;
//        _cityLabel.layer.masksToBounds = YES;
//        _cityLabel.layer.cornerRadius = 15.0f;
//        [self.contentView addSubview:_cityLabel];//
//        [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.ageLabel.mas_right).offset(7);
//            make.centerY.mas_equalTo(self.ageLabel.mas_centerY);
//            make.height.mas_equalTo(30);
//            make.right.mas_equalTo(-170);
//        }];
//    }return _cityLabel;
//}

- (UILabel *)focusCount {
    if (!_focusCount) {
        _focusCount = UILabel.new;
        _focusCount.text = @"0";
        _focusCount.textColor = kWhiteColor;
        _focusCount.textAlignment = NSTextAlignmentRight;
        _focusCount.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_focusCount];//
        [_focusCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(self.genderLabel.mas_bottom).offset(13);
            make.height.mas_equalTo(14);
        }];
    }return _focusCount;
}

- (UILabel *)focusLabel {
    if (!_focusLabel) {
        _focusLabel = UILabel.new;
        _focusLabel.text = NSLocalizedString(@"VDFocusText", nil);
        _focusLabel.textColor = kWhiteColor;
        _focusLabel.textAlignment = NSTextAlignmentLeft;
        _focusLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_focusLabel];//
        [_focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.focusCount.mas_right).offset(10);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
    } return _focusLabel;
}

- (UILabel *)praiseCount {
    if (!_praiseCount) {
        _praiseCount = UILabel.new;
        _praiseCount.text = @"0";
        _praiseCount.textColor = kWhiteColor;
        _praiseCount.textAlignment = NSTextAlignmentRight;
        _praiseCount.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_praiseCount];//
        [_praiseCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.focusLabel.mas_right).offset(20);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
    }return _praiseCount;
}

- (UILabel *)praiseLabel {
    if (!_praiseLabel) {
        _praiseLabel = UILabel.new;
        _praiseLabel.text = NSLocalizedString(@"VDpraiseText", nil);
        _praiseLabel.textColor = kWhiteColor;
        _praiseLabel.textAlignment = NSTextAlignmentLeft;
        _praiseLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_praiseLabel];//
        [_praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.praiseCount.mas_right).offset(10);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
    } return _praiseLabel;
}

- (UILabel *)fansCount {
    if (!_fansCount) {
        _fansCount = UILabel.new;
        _fansCount.text = @"0";
        _fansCount.textColor = kWhiteColor;
        _fansCount.textAlignment = NSTextAlignmentRight;
        _fansCount.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_fansCount];//
        [_fansCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.praiseLabel.mas_right).offset(20);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
    }return _fansCount;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = UILabel.new;
        _fansLabel.text = NSLocalizedString(@"VDfansText", nil);
        _fansLabel.textColor = kWhiteColor;
        _fansLabel.textAlignment = NSTextAlignmentLeft;
        _fansLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_fansLabel];//
        [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fansCount.mas_right).offset(10);
            make.centerY.mas_equalTo(self.focusCount.mas_centerY);
            make.height.mas_equalTo(14);
        }];
    }return _fansLabel;
}

- (UIButton *)pointsBtn {
    if (!_pointsBtn) {
        _pointsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pointsBtn setTitleColor:[UIColor colorWithHexString:@"EAEAEA"]
                         forState:UIControlStateNormal];
        _pointsBtn.backgroundColor = [UIColor colorWithHexString:@"3E394B"];
        _pointsBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:15];
        if (kiPhone5) {
            _pointsBtn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        }
        [_pointsBtn addTarget:self
                       action:@selector(pointsAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_pointsBtn];//
        [_pointsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.vipLabel.mas_right).offset(7);
            make.top.mas_equalTo(45+Height_NavBar);
            make.right.mas_equalTo(-5/375.0f*SCREEN_WIDTH);
            make.centerY.mas_equalTo(self.vipLabel.mas_centerY);
            if (kiPhone5) {
                make.width.mas_equalTo(105);
            } else {
                make.width.mas_equalTo(144);
            }
            make.height.mas_equalTo(30);
        }];
    }return _pointsBtn;
}

- (UILabel *)vipLabel {
    if (!_vipLabel) {
        _vipLabel = UILabel.new;
        _vipLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
        _vipLabel.text = NSLocalizedString(@"VDmembers", nil);
        _vipLabel.backgroundColor = [UIColor colorWithHexString:@"3E394B"];
        _vipLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:15];
        if (kiPhone5) {
            _vipLabel.font = [UIFont systemFontOfSize:9.0f];
        }
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        self.vipLabel.userInteractionEnabled = YES;
        [self.vipLabel addGestureRecognizer:self.tap];
        [self.contentView addSubview:_vipLabel];//
        [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(45+Height_NavBar);
            make.left.mas_equalTo(kiPhone5 ? 130 : 140/375.0f*SCREEN_WIDTH);
            make.height.mas_equalTo(30);
        }];
    }return _vipLabel;
}


@end
