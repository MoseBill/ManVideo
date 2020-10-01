//
//  NSArray+Tool.h
//  GoldenCatLottery
//
//  Created by Aron on 2017/8/8.
//  Copyright © 2017年 Aron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Tool)

- (CGFloat)getMin;
- (CGFloat)getMax;
- (NSArray *)removeDuplicatedOfArray;
/**
 获取数组指定个数的组合

 @param count
 @return
 */
- (NSArray *)getAllCombiesWithselectCount: (NSInteger)count;

@end
