//
//  CommentModel.h
//  MOABBS
//
//  Created by odin on 2019/1/28.
//  Copyright © 2019 odin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@interface Chlid_commentList : NSObject
//
//@property (nonatomic , assign) NSInteger              parentId;
//@property (nonatomic , assign) NSInteger              status;
//@property (nonatomic , copy) NSString              * createBy;
//@property (nonatomic , copy) NSString              * avatorId;
//@property (nonatomic , assign) NSInteger              ID;
//@property (nonatomic , copy) NSString              * articleId;
//@property (nonatomic , assign) NSInteger              likes;
//@property (nonatomic , copy) NSString              * comment;
//@property (nonatomic , copy) NSString              * createTime;
//
//@end
//
//@interface CommentList :NSObject
//
//
//
//
//@end

@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@property (nonatomic,assign) CGSize size;
/**collectionView偏移位置*/
@property (nonatomic, assign) CGFloat collectionViewOffsetX;

@property (nonatomic , assign) NSInteger              articleId;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * label;
@property (nonatomic , copy) NSString              * likeFlag;
@property (nonatomic , copy) NSString              * avatorId;
@property (nonatomic , copy) NSString              * createBy;
@property (nonatomic , assign) NSInteger              likes;
@property (nonatomic , assign) NSInteger              isGood;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              clicks;
@property (nonatomic , assign) NSInteger              readOnly;
//@property (nonatomic , copy) NSArray<CommentList *>              * commentList;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * commentCount;

@property (nonatomic , assign) NSInteger              top;


@property (nonatomic , copy) NSString              * writtenWords;

@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , copy) NSString              * comment;
@property (nonatomic, strong) NSMutableAttributedString   *commentString;

//@property (nonatomic , copy) NSArray<Chlid_commentList *>              * chlid_commentList;

@end

NS_ASSUME_NONNULL_END
