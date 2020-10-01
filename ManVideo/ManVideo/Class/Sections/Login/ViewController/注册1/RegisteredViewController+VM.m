//
//  RegisteredViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/27.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "RegisteredViewController+VM.h"
#import "HDAlertView.h"

@implementation RegisteredViewController (VM)

-(void)register{
    @weakify(self)
    [CMRequest requestNetSecurityGET:@"/member/registerByPhone"
                      paraDictionary:@{
                          @"phone":[NSString stringWithFormat:@"84%@",self.iphoneTextField.text],
                          @"verificationCode":self.codePassword.text,
                          @"ip":[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ifconfig.me/ip"]
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil],
                          @"imei":UDID,
                          @"userInvitation":self.codeInvitation.text
                      }
                        successBlock:^(NSDictionary *dict) {
                            @strongify(self)
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDtishi", nil)//温馨提示
                                                                                                     message:NSLocalizedString(@"VDRegisterSuccess", nil)//注册成功
                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil)
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                                 DLog(@"确定");
                                                                             }];//确定
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];

                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            [user setObject:dict[@"data"][@"token"] forKey:@"token"];
                            [user setObject:dict[@"data"][@"userId"] forKey:@"userId"];
                            [user synchronize];
                            @weakify(self)
                            dispatch_async(dispatch_get_main_queue(), ^{
                                @strongify(self)
                                HDAlertView *alertView = [HDAlertView alertViewWithTitle:NSLocalizedString(@"VDChangePassword", nil)//修改初始密码
                                                                              andMessage:NSLocalizedString(@"VDActionpassword", nil)];//您的初始密码为123456,为了您的账户安全,请及时修改登录密码!
                                alertView.buttonsListStyle = HDAlertViewButtonsListStyleRows;
                                alertView.isSupportRotating = YES;
                                alertView.titleColor = kWhiteColor;
                                alertView.messageColor = [UIColor colorWithHexString:@"CCCCCC"];
                                alertView.defaultButtonTitleColor = [UIColor colorWithHexString:@"29223B"];
                                alertView.cancelButtonTitleColor = [UIColor colorWithHexString:@"29223B"];
                                [alertView addButtonWithTitle:NSLocalizedString(@"VDDetermine", nil)//确定
                                                         type:HDAlertViewButtonTypeDefault
                                                      handler:^(HDAlertView *alertView) {
                                    [ChangePasswordController pushFromVC:self
                                                           requestParams:nil
                                                                 success:nil
                                                                animated:YES];
                                                      }];
                                [alertView addButtonWithTitle:NSLocalizedString(@"VDCancelText", nil)//取消
                                                         type:HDAlertViewButtonTypeDefault
                                                      handler:^(HDAlertView *alertView) {
                                                      }];
                                [alertView show];
                            });
    } errorBlock:^(NSString *message) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)//提示
                                                       message:NSLocalizedString(@"VDRegisterFail", nil)//注册失败
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];//我知道了
        [alert show];
    } failBlock:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];//亲,没有网络了
    }];
}

- (void)loadDataView {
    NSString *phone = [NSString stringWithFormat:@"84%@",self.iphoneTextField.text];
    NSDictionary *dict = @{@"phone":phone,
                           @"busType":@"1"};
    DLog(@"输入的手机号%@",phone);
    [CMRequest requestNetSecurityGET:@"/member/sendSmsCode"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDSendMessage", nil)];//验证码发送成功请注意查收
    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"参数错误");
    } failBlock:^(NSError * _Nonnull error) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];//亲,没有网络了
    }];
}

@end
