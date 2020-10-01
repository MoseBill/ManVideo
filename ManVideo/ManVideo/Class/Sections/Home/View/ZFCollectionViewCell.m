//
//  ZFCollectionViewCell.m
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFCollectionViewCell.h"

@interface ZFCollectionViewCell ()

@property (nonatomic, strong) UILabel    *nameTitle;
@property (nonatomic, strong) UIImageView    *userImage;
@property (nonatomic, strong) UILabel    *userName;
@property (nonatomic, strong) UIButton    *likeBtn;
@property (nonatomic, strong) UILabel   *likeCount;

@end

@implementation ZFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.coverImageView.tag = 100;
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        [self.contentView addSubview:self.nameTitle];
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.likeCount];
        
//        [self setNeedsUpdateConstraints];
//        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.coverImageView.frame = self.contentView.bounds;
    self.playBtn.frame = CGRectMake(0, 0, 44, 44);
    self.playBtn.center = self.coverImageView.center;
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(-57);
    }];
    
//    self.nameTitle.frame = CGRectMake(0, 197/812*SCREEN_HEIGHT, self.contentView.frame.size.width, 14);
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_bottom).offset(5);
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self).offset(-5);
        make.height.mas_equalTo(14);
    }];
    [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.nameTitle.mas_bottom).offset(12);
         make.left.mas_equalTo(self.contentView).offset(5);
         make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = self.userImage.height/2.0f;
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.userImage.mas_centerY);
        make.left.mas_equalTo(self.userImage.mas_right).offset(10);
        make.height.mas_equalTo(14);
        
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.userImage.mas_centerY);
         make.left.mas_equalTo(self.userName.mas_right).offset(10);
         make.width.mas_equalTo(14);
        make.height.mas_equalTo(12);
        
    }];
    
    [self.likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.likeBtn.mas_right).offset(5);
        make.right.mas_equalTo(self.contentView).offset(-5);
        make.centerY.mas_equalTo(self.likeBtn.mas_centerY);
        
    }];
}

- (void)updateConstraints {
    
   
    
    [super updateConstraints];
}

- (void)setData:(ZFTableData *)data {
    _data = data;
    [self.coverImageView setImageWithURLString:data.thumbnail_url placeholder:[UIImage imageNamed:@"loading_bgView"]];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:data.thumbnail_url] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

- (UILabel *)nameTitle {
    if (!_nameTitle) {
        _nameTitle = [UILabel new];
        _nameTitle.textAlignment = NSTextAlignmentLeft;
        _nameTitle.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0];
        _nameTitle.text = @"@Josee God Bless You!";
        _nameTitle.font = [UIFont systemFontOfSize:12.0f];
    }
    return _nameTitle;
}

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = [UIImageView new];
    }
    return _userImage;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [UILabel new];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.text = @"Josee";
        _userName.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0];
        _userName.font = [UIFont systemFontOfSize:12.0f];
    }
    return _userName;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (void)likeBtnClick:(UIButton *)click {
    click.selected = !click.selected;
    if (click.selected) {
         [click setImage:[UIImage imageNamed:@"love1"] forState:UIControlStateNormal];
    } else {
         [click setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
    }
}

- (UILabel *)likeCount {
    if (!_likeCount) {
        _likeCount = [UILabel new];
        _likeCount.textAlignment = NSTextAlignmentLeft;
        _likeCount.text = @"1314";
        _likeCount.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1.0];
        _likeCount.font = [UIFont systemFontOfSize:12.0f];
    }
    return _likeCount;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (void)playBtnClick:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
@end
