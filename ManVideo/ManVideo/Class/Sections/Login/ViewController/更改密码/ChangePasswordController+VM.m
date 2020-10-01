//
//  ChangePasswordController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/27.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChangePasswordController+VM.h"

@implementation ChangePasswordController (VM)

-(void)upload{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userId = [user objectForKey:@"userId"];
    int userInt = [userId intValue];
    NSNumber *number = [NSNumber numberWithInt:userInt];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"id"] = number;
    dict[@"password"] = self.passwordNewField.text;
    DLog(@"修改密码%@",dict);
    [CMRequest requestNetSecurityGET:@"/member/udpatePassword" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"修改密码成功%@",dict);
        [self.navigationController popToRootViewControllerAnimated:YES];
    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"修改密码失败%@",message);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDxiugaiFail", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
        [alert show];
    } failBlock:^(NSError * _Nonnull error) {
        DLog(@"修改密码网络异常%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDNoNetwork", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
        [alert show];
    }];
}

@end
