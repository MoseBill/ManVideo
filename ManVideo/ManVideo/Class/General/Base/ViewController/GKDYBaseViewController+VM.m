//
//  GKDYBaseViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/18.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController+VM.h"

@implementation GKDYBaseViewController (VM)

-(void)login{
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:@"/member/loginByUsername"
                                                     parameters:@{
                                                                  @"ip":[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ifconfig.me/ip"]
                                                                                                 encoding:NSUTF8StringEncoding
                                                                                                    error:Nil],
                                                                  @"imei":UDID,
                                                                  @"phone":[NSString stringWithFormat:@"84%@",self.userName],
                                                                  @"password":self.password
                                                                  }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (response.isSuccess) {
            NSLog(@"--%@",response.reqResult);
            [SVProgressHUD showSuccessWithStatus:@"登陆成功"];///KKK
            NSString *userId = [NSString stringWithFormat:@"%@",response.reqResult[@"userId"]];
            NSString *token = [NSString stringWithFormat:@"%@",response.reqResult[@"token"]];
            [[NSUserDefaults standardUserDefaults] setObject:token
                                                      forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:userId
                                                      forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:response.reqResult[@"phone"]
                                                      forKey:@"iphone"];
            [[NSUserDefaults standardUserDefaults] setObject:self.password
                                                      forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

//KKK还有登录任务奖励没有实现

@end
