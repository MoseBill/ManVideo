//
//  CaculateTime.m
//  ZJSport
//
//  Created by mac on 2017/11/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CaculateTime.h"

@implementation CaculateTime

- (NSString *)timeString:(NSString *)timeStr{
    //发布时间
    NSArray *arr1 = [timeStr componentsSeparatedByString:@" "]; //分离日期和时间
    NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"-"];
    NSString *year = arr2[0];
    NSString *month = arr2[1];
    NSString *day = arr2[2];
    
    //当前时间
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *currentDate = [formater stringFromDate:date];
    NSArray *arrCuurrent = [currentDate componentsSeparatedByString:@"-"];
    NSString *curYear = arrCuurrent[0];
    NSString *curMonth = arrCuurrent[1];
    NSString *curDay = arrCuurrent[2];
    
    if ([curYear isEqualToString:year]) { //年
        
        if ([curMonth isEqualToString:month]) {//月
        
            if ([curDay isEqualToString:day]) {//日
                return [self howManyTimeAgo:timeStr];
                
            }else{
                int currDay = [curDay intValue];
                int preDay = [day intValue];
                
                if ((currDay - preDay) == 1) {
                    return @"昨天";
                }
                if ((currDay - preDay) == 2){
                    return @"前天";
                }else{
                    return arr1[0];
                }
            }
            
        }else{ //不同月
            
            //如果今天为1，2号情况下
            if ([curDay isEqualToString:@"01"]) {
                if ([month isEqualToString:@"02"]) {
                    if ([self leapYear:[year intValue]]) { //闰年
                        if ([day isEqualToString:@"29"]) {
                            return @"昨天";
                        }
                        if([day isEqualToString:@"28"]){
                            return @"前天";
                        }
                    }else{ //平年
                        if ([day isEqualToString:@"28"]) {
                            return @"昨天";
                        }
                        if([day isEqualToString:@"27"]){
                            return @"前天";
                        }
                    }
                }
                if ([month isEqualToString:@"01"] || [month isEqualToString:@"03"] || [month isEqualToString:@"05"] || [month isEqualToString:@"07"] || [month isEqualToString:@"08"] || [month isEqualToString:@"10"] || [month isEqualToString:@"12"]) {
                    
                    if ([day isEqualToString:@"31"]) {
                        return @"昨天";
                    }
                    if([day isEqualToString:@"30"]){
                        return @"前天";
                    }
                }
                if ([month isEqualToString:@"04"] || [month isEqualToString:@"06"] || [month isEqualToString:@"09"] || [month isEqualToString:@"011"]) {
                    
                    if ([day isEqualToString:@"30"]) {
                        return @"昨天";
                    }
                    if([day isEqualToString:@"29"]){
                        return @"前天";
                    }
                }
                
            }else if ([curDay isEqualToString:@"02"]){
                if ([month isEqualToString:@"02"]) {
                    if ([self leapYear:[year intValue]]) { //闰年
                        if ([day isEqualToString:@"29"]) {
                            return @"前天";
                        }
                    }else{ //平年
                        if ([day isEqualToString:@"28"]) {
                            return @"前天";
                        }
                    }
                }
                if ([month isEqualToString:@"01"] || [month isEqualToString:@"03"] || [month isEqualToString:@"05"] || [month isEqualToString:@"07"] || [month isEqualToString:@"08"] || [month isEqualToString:@"10"] || [month isEqualToString:@"12"]) {
                    
                    if ([day isEqualToString:@"31"]) {
                        return @"前天";
                    }
                    
                }
                if ([month isEqualToString:@"04"] || [month isEqualToString:@"06"] || [month isEqualToString:@"09"] || [month isEqualToString:@"011"]) {
                    
                    if ([day isEqualToString:@"30"]) {
                        return @"前天";
                    }
                }
                
            }else{
                return arr1[0];
            }
        }
        
    }else{ //不同年
        return arr1[0]; //返回日期
    }
    return arr1[0];
}

//判断是否为闰年
- (BOOL)leapYear:(int)year {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}

//判断多长时间前
- (NSString *)howManyTimeAgo:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:timeStr];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long preStamp = [lastDate timeIntervalSince1970];
    
    NSDate *curDate = [NSDate date];
    long curStamp = [curDate timeIntervalSince1970];
    
    long gapTime = curStamp - preStamp;
    long minute = gapTime / 60;
    long hour = minute / 60;
    
    if (hour > 0) {
        return [NSString stringWithFormat:@"%ld小时前",hour];
    }else{
        if (minute > 0) {
            return [NSString stringWithFormat:@"%ld分钟前",minute];
        }else{
            return @"刚刚";
        }
    }
    
}





@end
