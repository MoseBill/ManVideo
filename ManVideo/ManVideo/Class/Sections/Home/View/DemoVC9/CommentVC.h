//
//  DemoVC9.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


#import "SDBaseTableViewController.h"
#import "SDTimeLineCellModel.h"

@protocol ReplyActionViewDelegate <NSObject>

- (void)didReplyActionDelegate:(UIButton *)delegate;
- (void)didReplyTapDelegate:(NSInteger)index;
- (void)clickActionPushPerson:(NSString *)person;
- (void)notificationSendMessage:(NSString *)message;

@end

/**
 评论弹出部分
 */
@interface CommentVC : GKDYBaseViewController

@property(nonatomic,weak)id<ReplyActionViewDelegate> delegate;
@property(nonatomic,assign)int artId;
@property(nonatomic,assign)int idString;
@property(nonatomic,assign)int videoUserId;
@property(nonatomic,copy)void(^btnActionBlock)(NSString *index);

@property(nonatomic,strong)NSMutableArray <SDTimeLineCellModel *>*commentArr;
@property(nonatomic,strong)SDTimeLineCellModel *model;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)UITableView *tableView;

-(void)actionBlock:(DataBlock)block;

@end
