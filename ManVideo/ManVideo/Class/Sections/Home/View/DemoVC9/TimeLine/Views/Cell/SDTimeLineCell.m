//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDTimeLineCellCommentView.h"
#import "SDTimeLineCellOperationMenu.h"
#import "LEETheme.h"
#import "CaculateTime.h"
#import "YTTextViewAlertView.h"

const CGFloat contentLabelFontSize = 13;
#define Offset SCALING_RATIO(10)

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@interface SDTimeLineCell ()
//<ReplyActionDelegate>
{
//    CGFloat margin;
}

@property(nonatomic,strong)UIButton *iconBtn;//头像👤
@property(nonatomic,strong)UILabel *nameLable;//用户名
@property(nonatomic,strong)UILabel *timeLabel;//时间
@property(nonatomic,strong)UILabel *contentLabel;//内容
@property(nonatomic,strong)SDTimeLineCellOperationMenu *operationMenu;
@property(nonatomic,strong)SDTimeLineCellCommentView *commentView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation SDTimeLineCell

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"050013"];
        [self NSNotification];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }return self;
}

- (void)richElementsInCellWithModel:(SDTimeLineCellModel *)model{
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_URL,model.headerImage]]
                            forState:UIControlStateNormal
                    placeholderImage:kIMG(@"头像占位图评论")];
    self.nameLable.text = model.userName;
    self.timeLabel.text = [model.createDate substringToIndex:10];
    if (model.otherUserName) {
        self.contentLabel.text = [NSString stringWithFormat:@"%@ 回复 %@  ：%@",model.userName,model.otherUserName,model.writtenWords];
    } else {
        self.contentLabel.text = model.writtenWords;
    }
}

-(CGFloat)cellHeightWithModel:(SDTimeLineCellModel *)model{
    [self.contentView layoutIfNeeded];//必须要刷新
    return self.contentLabel.mj_y + self.contentLabel.mj_h + Offset;
}

#pragma mark —— 点击事件
- (void)operationButtonClicked{
    [self postOperationButtonClickedNotification];
    if ( _operationMenu.commentButtonClickedOperation) {
        _operationMenu.commentButtonClickedOperation();
    }
}

-(void)iconBtnClickEvent:(UIButton *)sender{

}

- (void)moreButtonClicked{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

//- (void)clickReplyAction:(UIButton *)action {
//    DLog(@"点击了哪个%ld",(long)action.tag);
//    NSArray *arrayReply = [SDTimeLineCellModel mj_objectArrayWithKeyValuesArray:_model.replyList];
//     SDTimeLineCellModel *model = arrayReply[action.tag];
//    if ([self.delegate respondsToSelector:@selector(didReplyAction:)]) {
//        [self.delegate didReplyAction:model];
//    }
//}
//
//- (void)headerBtnClick:(UIButton *)click {
//    NSString * userId = [NSString stringWithFormat:@"%ld",_model.userId];
//    if([self.delegate respondsToSelector:@selector(clickActionHeaderImage:)]) {
//        [self.delegate clickActionHeaderImage:userId];
//    }
//}
#pragma mark —— private method
-(void)NSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveOperationButtonClickedNotification:)
                                                 name:kSDTimeLineCellOperationButtonClickedNotification
                                               object:nil];
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification{
//    UIButton *btn = [notification object];
//    if (btn != _operationButton && _operationMenu.isShowing) {
//        _operationMenu.show = NO;
//    }
}

- (void)postOperationButtonClickedNotification{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification
//                                                        object:_operationButton];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];
}
#pragma mark —— lazyLoad
-(UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = UIButton.new;
        _iconBtn.backgroundColor = kWhiteColor;
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.layer.cornerRadius = SCREEN_WIDTH / 30;
        [_iconBtn addTarget:self
                     action:@selector(iconBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_iconBtn];
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 15,SCREEN_WIDTH / 15));
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
        }];
    }return _iconBtn;
}

-(UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = UILabel.new;
        [_nameLable sizeToFit];
        _nameLable.textColor = kWhiteColor;
        [self.contentView addSubview:_nameLable];
        [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconBtn.mas_right).offset(SCALING_RATIO(10));
            make.top.equalTo(self.iconBtn);
            make.bottom.equalTo(self.iconBtn.mas_centerY);
        }];
    }return _nameLable;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = UILabel.new;
        [_timeLabel sizeToFit];
        _timeLabel.textColor = kWhiteColor;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLable);
            make.top.equalTo(self.iconBtn.mas_centerY).offset(SCALING_RATIO(10));
            make.bottom.equalTo(self.iconBtn).offset(SCALING_RATIO(10));
        }];
    }return _timeLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = UILabel.new;
        _contentLabel.textColor = kWhiteColor;
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(SCALING_RATIO(10));
            make.left.equalTo(self.nameLable);
            make.right.equalTo(self.contentView);
        }];
    }return _contentLabel;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }return _dataSource;
}



@end

