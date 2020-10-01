//
//  CMRequest.m
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CMRequest.h"

#import <CommonCrypto/CommonDigest.h>
//static NSString *const BaseUrl = @"https://clipyeuplus1.com";
//static NSString *const BaseUrl = @"https://clipyeuplus.com";
//static NSString *const BaseUrl = @"http://10.233.207.77:8080";

static NSString *const testUrl = @"http://172.16.58.79:8800";

@implementation CMRequest

+ (instancetype)request {
    return [[self alloc] init];
}

//单例模式
+ (AFHTTPSessionManager*)sharedHTTPSessionManager{
    static AFHTTPSessionManager* result = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!result) {
            result=[AFHTTPSessionManager manager];

            //无条件的信任服务器上的证书
            AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
            // 客户端是否信任非法证书
            securityPolicy.allowInvalidCertificates = YES;
            // 是否在证书域字段中验证域名
            securityPolicy.validatesDomainName = NO;
            result.securityPolicy = securityPolicy;

            AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
            response.removesKeysWithNullValues=YES;
            result.responseSerializer=response;
            result.requestSerializer=[AFJSONRequestSerializer serializer];

            // 2.设置非校验证书模式
            result.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            result.securityPolicy.allowInvalidCertificates = YES;
            [result.securityPolicy setValidatesDomainName:NO];
          
            result.requestSerializer.timeoutInterval = 50.f;
            [result.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            // 设置响应内容的类型
            result.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/jpg",@"application/x-javascript",@"keep-alive", nil];
               
        }
    });
    return result;
}

- (instancetype)init {
    if (self = [super init]) {
//        self.operationManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(CMRequest *, NSString *))success
    failure:(void (^)(CMRequest *, NSError *))failure {
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.operationManager GET:URLString
                    parameters:parameters
                      progress:^(NSProgress * _Nonnull downloadProgress) {
        
        DLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        
        NSString *responseJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DLog(@"[CMRequest]: %@",responseJson);
        success(self,responseJson);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"[CMRequest]: %@",error.localizedDescription);
        failure(self,error);
    }];
}

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(CMRequest *request, NSString* responseString))success
     failure:(void (^)(CMRequest *request, NSError *error))failure{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //默认:application/x-www-form-urlencoded
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
      NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,URLString];
    manager.requestSerializer.timeoutInterval = 30.0f;
    [manager POST:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        if (success) {
            NSString* responseJson = [[NSString alloc]initWithData:responseObject
                                                          encoding:NSUTF8StringEncoding];
            //        NSLog(@"[CMRequest]: %@",responseJson);
            success(self,responseJson);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        if (failure) {
            failure(self,error);
        }
    }];
//    self.operationQueue = self.operationManager.operationQueue;
//    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    [self.operationManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//
//        NSLog(@"%@",uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSString* responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"[CMRequest]: %@",responseJson);
//        success(self,responseJson);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        NSLog(@"[CMRequest]: %@",error.localizedDescription);
//        failure(self,error);
//
//    }];
}

