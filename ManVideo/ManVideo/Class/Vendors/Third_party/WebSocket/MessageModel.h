//
//  MessageModel.h
//  Clipyeu ++
//
//  Created by Josee on 7/1/19.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger startIndex;
@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,copy)NSString * link;
@property(nonatomic,copy)NSString * text;
@property(nonatomic,copy)NSString * theme;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger createTime;
@property(nonatomic,assign)NSInteger pageNum;

@end

NS_ASSUME_NONNULL_END
