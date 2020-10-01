//
//  ZFDouYinCell.m
//  ZFPlayer_Example
//
//  Created by Josee on 2018/6/4.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import "ZFDouYinCell.h"
#import "JhPageItemModel.h"
#import "JhScrollActionSheetView.h"

#define OFFSET SCREEN_HEIGHT / 15

@interface ZFDouYinCell ()
//<
//EdwVideoSoundSliderDelegate,
//TLDisplayViewDelegate,
//>
<
TXScrollLabelViewDelegate
>

@property(nonatomic,strong)UIImageView *coverImageView;
@property(nonatomic,strong)UIButton *commentBtn;//评论
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *userBtn;
@property(nonatomic,strong)UIImageView *addImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImage *placeholderImage;
@property(nonatomic,strong)UILabel *msgCount;
@property(nonatomic,strong)UILabel *shareCount;
@property(nonatomic,strong)NSMutableArray *shareArray;
@property(nonatomic,strong)NSMutableArray *otherArray;
@property(nonatomic,strong)EmitterBtn *emitterBtn;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)BOOL isExpanded;
@property(nonatomic,strong)id noty;
@property(nonatomic,strong)FLAnimatedImageView *imageAnimated;
@property(nonatomic,strong)TXScrollLabelView *scrollLabelView;
@property(nonatomic,copy)NSString *imageHeader;
@property(nonatomic,copy)NSString *noPasswordUrl;

@end

@implementation ZFDouYinCell

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+(instancetype)cellWith:(UITableView *)tableView{
    ZFDouYinCell *cell = (ZFDouYinCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[ZFDouYinCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:ReuseIdentifier];
    }return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"050013"];
        //    [self systemSound];
        [self Notification];
    }return self;
}

- (void)richElementsInCellWithModel:(id _Nullable)model
                   isSecondaryPages:(BOOL)isSecondaryPages{
    self.commonModel = model;
    self.noPasswordUrl = [NSString stringWithFormat:@"%@%@",REQUEST_URL,self.commonModel.videoUrlPng];//封面图
    NSLog(@"self.noPasswordUrl = %@", self.noPasswordUrl);
//    self.coverImageView.alpha = 1;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.noPasswordUrl]
                           placeholderImage:[UIImage imageNamed:@"附近占位"]];//不能写在懒加载里面，因为有缓存
    //由下至上
//    self.musicView.alpha = 1;
    self.shareBtn.alpha = 1;
    self.commentBtn.alpha = 1;
    self.emitterBtn.alpha = 1;
    if (self.commonModel.videoUrlPng &&
        self.commonModel.videoUrl) {
        NSString *signstr = @"Kef9lkpzEBQD8WSged";
        NSString *md5Header = [NSString stringWithFormat:@"%@%@",self.commonModel.headerImage,signstr];
        NSString *signUrlHeader = [NSString md5String:md5Header];
        self.imageHeader = [NSString stringWithFormat:@"%@%@?secretKeyStr=%@",REQUEST_URL,self.commonModel.headerImage,signUrlHeader];
        self.userBtn.alpha = 1;
        self.addImage.alpha = 1;

        NSLog(@"点赞%ld",(long)self.commonModel.praiseCount);
        self.messageCountString = [NSString stringWithFormat:@"%ld",(long)self.commonModel.commentsCount];
        self.shareCountString = [NSString stringWithFormat:@"%ld",(long)self.commonModel.shareNum];

        self.titleLabel.text = [NSString stringWithFormat:@"@%@",self.commonModel.nickName];
        self.likeCount.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)self.commonModel.praiseCount] ? :@""
                                                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold"
                                                                                                                             size: 12],
                                                                                        NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0
                                                                                                                                        green:239/255.0
                                                                                                                                         blue:239/255.0
                                                                                                                                        alpha:1.0]}];
        self.msgCount.alpha = 1;
        self.shareCount.alpha = 1;
        self.likeCount.alpha = 1;
        self.scrollLabelView.alpha = 1;
        self.titleLabel.alpha = 1;

        if (isSecondaryPages) {
            self.userBtn.hidden = isSecondaryPages;
            self.addImage.hidden = isSecondaryPages;
        }else{
            [self.userBtn sd_setImageWithURL:[NSURL URLWithString:self.imageHeader]
                                    forState:UIControlStateNormal
                            placeholderImage:[UIImage imageNamed:@"头像占位"]];
        }
    }
}

-(void)setShareCountString:(NSString *)shareCountString{
    _shareCountString = shareCountString;
}