- (void)postWithURL:(NSString *)URLString
         parameters:(NSDictionary *)parameters {
    
    [self POST:URLString parameters:parameters
        success:^(CMRequest *request, NSString *responseString) {
           if ([self.delegate respondsToSelector:@selector(CMRequest:finished:)]) {
               [self.delegate CMRequest:request finished:responseString];
               
           }
       }
       failure:^(CMRequest *request, NSError *error) {
           if ([self.delegate respondsToSelector:@selector(CMRequest:Error:)]) {
               [self.delegate CMRequest:request Error:error.description];
           }
       }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString
   parameters:nil
      success:^(CMRequest *request,
                NSString *responseString) {
        if ([self.delegate respondsToSelector:@selector(CMRequest:finished:)]) {
            [self.delegate CMRequest:request
                            finished:responseString];
        }
    } failure:^(CMRequest *request,
                NSError *error) {
        if ([self.delegate respondsToSelector:@selector(CMRequest:Error:)]) {
            [self.delegate CMRequest:request
                               Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

- (void)requestSecurityGET:(NSString *)path
            paraDictionary:(NSDictionary *)params
              successBlock:(successBlock)success
                errorBlock:(errorBlock)errorBlock
                 failBlock:(failBlock)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,path];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];

    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;

    //    JMLog(@"请求地址%@",url);
    //    NSDictionary *parameter=  @{@"countryCallingCode":@"86",@"mobile":@"18683289306"};
    NSData *jsonData= [NSJSONSerialization dataWithJSONObject:params
                                                      options:NSJSONWritingPrettyPrinted error:nil];
    NSString *objectStr=[[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    NSString *object = [self base64EncodeString:objectStr];
    NSString *signstr = [object stringByAppendingString:@"123456"];
    NSString *sign = [NSString md5String:signstr];
    NSDictionary *newparameter = @{@"object":object,
                                   @"sign":sign};
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues=YES;
    manager.responseSerializer=response;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",
                                                       @"text/json",
                                                       @"text/javascript",
                                                       @"text/html",
                                                       @"text/plain",
                                                       nil];
    DLog(@"最终参数:%@",newparameter);
    [manager.requestSerializer setValue:@"1"
                     forHTTPHeaderField:@"d"];
    [manager.requestSerializer setValue:@"1"
                     forHTTPHeaderField:@"c"];
    NSUserDefaults *userToken = [NSUserDefaults standardUserDefaults];
    if (userToken) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer_%@",[userToken objectForKey:@"token"]]
                         forHTTPHeaderField:@"Authorization"];
    }
    
    [manager GET:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
      parameters:newparameter
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task,
                   id  _Nullable responseObject) {
//        DLog(@"获取验证码返回参数:%@",responseObject);
        VDBaseModel *baseModel = [VDBaseModel mj_objectWithKeyValues:responseObject];
        if (responseObject != nil) {
           DLog(@"%@", responseObject);
            success(responseObject);
        } else if([baseModel.code isEqualToString:@"20014"]) {//该用户不存在
            //                baseModel.message = @"该用户不存在";
            if (errorBlock) {
                errorBlock(baseModel.msg);
            }
        } else {
            if (errorBlock) {
                errorBlock(baseModel.msg);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
        DLog(@"错误信息:%@",error);
    }];
}

#pragma mark -- 网络请求处理
+ (void)httpWithUrl:(NSString *)url
               body:(NSDictionary *)bodyDic
         parameters:(NSDictionary *)parameters
       successBlock:(successBlock)success
         errorBlock:(errorBlock)errorBlock
          failBlock:(failBlock)failBlock {
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:baseUrl
                                                                                parameters:nil
                                                                                     error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSData *dataBody = [NSJSONSerialization dataWithJSONObject:bodyDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    // 设置body
    [request setHTTPBody:dataBody];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/jpg",@"application/x-javascript", nil];
    manager.responseSerializer = responseSerializer;
    //    AFJSONRequestSerializer *resquest = [AFJSONRequestSerializer serializer];

    [[manager dataTaskWithRequest:request
                   uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response,
                          id  _Nullable responseObject,
                          NSError * _Nullable error) {
        VDBaseModel *baseModel = [VDBaseModel mj_objectWithKeyValues:responseObject];
        if (!error) {
            if (![responseObject isKindOfClass:[NSNull class]] &&
                responseObject != nil) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                            options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                                              error:nil];
                if (responseObject) {
                    DLog(@"请求结果 = %@",responseDic);
                    success(responseDic);
                }
            }
        }else {
            //        failure(nil,-200,[TipMessage shared].tipMessage.errorMsgNetworkUnavailable);
            DLog(@"错误内容 = %@",error);
           errorBlock(baseModel.msg);
        }
    }] resume];
}

- (void)upLoadImage:(NSString *)path
           paraDict:(UIImage *)params
             userId:(NSDictionary *)paramsDic
       successBlock:(successBlock)success
         errorBlock:(errorBlock)errorBlock
          failBlock:(failBlock)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,path];
//    NSUserDefaults *userToken = [NSUserDefaults standardUserDefaults];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;

//    AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
//    response.removesKeysWithNullValues=YES;
//    manager.responseSerializer=response;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
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
    
    NSData *imageData;
    NSString *mimetype;
    //判断下图片是什么格式
    if (UIImagePNGRepresentation(params)) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(params);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(params, 1.0);
    }
    //开始上传
    [manager POST:url
       parameters:paramsDic
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //        [imageV sd_setImageWithURL:params placeholderImage:[UIImage imageNamed:@"logo"]];
        //        NSString *str = @"avatar";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName;
        if (UIImagePNGRepresentation(params) != nil) {
            fileName = [NSString stringWithFormat:@"%@.png", str];
        }else{
            fileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        //        NSString *fileName = [NSString stringWithFormat:@"%@.png",[userToken objectForKey:@"appId"]];
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:mimetype];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"上传进度: %f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        DLog(@"上传图片成功: %@", responseObject);
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        DLog(@"上传失败: %@", error);
    }];
    
}

