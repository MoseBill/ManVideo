//
//  AppDelegate+VM.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/24.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (VM)

- (void)login;//登录
- (void)ADnetworking;//开屏广告
- (void)score;//积分接口 
- (void)getImei;//获取imei接口
- (void)hsUpdateApp;//App更新检测
- (void)invateCode;//邀请好友接口

@end

NS_ASSUME_NONNULL_END
