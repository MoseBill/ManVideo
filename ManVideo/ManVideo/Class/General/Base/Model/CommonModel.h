//
//  commonModel.h
//  ManVideo
//
//  Created by 刘赓 on 2019/8/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKDYBottomAdvertisement : NSObject

@property(nonatomic,copy)NSString *advertisementContent;
@property(nonatomic,copy)NSString *advertisingLinks;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger startIndex;

@end

@interface CommonModel : NSObject

@property(nonatomic,copy)NSString *adTitle;
@property(nonatomic,copy)NSString *advertUrl;
@property(nonatomic,assign)NSInteger auditStatus;
@property(nonatomic,copy)NSString *auditor;
@property(nonatomic,assign)NSInteger autoArtific;
@property(nonatomic,strong)GKDYBottomAdvertisement *bottomAdvertisement;
@property(nonatomic,assign)NSInteger category;
@property(nonatomic,assign)NSInteger commentsCount;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *gifUrl;
@property(nonatomic,copy)NSString *headerImage;
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign)NSInteger isclip;
@property(nonatomic,copy)NSString *musicUrl;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *originalFileName;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger praiseCount;
@property(nonatomic,assign)NSInteger shareNum;
@property(nonatomic,assign)NSInteger startIndex;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,assign)NSInteger statusType;
@property(nonatomic,copy)NSString *thumbnailUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *titleList;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,assign)NSInteger videoHeight;
@property(nonatomic,copy)NSString *videoHls;
@property(nonatomic,assign)NSInteger videoLogId;
@property(nonatomic,copy)NSString *videoType;
@property(nonatomic,copy)NSString *videoUrl;
@property(nonatomic,copy)NSString *videoUrlBefore;
@property(nonatomic,copy)NSString *videoUrlGif;
@property(nonatomic,copy)NSString *videoUrlPng;
@property(nonatomic,copy)NSString *wave;

@end

NS_ASSUME_NONNULL_END

//{
//    adTitle = "";
//    advertUrl = "";
//    auditStatus = 2;
//    auditor = "";
//    autoArtific = 02;
//    bottomAdvertisement =     {
//        advertisementContent = "";
//        advertisingLinks = "";
//        pageNum = 0;
//        pageSize = 10;
//        startIndex = 0;
//    };
//    category = 1;
//    commentsCount = 4;
//    createDate = "2019-09-28T05:06:34.143+0000";
//    endTime = "";
//    gifUrl = "";
//    headerImage = "/video/memberHeadImg/20190817131444_20190817141444.png";
//    id = 1826;
//    isclip = 2;
//    musicUrl = "";
//    nickName = "Minh Tú";
//    originalFileName = "306.mp4";
//    pageNum = 0;
//    pageSize = 10;
//    praiseCount = 46;
//    shareNum = 0;
//    startIndex = 0;
//    startTime = "";
//    statusType = 1;
//    thumbnailUrl = "";
//    title = "GroupGroup,Bigass,Bigcock,MissGong";
//    titleList =     (
//    );
//    type = 04;
//    updateDate = "2019-09-28T05:06:34.143+0000";
//    userId = 995;
//    userName = "";
//    videoHeight = 0;
//    videoHls = "";
//    videoLogId = 0;
//    videoType = "Miệng Bú Cu Mu Được Địt";
//    videoUrl = "/video/slideVideo/156230243807715e549843096482a819b6e306d76e7c8/156230243807715e549843096482a819b6e306d76e7c8.m3u8";
//    videoUrlBefore = "";
//    videoUrlGif = "/video/slideVideo/156230243807715e549843096482a819b6e306d76e7c8.gif";
//    videoUrlPng = "/video/slideVideo/156230243807715e549843096482a819b6e306d76e7c8.jpg";
//    wave = "";
//}
