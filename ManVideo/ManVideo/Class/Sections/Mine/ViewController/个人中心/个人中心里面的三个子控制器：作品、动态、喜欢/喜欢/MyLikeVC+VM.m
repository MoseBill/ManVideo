//
//  MyLikeVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/19.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MyLikeVC+VM.h"

extern LZTabBarVC *tabBarVC;

@implementation MyLikeVC (VM)

- (void)loadLikeData {
    if (self.page == 1) {
        [self.videoArr removeAllObjects];
    }
    int typeCount = 2;
    int pageSize = 18;
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){
        @weakify(self)
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                               path:@"/member/works"
                                                         parameters:@{
                                                                        @"userId":[self.userIdString isNullString] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] : self.userIdString,
                                                                        @"typeNew":[NSNumber numberWithInt:typeCount],
                                                                        @"pageNum":[NSNumber numberWithInt:self.page],
                                                                        @"pageSize":[NSNumber numberWithInt:pageSize],
                                                                        @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @""
                                                            }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);
                @strongify(self)
                if(response.reqResult) {
                    NSArray *array = [GKDYVideoModel mj_objectArrayWithKeyValuesArray:response.reqResult];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"likeCountNoticification"
                                                                        object:[NSString stringWithFormat:@"%lu",(unsigned long)array.count]];
                    self.isRefresh = YES;
                    [self endRefreshing:YES];
                    self.collectionView.mj_footer.hidden = NO;
                    for (int i = 0; i < array.count; i++) {
                        GKDYVideoModel *model = array[i];
                        [self.videoArr addObject:model];
                        if (model.videoUrl) {
                            NSString *videoString = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.videoUrl];
                            DLog(@"动态页播放地址%@",videoString);
                            NSURL *url = [NSURL URLWithString:videoString];
                            [self.urlsArr addObject:url];
                        }
                    }
                    if (self.videoArr.count > 0) {
                        self.noContent.hidden = YES;
                    } else {
                        self.noContent.hidden = NO;
                    }
                }[self.collectionView reloadData];
            }
        }];
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

@end
