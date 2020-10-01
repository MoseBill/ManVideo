//
//  ZFCollectionViewCell.m
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFCollectionViewCell.h"
#import <CommonCrypto/CommonDigest.h>

typedef void(^JLXCommonToolVedioCompletionHandler)(NSURL *assetURL,
                                                   NSError *error,
                                                   BOOL isVideoAssetvertical);

@interface ZFCollectionViewCell ()<TXScrollLabelViewDelegate>
{
    AVAsset * videoAsset;
    CADisplayLink* dlink;
    AVAssetExportSession *exporter;
    
    GPUImageMovie *movieFile;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageMovieWriter *movieWriter;
}

@property(copy,nonatomic)JLXCommonToolVedioCompletionHandler completionHandler;
//@property(nonatomic,strong)UILabel *nameTitle;
@property(nonatomic,strong)TXScrollLabelView *scrollLabelView;
@property(nonatomic,strong)UILabel *userName;
@property(nonatomic,strong)UILabel *likeCount;
@property(nonatomic,strong)UIButton *likeBtn;
@property(nonatomic,strong)UIImageView *userImage;
@property(nonatomic,strong)FLAnimatedImageView *imageAnimated;
@property(nonatomic,strong)NSMutableArray *gifArr;
@property(nonatomic,assign)CGFloat gifMargin;
@property(nonatomic,assign)CGFloat cellHeight;

@end

@implementation ZFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cellHeight = frame.size.height;
//        self.backgroundColor = RandomColor;
    }return self;
}

//- (void)setCommonModel:(CommonModel *)model {
//    _commonModel = model;
////    self.scrollLabelView.alpha =  1;
////    NSString *headerImage = [model.headerImage stringByReplacingOccurrencesOfString:@"\\"
////                                                                         withString:@""];
////    [self.userImage sd_setImageWithURL:[NSURL URLWithString:headerImage]
////                      placeholderImage:[UIImage imageNamed:@"头像占位"]];
////    self.userName.text = model.nickName;
////    self.likeBtn.alpha = 1;
////    self.likeCount.text = [NSString stringWithFormat:@"%ld",(long)model.praiseCount];
//}

- (void)likeBtnClick:(UIButton *)click {
    click.selected = !click.selected;
}

#pragma mark ===================== 图片优化===================================
- (void)setCommonModel:(CommonModel *)model
                andTag:(NSIndexPath*)index{
    _commonModel = model;
    if ([_commonModel.videoUrlGif isNullString]) {
        self.imageAnimated.image = kIMG(@"发布图片");
        [self setUp];
    }else{
        NSString *noPasswordUrl = [NSString stringWithFormat:@"%@%@",REQUEST_URL,_commonModel.videoUrlGif];
        NSData *dataImage =  [NSData dataWithContentsOfURL:[NSURL URLWithString:noPasswordUrl]];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:dataImage];
        if (dataImage) {
            @weakify(self)
            dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新UI
                @strongify(self)
                self.imageAnimated.animatedImage = image;
                [self setUp];
            });
        }
    }
}

-(void)setUp{

    NSString *headerImage = [self.commonModel.headerImage stringByReplacingOccurrencesOfString:@"\\"
                                                                         withString:@""];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:headerImage]
                      placeholderImage:kIMG(@"头像占位")];
    self.userName.text = self.commonModel.nickName;
    self.likeBtn.alpha = 1;
    self.likeCount.text = [NSString stringWithFormat:@"%ld",(long)self.commonModel.praiseCount];
    self.scrollLabelView.alpha =  1;
}

#pragma mark —— LazyLoad
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
//        _scrollLabelView.frame = CGRectMake(SCALING_RATIO(5),
//                                            self.cellHeight - SCALING_RATIO(57),
//                                            SCALING_RATIO(162),
//                                            SCALING_RATIO(14));
        _scrollLabelView.frame = CGRectMake(SCALING_RATIO(5),
                                            self.likeCount.mj_y - SCALING_RATIO(14),
                                            SCALING_RATIO(162),
                                            SCALING_RATIO(14));

        [_scrollLabelView beginScrolling];
    }return _scrollLabelView;
}

- (FLAnimatedImageView *)imageAnimated {
    if (!_imageAnimated) {
        _imageAnimated = FLAnimatedImageView.new;
        _imageAnimated.contentMode = UIViewContentModeScaleAspectFill;
        _imageAnimated.layer.masksToBounds = YES;
        _imageAnimated.layer.cornerRadius = 8.0f;
        @weakify(self)
        [UIView transitionWithView:self.contentView
                          duration:0.3f
                           options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            @strongify(self)
                            [self.contentView addSubview:self->_imageAnimated];
                            [self->_imageAnimated mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.top.right.equalTo(self.contentView);
                                make.bottom.equalTo(self.userImage.mas_top).offset(SCALING_RATIO(-10));
                            }];
                        } completion:^(BOOL finished) {
                        }];
    }return _imageAnimated;
}

- (UIImageView *)userImage {
    if (!_userImage) {
        _userImage = UIImageView.new;
        _userImage.layer.masksToBounds = YES;
        _userImage.layer.cornerRadius = 10.0f;
        [self.contentView addSubview:_userImage];
        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(5));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(20), SCALING_RATIO(20)));
//            make.top.equalTo(self.scrollLabelView.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    } return _userImage;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [UILabel new];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.text = [NSString stringWithFormat:@"Clipyeu++"];
        _userName.textColor = [UIColor colorWithRed:176/255.0
                                              green:176/255.0
                                               blue:176/255.0
                                              alpha:1.0];
        _userName.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_userName];
        [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userImage.mas_right).offset(SCALING_RATIO(5));
            make.height.mas_equalTo(SCALING_RATIO(14));
            make.centerY.equalTo(self.userImage);
        }];
     }return _userName;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:kIMG(@"love")
                  forState:UIControlStateNormal];
//        [_likeBtn setImage:[UIImage imageNamed:@"Love_yes"]
//                  forState:UIControlStateSelected];
        [_likeBtn addTarget:self
                     action:@selector(likeBtnClick:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_likeBtn];
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userName.mas_right).offset(SCALING_RATIO(2));
            make.centerY.equalTo(self.userName);
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(12), SCALING_RATIO(12)));
        }];
    }return _likeBtn;
}

- (UILabel *)likeCount {
    if (!_likeCount) {
        _likeCount = UILabel.new;
        _likeCount.textAlignment = NSTextAlignmentCenter;
        _likeCount.textColor = [UIColor colorWithRed:176/255.0
                                               green:176/255.0
                                                blue:176/255.0
                                               alpha:1.0];
        _likeCount.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_likeCount];
        [_likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.likeBtn.mas_right).offset(SCALING_RATIO(2));
            make.centerY.equalTo(self.userName);
        }];
    }return _likeCount;
}


@end
