//
//  CommentVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CommentVC+VM.h"

@implementation CommentVC (VM)
//评论条接口:
- (void)loadDataView{
    [self.commentArr removeAllObjects];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                             path:@"/videoUploading/commentWhole"
                                                       parameters:@{
                                                           @"id":[NSNumber numberWithInt:self.idString],
                                                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                                                       }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response.isSuccess) {
            NSLog(@"--%@",response.reqResult);
            NSArray *array = [SDTimeLineCellModel mj_objectArrayWithKeyValuesArray:response.reqResult];
            self.tableView.mj_footer.hidden = (array.count != 0);
            for (int i = 0; i < array.count; i++) {
                SDTimeLineCellModel *model = array[i];
                [self.commentArr addObject:model];
            }
            //倒叙输出，永远优先显示最新鲜评论
            self.commentArr = (NSMutableArray *)[[self.commentArr reverseObjectEnumerator] allObjects];
            self.lab.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)self.commentArr.count,NSLocalizedString(@"VDCommentCount", nil)];
            NSLog(@"123dd");
            [self.tableView reloadData];
        }
    }];
}

//回复
- (void)loadNetWorkReply:(NSDictionary *)dict {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSNumber *number =  [NSNumber numberWithInt:self.idString];
    NSNumber *videoNumber = [NSNumber numberWithInt:self.videoUserId];
    NSString *url = [NSString stringWithFormat:@"/videoUploading/replyComment?userId=%@&token=%@&videoId=%@&videoUserId=%@&writtenWords=%@&commentId=%@",userId,token,number,videoNumber,dict[@"message"],dict[@"Id"]];

    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                             path:url
                                                       parameters:nil];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response.isSuccess) {
            NSLog(@"--%@",response.reqResult);
//            [self exampleRefresh];
        }
    }];
}

//- (void)loadNetWorkReply_01:(NSDictionary *)dict {
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
//    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
//    NSNumber *number =  [NSNumber numberWithInt:self.idString];
//    NSNumber *videoNumber = [NSNumber numberWithInt:self.videoUserId];
//    NSString *url = [NSString stringWithFormat:@"/videoUploading/replyComment?userId=%@&token=%@&videoId=%@&videoUserId=%@&writtenWords=%@&commentId=%@",userId,token,number,videoNumber,dict[@"message"],dict[@"Id"]];
//     DLog(@"回复评论传参%@",url);
////    @weakify(self)
//    [CMRequest requestNetSecurityPOST:url
//                       paraDictionary:NULL
//                         successBlock:^(NSDictionary * _Nonnull dict) {
////        @strongify(self)
//        DLog(@"回复成功%@",dict);
//      [self exampleRefresh];
//    } errorBlock:^(NSString * _Nonnull message) {
//         DLog(@"回复失败%@",message);
//    } failBlock:^(NSError * _Nonnull error) {
//         DLog(@"网络错误%@",error);
//    }];
//}

//评论接口:
- (void)loadNetWork:(NSString *)text {
    NSString *url = [NSString stringWithFormat:@"/videoUploading/commentForm"];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                             path:url
                                                       parameters:@{
                                                           @"userId":@([[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue]),
                                                           @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                                           @"writtenWords":text,
                                                           @"id":@(self.idString)//视频id
                                                       }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response.isSuccess) {
            NSLog(@"--%@",response.reqResult);
            [self.tableView.mj_header beginRefreshing];
            NSInteger count = [response.reqResult[@"count"] integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successMessageCount"
                                                                object:[NSString stringWithFormat:@"%ld",(long)count]];
        }
    }];
}
//- (void)loadNetWork_01:(NSString *)text {
//    int userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] intValue];
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
//    NSNumber *number = [NSNumber numberWithInt:self.idString];
//    NSNumber *userNumber = [NSNumber numberWithInt:userId];
//    NSString *url = [NSString stringWithFormat:@"/videoUploading/comment?id=%@&userId=%@&token=%@&writtenWords=%@",number,userNumber,token,text];
//    @weakify(self)
//    [CMRequest requestNetSecurityPOST:url
//                       paraDictionary:NULL
//                         successBlock:^(NSDictionary * _Nonnull dict) {
//                             @strongify(self)
//                             [self exampleRefresh];
//                             NSInteger count = [dict[@"data"][@"count"] integerValue];
//                             [[NSNotificationCenter defaultCenter] postNotificationName:@"successMessageCount"
//                                                                                 object:[NSString stringWithFormat:@"%ld",count]];
//                             DLog(@"请求成功");
////        [self.tableView reloadData];
//    } errorBlock:^(NSString * _Nonnull message) {
//        DLog(@"请求失败");
//    } failBlock:^(NSError * _Nonnull error) {
//        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];
//    }];
//}

#pragma mark —— 疑似废弃的
//- (void)replyMyMessage:(NSString *)message {
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? : @"";
//    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
//    NSNumber *number =  [NSNumber numberWithInt:self.idString];
//    NSNumber *videoNumber = [NSNumber numberWithInt:self.videoUserId];
//
//     NSString *url = [NSString stringWithFormat:@"/videoUploading/replyComment?userId=%@&token=%@&videoId=%@&videoUserId=%@&writtenWords=%@&commentId=%@&otherUserId=%ld",userId,token,number,videoNumber,message,self.model.commentId,self.model.userId];
//    DLog(@"回复别人 的评论传参%@",url);
//    @weakify(self)
//    [CMRequest requestNetSecurityPOST:url
//                       paraDictionary:nil
//                         successBlock:^(NSDictionary * _Nonnull dict) {
//                             @strongify(self)
//                             DLog(@"回复别人成功%@",dict);
//                             [self exampleRefresh];
//                         } errorBlock:^(NSString * _Nonnull message) {
//                             DLog(@"回复别人失败%@",message);
//                         } failBlock:^(NSError * _Nonnull error) {
//                             DLog(@"网络错误%@",error);
//                         }];
//}


@end