-(void)setMessageCountString:(NSString *)messageCountString{
    _messageCountString = messageCountString;
}

#pragma mark —— 点击事件
- (void)shareClick:(UIButton *)click {
    if ([self.delegate respondsToSelector:@selector(shareClickDelegate:)]) {
        [self.delegate shareClickDelegate:click];
    }
}

- (void)commentClick:(UIButton *)click {
    if ([self.delegate respondsToSelector:@selector(upCommentId:)]) {
        NSArray *array;
        if (self.commonModel) {
            NSString *idComment = [NSString stringWithFormat:@"%ld",(long)self.commonModel.ID];
            NSString *userId = [NSString stringWithFormat:@"%ld",(long)self.commonModel.userId];
            array  = @[idComment,userId];
        }
        [self.delegate upCommentId:array];
    }
}

- (void)emitterClick:(EmitterBtn *)btn {
    if ([self.delegate respondsToSelector:@selector(likeClickDelegate:Index:)]) {
        [self.delegate likeClickDelegate:btn
                                   Index:self.index.row];
    }
}

- (void)userAction:(UIButton *)action {
    if ([self.delegate respondsToSelector:@selector(focusOnAction:)]) {
        [self.delegate focusOnAction:action];
    }
}

-(void)Notification{
    @weakify(self)
    _noty = [[NSNotificationCenter defaultCenter] addObserverForName:@"playVideoStatus"
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:^(NSNotification * _Nonnull note) {
                                                              @strongify(self)
                                                              NSString *states = [note object];
                                                              if ([states isEqualToString:@"完成"]) {
//                                                                  self.musicView.hidden = YES;
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"presentPlay"
                                                                                                                      object:self.index];
                                                              }
                                                          }];
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notification1:)
                                                 name:@"notifyProgress"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationPassue:)
                                                 name:@"notifypassue"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageCount:)
                                                 name:@"successMessageCount"
                                               object:nil];
}

#pragma mark ===================== 通知===================================
- (void)notificationScroll:(NSNotification *)noti {
    NSString *scorll = [noti object];
    if (scorll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerScroll"
                                                            object:@"下滑暂停播放器"];
    }
}

- (void)notificationPassue:(NSNotification *)noti {
    NSString *info = [noti object];
    if ([info isEqualToString:@"Pass"]) {
        [_lanternView startOrResumeAnimate];
//        [_musicView startOrResumeAnimate];
    } else {
        [_lanternView pauseAnimate];
//        [_musicView pauseAnimate];
    }
}

- (void)notification1:(NSNotification *)noti{
    if ([noti object]) {
        [_lanternView startOrResumeAnimate];
//        [_musicView startOrResumeAnimate];
    } else {
        [_lanternView stopAnimate];
//        [_musicView stopAnimate];
    }
}

- (void)playVideoStatus:(NSNotification *)play {
    NSString *states = [play object];
    if ([states isEqualToString:@"完成"]) {
        //        self.bgImgView.hidden = NO;
        //        self.effectView.hidden = NO;
        //        self.recommended.hidden = NO;
//        self.musicView.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"presentPlay"
                                                            object:self.index];
    }
}

- (void)messageCount:(NSNotification *)noti {
    NSString *count = [noti object];
    NSMutableAttributedString *stringMsg = [[NSMutableAttributedString alloc] initWithString:count
                                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold"
                                                                                                                                    size: 12],
                                                                                               NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0
                                                                                                                                               green:239/255.0
                                                                                                                                                blue:239/255.0
                                                                                                                                               alpha:1.0]}];
    self.msgCount.attributedText = stringMsg;
}

- (void)hiddenView:(NSString *)viewString {
    if ([viewString isEqualToString:@"定时器结束"]) {
        if ([self.delegate respondsToSelector:@selector(playerIndexPath:)]) {
                [self.delegate playerIndexPath:self.index];
        }
    } else {}
}

#pragma mark —— TXScrollLabelViewDelegate
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView
       didClickWithText:(NSString *)text
                atIndex:(NSInteger)index{
    NSLog(@"%@",text);
}

#pragma mark —— lazyLoad
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = UIImageView.new;
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.contentView layoutIfNeeded];
    }return _coverImageView;
}

