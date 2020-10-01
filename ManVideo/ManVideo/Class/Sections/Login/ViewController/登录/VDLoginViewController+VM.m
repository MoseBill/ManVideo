//
//  VDLoginViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/23.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDLoginViewController+VM.h"

@implementation VDLoginViewController (VM)

//登录接口
-(void)login{
    @weakify(self)
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                           path:@"/member/loginByUsername"
                                                     parameters:@{
                                                                  @"ip":[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ifconfig.me/ip"]
                                                                                                 encoding:NSUTF8StringEncoding
                                                                                                    error:Nil],
                                                                  @"imei":UDID,
                                                                  @"phone":[NSString stringWithFormat:@"84%@",self.iphoneTextField.text],
                                                                  @"password":self.passwordTextField.text
                                                                  }
                          ];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        BaseUrl;
        if (response.isSuccess) {
            NSLog(@"登陆成功——%@",response.reqResult);
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDLoginSuccess", nil)];

            [self backBtnClickEvent:self.registerBtn];
            //         LoginModel *loginModel = [LoginModel mj_objectWithKeyValues:dict];
            NSString *userId = [NSString stringWithFormat:@"%@",response.reqResult[@"userId"]];
            NSString *token = [NSString stringWithFormat:@"%@",response.reqResult[@"token"]];

            NSLog(@"登陆的的token = %@",token);
            [[NSUserDefaults standardUserDefaults] setObject:token
                                                      forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:userId
                                                      forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"84%@",self.iphoneTextField.text]
                                                      forKey:@"iphone"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text
                                                      forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self score];
            //登录成功——发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_Success"
                                                                object:nil];
        }
    }];
}

//积分接口
- (void)score{
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                           path:@"/member/integral"
                                                     parameters:@{
                                                                  @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] ? : @"",
                                                                  @"date":[self.formatter stringFromDate:[NSDate date]],
                                                                  @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @""
                                                                  }
                          ];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//        @strongify(self)
        if (response.isSuccess) {
            NSLog(@"登陆成功——%@",response.reqResult);
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDLoginSuccess", nil)];
        }
    }];
}

@end
