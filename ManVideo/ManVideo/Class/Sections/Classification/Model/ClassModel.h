//
//  ClassModel.h
//  Clipyeu ++
//
//  Created by Josee on 24/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BottomAdvertisementModel : NSObject
@property(nonatomic,copy)NSString *advertisementContent;
@property(nonatomic,copy)NSString *advertisingLinks;
@property(nonatomic,assign)int pageNum;
@property(nonatomic,assign)int pageSize;
@property(nonatomic,assign)int startIndex;

@end

@interface ClassModel : CommonModel

@property(nonatomic,copy)NSString *adTitle;
@property(nonatomic,copy)NSString *auditor;
@property(nonatomic,copy)NSString *autoArtific;
@property(nonatomic,strong)BottomAdvertisementModel *bottomAdvertisement;//!!!!
@property(nonatomic,assign)int category;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *gifUrl;
@property(nonatomic,assign)int isclip;
@property(nonatomic,copy)NSString *musicUrl;
@property(nonatomic,copy)NSString *originalFileName;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger startIndex;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,strong)NSArray *titleList;
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *videoUrlBefore;

@end

@interface ClassTotalDataModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSMutableArray <ClassModel *>*videoUploadingList;

@end

@interface ClassLabelModel : NSObject

@property(nonatomic,assign)int identifier;//字典id
@property(nonatomic,strong)id keyList;//??
@property(nonatomic,copy)NSString *key;//字典key(分类标签key)
@property(nonatomic,copy)NSString *name;//字典名称(分类标签名称)
@property(nonatomic,copy)NSString *value;//分类标签值
@property(nonatomic,strong)id remark;//??
@property(nonatomic,copy)NSString *createTime;//创建时间
@property(nonatomic,strong)id createBy;//??
@property(nonatomic,copy)NSString *updateTime;//更新时间
@property(nonatomic,copy)id updateBy;//??

@end

//可能被废弃的
@interface VideoUploadingList : NSObject

@property(nonatomic,copy)NSString *videoType;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,assign)NSInteger shareNum;
@property(nonatomic,copy)NSString *auditStatus;
@property(nonatomic,assign)NSInteger commentsCount;
@property(nonatomic,copy)NSString *videoUrl;
@property(nonatomic,copy)NSString *category;
@property(nonatomic,copy)NSString *videoHeight;
@property(nonatomic,copy)NSString *videoHls;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *advertUrl;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *headerImage;
@property(nonatomic,copy)NSString *thumbnailUrl;
@property(nonatomic,copy)NSString *videoLogId;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,copy)NSString *gifUrl;
@property(nonatomic,assign)NSInteger startIndex;
@property(nonatomic,copy)NSString *statusType;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,assign)NSInteger praiseCount;
@property(nonatomic,assign)NSInteger userId;

@end

NS_ASSUME_NONNULL_END

