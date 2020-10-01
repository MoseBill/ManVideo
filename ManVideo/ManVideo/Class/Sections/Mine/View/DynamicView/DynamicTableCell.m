//
//  DynamicTableCell.m
//  Clipyeu ++
//
//  Created by Josee on 15/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "DynamicTableCell.h"

@interface DynamicTableCell ()

@property (nonatomic, strong) UIImageView   *headerImage;

@property (nonatomic, strong) UILabel    *nameLabel;

@property (nonatomic, strong) UILabel    *contenLabel;

@property (nonatomic, strong) UIImageView    *videoImage;

@property (nonatomic, strong) UIImageView  *actionBtn;

@property (nonatomic, strong) UILabel    *timeLabel;

@property (nonatomic, strong) FLAnimatedImageView *imageV;

@end

@implementation DynamicTableCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.headerImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contenLabel];
//        [self.contentView addSubview:self.videoImage];
//        [self.videoImage addSubview:self.actionBtn];
       [self.contentView addSubview:self.imageV];
        [self.imageV addSubview:self.actionBtn];
           [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(39);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.headerImage.mas_right).offset(10);
        make.centerY.mas_equalTo(self.headerImage.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(13);
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(7);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(32);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(13);
        make.top.mas_equalTo(97);
         make.width.mas_equalTo(178);
        make.height.mas_equalTo(250);
    }];
  
    self.videoImage.layer.masksToBounds = YES;
    self.videoImage.layer.cornerRadius = 8.0f;
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_equalTo(20);
         make.height.mas_equalTo(20);
         make.bottom.mas_equalTo(-5);
         make.left.mas_equalTo(5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.bottom.mas_equalTo(-9);
        make.height.mas_equalTo(11);
    }];
}

- (void)setModel:(GKDYVideoModel *)model {
    
    _model = model;
   
    self.contenLabel.text = model.videoType;
    
    if (model.videoUrlGif != nil) {
        
        NSString *signstr=@"Kef9lkpzEBQD8WSged";
        NSString *md5String = [NSString stringWithFormat:@"%@%@",model.videoUrlGif,signstr];
        NSString *signUrl = [NSString md5String:md5String];
        NSString *imageString = [NSString stringWithFormat:@"%@%@?secretKeyStr=%@",REQUEST_URL,model.videoUrlGif,signUrl];
        DLog(@"动态地址%@",imageString);
        @weakify(self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *dataImage =  [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
            @strongify(self)
              FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:dataImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    @strongify(self)
                    self.imageV.animatedImage = image;
                });
        });
     
        NSString *md5Header = [NSString stringWithFormat:@"%@%@",model.headerImage,signstr];
        NSString *signUrlHeader =[NSString md5String:md5Header];
        NSString *imageHeader = [NSString stringWithFormat:@"%@%@?secretKeyStr=%@",REQUEST_URL,model.headerImage,signUrlHeader];
         [self.headerImage sd_setImageWithURL:[NSURL URLWithString:imageHeader] placeholderImage:[UIImage imageNamed:@"userImage"]];
    }
}

- (FLAnimatedImageView *)imageV {
    if (!_imageV) {
        _imageV = [[FLAnimatedImageView alloc]init];
        _imageV.image = [UIImage imageNamed:@"附近占位"];
        _imageV.userInteractionEnabled = YES;
//        _imageV.frame = CGRectMake(13, 97,178, 250);
       _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 5.0f;
    }
    return _imageV;
}

- (UIImageView *)videoImage {
    if (!_videoImage) {
        _videoImage = [UIImageView new];
        _videoImage.image = [UIImage imageNamed:@"附近占位"];
    }
    return _videoImage;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
//        _timeLabel.text = @"2019-01-23";
        _timeLabel.textColor = [UIColor colorWithHexString:@"B0B0B0"];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _timeLabel;
}

- (UILabel *)contenLabel {
    if (!_contenLabel) {
        _contenLabel = [UILabel new];
//        _contenLabel.text = @"视频描述视频描述视频描述";
        _contenLabel.textColor = [UIColor colorWithHexString:@"F2EFEF"];
    }
    return _contenLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = [NSString stringWithFormat:@"@Clipyeu++"];
        _nameLabel.textColor = [UIColor colorWithHexString:@"FFFDFD"];
        _nameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nameLabel;
}

- (UIImageView *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [UIImageView new];
        _actionBtn.image = [UIImage imageNamed:@"videoLogo"];
    }
    return _actionBtn;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [UIImageView new];
        _headerImage.image = [UIImage imageNamed:@"userImage"];
    }
    return _headerImage;
}

@end
