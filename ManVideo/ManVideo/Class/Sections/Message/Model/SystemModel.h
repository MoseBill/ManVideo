//
//  SystemModel.h
//  Clipyeu ++
//
//  Created by Josee on 08/05/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemModel : NSObject

@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              startIndex;
@property (nonatomic , assign) NSInteger              Id;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , copy) NSString              * text;
@property (nonatomic , copy) NSString              * theme;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              pageNum;

@property (nonatomic, assign) NSInteger    userName;
@property (nonatomic,assign) NSInteger    userId;
@property (nonatomic, strong) NSString    *headerImage;
@property (nonatomic, strong) NSString    *createDate;

@end

NS_ASSUME_NONNULL_END
