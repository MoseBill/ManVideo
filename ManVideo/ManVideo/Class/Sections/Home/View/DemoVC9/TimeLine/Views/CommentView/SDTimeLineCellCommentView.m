//
//  SDTimeLineCellCommentView.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import "SDTimeLineCellCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "SDTimeLineCellModel.h"
#import "MLLinkLabel.h"

#import "LEETheme.h"

@interface SDTimeLineCellCommentView () <MLLinkLabelDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray<SDTimeLineCellCommentItemModel *> *commentItemsArray;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) MLLinkLabel *likeLabel;
@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@property (nonatomic, strong) UIView *backG;

@property (nonatomic, strong) NSMutableArray    *viewArr;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong)  UILabel *timeLabel;

@property (nonatomic, strong) NSMutableArray    *nameArr;
@property (nonatomic, strong) NSMutableArray    *imageArr;
@property (nonatomic, strong) NSMutableArray    *timeLabelArr;

@property (nonatomic, strong) NSMutableArray    *clickArr;

@property (nonatomic, strong) NSMutableArray    *idArr;

@property (nonatomic, strong)   NSString *headerText;

@property (nonatomic, assign) NSRange rangeB;

@end

@implementation SDTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
        self.userInteractionEnabled = YES;
        //设置主题
        [self configTheme];
        
    }
    return self;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return [self superview]; // return nil;
//    // 此处返回nil也可以。返回nil就相当于当前的view不是最合适的view
//}

- (void)setupViews
{
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : TimeLineCellHighlightedColor};
    _likeLabel.isAttributedContent = YES;
    [self addSubview:_likeLabel];
    
    _likeLableBottomLine = [UIView new];
//    _likeLableBottomLine.userInteractionEnabled = YES;
    [self addSubview:_likeLableBottomLine];

}

- (void)configTheme{
    
//    self.lee_theme
//    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
//    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);
//
//
//    _likeLabel.lee_theme
//    .LeeAddTextColor(DAY , [UIColor blackColor])
//    .LeeAddTextColor(NIGHT , [UIColor grayColor]);
    
    _likeLableBottomLine.lee_theme
    .LeeAddBackgroundColor(DAY , SDColor(210, 210, 210, 1.0f))
    .LeeAddBackgroundColor(NIGHT , SDColor(60, 60, 60, 1.0f));
    
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        
        self.backG = [UIView new];
       
        [self addSubview:self.backG];
        self.backG.backgroundColor = KYellowColor;
        
        self.image = [UIImageView new];
        [self.backG addSubview:self.image];
        self.image.hidden = NO;
        self.image.sd_layout
        .leftSpaceToView(self.backG, 8)
        .topSpaceToView(self.backG, 8)
        .widthIs(25)
        .heightIs(25);
        self.image.layer.masksToBounds = YES;
        self.image.layer.cornerRadius = self.image.height/2;
        //    .autoHeightRatio(0);
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        
       self.nameLabel = [UILabel new];
        [self.backG addSubview:self.nameLabel];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"B0B0B0"];
        
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.sd_layout
        .leftSpaceToView(self.image, 5)
        .topSpaceToView(self.backG, 8)
        .rightSpaceToView(self.backG, 0)
        .heightIs(16);
        
        self.timeLabel = [UILabel new];
        [self.backG addSubview:self.timeLabel];
      
        self.timeLabel.textColor = [UIColor colorWithHexString:@"B0B0B0"];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.sd_layout
        .leftSpaceToView(self.image, 5)
        .topSpaceToView(self.nameLabel, 6)
        .rightSpaceToView(self.backG, 0)
        .heightIs(11);
        
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = kWhiteColor;
        label.userInteractionEnabled = YES;
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:13];
        label.delegate = self;
        [self addSubview:label];
        
     
        
//        [self.backG addGestureRecognizer:tapRecognize];
        [self.commentLabelsArray addObject:label];
        [self.viewArr addObject:self.backG];
        
        [self.imageArr addObject:self.image];
        [self.nameArr addObject:self.nameLabel];
        [self.timeLabelArr addObject:self.timeLabel];
        
//        [self.clickArr addObject:btnClick];
    }
    
    NSArray *commentArr  = [SDTimeLineCellModel mj_objectArrayWithKeyValuesArray:commentItemsArray];
    for (int i = 0; i < commentArr.count; i++) {
        
        SDTimeLineCellModel *model = commentArr[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        model.attributedContent =  [self generateAttributedStringWithCommentItemModel:model];
        label.attributedText = model.attributedContent;
        label.textColor = kWhiteColor;
        
        [self.nameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *nameLabel = self.nameArr[idx];
            nameLabel.text =  model.userName;
        }];
        [self.timeLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *timeLabel = self.timeLabelArr[idx];
            
            NSString *jason = [model.createDate substringToIndex:10];
            timeLabel.text = jason;
        }];
        [self.imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageV = self.imageArr[idx];
            
            NSString *stringImage = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.headerImage];
            [imageV sd_setImageWithURL:[NSURL URLWithString:stringImage] placeholderImage:[UIImage imageNamed:@"userImageP"]];
            
        }];
         DLog(@"楚霸王数据%@",commentItemsArray);
    }
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//
//    return YES;
//}
//- (void)replyAction:(UIButton *)action {
//
//   DLog(@"点击识别%@",action);
//    if ([self.delegate respondsToSelector:@selector(replyClickView:)]) {
//        [self.delegate replyClickView:action];
//    }
//
//}

- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeItemsArray.count; i++) {
        SDTimeLineCellLikeItemModel *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithLikeItemModel:model];
        }
        [attributedText appendAttributedString:model.attributedContent];
    }
    
    _likeLabel.attributedText = [attributedText copy];
}

- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (NSMutableArray *)viewArr {
    if (!_viewArr) {
        _viewArr = [NSMutableArray new];
    }
    return _viewArr;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray new];
    }
    return _imageArr;
}

- (NSMutableArray *)nameArr {
    if (!_nameArr) {
        _nameArr = [NSMutableArray new];
    }
    return _nameArr;
}

- (NSMutableArray *)timeLabelArr {
    if (!_timeLabelArr) {
        _timeLabelArr = [NSMutableArray new];
    }
    return _timeLabelArr;
}

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
    if (!commentItemsArray.count && !likeItemsArray.count) {
        self.fixedWidth = @(0); // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
    }
    CGFloat margin = 5;
    UIView *lastTopView = nil;
    if (likeItemsArray.count) {
        _likeLabel.sd_resetLayout
        .leftSpaceToView(self, margin)
        .rightSpaceToView(self, margin)
        .topSpaceToView(lastTopView, 10)
        .autoHeightRatio(0);
        [_likeLabel sizeToFit];
        lastTopView = _likeLabel;
    } else {
        _likeLabel.attributedText = nil;
        _likeLabel.sd_resetLayout
        .heightIs(0);
    }
    if (self.commentItemsArray.count && self.likeItemsArray.count) {
        _likeLableBottomLine.sd_resetLayout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(1)
        .topSpaceToView(lastTopView, 3);
        
        lastTopView = _likeLableBottomLine;
    } else {
        _likeLableBottomLine.sd_resetLayout.heightIs(0);
    }
    CGFloat heightAll = 0.0;
//    CGFloat widthAll = 0.0;
    if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
        heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
//        widthAll = IS_IPHONE_X || IS_IPHONE_Xs ? 375 : 414;
    } else if (kiPhone6Plus) {
        heightAll = 736.0f;
//        widthAll = 414.0f;
    } else {
//        widthAll  = iPhone5 ? 320.0f : 375.0f;
        heightAll = kiPhone5 ? 568 : 667.0f;
    }
    
    DLog(@"评论的UI %@",self.commentItemsArray);
    UILabel *label;
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
//        CGFloat topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 46*667.0f/heightAll;
        label.sd_layout
        .leftSpaceToView(self, 40)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView,56*667.0f/heightAll)
        .autoHeightRatio(0);
       
        
        UIView *view = (UIView *)self.viewArr[i];
        view.userInteractionEnabled = YES;
        view.hidden = NO;
        CGFloat topMarginView = (i == 0 && likeItemsArray.count == 0) ? 0 : label.height-10;
        view.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, topMarginView)
        .autoHeightRatio(0);
        
      
        
         label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

- (void)clickAction:(UIButton *)action {
    
    DLog(@"你他妈的 点了她%@",action);
    
    if ([self.delegate respondsToSelector:@selector(replyClickView:)]) {
        [self.delegate replyClickView:action];
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(SDTimeLineCellModel *)model
{
    NSUserDefaults *userName = [NSUserDefaults standardUserDefaults];
//    NSString *text = [userName objectForKey:@"userName"];
    if (model.writtenWords != nil) {
        if (model.otherUserName) {
                 
//                           SDTimeLineCellCommentItemModel *modelComment = self.commentItemsArray[idx];
           self.headerText = [NSString stringWithFormat:@"%@ %@ :  %@",NSLocalizedString(@"VDhuifu", nil),model.otherUserName, model.writtenWords];
            self.rangeB = [self.headerText rangeOfString:model.otherUserName];
            // 2.将字符串拆分，按照需要展现的颜色或字体的不同拆分成多个单独的字符串，并转化成NSRange格式；
            NSRange rangeA = [self.headerText rangeOfString:NSLocalizedString(@"VDhuifu", nil)];
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.headerText];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeA];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"B0B0B0"] range:self.rangeB];
            
            return attString;
        } else {
              self.headerText = [NSString stringWithFormat:@"%@", model.writtenWords];
            // 2.将字符串拆分，按照需要展现的颜色或字体的不同拆分成多个单独的字符串，并转化成NSRange格式；
//            NSRange rangeA = [self.headerText rangeOfString:NSLocalizedString(@"VDhuifu", nil)];
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.headerText];
//            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeA];
//            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"B0B0B0"] range:self.rangeB];
            [attString setAttributes:@{NSLinkAttributeName : [NSString stringWithFormat:@"%ld",(long)model.ID],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"B0B0B0"]} range:[self.headerText rangeOfString:[userName objectForKey:@"userName"]]];
            return attString;
        }

    } else {
        return nil;
    }
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(SDTimeLineCellLikeItemModel *)model
{
    NSString *text = model.userName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
    
    return attString;
}


#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    DLog(@"这是什么%@", link.linkValue);
}

- (NSMutableArray *)clickArr {
    if (!_clickArr) {
        _clickArr  =  [NSMutableArray arrayWithCapacity:0];
    }
    return _clickArr;
}

- (NSMutableArray *)idArr {
    if (!_idArr) {
        _idArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _idArr;
}

@end
