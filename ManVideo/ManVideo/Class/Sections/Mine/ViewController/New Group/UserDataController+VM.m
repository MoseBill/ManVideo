//
//  UserDataController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/23.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "UserDataController+VM.h"
extern LZTabBarVC *tabBarVC;

@implementation UserDataController (VM)

- (void)netWorkLoad {

    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] isEqualToString:@""]){
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:@"/member/editDate"
                                                         parameters:@{
                                                             @"id":@([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]),
                                                             @"userName":self.nameString ? :self.modelPersonal.username,
                                                             @"birthday":self.birthDay ? :self.modelPersonal.birthday,
                                                             @"sex":self.genderString ? :self.modelPersonal.sex,
                                                             @"agentAcct":self.signString ? :self.modelPersonal.agentAcct,
                                                             @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? :@"",
                                                             @"headerImage":[[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"] ? :@""
                                                         }
                              ];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);
                [SVProgressHUD setMinimumDismissTimeInterval: 1.0];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDUpload", nil)];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[PersonalCenterVC class]]) {
                        PersonalCenterVC *personal =(PersonalCenterVC *)controller;
                        [personal loadDataView];
                        personal.personString = @"资料保存";
                        [self.navigationController popToViewController:personal
                                                              animated:YES];
                    }
                }
            }
        }];
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}
//上传头像
-(void)upDateHeadIconNetWorking_01{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        BaseUrl;
        self.reqSignal = [[FMARCNetwork sharedInstance] uploadNetworkPath:@"/member/imgUpdate"
                                                                   params:@{
                                                                       @"id":@([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]),
                                                                       @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? :@""
                                                                   }
                                                                fileDatas:@[UIImagePNGRepresentation(self.upImageData)]
                                                                     name:@""
                                                                 mimeType:@""];
    //        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
    //            @strongify(self)
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);

            }
        }];
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

-(void)upDateHeadIconNetWorking{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        [CMRequest.new upLoadImage:@"/member/imgUpdate"
                          paraDict:self.upImageData
                            userId:@{
                                @"id":@([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]),
                                @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? :@""
                            }
                      successBlock:^(NSDictionary * _Nonnull dict) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:(NSData *)dict
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            NSString *headerString = dic[@"data"][@"headerImage"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:headerString
                     forKey:@"headerImage"];
            [user synchronize];
            DLog(@"上传头像成功%@",dic);
            [self.headerImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,headerString]]
                                                     forState:UIControlStateNormal
            placeholderImage:kIMG(@"userCenter_selected")];
        } errorBlock:^(NSString * _Nonnull message) {
            DLog(@"上传头像失败%@",message);
        } failBlock:^(NSError * _Nonnull error) {
            DLog(@"上传头像网络异常%@",error);
        }];
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

@end