-(TXScrollLabelView *)scrollLabelView{
    if (!_scrollLabelView) {
        NSString *str;
        if (self.commonModel.videoType) {
            str = self.commonModel.videoType;
        }
        _scrollLabelView = [TXScrollLabelView scrollWithTitle:str
                                                         type:TXScrollLabelViewTypeLeftRight
                                                     velocity:.5f
                                                      options:UIViewAnimationOptionCurveEaseInOut];
        _scrollLabelView.scrollLabelViewDelegate = self;
        _scrollLabelView.scrollTitleColor = kWhiteColor;
        _scrollLabelView.backgroundColor = kClearColor;
        [self.contentView addSubview:_scrollLabelView];
        _scrollLabelView.frame = CGRectMake(0,
                                            SCREEN_HEIGHT - 100,
                                            SCREEN_WIDTH,
                                            20);
        [_scrollLabelView beginScrolling];
    }return _scrollLabelView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.backgroundColor = kClearColor;
        _titleLabel.textColor = [UIColor colorWithWhite:1
                                                  alpha:0.6];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.numberOfLines = 5;
        [_titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.scrollLabelView.mas_top).offset(-SCALING_RATIO(10));
            make.left.equalTo(self.contentView).offset(OFFSET);
        }];
        [self.contentView layoutIfNeeded];
    }return _titleLabel;
}

//-(EdwVideoMusicView *)musicView{
//    if (!_musicView) {
//        _musicView = EdwVideoMusicView.new;
//        [self.contentView addSubview:_musicView];
//        extern CGFloat VDHomeViewController_BottomY;
//        [_musicView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
//            make.bottom.equalTo(self.contentView).offset(-VDHomeViewController_BottomY-OFFSET);
//            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(50), SCALING_RATIO(50)));
//        }];
//        [self.contentView layoutIfNeeded];
//    }return _musicView;
//}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"share"]
                   forState:UIControlStateNormal];
        [_shareBtn addTarget:self
                      action:@selector(shareClick:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.musicView);
//            make.size.equalTo(self.musicView);
//            make.bottom.equalTo(self.musicView.mas_top).offset(-OFFSET);
            extern CGFloat VDHomeViewController_BottomY;
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            make.bottom.equalTo(self.contentView).offset(-VDHomeViewController_BottomY-OFFSET);
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(50), SCALING_RATIO(50)));
        }];
    }return _shareBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"]
                     forState:UIControlStateNormal];
        [_commentBtn addTarget:self
                        action:@selector(commentClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentBtn];
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.musicView);
//            make.size.equalTo(self.musicView);
            make.centerX.equalTo(self.shareBtn);
            make.size.equalTo(self.shareBtn);
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-OFFSET);
        }];
    }return _commentBtn;
}

- (EmitterBtn *)emitterBtn {
    if (!_emitterBtn) {
        _emitterBtn = [EmitterBtn buttonWithType:UIButtonTypeCustom];
        [_emitterBtn setImage:[UIImage imageNamed:@"love"]
                     forState:UIControlStateNormal];
//        [_emitterBtn setImage:[UIImage imageNamed:@"Love_yes"]
//                     forState:UIControlStateSelected];
        [_emitterBtn addTarget:self
                        action:@selector(emitterClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_emitterBtn];
        [_emitterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.musicView);
//            make.size.equalTo(self.musicView);
            make.centerX.equalTo(self.shareBtn);
            make.size.equalTo(self.shareBtn);
            make.bottom.equalTo(self.commentBtn.mas_top).offset(-OFFSET);
        }];
    }return _emitterBtn;
}

- (UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _userBtn.layer.cornerRadius = SCALING_RATIO(50) / 2;
        _userBtn.layer.masksToBounds = YES;
        _userBtn.layer.borderWidth = 1.0f;
        _userBtn.layer.borderColor = kWhiteColor.CGColor;
        [_userBtn addTarget:self
                     action:@selector(userAction:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_userBtn];
        [_userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.musicView);
//            make.size.equalTo(self.musicView);
            make.centerX.equalTo(self.shareBtn);
            make.size.equalTo(self.shareBtn);
            make.bottom.equalTo(self.emitterBtn.mas_top).offset(-OFFSET);
        }];
        [self.contentView layoutIfNeeded];
    }return _userBtn;
}

- (UILabel *)likeCount {
    if (!_likeCount) {
        _likeCount = UILabel.new;
        _likeCount.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_likeCount];
        [_likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emitterBtn.mas_bottom);
            make.width.left.right.equalTo(self.emitterBtn);
        }];
        [self layoutIfNeeded];
    }return _likeCount;
}

