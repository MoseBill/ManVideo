//
//  GKDYPersonalModel.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/24.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKDYUserModel : NSObject

@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *nani_id;
@property(nonatomic,copy)NSString *club_num;
@property(nonatomic,copy)NSString *is_follow;
@property(nonatomic,copy)NSString *fans_num;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *video_num;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *portrait;
@property(nonatomic,copy)NSString *name_show;
@property(nonatomic,copy)NSString *agree_num;
@property(nonatomic,copy)NSString *favor_num;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *follow_num;

@end

@interface GKDYUserVideoList : NSObject

@property(nonatomic,copy)NSString *has_more;
@property(nonatomic,strong)NSArray *list;

@end

@interface GKDYFavorVideoList : NSObject

@property(nonatomic,copy)NSString *has_more;
@property(nonatomic,strong)NSArray *list;

@end

@interface GKDYPersonalModel : NSObject

@property(nonatomic,copy)NSString *agentAcct;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,assign)NSInteger byId;/* 被关注用户ID*/
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *dynamicCount; /* 关注动态数量 */
@property(nonatomic,strong)NSString *floowCount;
@property(nonatomic,strong)NSString *followCount;
@property(nonatomic,assign)NSInteger follwCount;
@property(nonatomic,assign)NSInteger follwStatus;
@property(nonatomic,strong)NSString *headerImage;
@property(nonatomic,assign)NSInteger ID;/* 用户id*/
@property(nonatomic,copy)NSString * imei;
@property(nonatomic,copy)NSString *inviteCode;
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,copy)NSString *likeCount; /* 喜欢数量 */
@property(nonatomic,copy)NSString *loginAddress;
@property(nonatomic,assign)NSInteger newId;//????
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *praiseCount;
@property(nonatomic,copy)NSString *refereeCode;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *trueName;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString * updateTime;
@property(nonatomic,assign)NSInteger userCount;
@property(nonatomic,copy)NSString *userInvitation;//???
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *verificationCode;
@property(nonatomic,copy)NSString *vipLevel;
@property(nonatomic,copy)NSString *worksCount; /*作品数量 */

//以下字段 待商榷
@property(nonatomic,strong)GKDYUserModel *user;
@property(nonatomic,strong)GKDYUserVideoList *user_video_list;
@property(nonatomic,strong)GKDYFavorVideoList *favor_video_list;
@property(nonatomic,assign)NSInteger goodFriend;
@property(nonatomic,assign)NSInteger uploadThreeZeroZero;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,assign)NSInteger uploadThirty;
@property(nonatomic,assign)NSInteger uploadOneFiveZero;
@property(nonatomic,copy)NSString *loginSeven;
@property(nonatomic,assign)NSInteger uploadSeven;
@property(nonatomic,assign)NSInteger totalScore;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)NSInteger uploadFourFiveZero;
@property(nonatomic,copy)NSString * loginThirty;
@property(nonatomic,copy)NSString * updateDate;
@property(nonatomic,assign)NSInteger otherSpot;
@property(nonatomic,assign)NSInteger spot;
@property(nonatomic,assign)NSInteger shareOwn;
@property(nonatomic,assign)NSInteger upload;
@property(nonatomic,assign)NSInteger follow;
@property(nonatomic,strong)NSString *creteaNew;
@property(nonatomic,assign)NSInteger soptCountList;
@property(nonatomic,assign)NSInteger videoCountList;
@property(nonatomic,copy)NSString *uploadThirtyTntegral;
@property(nonatomic,copy)NSString *uploadFourFiveZeroTntegral;
@property(nonatomic,copy)NSString *otherSpotTntegral;
@property(nonatomic,copy)NSString *monthDateTntegral;
@property(nonatomic,copy)NSString *shareOwnTntegral;
@property(nonatomic,copy)NSString *loginThirtyTntegral;
@property(nonatomic,copy)NSString *spotTntegral;
@property(nonatomic,copy)NSString *goodFriendTntegral;
@property(nonatomic,copy)NSString *loginSevenTntegral;
@property(nonatomic,copy)NSString *followTntegral;
@property(nonatomic,copy)NSString *uploadOneFiveZeroTntegral;
@property(nonatomic,copy)NSString *createDateTntegral;
@property(nonatomic,copy)NSString *uploadSevenTntegral;
@property(nonatomic,copy)NSString *uploadTntegral;
@property(nonatomic,copy)NSString *uploadThreeZeroZeroTntegral;




@end

NS_ASSUME_NONNULL_END
