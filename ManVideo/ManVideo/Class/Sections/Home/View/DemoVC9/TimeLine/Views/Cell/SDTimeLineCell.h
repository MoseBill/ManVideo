//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "SDTimeLineCellModel.h"

//@protocol SDTimeLineCellDelegate <NSObject>
//
//- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
//- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;
//- (void)didPushUserView:(UITapGestureRecognizer *)tap;
//- (void)didReplyAction:(SDTimeLineCellModel*)model;
//- (void)replyDidTap:(UIButton*)tap;
//- (void)clickActionHeaderImage:(NSString *)image;
//
//@end

//@class SDTimeLineCellModel;

@interface SDTimeLineCell : UITableViewCell

//@property(nonatomic,weak)id<SDTimeLineCellDelegate> delegate;

@property(nonatomic,strong)SDTimeLineCellModel *model;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSMutableArray * likeArr;
@property(nonatomic,copy)void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property(nonatomic,strong)NSArray *replyArr;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;

-(CGFloat)cellHeightWithModel:(SDTimeLineCellModel *)model;

-(void)richElementsInCellWithModel:(SDTimeLineCellModel *)model;




@end
