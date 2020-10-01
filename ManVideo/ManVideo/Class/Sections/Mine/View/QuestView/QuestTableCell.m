//
//  QuestTableCell.m
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "QuestTableCell.h"

@interface QuestTableCell()

@end

@implementation QuestTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.questCount.layer.masksToBounds = YES;
    self.questCount.layer.cornerRadius = 5.0f;
    self.successBtn.backgroundColor = kWhiteColor;
    self.successBtn.layer.masksToBounds = YES;
    self.successBtn.layer.cornerRadius = 5.0f;

    self.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;
}

- (void)richElementsInCellWithModel:(GKDYPersonalModel *)model
                      WithIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        self.questCount.text = model.spotTntegral;
        NSString *likeString = NSLocalizedString(@"ByThumbUp", nil);//被点赞
        NSString *cancelString = NSLocalizedString(@"VDLikeNoCancel", nil);//不可取消点赞
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",likeString,cancelString]
                                                                                   attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size: 8],
                                                                                                NSForegroundColorAttributeName: [UIColor colorWithRed:157/255.0
                                                                                                                                                green:157/255.0
                                                                                                                                                 blue:156/255.0
                                                                                                                                                alpha:1.0]}];
        [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial"
                                                                     size: 17],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:234/255.0
                                                                                green:234/255.0
                                                                                 blue:234/255.0
                                                                                alpha:1.0]}
                        range:NSMakeRange(0, likeString.length)];
        [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size: 8],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:157/255.0
                                                                                green:157/255.0
                                                                                 blue:156/255.0
                                                                                alpha:1.0]}
                        range:NSMakeRange(likeString.length,
                                          cancelString.length)];
        self.titleLabel.attributedText = string;
        if (model.spot == 0) {
            [self UNFinished];
        } else {
            [self finished];
        }
    } else if (indexPath.section == 0 &&
               indexPath.row == 1) {
        self.questCount.text = model.shareOwnTntegral;
        self.detailLabel.text = NSLocalizedString(@"VDOnceShare", nil);//(每一平台分享一次算得分,同一平台分享多次只算一次)
        self.titleLabel.text = NSLocalizedString(@"VDshareText", nil);//自己分享
        if (model.shareOwn == 0) {
            [self UNFinished];
        } else {
            [self finished];
        }
    } else if (indexPath.section == 0 &&
               indexPath.row == 2){
        self.questCount.text = model.otherSpotTntegral;
        if (model.otherSpot) {
            [self UNFinished];
        } else {
            [self finished];
        }
    } else if (indexPath.section == 0 &&
               indexPath.row == 3) {
        self.questCount.text = model.followTntegral;
        if (model.follow == 0) {
            [self UNFinished];
        } else {
            [self finished];
        }
    } else if (indexPath.section == 0 &&
               indexPath.row == 4) {
        self.questCount.text = model.createDateTntegral;
        if (model.createDate == 0) {
            [self UNFinished];
        } else {
            [self finished];
        }
    } else if (indexPath.section == 0 &&
               indexPath.row == 5) {
        self.questCount.text = model.uploadTntegral;
        if (model.upload == 0) {
            [self UNFinished];
        } else {
            [self finished];
        }
    } else if (indexPath.section == 0 &&
               indexPath.row == 6) {
        self.questCount.text = model.goodFriendTntegral;
        if (model.goodFriend == 0) {
            [self UNFinished];
        } else {
            [self finished];
        }
    }
    if (indexPath.section == 1 &&
        indexPath.row == 0) {
        self.questCount.text = model.uploadSevenTntegral;
        if (model.uploadSeven == 7) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%@",model.createDate]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    } else if (indexPath.section == 1 &&
               indexPath.row == 1) {
        self.questCount.text =  model.loginSevenTntegral;
        if ([model.loginSeven intValue] == 7) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%@",model.creteaNew]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    } else if (indexPath.section == 2 &&
               indexPath.row == 0) {
        self.questCount.text = model.loginThirtyTntegral;
        if ([model.loginThirty intValue] == 30) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%@",model.creteaNew]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    } else if (indexPath.section == 2 &&
               indexPath.row == 1) {
        self.questCount.text = model.uploadThirtyTntegral;
        if (model.uploadThirty == 30) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%ld/30",(long)model.uploadThirty]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    } else if (indexPath.section == 2 &&
               indexPath.row == 2) {
        self.questCount.text = model.uploadOneFiveZeroTntegral;
        if (model.uploadOneFiveZero == 150) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%ld/150",(long)model.uploadOneFiveZero]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        self.questCount.text = model.uploadThreeZeroZeroTntegral;
        if (model.uploadThreeZeroZero == 300) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%ld/300",(long)model.uploadThreeZeroZero]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    } else if (indexPath.section == 2 &&
               indexPath.row == 4) {
        self.questCount.text = model.uploadFourFiveZeroTntegral;
        if (model.uploadFourFiveZero == 450) {
            [self finished];
        } else {
            [self.successBtn setTitle:[NSString stringWithFormat:@"%ld/450",(long)model.uploadFourFiveZero]
                             forState:UIControlStateNormal];
            [self unFinished];
        }
    }
}

//已完成
-(void)finished{
    [self.successBtn setTitle:NSLocalizedString(@"VDcompletedText", nil)
                     forState:UIControlStateNormal];//已完成
    self.successBtn.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    [self.successBtn setTitleColor:kWhiteColor
                          forState:UIControlStateNormal];
}
//未完成
-(void)unFinished{
    [self.successBtn setTitleColor:kWhiteColor
                          forState:UIControlStateNormal];
    self.successBtn.backgroundColor = [UIColor colorWithHexString:@"808080"];
}

-(void)UNFinished{
    [self.successBtn setTitle:NSLocalizedString(@"VDunfinishedText", nil)
                     forState:UIControlStateNormal];//未完成
    [self unFinished];
}


- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];
}

@end
