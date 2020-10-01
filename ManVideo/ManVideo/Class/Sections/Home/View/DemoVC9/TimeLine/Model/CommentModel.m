//
//  CommentModel.m
//  MOABBS
//
//  Created by odin on 2019/1/28.
//  Copyright © 2019 odin. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"ID" : @"id",
             };
}

@end
