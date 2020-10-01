//
//  MyProductsVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/19.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MyProductsVC+VM.h"

extern LZTabBarVC *tabBarVC;

@implementation MyProductsVC (VM)

- (void)loadDataView{
    if (self.page == 1) {
        [self.videos removeAllObjects];
    }
    int type = 1;
    int pageSize = 18;
    NSDictionary *dic = @{
    @"userId":[self.userIdString isNullString] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] : self.userIdString,
    @"typeNew":[NSNumber numberWithInt:type],
    @"pageNum":[NSNumber numberWithInt:self.page],
    @"pageSize":[NSNumber numberWithInt:pageSize],
    @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"",
    @"byId":[self.byId isNullString] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"byId"] : self.byId
    };
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"" isEqualToString:@""]){
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:@"/member/works"
                                                         parameters:@{
                                                                      @"userId":[self.userIdString isNullString] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] : self.userIdString,
                                                                      @"typeNew":[NSNumber numberWithInt:type],
                                                                      @"pageNum":[NSNumber numberWithInt:self.page],
                                                                      @"pageSize":[NSNumber numberWithInt:pageSize],
                                                                      @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"",
                                                                      @"byId":[self.byId isEqualToString:@"0"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"byId"] : self.byId
                                                                      }
                              ];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            if (response.isSuccess) {//BaseUrl
                NSLog(@"--%@",response.reqResult);
                @strongify(self)
                NSArray *array = [GKDYVideoModel mj_objectArrayWithKeyValuesArray:response.reqResult];
                for (int i = 0; i < array.count; i++) {
                    GKDYVideoModel *model = array[i];
                    [self.videos addObject:model];
                    NSString *videoString = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.videoUrl];
                    NSURL *url = [NSURL URLWithString:videoString];
                    [self.urlsArr addObject:url];
                }
                self.isRefresh = YES;
                self.collectionView.mj_footer.hidden = NO;
                [self endRefreshing:YES];
                [self.collectionView reloadData];
            }
        }];
    } else{// 之前登录成功
        [self presentViewController:VDLoginViewController.new
                           animated:YES
                         completion:^{}];
    }
}

@end
