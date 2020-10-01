//
//  InviteFriendsController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/27.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "InviteFriendsController+VM.h"

@implementation InviteFriendsController (VM)

- (void)loadDatanetWork {
    NSUserDefaults *user  = [NSUserDefaults standardUserDefaults];
    NSString *userString = [user objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
    int userId = [userString intValue];
    NSNumber *number = [NSNumber numberWithInt:userId];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"id"] = number;
    dict[@"token"] = token;
    [CMRequest requestNetSecurityGET:@"/videoUploading/inviteCodeList" paraDictionary:dict successBlock:^(NSDictionary * _Nonnull dict) {
        DLog(@"邀请码%@",dict);

        HistoryModel *model = [HistoryModel mj_objectWithKeyValues:dict[@"data"]];
//        [self.dataSource addObject:model];
        self.codeLabel.text = model.inviteCode;
    } errorBlock:^(NSString * _Nonnull message) {
            DLog(@"邀请码%@",message);
    } failBlock:^(NSError * _Nonnull error) {

    }];
}

@end
