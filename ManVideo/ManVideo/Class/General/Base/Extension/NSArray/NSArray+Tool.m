//
//  NSArray+Tool.m
//  GoldenCatLottery
//
//  Created by Aron on 2017/8/8.
//  Copyright © 2017年 Aron. All rights reserved.
//

#import "NSArray+Tool.h"

@implementation NSArray (Tool)
- (CGFloat)getMin {
    return [[self valueForKeyPath:@"@min.floatValue"] floatValue];
}
- (CGFloat)getMax {
    return [[self valueForKeyPath:@"@max.floatValue"] floatValue];
}

- (NSArray *)getAllCombiesWithselectCount: (NSInteger)count {
    NSMutableArray *result = [NSMutableArray array];//结果
    NSMutableArray *list = [NSMutableArray array];//每次递归的子集
    int pos = 0;//保证子集升序排列
    [self subsetsHelper:result list:list nums:self postion:pos];
    NSMutableArray *resultArray = [NSMutableArray new];
    for (int i = 0; i<result.count; i++) {
        NSArray *array = [result[i]mutableCopy];
        if (array.count == count) {
            [resultArray addObject:array];
        }
    }
    return resultArray;
}
- (void)subsetsHelper:(NSMutableArray<NSMutableArray *> *)result
                 list:(NSMutableArray *)list
                 nums:(NSArray *)nums
              postion:(int)pos {
    [result addObject:[list mutableCopy]];
    for (int i = pos; i < nums.count; i++) {
        [list addObject:nums[i]];
        [self subsetsHelper:result list:list nums:nums postion:i + 1];
        [list removeObjectAtIndex:list.count - 1];
    }
}

- (NSArray *)removeDuplicatedOfArray {
    NSSet *set = [NSSet setWithArray:self];
    NSArray *array = [set allObjects];
    return array;
}
@end
