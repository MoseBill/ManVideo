//
//  VDIconModel.h
//  Clipyeu ++
//
//  Created by Josee on 15/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VDIconModel : NSObject

@property(nonatomic,assign)float iconW;
@property(nonatomic,assign)float IconH;
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)IconWithDictionay:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
