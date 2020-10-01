//
//  PersonalCenterVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/20.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "PersonalCenterVC+VM.h"

extern LZTabBarVC *tabBarVC;

@implementation PersonalCenterVC (VM)

#pragma mark ===================== 网络请求===================================
- (void)loadDataView_VM {

    NSString *url = [NSString stringWithFormat:@"/member/personalCenter?id=%@&token=%@&byId=%@",@([self.userId intValue]),self.tokenString,self.userId];

    DLog(@"个人中心%@",url);
    if ((![self.userId isEqualToString:@""])) {//userId不为空
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:url
                                                         parameters:Nil//NSMutableDictionary.dictionary
                              ];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        BaseUrl;
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);
                self.modelPersonal = [GKDYPersonalModel mj_objectWithKeyValues:response.reqResult];
                [[NSUserDefaults standardUserDefaults] setObject:self.modelPersonal.headerImage
                                                          forKey:@"headerImage"];
                [[NSUserDefaults standardUserDefaults] setObject:self.modelPersonal.username
                                                          forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",self.modelPersonal.byId]
                                                          forKey:@"byId"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                self.likeCount = [self.modelPersonal.likeCount isNullString] ? 0 : [self.modelPersonal.likeCount intValue];
                self.videoCount = [self.modelPersonal.worksCount isNullString] ? 0 : [self.modelPersonal.worksCount intValue];
                self.dynamicCountString = [self.modelPersonal.dynamicCount isNullString] ? 0 : [self.modelPersonal.dynamicCount intValue];
                [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
                self.headerView.userModel = self.modelPersonal;//[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
                if (self.modelPersonal.birthday.length != 0) {

                } else {
                    self.headerView.ageLabel.text = NSLocalizedString(@"VDageText", nil);
                }

                if (self.headerView.isPush) {
                    if (self.modelPersonal.follwStatus == 1) {
                        [self.headerView.pointsBtn setTitle:NSLocalizedString(@"VDyiguanzhu", nil)
                                                   forState:UIControlStateNormal];
                    } else {
                        [self.headerView.pointsBtn setTitle:NSLocalizedString(@"VDFocusText", nil)
                                                   forState:UIControlStateNormal];
                    }
                }else{
                    [self.headerView.pointsBtn setTitle:NSLocalizedString(@"VDQuestText", nil)
                                               forState:UIControlStateNormal];//任务奖励
                }
                [self.view layoutIfNeeded];
            }
        }];
    }else{//userId为空
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

- (void)cancelFocusonNetWork {
    int idInt = [self.userId intValue];
    NSNumber *number = [NSNumber numberWithInt:idInt];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
    int userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue];
    NSNumber *numberUser = [NSNumber numberWithInt:userId];
    //    DLog(@"关注%ld  -> %d",(long)model.userId,userId);
    //        NSDictionary *dic = @{@"byId":number,@"userId":numberUser,@"token":token,@"status":@"2"};
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSString *focusUrl = [NSString stringWithFormat:@"/member/followOrCancel?byId=%@&userId=%@&token=%@&status=2",number,numberUser,token];
    DLog(@"取消关注参数%@",dic);
    [CMRequest requestNetSecurityPOST:focusUrl
                       paraDictionary:dic
                         successBlock:^(NSDictionary * _Nonnull dict) {

                             DLog(@"关注%@",dict);

                         } errorBlock:^(NSString * _Nonnull message) {
                             DLog(@"关注%@",message);
                         } failBlock:^(NSError * _Nonnull error) {
                             DLog(@"关注%@",error);
                         }];

//    if ((![self.userId isEqualToString:@""])) {
//        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
//                                                               path:focusUrl
//                                                         parameters:NSMutableDictionary.dictionary
//                              ];
//        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//        @weakify(self)
//        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//            @strongify(self)
//            if (response.isSuccess) {
//                NSLog(@"--%@",response.reqResult);
//            }
//        }];
//    }else{

//        [self presentViewController:VDLoginViewController.new
//                           animated:YES
//                         completion:^{}];
//    }
}

- (void)loadNetWorkFocusOn {
    int idInt = [self.userId intValue];
    NSNumber *number = [NSNumber numberWithInt:idInt];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
    int userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue];
    NSNumber *numberUser = [NSNumber numberWithInt:userId];
    //    DLog(@"关注%ld  -> %d",(long)model.userId,userId);
    //        NSDictionary *dic = @{@"byId":number,@"userId":numberUser,@"token":token,@"status":@"1"};
    NSString *focusUrl = [NSString stringWithFormat:@"/member/followOrCancel?byId=%@&userId=%@&token=%@&status=2",number,numberUser,token];
    //    NSString *focusUrl = [NSString stringWithFormat:@"/member/followOrCancel%@",];
    DLog(@"关注参数%@",self.dic);
    @weakify(self)
    [CMRequest requestNetSecurityPOST:focusUrl
                       paraDictionary:self.dic//NSMutableDictionary.dictionary
                         successBlock:^(NSDictionary * _Nonnull dict) {

                             DLog(@"关注%@",dict);
                             //            [self.navigationController popToRootViewControllerAnimated:YES];
                         } errorBlock:^(NSString * _Nonnull message) {
                             DLog(@"关注%@",message);
                             @strongify(self)
                             UIAlertView *AlertView;
                             //方法点击显示弹窗
                             AlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDtishi", nil)
                                                                   message:NSLocalizedString(@"VDFocuschongfu", nil)
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"VDDetermine", nil), nil];
                             [AlertView show];
                         } failBlock:^(NSError * _Nonnull error) {
                             DLog(@"关注%@",error);
                         }];
//    if ((![self.userId isEqualToString:@""])) {
//        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
//                                                               path:focusUrl
//                                                         parameters:NSMutableDictionary.dictionary
//                              ];
//        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
//        @weakify(self)
//        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//            @strongify(self)
//            if (response.isSuccess) {
//                NSLog(@"--%@",response.reqResult);
//            }
//        }];
//    }else{
//        [self presentViewController:VDLoginViewController.new
//                           animated:YES
//                         completion:^{}];
//    }
}

@end
