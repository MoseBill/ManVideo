//
//  AppDelegate+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/24.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "AppDelegate+VM.h"

@implementation AppDelegate (VM)

- (void)login{

//    // 从keychain中读取用户名和密码
//    NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[ZHKeyChainManager keyChainReadData:KEY_SERVICE_PASSWORD];
//    NSString *phone = [readUsernamePassword objectForKey:KEY_USERPhone];
//    NSString *password = [readUsernamePassword objectForKey:KEY_PASSWord];

//    DLog(@"登录信息%@",self.loginInDict);


//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] isEqualToString:@""]) {
//        <#statements#>
//    }
//BaseUrl
    @weakify(self)
    [CMRequest requestNetSecurityGET:@"/member/loginByUsername"
                      paraDictionary:@{
                          @"phone":[[NSUserDefaults standardUserDefaults] objectForKey:@"iphone"] ?:@"",
                          @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] ?:@""
                      }
                        successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"登录成功%@",dict);
        @strongify(self)
        NSString *userId = [NSString stringWithFormat:@"%@",dict[@"data"][@"userId"]];
        NSString *token = [NSString stringWithFormat:@"%@",dict[@"data"][@"token"]];
        NSLog(@"每次进入APP的token = %@",token);
        [[NSUserDefaults standardUserDefaults] setObject:token
                                                  forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:userId
                                                  forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //登录成功➕积分
        [self score];
        } errorBlock:^(NSString * _Nonnull message) {
//                                @strongify(self)
            if (message) {}
        } failBlock:^(NSError * _Nonnull error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                           message:NSLocalizedString(@"VDNoNetwork", nil)
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
            [alert show];
        }];
}
#pragma mark —— 开屏广告
- (void)ADnetworking {
    [CMRequest requestNetSecurityGET:@"/member/getHomePageAdvertisement"
                      paraDictionary:[NSDictionary new]
                        successBlock:^(NSDictionary * _Nonnull dict) {
//                            DLog(@"广告%@",dict);
                            if (dict) {
                                __block NSString *imageString = [NSString stringWithFormat:@"%@",dict[@"data"][@"advertUrl"]];
                                NSString *advertString = [NSString stringWithFormat:@"%@",dict[@"data"][@"videoUrl"]];
                                NSString *imageGif = [NSString stringWithFormat:@"%@%@",REQUEST_URL,advertString];
                                DHLaunchAdPageHUD *launchAd = [[DHLaunchAdPageHUD alloc] initWithFrame:CGRectMake(0,
                                                                                                                  0,
                                                                                                                  DDScreenW,
                                                                                                                  SCREEN_HEIGHT)
                                                                                            aDduration:6.0f
                                                                                            aDImageUrl:imageGif
                                                                                        hideSkipButton:NO
                                                                                    launchAdClickBlock:^{
                                                                                        DLog(@"[AppDelegate]:点了广告图片");
                                                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imageString]];
                                                                                    }];
                                [kAPPWindow addSubview:launchAd];
                            }
//                            DLog(@"广告页加载%@",dict);
                        } errorBlock:^(NSString * _Nonnull message) {
                            DLog(@"参数错误%@",message);
                        } failBlock:^(NSError * _Nonnull error) {
                            DLog(@"网络失败%@",error);
                        }];
}
#pragma mark —— 积分接口
- (void)score{
    [CMRequest requestNetSecurityGET:@"/member/integral"
                      paraDictionary:@{
                          @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ? : @"",
                          @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"",
                          @"date":[self.formatter stringFromDate:[NSDate date]] ? : @""
                      }
                        successBlock:^(NSDictionary * _Nonnull dict) {
                            DLog(@"任务奖励请求成功%@",dict);
                        } errorBlock:^(NSString * _Nonnull message) {
                            DLog(@"任务奖励请求失败");
                        } failBlock:^(NSError * _Nonnull error) {
                            DLog(@"任务奖励没有网络");
                        }];
}
#pragma mark —— 获取imei接口
- (void)getImei {
    NSString *url = [NSString stringWithFormat:@"/member/getImei?imei=%@&type=1",UDID];
    [CMRequest requestNetSecurityPOST:url
                       paraDictionary:NSMutableDictionary.dictionary
                         successBlock:^(NSDictionary * _Nonnull dict) {
//                             DLog(@"长链接之后请求成功%@",dict);
                         } errorBlock:^(NSString * _Nonnull message) {
                             DLog(@"长链接之后请求失败%@",message);
                         } failBlock:^(NSError * _Nonnull error) {
                         }];
}
#pragma mark —— App更新检测
- (void)hsUpdateApp{
    NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    DLog(@"哈哈哈版本更新%@",ver);
    NSDictionary *dict = @{
                           @"appType":@"IOS"
                           };
     @weakify(self)
     [CMRequest requestNetSecurityGET:@"/appVersion/appInquire"
                       paraDictionary:dict
                         successBlock:^(NSDictionary * _Nonnull dict) {
                             @strongify(self)
//                             DLog(@"更新软件%@",dict);
                             NSString *appVersion = dict[@"data"][@"appVersion"];
                             NSString *appUpdateUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://clipyeuplus.com/video/package/Clipyeu++.plist"];
                             if ([appVersion compare:ver options:NSCaseInsensitiveSearch] > 0) {
                                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                                                                          message:NSLocalizedString(@"VDNewRelease", nil)
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil)
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                                     [[UIApplication sharedApplication]
                                                                                      openURL:[NSURL URLWithString:appUpdateUrl]];
                                                                                 }];
                                 [alertController addAction:confirm];
                                 [self.window.rootViewController presentViewController:alertController
                                                                              animated:YES
                                                                            completion:nil];
                             }
     } errorBlock:^(NSString * _Nonnull message) {
//          DLog(@"更新软件%@",message);
     } failBlock:^(NSError * _Nonnull error) {
     }];
}

//BaseUrl;
#pragma mark —— 邀请好友接口
- (void)invateCode {
//    NSString *userString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
//    int userId = [userString intValue];
//    NSNumber *number = [NSNumber numberWithInt:userId];
//    self.dict[@"id"] = number;
//    self.dict[@"token"] = token;
    [CMRequest requestNetSecurityGET:@"/videoUploading/inviteCodeList"
                      paraDictionary:@{
                          @"id":@([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]),
                          @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @""
                      }
                        successBlock:^(NSDictionary * _Nonnull dict) {
//                            DLog(@"邀请码%@",self.dict);
                            NSString *inviteString = [NSString stringWithFormat:@"%@",dict[@"data"][@"inviteCode"]];
                            NSUserDefaults *userCode = [NSUserDefaults standardUserDefaults];
                            [userCode setObject:inviteString
                                         forKey:@"inviteCode"];
                            [userCode synchronize];
                        } errorBlock:^(NSString * _Nonnull message) {
                            DLog(@"邀请码%@",message);
                        } failBlock:^(NSError * _Nonnull error) {

                        }];
}

@end
