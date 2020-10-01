//
//  MyDynamicVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/19.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MyDynamicVC+VM.h"

extern LZTabBarVC *tabBarVC;

@implementation MyDynamicVC (VM)

- (void)netWorkLoadData{
    if (self.page == 1) {
        [self.videoArr removeAllObjects];
    }
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                               path:@"/videoUploading/followDynamic"
                                                         parameters:@{
                                                                      @"userId":[self.userIdString isNullString] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] : self.userIdString,
                                                                      @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @""
                                                                     }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);
                @strongify(self)
                self.tableView.mj_footer.hidden = NO;
                NSArray *array = [GKDYVideoModel mj_objectArrayWithKeyValuesArray:response.reqResult];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                    NSUInteger idx,
                                                    BOOL * _Nonnull stop) {
                    GKDYVideoModel *model = array[idx];
                    [self.videoArr addObject:model];
                    if (model.videoUrl) {
                        NSString *videoString = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.videoUrl];
                        DLog(@"动态页播放地址%@",videoString);
                        NSURL *url = [NSURL URLWithString:videoString];
                        [self.urlsArr addObject:url];
                    }
                }];
                [self endRefreshing:YES];
                if (self.videoArr.count > 0) {
                    self.noContent.hidden = YES;
                } else {
                    self.noContent.hidden = NO;
                }
                [self.tableView reloadData];
            } else{// 之前登录成功
                [self presentViewController:VDLoginViewController.new
                                   animated:YES
                                 completion:^{}];
            }
        }];
    }
}

@end
