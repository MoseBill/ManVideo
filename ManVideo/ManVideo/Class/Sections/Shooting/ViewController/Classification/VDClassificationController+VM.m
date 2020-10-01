//
//  VDClassificationController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/18.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDClassificationController+VM.h"

@implementation VDClassificationController (VM)

//上拉加载 + 首次请求
-(void)netWorkLoadData{//[self endRefreshing:NO];????
    self.page++;
    /// 1. 配置参数
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:@"/videoUploading/category/page"
                                                     parameters:@{
                                                                  @"pageNum":[NSString stringWithFormat:@"%d",self.page],
                                                                  @"pageSize":@(7),
                                                                  @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @""
                                                                  }
                          ];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if (response.isSuccess) {
            NSLog(@"--%@",response.reqResult);
            //            self.tableView.mj_footer.hidden = NO;
            if (response.reqResult) {
                if (response.reqResult[@"list"]) {
                    NSArray *dataArr = response.reqResult[@"list"];//需要用到的总数据
                    for (int i = 0; i < dataArr.count; i ++) {
                        ClassTotalDataModel *classTotalDataModel = [ClassTotalDataModel mj_objectWithKeyValues:dataArr[i]];
                        [self.classTotalDatamutArr addObject:classTotalDataModel];
                    }
                    NSMutableArray <ClassModel *>*rowDataMutArr;
                    for (int i = 0; i < self.classTotalDatamutArr.count; i++) {
                        ClassTotalDataModel *classTotalDataModel = self.classTotalDatamutArr[i];
                        NSMutableArray <ClassModel *>*videoUploadingListMutArr = classTotalDataModel.videoUploadingList;
                        rowDataMutArr = NSMutableArray.array;
                        for (int u = 0; u < videoUploadingListMutArr.count; u++) {
                            ClassModel *classModel = [ClassModel mj_objectWithKeyValues:videoUploadingListMutArr[u]];
                            [rowDataMutArr addObject:classModel];
                        }
                        [self.sectionDataMutArr addObject:rowDataMutArr];
                    }

                    //videoUrl
                    NSMutableArray <NSString *>*videoUrlRowMutArr;
                    for (int i = 0; i < self.sectionDataMutArr.count; i++) {
                        videoUrlRowMutArr = NSMutableArray.array;
                        for (int f = 0; f < [self.sectionDataMutArr[i] count]; f ++) {
                            ClassModel *classModel = self.sectionDataMutArr[i][f];
                            [videoUrlRowMutArr addObject:classModel.videoUrl];
                        }
                        [self.videoUrlSectionMutArr addObject:videoUrlRowMutArr];
                    }
                    [self.tableView reloadData];
                    [self endRefreshing:YES];
                }

            }
        }
    }];

    [CMRequest requestNetSecurityPOST:[NSString stringWithFormat:@"/videoUploading/list"]
                       paraDictionary:@{
                                        @"video_title":@"",
                                        @"pageNum":@(1),
                                        @"pageSize":@(24),
                                        @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @""
                                        }
                         successBlock:^(NSDictionary * _Nonnull dict) {
                             @strongify(self)
                             NSArray *dictArr = [ClassLabelModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
                             for (int i = 0; i < dictArr.count; i++) {
                                 ClassLabelModel *classLabelModel = [ClassLabelModel mj_objectWithKeyValues:dictArr[i]];
                                 [self.labelArr addObject:classLabelModel.name];
                                 [self.valueArr addObject:classLabelModel.value];
                             }
                             [self.tableView  reloadData];
                         } errorBlock:^(NSString * _Nonnull message) {
                             NSLog(@"message = %@",message);
                             [self endRefreshing:NO];
                         } failBlock:^(NSError * _Nonnull error) {
                             NSLog(@"error = %@",error);
                             [self endRefreshing:NO];
                         }];
}

@end
