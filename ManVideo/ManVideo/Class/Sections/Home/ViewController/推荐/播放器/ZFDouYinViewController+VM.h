//
//  ZFDouYinViewController+VM.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/20.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ZFDouYinViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFDouYinViewController (VM)

- (void)requestData;//总请求
-(void)LikeNetWorking:(EmitterBtn *)click;//点赞
- (void)shareNetWork:(NSString *)work
              userID:(NSInteger)userId
         platformNet:(NSString *)platform;//分享
@end

NS_ASSUME_NONNULL_END
