//
//  commonModel.m
//  ManVideo
//
//  Created by 刘赓 on 2019/8/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CommonModel.h"

@implementation GKDYBottomAdvertisement

@end

@implementation CommonModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"ID" : @"id",
             };
}


@end
