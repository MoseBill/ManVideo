//
//  ZFDouYinViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/20.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ZFDouYinViewController+VM.h"

@implementation ZFDouYinViewController (VM)
//总请求
- (void)requestData{
    NSLog(@"开始网络请求");
    @weakify(self)
    NSInteger pageSize = 18;
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:[NSString stringWithFormat:@"/videoUploading/recommend?pageNum=%ld&pageSize%ld",(long)self.pageNum,(long)pageSize]
                                                     parameters:Nil];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (response.isSuccess) {
            @strongify(self)
            self.dataSourceCount = self.dataSource.count;
            [self endRefreshing:YES];
            NSArray *array = [CommonModel mj_objectArrayWithKeyValuesArray:response.reqResult[@"list"]];
            if (array) {
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL * _Nonnull stop) {
                    @strongify(self)
                    CommonModel *model  = array[idx];
                    [self.dataSource addObject:model];//需要 self.dataSource<CommonModel *>
                    if (model.videoUrl) {
                        NSString *noPasswordUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,model.videoUrl];
                        NSURL *url = [NSURL URLWithString:noPasswordUrl];
                        [self.urls addObject:url];//需要 self.urls<NSURL *>
                    }
                    [self.userIds addObject:[NSString stringWithFormat:@"%ld",(long)model.userId]];//需要 self.userIds<CommonModel *userId>
                }];
            }
            if (!self.isFirstRequestData) {
                self.isFirstRequestData = YES;
                [self.tableView reloadData];
                self.tableView.mj_footer.hidden = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                            inSection:0];
                [self playTheVideoAtIndexPath:indexPath
                                  scrollToTop:NO];
            }else{
                NSMutableArray *indexPaths = NSMutableArray.array;
                for (NSInteger i = self.dataSourceCount; i < self.dataSource.count; i ++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths
                                       withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                if (!self.isPullToRefresh) {
                    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - 44 + SCREEN_HEIGHT)
                                            animated:YES];
                }else{
                    self.isPullToRefresh = NO;
                }
                [self findAvailableResourceAndPlay];
            }
        }
    }];
}

//点赞
-(void)LikeNetWorking:(EmitterBtn *)click{
    if (self.dataSource.count > 0) {
        self.commonModel = [self.dataSource objectAtIndex:self.currentIndex];
    }else return;
    NSString * idString = [NSString stringWithFormat:@"%ld",(long)self.commonModel.ID];
    int channelid =[idString intValue];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    int user = [userId intValue];
    NSString *tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";

    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:@"/videoUploading/spotFabulous"
                                                     parameters:@{
                                                                  @"videoId":@(channelid),
                                                                  @"userId":[NSString stringWithFormat:@"%d",user],
                                                                  @"token":tokenString,
                                                                  @"byId":@(self.commonModel.userId)
                                                                  }
                          ];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (response.isSuccess) {
            NSLog(@"--%@",response.reqResult);
            @strongify(self)
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDLikeSuccess", nil)];
            int count = [response.reqResult[@"count"] intValue];
            if (self.likeCountBlock) {
                self.likeCountBlock(count);
            }
            click.selected = YES;
//            [click setImage:kIMG(@"love1 拷贝")//[UIImage imageNamed:@"Love_yes"]
//                   forState:UIControlStateSelected];
            [click startAnimation];
            [self.tableView reloadData];
            DLog(@"点赞请求成功");
        }
    }];
}

- (void)shareNetWork:(NSString *)work
              userID:(NSInteger)userId
         platformNet:(NSString *)platform{
    NSMutableDictionary *dict = NSMutableDictionary.dictionary;
    dict[@"videoId"] = work;
    dict[@"userId"] = self.userString;
    dict[@"token"] = self.tokenString;
    dict[@"byId"] = @(userId);
    dict[@"platform"] = @"";
    DLog(@"分享成功%@",dict);
    @weakify(self)
    [CMRequest requestNetSecurityGET:@"/videoUploading/share"
                      paraDictionary:dict
                        successBlock:^(NSDictionary * _Nonnull dict) {
                            @strongify(self)
                            int code = [dict[@"data"][@"count"] intValue];
                            if (self.shareCountBlock) {
                                self.shareCountBlock(code);
                            }
                            [self.tableView reloadData];
                        } errorBlock:^(NSString * _Nonnull message) {
                            DLog(@"分享成功%@",message);
                        } failBlock:^(NSError * _Nonnull error) {
                            DLog(@"分享成功%@",error);
                        }];
}

