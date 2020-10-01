//
//  CommentVC+VM.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CommentVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentVC (VM)

- (void)loadDataView;//评论条接口:
- (void)loadNetWorkReply:(NSDictionary *)dict;
- (void)loadNetWork:(NSString *)text;//评论接口:
//- (void)replyMyMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
