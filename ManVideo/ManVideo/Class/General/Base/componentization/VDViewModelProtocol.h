//
//  VDViewModelProtocol.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LSHeaderRefresh_HasMoreData = 1,
    LSHeaderRefresh_HasNoMoreData,
    LSFooterRefresh_HasMoreData,
    LSFooterRefresh_HasNoMoreData,
    LSRefreshError,
    LSRefreshUI,
} LSRefreshDataStatus;


@protocol VDViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

@property (strong, nonatomic) CMRequest *request;

/**
 *  初始化
 */
- (void)vd_initialize;

@end

NS_ASSUME_NONNULL_END
