//
//  SDTimeLineCellModel.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <Foundation/Foundation.h>

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel;

@interface ReplyList :NSObject

@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *writtenWords;
@property(nonatomic,assign)NSInteger videoId;
@property(nonatomic,assign)NSInteger videoUserId;
@property(nonatomic,copy)NSString *newId;
@property(nonatomic,copy)NSString *headerImage;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,assign)NSInteger commentId;
@property(nonatomic,copy)NSString *otherUserName;

@end

@interface Chlid_commentList : NSObject

@end

@interface CommentList :NSObject

@end

@interface SDTimeLineCellModel : NSObject

@property(nonatomic,copy) NSString *iconName;
@property(nonatomic,copy) NSString *msgContent;
@property(nonatomic,strong) NSArray *picNamesArray;
@property(nonatomic,assign, getter = isLiked) BOOL liked;
@property(nonatomic,strong) NSArray<SDTimeLineCellLikeItemModel *> *likeItemsArray;
@property(nonatomic,strong) NSArray<SDTimeLineCellCommentItemModel *> *commentItemsArray;
@property(nonatomic,assign) BOOL isOpening;
@property(nonatomic,assign, readonly) BOOL shouldShowMoreButton;
@property(nonatomic,assign) CGSize size;
/**collectionView偏移位置*/
@property(nonatomic,assign)CGFloat collectionViewOffsetX;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *label;
@property(nonatomic,copy)NSString *likeFlag;
@property(nonatomic,copy)NSString *avatorId;
@property(nonatomic,copy)NSString *createBy;
@property(nonatomic,assign)NSInteger likes;
@property(nonatomic,assign)NSInteger isGood;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)NSInteger clicks;
@property(nonatomic,assign)NSInteger readOnly;
@property(nonatomic,copy)NSArray<CommentList *> *commentList;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,copy)NSString *imgPath;
@property(nonatomic,assign)NSInteger top;
@property(nonatomic,copy)NSString *parentId;
@property(nonatomic,copy)NSArray<Chlid_commentList *> *chlid_commentList;
@property(nonatomic,copy)NSAttributedString *attributedContent;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *articleId;
@property(nonatomic,copy)NSString *comment;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *writtenWords;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *headerImage;
@property(nonatomic,copy)NSString *commentId;
@property(nonatomic,assign)NSInteger newId;
@property(nonatomic,assign)NSInteger videoId;
@property(nonatomic,copy)NSArray<ReplyList *> *replyList;
@property(nonatomic,assign)NSInteger byId;
@property(nonatomic,copy)NSString * otherUserName;

@end

@interface SDTimeLineCellLikeItemModel : NSObject

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSAttributedString *attributedContent;

@end

@interface SDTimeLineCellCommentItemModel : NSObject

@property(nonatomic,copy)NSString *commentString;
@property(nonatomic,copy)NSString *firstUserName;
@property(nonatomic,copy)NSString *firstUserId;
@property(nonatomic,copy)NSString *secondUserName;
@property(nonatomic,copy)NSString *secondUserId;
@property(nonatomic,copy)NSAttributedString *attributedContent;
@property(nonatomic,assign)NSInteger articleId;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString * label;
@property(nonatomic,copy)NSString *likeFlag;
@property(nonatomic,copy)NSString *avatorId;
@property(nonatomic,copy)NSString *createBy;
@property(nonatomic,assign)NSInteger likes;
@property(nonatomic,assign)NSInteger isGood;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,assign)NSInteger clicks;
@property(nonatomic,assign)NSInteger readOnly;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,copy)NSString *imgPath;
@property(nonatomic,assign)NSInteger top;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *comment;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *writtenWords;
@property(nonatomic,assign)NSInteger videoId;
@property(nonatomic,assign)NSInteger videoUserId;
@property(nonatomic,copy)NSString *headerImage;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,assign)NSInteger commentId;
//@property (nonatomic , copy) NSArray<CommentList *>              * commentList;

@end
