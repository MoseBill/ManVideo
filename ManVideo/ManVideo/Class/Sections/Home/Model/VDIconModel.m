//
//  VDIconModel.m
//  Clipyeu ++
//
//  Created by Josee on 15/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDIconModel.h"

@implementation VDIconModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
        
        
    }
    
    return self;
    
}

+ (instancetype)IconWithDictionay:(NSDictionary *)dic{
    
    return [[self alloc]initWithDic:dic];
    
    
}

@end
