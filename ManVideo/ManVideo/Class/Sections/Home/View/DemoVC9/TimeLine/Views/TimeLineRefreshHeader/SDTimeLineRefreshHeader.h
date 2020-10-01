//
//  SDTimeLineRefreshHeader.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/3/5.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SDBaseRefreshView.h"

@interface SDTimeLineRefreshHeader : SDBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)(void);

@end