- (void)uploadImagePost:(NSString *)path
               paraDict:(UIImage *)params
           successBlock:(successBlock)success
             errorBlock:(errorBlock)errorBlock
              failBlock:(failBlock)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,path];
    NSUserDefaults *userToken = [NSUserDefaults standardUserDefaults];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues=YES;
    manager.responseSerializer=response;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //设置请求头类型
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"d"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"c"];
    //设置请求头, 授权码
    if (userToken) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer_%@",[userToken objectForKey:@"token"]]
                         forHTTPHeaderField:@"Authorization"];
    }
    
    NSData *imageData;
    NSString *mimetype;
    //判断下图片是什么格式
    if (UIImagePNGRepresentation(params) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(params);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(params, 1.0);
    }
    //开始上传
    [manager POST:url
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        [imageV sd_setImageWithURL:params placeholderImage:[UIImage imageNamed:@"logo"]];
    NSString *str = @"avatar";
    NSString *fileName;
    if (UIImagePNGRepresentation(params) != nil) {
        fileName = [NSString stringWithFormat:@"%@.png", str];
    }else{
        fileName = [NSString stringWithFormat:@"%@.jpg", str];
    }
    //        NSString *fileName = [NSString stringWithFormat:@"%@.png",[userToken objectForKey:@"appId"]];
    [formData appendPartWithFileData:imageData
                                name:@"fileName"
                            fileName:fileName
                            mimeType:mimetype];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"上传进度: %f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        DLog(@"上传照片成功: %@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        DLog(@"上传失败: %@", error);
    }];
}

+ (void)requestNetSecurityPOST:(NSString *)path
                paraDictionary:(NSDictionary *)params
                  successBlock:(successBlock)success
                    errorBlock:(errorBlock)errorBlock
                     failBlock:(failBlock)failBlock {

   __block NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,path];
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"
                     forHTTPHeaderField:@"Content-Type"];
   
        // 2.设置非校验证书模式
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//[AFSecurityPolicy defaultPolicy];
    //    // 客户端是否信任非法证书
    //    securityPolicy.allowInvalidCertificates = YES;
    //    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;

