//
//  SystemModel.m
//  Clipyeu ++
//
//  Created by Josee on 08/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SystemModel.h"

@implementation SystemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"Id" : @"id",
             };
}

@end
