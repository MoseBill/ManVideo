//
//  HistoryModel.h
//  Clipyeu ++
//
//  Created by Josee on 02/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryModel : NSObject

@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              bankCard;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * savings;
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , assign) NSInteger              integral;
@property (nonatomic , copy) NSString              * money;

@property (nonatomic , copy) NSString              * followCount;

@property (nonatomic , copy) NSString              * backWaterType;
@property (nonatomic , copy) NSString              * vipLevel;
@property (nonatomic , copy) NSString              * payNum;
@property (nonatomic , copy) NSString              * qqNum;
@property (nonatomic , copy) NSString              * isUse;
@property (nonatomic , copy) NSString              * loginAddress;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * updateBy;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * webChat;
@property (nonatomic , copy) NSString              * relName;
@property (nonatomic , copy) NSString              * inviteCode;

@property (nonatomic , copy) NSString              * createBy;
@property (nonatomic , copy) NSString              * userCount;
@property (nonatomic , copy) NSString              * userTypeNew;
@property (nonatomic , copy) NSString              * headerImage;
@property (nonatomic , copy) NSString              * picPath;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * refereeCode;
@property (nonatomic , copy) NSString              * userType;
@property (nonatomic , copy) NSString              * bankNum;
@property (nonatomic , copy) NSString              * userInvitation;

@property (nonatomic , copy) NSString              * password;

@property (nonatomic , copy) NSString              * imei;
@property (nonatomic , copy) NSString              * ip;
@property (nonatomic , copy) NSString              * loginTime;
@property (nonatomic , copy) NSString              * agentAcct;


@end

NS_ASSUME_NONNULL_END