//- (void)requestData_0{
//    NSLog(@"开始网络请求");
//    @weakify(self)
//    NSInteger pageSize = 18;
//    NSString *url = [NSString stringWithFormat:@"/videoUploading/recommend?pageNum=%d&pageSize%ld",0,(long)pageSize];
//    [CMRequest requestNetSecurityPOST:url
//                       paraDictionary:self.dict
//                         successBlock:^(NSDictionary * _Nonnull dict) {
//                             @strongify(self)
//                             self.dataSourceCount = self.dataSource.count;
//                             [self endRefreshing:YES];
//                             NSArray *array = [CommonModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"list"]];
//                             if (array) {
//                                 [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
//                                                                     NSUInteger idx,
//                                                                     BOOL * _Nonnull stop) {
//                                     @strongify(self)
//                                     CommonModel *model  = array[idx];
//                                     [self.dataSource addObject:model];
//                                     if (model.videoUrl) {
////                                         NSString *noPasswordUrl = [NSString stringWithFormat:@"%@%@",VedioBaseUrl,model.videoUrl];
//                                          NSString *noPasswordUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,model.videoUrl];
//                                         NSURL *url = [NSURL URLWithString:noPasswordUrl];
//                                         [self.urls addObject:url];
//                                     }
//                                 }];
//                             }
//                             if (!self.isFirstRequestData) {
//                                 self.isFirstRequestData = YES;
//                                 [self.tableView reloadData];
//                                 self.tableView.mj_footer.hidden = NO;
//
//                                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
//                                                                             inSection:0];
//                                 [self playTheVideoAtIndexPath:indexPath
//                                                   scrollToTop:NO];
//                             }else{
//                                 NSMutableArray *indexPaths = [NSMutableArray array];
//                                 for (NSInteger i = self.dataSourceCount; i < self.dataSource.count; i ++) {
//                                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                                     [indexPaths addObject:indexPath];
//                                 }
//                                 [self.tableView beginUpdates];
//                                 [self.tableView insertRowsAtIndexPaths:indexPaths
//                                                       withRowAnimation:UITableViewRowAnimationNone];
//                                 [self.tableView endUpdates];
//                                 if (!self.isPullToRefresh) {
//                                     [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - 44 + SCREEN_HEIGHT)
//                                                             animated:YES];
//                                 }else{
//                                     self.isPullToRefresh = NO;
//                                 }
//                                 [self findAvailableResourceAndPlay];
//                             }
//                         } errorBlock:^(NSString * _Nonnull message) {
//                             @strongify(self)
//                             NSLog(@"message = %@",message);
//                             [self endRefreshing:NO];
//                         } failBlock:^(NSError * _Nonnull error) {
//                             @strongify(self)
//                             NSLog(@"error = %@",error);
//                             [self endRefreshing:NO];
//                         }];
//}

#pragma mark —— 被遗弃
////关注
//- (void)loadNetWorkFocusOn {
//    RecommendedModel *model = self.dataSource[self.shareIndex];
//    NSNumber *number = [NSNumber numberWithInt:(int)model.userId];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *token = [user objectForKey:@"token"];
//    int userId = [[user objectForKey:@"userId"] intValue];
//    NSNumber *numberUser = [NSNumber numberWithInt:userId];
//    DLog(@"关注%@",token);
//    if (userId != 0) {
//        NSDictionary *dic = @{@"id":number,
//                              @"userId":numberUser,
//                              @"token":token};
//        DLog(@"关注参数%@",dic);
//        [CMRequest requestNetSecurityGET:@"/member/follow"
//                          paraDictionary:dic
//                            successBlock:^(NSDictionary * _Nonnull dict) {
//                                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDSuccessFocus", nil)];
//                                DLog(@"关注%@",dict);
//                            } errorBlock:^(NSString * _Nonnull message) {
//                                DLog(@"关注%@",message);
//                            } failBlock:^(NSError * _Nonnull error) {
//                                DLog(@"关注%@",error);
//                                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
//                            }];
//    } else {
//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.loginController]
//                           animated:YES
//                         completion:^{}];
//    }
//}

@end
