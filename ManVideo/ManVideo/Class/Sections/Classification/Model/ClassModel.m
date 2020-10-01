//
//  ClassModel.m
//  Clipyeu ++
//
//  Created by Josee on 24/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ClassModel.h"

@implementation BottomAdvertisementModel

@end

@implementation ClassModel

+(NSDictionary *)objectClassInArray{

    return @{
             @"bottomAdvertisement" : [BottomAdvertisementModel class]
             };
}

@end

@implementation ClassTotalDataModel : NSObject

@end

@implementation ClassLabelModel

/* 返回的字典，key为模型属性名，value为转化的字典的多级key */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"identifier" : @"id",
             };
}

@end


//可能被废弃的
@implementation VideoUploadingList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"videoUploadingList" : [VideoUploadingList class]};
}

@end
