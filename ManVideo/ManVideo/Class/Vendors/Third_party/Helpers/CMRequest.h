//
//  CMRequest.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>

//#define BaseUrl @"https://clipyeuplus.com"//正式环境
#define BaseUrl @"http://192.168.1.147:8800"//测试环境
#define VedioBaseUrl @"https://app.clipyeuplus.com"
#define scoketUrl @"wss://clipyeuplus.com/messagePushWebSocket"

NS_ASSUME_NONNULL_BEGIN

@class CMRequest;
@protocol CMRequestDelegate <NSObject>

- (void)CMRequest:(CMRequest *)request finished:(NSString *)response;
- (void)CMRequest:(CMRequest *)request Error:(NSString *)error;

@end

@interface CMRequest : NSObject

@property (nonatomic,strong) AFHTTPSessionManager *manager;

typedef void (^successBlock)(NSDictionary *dict);
typedef void (^errorBlock)(NSString *message);
typedef void (^failBlock)(NSError *error);

@property (nonatomic,copy) void(^tokenBlock)(NSString *type);

@property (assign) id <CMRequestDelegate> delegate;

/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager* operationManager;

/**
 *当前的请求operation队列
 */
@property (nonatomic, strong) NSOperationQueue* operationQueue;

/**
 *功能: 创建CMRequest的对象方法
 */
+ (instancetype)request;

/**
 *功能：GET请求
 *参数：(1)请求的url: urlString
 *     (2)请求成功调用的Block: success
 *     (3)请求失败调用的Block: failure
 */
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(CMRequest *, NSString *))success
    failure:(void (^)(CMRequest *, NSError *))failure;

/**
 *功能：POST请求
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(CMRequest *request, NSString* responseString))success
     failure:(void (^)(CMRequest *request, NSError *error))failure;

/**
 *  post请求
 *
 *  @param URLString  请求网址
 *  @param parameters 请求参数
 */
- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;

/**
 *  get 请求
 *
 *  @param URLString 请求网址
 */
- (void)getWithURL:(NSString *)URLString;

/**
 *取消当前请求队列的所有请求
 */
- (void)cancelAllOperations;



////网络请求封装
//+ (void)requestNetUrl:(NSString *)path paraDict:(NSDictionary *)params successBlock:(successBlock)success errorBlock:(errorBlock)errorBlock  failBlock:(failBlock)failBlock;
//+ (void)requestSocialSecurity:(NSString *)path paraDict:(NSDictionary *)params successBlock:(successBlock)success errorBlock:(errorBlock)errorBlock  failBlock:(failBlock)failBlock;

+ (void)requestNetSecurityPOST:(NSString *)path
                paraDictionary:(NSDictionary *)params
                  successBlock:(successBlock)success
                    errorBlock:(errorBlock)errorBlock
                     failBlock:(failBlock)failBlock;

//- (void)requestNetworkUrl:(NSString *)path paraDict:(NSDictionary *)params successBlock:(successBlock)success errorBlock:(errorBlock)errorBlock  failBlock:(failBlock)failBlock;

- (void)requestSecurityGET:(NSString *)path
            paraDictionary:(NSDictionary *)params
              successBlock:(successBlock)success
                errorBlock:(errorBlock)errorBlock
                 failBlock:(failBlock)failBlock;

+ (void)requestNetSecurityGET:(NSString *)path
               paraDictionary:(NSDictionary *)params
                 successBlock:(successBlock)success
                   errorBlock:(errorBlock)errorBlock
                    failBlock:(failBlock)failBlock;

- (void)upLoadImage:(NSString *)path
           paraDict:(UIImage *)params
             userId:(NSDictionary *)paramsDic
       successBlock:(successBlock)success
         errorBlock:(errorBlock)errorBlock
          failBlock:(failBlock)failBlock;

- (void)loadTeasingUrl:(NSString *)path
              paraDict:(NSMutableDictionary*)params
          successBlock:(successBlock)success
            errorBlock:(errorBlock)errorBlock
             failBlock:(failBlock)failBlock;

- (void)uploadImagePost:(NSString *)path
               paraDict:(UIImage *)params
           successBlock:(successBlock)success
             errorBlock:(errorBlock)errorBlock
              failBlock:(failBlock)failBlock;

+ (void)httpWithUrl:(NSString *)url
               body:(NSDictionary *)bodyDic
         parameters:(NSDictionary *)parameters
       successBlock:(successBlock)success
         errorBlock:(errorBlock)errorBlock
          failBlock:(failBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
