//
//  ChooseTableViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 31/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChooseTableViewCell.h"



@interface ChooseTableViewCell ()

@property (nonatomic, strong) UILabel    *nameTitle;

@property (nonatomic, strong) UILabel    *authorLabel;

@property (nonatomic, strong) UILabel    *timeLabel;

@property (nonatomic, strong) UIImageView  *headerImage;

@property (nonatomic, strong) UIButton    *musicPlay;



@property (nonatomic, strong) UIView *lineView;


@end

@implementation ChooseTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier])  {
        
        [self setupView];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
        self.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
        /* 获取本地文件 */
//        NSBundle *bundle = [NSBundle mainBundle];
//        NSString *urlString = [bundle pathForResource:@"music" ofType:@"mp3"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseActionNotification:) name:@"collectionButton" object:nil];
    }
    return self;
}

- (void)chooseActionNotification:(NSNotification *)noti  {
    NSString *collection = [noti object];
    if ([collection isEqualToString:@"收藏"]) {
            self.likeBtn.hidden = YES;
    } else {
            self.likeBtn.hidden = NO;
    }
    
}

- (void)loadIndexPath:(NSIndexPath *)index {
    
}
- (void)setupView {
    
    [self.contentView addSubview:self.headerImage];
    [self.contentView addSubview:self.nameTitle];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.timeLabel];
//    [self.contentView addSubview:self.likeBtn];
    [self.headerImage addSubview:self.musicPlay];
  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = kClearColor;
    [button addTarget:self action:@selector(onExpand:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    [button addSubview:self.likeBtn];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
//    self.lineView = [[UIView alloc]init];
//    self.lineView.backgroundColor = [UIColor colorWithHexString:@"1a142d"];
//    [self.contentView addSubview:self.lineView];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(13);
        make.width.mas_equalTo(61);
        make.height.mas_equalTo(61);
    }];
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.headerImage.mas_right).offset(13);
        make.top.mas_equalTo(13);
//         make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(18);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.headerImage.mas_right).offset(13);
        make.top.mas_equalTo(self.nameTitle.mas_bottom).offset(7);
         make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(15);
        
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(self.headerImage.mas_right).offset(13);
        make.top.mas_equalTo(self.authorLabel.mas_bottom).offset(7);
         make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(14);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-20);
         make.width.mas_equalTo(37);
        make.height.mas_equalTo(36);
        
    }];
    
    [self.lineView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    [self.musicPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.headerImage);
        make.centerY.mas_equalTo(self.headerImage);
    }];
    
    [super updateConstraints];
    
}

#pragma mark ===================== 数据===================================
- (void)setModel:(ChooseModel *)model {
    
    _model = model;
    if (model.musicName) {
        self.nameTitle.text = model.musicName;
        self.authorLabel.text = model.musicAuthor;
        NSString *timeString = [NSString stringWithFormat:@"%@",model.createTime];
        NSString *str1 = [timeString substringToIndex:10];
        self.timeLabel.text = str1;
    }
    if (model.musicImg) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.musicImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
  
}

- (UIButton *)musicPlay {
    if (!_musicPlay) {
        _musicPlay = [UIButton buttonWithType:UIButtonTypeCustom];
//        _musicPlay.image = [UIImage imageNamed:@"播放"];
        [_musicPlay setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [_musicPlay addTarget:self action:@selector(musicPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _musicPlay;
}


- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"形状 3"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"形状 5"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _timeLabel.text = [NSString stringWithFormat:@"12:12"];
        _timeLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _timeLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc]init];
        _authorLabel.textColor = [UIColor colorWithHexString:@"7D7D7B"];
        _authorLabel.text = [NSString stringWithFormat:@"作者"];
        _authorLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _authorLabel;
}

- (UILabel *)nameTitle {
    if (!_nameTitle) {
        _nameTitle = [[UILabel alloc]init];
        _nameTitle.text = [NSString stringWithFormat:@"min音乐"];
        _nameTitle.textColor = kWhiteColor;
        _nameTitle.font = [UIFont systemFontOfSize:17];
    }
    return _nameTitle;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
        _headerImage.image = [UIImage imageNamed:@"music_choose"];
    }
    return _headerImage;
}

- (void)likeAction:(UIButton *)action {
    action.selected = !action.selected;
    if (action.selected) {
        [action setImage:[UIImage imageNamed:@"形状 5"] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(collectionMusicActionIndex:)]) {
            [self.delegate collectionMusicActionIndex:self.section];
        }
    } else {
        [action setImage:[UIImage imageNamed:@"形状 3"] forState:UIControlStateNormal];
    }
    
}

- (void)musicPlayClick:(UIButton *)music {
    music.selected = !music.selected;
    if (music.selected) {
        [self.musicPlay setImage:[UIImage imageNamed:@"停止"] forState:UIControlStateNormal];
    } else {
         [self.musicPlay setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }
}

- (void)onExpand:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isExpanded = !self.model.isExpanded;

    if (self.expandCallback) {
        self.expandCallback(self.model.isExpanded);
    }
    if (self.model.isExpanded) {
        [self.musicPlay setImage:[UIImage imageNamed:@"停止"] forState:UIControlStateNormal];
//        [self.likeBtn setImage:[UIImage imageNamed:@"形状 5"] forState:UIControlStateNormal];
    } else {
        [self.musicPlay setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
//         [self.likeBtn setImage:[UIImage imageNamed:@"形状 3"] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
