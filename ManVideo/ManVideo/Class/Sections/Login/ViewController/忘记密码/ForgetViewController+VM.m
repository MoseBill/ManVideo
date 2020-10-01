//
//  ForgetViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/27.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ForgetViewController+VM.h"

@implementation ForgetViewController (VM)

-(void)upload{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userString = [user objectForKey:@"userId"];
    int userInt = [userString intValue];
//    int userInt = 155;
    NSNumber *number = [NSNumber numberWithInt:userInt];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"phone"] = [NSString stringWithFormat:@"84%@",self.iphoneTextField.text];
    dict[@"verificationCode"] = self.codeTextField.text;
    dict[@"password"] = self.passwordTextField.text;
    dict[@"id"] = number;
    DLog(@"修改密码请求参数%@",dict);
    [CMRequest requestNetSecurityGET:@"/member/loginByPhoneUpdate" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"忘记密码请求成功参数%@",dict);
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDupdatePassword", nil)];
        [self.navigationController popViewControllerAnimated:YES];

    } errorBlock:^(NSString * _Nonnull message) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDxiugaiFail", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
        [alert show];
        DLog(@"忘记密码%@",message);
    } failBlock:^(NSError * _Nonnull error) {
          DLog(@"忘记密码%@",error);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDNoNetwork", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
        [alert show];
    }];
}

- (void)loadDataView {
    NSString *phone = [NSString stringWithFormat:@"84%@",self.iphoneTextField.text];
    NSDictionary *  dict = @{@"phone":phone,@"busType":@"1"};
    DLog(@"输入的手机号%@",self.iphoneTextField.text);
    [CMRequest requestNetSecurityGET:@"/member/sendSmsCode" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {

        //        ShowSuccessStatus(@"验证码发送成功请注意查收");
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDSendMessage", nil)];

    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"用户已注册");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDRegisterFail", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
        [alert show];
    } failBlock:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
    }];

}

@end
