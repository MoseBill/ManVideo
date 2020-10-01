//
//  OrdinaryViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/27.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "OrdinaryViewController+VM.h"

@implementation OrdinaryViewController (VM)

- (void)loadData {
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSRange range1 = NSMakeRange(28, 13);
    self.ipStr = [ip substringWithRange:range1];
    NSString *identifierForVendor = UDID;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"phone"] = [NSString stringWithFormat:@"84%@",self.iphoneFieldText.text];
    dict[@"password"] = self.codeFieldText.text;
    dict[@"inviteCode"] = self.InviteCodeField.text;
    dict[@"imei"] = identifierForVendor;
    dict[@"ip"] = self.ipStr;

    [CMRequest requestNetSecurityGET:@"/member/registerByUsername" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"注册成功%@",dict);
        [self.navigationController popToRootViewControllerAnimated:YES];
    } errorBlock:^(NSString * _Nonnull message) {
         DLog(@"注册失败%@",dict);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDtishi", nil) message:NSLocalizedString(@"VDIphoneBUG", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DLog(@"确定");
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } failBlock:^(NSError * _Nonnull error) {
         DLog(@"注册网络错误%@",dict);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDtishi", nil) message:NSLocalizedString(@"VDNoNetwork", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DLog(@"确定");
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

@end
