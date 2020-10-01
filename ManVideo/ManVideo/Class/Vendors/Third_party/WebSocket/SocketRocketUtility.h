//
//  SocketRocketUtility.h
//  SUN
//
//  Created by Joseph on 17/2/16.
//  Copyright © 2017年  Joseph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket.h>

#import "MessageModel.h"

extern NSString *const kNeedPayOrderNote;
extern NSString *const kWebSocketDidOpenNote;
extern NSString *const kWebSocketDidCloseNote;
extern NSString *const kWebSocketdidReceiveMessageNote;

@protocol AnnouncementSocketDelegate <NSObject>

- (void)sendMessageSocketModel:(MessageModel *)model;

@end

@interface SocketRocketUtility : NSObject

@property(nonatomic,weak)id<AnnouncementSocketDelegate> delegate;
@property(nonatomic,assign,readonly)SRReadyState socketReadyState;//获取连接状态
+ (SocketRocketUtility *)instance;

/** 开始连接 */
- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;

/** 关闭连接 */
- (void)SRWebSocketClose;

/** 发送数据 */
- (void)sendData:(id)data;


@end
