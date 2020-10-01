//
//  MessageTableViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 22/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "RJBadgeKit.h"
#import "MessageViewController.h"

NSString * const DEMO_PARENT_PATH = @"root.p365";


@interface MessageTableViewCell ()
/*头像*/
@property (nonatomic, strong) UIImageView    *imageV;
/*标题*/
@property (nonatomic, strong) UILabel    *nameLabel;
/*详情*/
@property (nonatomic, strong) UILabel    *detailLabel;
/*时间*/
@property (nonatomic, strong) UILabel    *timeLabel;

@property (nonatomic, strong) UIImageView  *typeImage;

@property (nonatomic, strong) UIView    *redView;

@end

@implementation MessageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 54);
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.nameLabel];
//        [self.contentView addSubview:self.typeImage];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.redView];
         
        [RJBadgeController setBadgeForKeyPath:DEMO_PARENT_PATH
                                        count:5.0f];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNotification:) name:@"MessageNotification" object:nil];
    }
    return self;
}

//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   @weakify(self)
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(7);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     @strongify(self)
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
        make.top.mas_equalTo(12);
        
        make.height.mas_equalTo(13);
    }];
//    [self.typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//         make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
//        make.top.mas_equalTo(12);
//         make.width.mas_equalTo(23);
//        make.height.mas_equalTo(11);
//
//    }];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(13);

    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
   
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(13);

    }];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.right.mas_equalTo(-30);
         make.width.mas_equalTo(10);
        make.height.mas_equalTo(10);
          make.bottom.mas_equalTo(-6);
    }];
    
    [self.badgeController observePath:DEMO_PARENT_PATH
                            badgeView:self.redView
                                block:^(id observer, NSDictionary *info) {
                                    DLog(@"系统通知 => %@", info);
                                }];
  
//    NSArray *array = @[@"通知图片",@"系统通知",@"粉丝",@"",@"",@""];
//    NSArray *arrTitle = @[@"系统通知",@"系统通知",@"粉丝通知",@"点赞通知",@"视频通知",@"评论通知"];
//    NSArray *detailArr = @[@"欢迎您的加入Clipyeu++",@"提醒您视频未通过审核",@"新增粉丝用户（手机用户）关注了您",@"您获得（手机用户）的点赞",@"新增粉丝用户（手机用户）关注了您",@"您获得（手机用户）的点赞"];
}

- (void)messageNotification:(NSNotification *)noti {
    
    if ([noti object]) {
           [RJBadgeController clearBadgeForKeyPath:DEMO_PARENT_PATH];
    }
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc]init];
        _redView.backgroundColor = kClearColor;
    }
    return _redView;
}

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [UIImageView new];
        _imageV.image = [UIImage imageNamed:@"通知图片"];
    }
    return _imageV;
}

- (UIImageView *)typeImage {
    if (!_typeImage) {
        
        _typeImage = [UIImageView new];
        _typeImage.image = [UIImage imageNamed:NSLocalizedString(@"VDofficialText", nil)];
    }
    return _typeImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = NSLocalizedString(@"VDsystemText", nil);
        _nameLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:10];
        _detailLabel.textColor = [UIColor colorWithHexString:@"B0B0B0"];
//        _detailLabel.text = NSLocalizedString(@"VDAudit", nil);
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor colorWithHexString:@"B0B0B0"];
//        _timeLabel.text = @"2019-01-23";
        _timeLabel.font = [UIFont systemFontOfSize:10];
    }
    return _timeLabel;
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
