//
//  FMARCNetwork.h
//  ZFMRACNetwork
//
//  Created by todriver02 on 2018/7/31.
//  Copyright © 2018年 zhufaming. All rights reserved.
//

/**
 *  网络请求工具类
 */
#import <Foundation/Foundation.h>
@class FMHttpRequest;

@interface FMARCNetwork : NSObject

+(instancetype) sharedInstance;
/**
 网络请求,返回信号
 按照， FMHttpRequest 参数化设置
 @param req FMHttpRequest
 @return RACSignal
 */
- (RACSignal *)requestNetworkData:(FMHttpRequest *)req;

/**
 网络请求，简便方案

 @param path 请求路径 --- 基本链接，请在 FMHttpRConstant.h 文件中设置
 @param params 参数字典
 @return RACSignal
 */
- (RACSignal *)requestSimpleNetworkPath:(NSString *)path
                                 params:(NSDictionary *)params;


/**
 文件上传、可以单个文件、也可以多个文件

 @param path 文件上传服务器地址，这里单独给出来，是因为很大部分图片服务器和业务服务器不是同一个
 @param params 参数 没有可传 @{}
 @param fileDatas NSData 数组
 @param name 指定数据关联的名称
 @return RACSignal
 */
- (RACSignal *)uploadNetworkPath:(NSString *)path
                          params:(NSDictionary *)params
                       fileDatas:(NSArray<NSData *> *)fileDatas
                            name:(NSString *)name
                        mimeType:(NSString *)mimeType;


@end
