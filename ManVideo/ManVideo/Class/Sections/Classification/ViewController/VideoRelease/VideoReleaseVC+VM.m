//
//  VideoReleaseVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/18.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VideoReleaseVC+VM.h"

@implementation VideoReleaseVC (VM)

-(void)upLoadFile{

    [self.view endEditing:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        @weakify(self)
        //1.获取单利的网络管理对象
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        manager.securityPolicy = securityPolicy;
        //2.选择返回值类型
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //设置相应数据支持的类型
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",
                                                               @"text/json",
                                                               @"text/javascript",
                                                               @"text/html",
                                                               @"text/css",
                                                               @"text/plain",
                                                               @"application/javascript",
                                                               @"application/json",
                                                               @"application/x-www-form-urlencoded",
                                                               nil]];
        //文件名
        NSDateFormatter *formatter = NSDateFormatter.new;
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName;
        fileName = [NSString stringWithFormat:@"%@.mp4", str];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"VDNoNetwork", nil)];

        [manager POST:[BaseUrl stringByAppendingString:@"/member/upload"]
           parameters:@{
//                        @"files ":self.data,
                        @"StatusType":@(2),
                        @"Category": @(1),
                        @"UserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                        @"videoType":self.infoStr,
                        @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                        }
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    @strongify(self)
    //通过工程中的文件进行上传
    [formData appendPartWithFileData:self.data
                                name:@"files"
                            fileName:fileName
                            mimeType:@"video/quicktime"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        float _percent = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        [SVProgressHUD showProgress:_percent * 100.0f
                             status:@"Uploading"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"请求成功%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        DLog(@"请求失败：%@",error);
        [SVProgressHUD showSuccessWithStatus:@"上传失败"];
    }];
    }else{
        [self showLoginAlertView];
    }
}

//不知道为什么，已经很接近正确答案了，要和后台对一下
-(void)upLoadFile_1{
    [self.view endEditing:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        NSDictionary *dic = @{
                              @"files ":self.data,
                              @"StatusType":@(2),
                              @"Category": @(1),
                              @"UserId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                              @"videoType":self.infoStr,
                              @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                              };
        self.reqSignal = [[FMARCNetwork sharedInstance] uploadNetworkPath:@"/member/upload"
                                                                   params:dic
                                                                fileDatas:@[self.data]
                                                                     name:@""
                                                                 mimeType:@""];
//        @weakify(self)
        BaseUrl;
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//            @strongify(self)
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);

            }
        }];
    }else{
        [self showLoginAlertView];
    }
}

@end