- (UILabel *)msgCount {
    if (!_msgCount) {
        _msgCount = UILabel.new;
        _msgCount.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_msgCount];
        [_msgCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentBtn.mas_bottom);
            make.width.left.right.equalTo(self.commentBtn);
        }];
        [self layoutIfNeeded];
        _msgCount.attributedText = [[NSMutableAttributedString alloc] initWithString:self.messageCountString ? :@""
                                                                          attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold"
                                                                                                                            size: 12],
                                                                                       NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0
                                                                                                                                       green:239/255.0
                                                                                                                                        blue:239/255.0
                                                                                                                                       alpha:1.0]}];
    }return _msgCount;
}

- (UILabel *)shareCount {
    if (!_shareCount) {
        _shareCount = UILabel.new;
        _shareCount.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_shareCount];
        [_shareCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shareBtn.mas_bottom);
            make.width.left.right.equalTo(self.shareBtn);
        }];
        [self layoutIfNeeded];
        _shareCount.attributedText = [[NSMutableAttributedString alloc] initWithString:self.shareCountString ? : @""
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold"
                                                                                                                              size: 12],
                                                                                         NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0
                                                                                                                                         green:239/255.0
                                                                                                                                          blue:239/255.0
                                                                                                                                         alpha:1.0]}];
    }return _shareCount;
}

- (UIImageView *)addImage {
    if (!_addImage) {
        _addImage = UIImageView.new;
        _addImage.image = [UIImage imageNamed:@"+图"];
        [self.contentView addSubview:_addImage];
        [_addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userBtn.mas_bottom);
            make.centerX.equalTo(self.userBtn);
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(25), SCALING_RATIO(25)));
        }];
        _addImage.layer.cornerRadius = _addImage.height / 2.0f;
        _addImage.layer.masksToBounds = YES;
    }return _addImage;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0
                                                                        green:220/255.0
                                                                         blue:220/255.0
                                                                        alpha:1]
                                                   size:CGSizeMake(1, 1)];
    }return _placeholderImage;
}

- (NSMutableArray *)shareArray {
    if (!_shareArray) {
        _shareArray = NSMutableArray.array;
        NSArray *data = @[
                          @{
                              @"text" : @"内容转播",
                              @"img" : @"bb",
                              },
                          @{
                              @"text" : @"Viber",
                              @"img" : @"Viber",
                              },
                          @{
                              @"text" : @"Messenger",
                              @"img" : @"Facebook Messenger",
                              },
                          @{
                              @"text" : @"WhatsApp",
                              @"img" : @"WhatsApp",
                              },
                          @{
                              @"text" : @"Facebook",
                              @"img" : @"fb",
                              },
                          @{
                              @"text" : @"instagram",
                              @"img" : @"图层 2023",
                              },
                          @{
                              @"text" : @"email",
                              @"img" : @"email",
                              },
                          @{
                              @"text" : @"FB story",
                              @"img" : @"camera story",
                              },
                          @{
                              @"text" : @"message",
                              @"img" : @"图层 2029",
                              }];

        _shareArray = [JhPageItemModel mj_objectArrayWithKeyValuesArray:data];
    }return _shareArray;
}

- (NSMutableArray *)otherArray {
    if (!_otherArray) {
        _otherArray = NSMutableArray.array;
        NSArray *data = @[
                          @{
                              @"text" : @"举报",
                              @"img" : @"jubao_share",
                              },
                          @{
                              @"text" : @"复制",
                              @"img" : @"shaver11",
                              },
                          @{
                              @"text" : @"保存",
                              @"img" : @"save",
                              }];
        _otherArray = [JhPageItemModel mj_objectArrayWithKeyValuesArray:data];
    } return _otherArray;
}

#pragma mark —— 遗弃
- (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [attrString addAttribute:NSFontAttributeName
                       value:font
                       range:NSMakeRange(0,self.name.length)];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14]
                       range:NSMakeRange(self.name.length,
                                         needText.length-self.name.length)];

    return attrString;
}

////监听系统声音
//- (void)systemSound {
//    //添加这个将不会出现系统声音的UI(播放音乐时才有效，目前没有添加音乐)
//    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000,
//                                                                              -2000,
//                                                                              0.01,
//                                                                              0.01)];
//    [self addSubview:volumeView];
//    //监听系统声音
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(volumeChanged:)
//                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
//                                               object:nil];
//}
//
////系统声音改变
//- (void)volumeChanged:(NSNotification *)notification{
//    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
//                    floatValue];
//
//    DLog(@"声音%f",volume);
//}


@end
