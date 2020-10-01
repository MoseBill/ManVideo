//
//  LoginModel.h
//  Clipyeu ++
//
//  Created by Josee on 30/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN



@interface LoginModel : NSObject

@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString  *nickname;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,copy)NSString *avatorId;
@property(nonatomic,copy)NSString *signname;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *attentionCount;


@end

NS_ASSUME_NONNULL_END
