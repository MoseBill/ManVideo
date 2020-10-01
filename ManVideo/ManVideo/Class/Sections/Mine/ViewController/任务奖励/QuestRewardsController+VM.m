//
//  QuestRewardsController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/25.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "QuestRewardsController+VM.h"
#import "GKDYPersonalModel.h"

@implementation QuestRewardsController (VM)

- (void)netWork {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeString = [formatter stringFromDate:[NSDate date]];

    DLog(@"任务奖励%@",timeString);
//    NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[ZHKeyChainManager keyChainReadData:KEY_Clipyeu ++_SERVICE];
//    NSString *userId = [readUsernamePassword objectForKey:KEYUSERID];
//    NSDictionary *dict = @{@"userId":userId,@"date":timeString};

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userId = [user  objectForKey:@"userId"];
    NSString *token = [user objectForKey:@"token"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"userId"] = userId;
    dict[@"date"] = timeString;
    dict[@"token"] = token;
    DLog(@"任务奖励%@",dict);
    [CMRequest requestNetSecurityGET:@"/member/integral"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
        GKDYPersonalModel *model = [GKDYPersonalModel mj_objectWithKeyValues:dict[@"data"]];
        [self.arrRewards addObject:model];
        DLog(@"任务奖励请求成功%@",dict);
        [self.tableView.mj_header endRefreshing];
        self.tableView.tableFooterView.hidden = NO;
        [self.tableView reloadData];
    } errorBlock:^(NSString * _Nonnull message) {
        DLog(@"请求失败");
    } failBlock:^(NSError * _Nonnull error) {
        DLog(@"没有网络");
    }];
}

@end