//    __block NSDictionary *dic = params;
    [manager POST:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
       parameters:params
         progress:^(NSProgress * _Nonnull uploadProgress) {}
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
//              DLog(@"返回参数%@",responseObject);
//              if ([responseObject[@"msg"] isEqualToString:@"token不能為空"]) {
//                  NSLog(@"url = %@",url);
//                  NSLog(@"dic = %@",dic);
//              }
              if (responseObject) {
                  VDBaseModel *baseModel = [VDBaseModel mj_objectWithKeyValues:responseObject];
                  if (success) success(responseObject);
                  if (baseModel.message) {
                      if (errorBlock) errorBlock(baseModel.message);
                  }
                  if ([baseModel.code isEqualToString:@"401"] ||
                      [baseModel.code isEqualToString:@"407"] ||
                      [baseModel.code isEqualToString:@"408"] ||
                      [baseModel.code isEqualToString:@"409"]) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenPass"
                                                                          object:nil];
                  }
                  if ([baseModel.code isEqualToString:@"10008"]) {
                      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                                     message:NSLocalizedString(@"VDjinzhichina", nil)
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
                      [alert show];
                  }
              }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        if (failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (void)requestNetSecurityGET:(NSString *)path
               paraDictionary:(NSDictionary *)params
                 successBlock:(successBlock)success
                   errorBlock:(errorBlock)errorBlock
                    failBlock:(failBlock)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,path];
    AFHTTPSessionManager *manager = [self sharedHTTPSessionManager];
    AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues=YES;
    manager.responseSerializer=response;
    [manager GET:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
      parameters:params
        progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        
//        DLog(@"返回参数%@",responseObject);
        if (responseObject != nil) {
            VDBaseModel *baseModel = [VDBaseModel mj_objectWithKeyValues:responseObject];
//            if (responseObject[@"msg"]) {
//                if (success != nil) {
//                    success(responseObject);
//                }
//            }
            if ([baseModel.code isEqualToString:@"200"] ||
                [baseModel.code isEqualToString:@"0"]) {
                if (success) {
                    success(responseObject);
                }
            } else if ([baseModel.code isEqualToString:@"12005"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDRegistered", nil));
            } else if ([baseModel.code isEqualToString:@"12087"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDCodeNo", nil));
            } else if ([baseModel.code isEqualToString:@"12088"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDCodeSendFail", nil));
            } else if ([baseModel.code isEqualToString:@"12089"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDSendCode", nil));
            } else if ([baseModel.code isEqualToString:@"12027"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDtransmissions", nil));
            } else if ([baseModel.code isEqualToString:@"12028"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDMessageFail", nil));
            } else if ([baseModel.code isEqualToString:@"12029"])  {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDFailMessage", nil));
            } else if ([baseModel.code isEqualToString:@"12030"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDtimeout", nil));
            } else if ([baseModel.code isEqualToString:@"13002"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDLoginFail", nil));
            } else if ([baseModel.code isEqualToString:@"13021"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDPasswordFail", nil));
            } else if ([baseModel.code isEqualToString:@"12009"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDRegisterFail", nil));
            } else if ([baseModel.code isEqualToString:@"13105"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDVideoSuccess", nil));
            } else if ([baseModel.code isEqualToString:@"13109"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDVideoaudit", nil));
            } else if ([baseModel.code isEqualToString:@"10004"]) {
            } else if ([baseModel.code isEqualToString:@"401"]) {
                if (errorBlock) errorBlock(NSLocalizedString(@"VDLoginFail", nil));
            } else{
                if (errorBlock) errorBlock(responseObject);
            }
            if ([baseModel.code isEqualToString:@"401"] ||
                [baseModel.code isEqualToString:@"407"] ||
                [baseModel.code isEqualToString:@"408"] ||
                [baseModel.code isEqualToString:@"409"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenPass"
                                                                    object:nil];
            }
            if ([baseModel.code isEqualToString:@"10008"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                               message:NSLocalizedString(@"VDjinzhichina", nil)
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
                [alert show];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
    
}

- (void)loadTeasingUrl:(NSString *)path
              paraDict:(NSMutableDictionary*)params
          successBlock:(successBlock)success
            errorBlock:(errorBlock)errorBlock
             failBlock:(failBlock)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,path];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];

    //无条件的信任服务器上的证书
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;

    DLog(@"请求地址%@",url);
    
    NSData *jsonData= [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *objectStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *object = [self base64EncodeString:objectStr];
    NSString *signstr = [object stringByAppendingString:@"123456"];
    NSString *sign = [NSString md5String:signstr];
    NSDictionary *newparameter=@{@"object":object,@"sign":sign};
    AFJSONResponseSerializer *response=[AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues=YES;
    manager.responseSerializer=response;
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",
                                                       @"text/json",
                                                       @"text/javascript",
                                                       @"text/html",
                                                       @"text/plain",
                                                       nil];
    DLog(@"最终参数:%@",newparameter);
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"d"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"c"];
    NSUserDefaults *userToken = [NSUserDefaults standardUserDefaults];
    if (userToken) {
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer_%@",[userToken objectForKey:@"token"]]
                         forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST: [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
       parameters:newparameter
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        
        
        if (responseObject != nil) {
            DLog(@"%@", responseObject);
            VDBaseModel *baseModel = [VDBaseModel mj_objectWithKeyValues:responseObject];
            
            if ([baseModel.msg isEqualToString:@"SUCCESS"]) {//表示正确
                if (success) {
                    success(responseObject);
                }
            } else if([baseModel.code isEqualToString:@"20012"]) {//没有权限
                if (success) {
                    success(responseObject);
                }
            } else if([baseModel.code isEqualToString:@"20013"]) {//参数错误
                if (success) {
                    success(responseObject);
                }
            } else if([baseModel.code isEqualToString:@"2"]) {
                if (success) {
                    success(responseObject);
                }
            } else if([baseModel.code isEqualToString:@"43"]) {//该用户已存在
                if (errorBlock) {
                    errorBlock(baseModel.msg);
                }
            } else if([baseModel.code isEqualToString:@"40"]) {//用户正在审核中,暂时无法登陆
                baseModel.msg = @"用户正在审核中,暂时无法登录";
                if (errorBlock) {
                    errorBlock(baseModel.msg);
                }
            } else if([baseModel.code isEqualToString:@"20014"]) {//该用户不存在
                baseModel.message = @"该用户不存在";
                if (errorBlock) {
                    errorBlock(baseModel.msg);
                }
            } else {
                if (errorBlock) {
                    errorBlock(baseModel.msg);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
        DLog(@"错误信息:%@",error);
    }];
}

//对string进行base64加密
- (NSString *)base64EncodeString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

@end
