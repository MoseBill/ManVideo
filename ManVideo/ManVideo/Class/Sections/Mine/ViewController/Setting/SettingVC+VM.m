//
//  SettingVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/27.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SettingVC+VM.h"
#import "HDAlertView.h"

@implementation SettingVC (VM)

- (void)hsUpdateApp{
    NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSDictionary *dict = @{@"appType":@"IOS"};
    [CMRequest requestNetSecurityGET:@"/appVersion/appInquire" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
//        DLog(@"更新软件%@",dict);
        NSString *appVersion = dict[@"data"][@"appVersion"];
        //          NSString * str2 = ver;
        //         NSString *appFullName = dict[@"data"][@"appFullName"];
        NSString *appUpdateUrl = [NSString stringWithFormat:@"https://app.goceshi.com/qy/a3s8"];
        if ([appVersion compare:ver options:NSCaseInsensitiveSearch]>0) {

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDNewRelease", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUpdateUrl]];
            }];
            [alertController addAction:confirm];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            HDAlertView *alertView = [HDAlertView alertViewWithTitle:NSLocalizedString(@"VDbanben", nil) andMessage:NSLocalizedString(@"VDzuixin", nil)];
            alertView.isSupportRotating = YES;
            alertView.titleColor = kWhiteColor;
            alertView.messageColor = [UIColor colorWithHexString:@"CCCCCC"];
            alertView.defaultButtonTitleColor = [UIColor colorWithHexString:@"29223B"];
            alertView.cancelButtonTitleColor = [UIColor colorWithHexString:@"29223B"];
            [alertView addButtonWithTitle:NSLocalizedString(@"VDDetermine", nil) type:HDAlertViewButtonTypeDefault handler:^(HDAlertView *alertView) {
                DLog(@"styleOne");
            }];
            [alertView show];
        }
    } errorBlock:^(NSString * _Nonnull message) {
//        DLog(@"更新软件%@",message);
    } failBlock:^(NSError * _Nonnull error) {
    }];

}

@end
