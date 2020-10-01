//
//  Base.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#ifndef Base_h
#define Base_h

//系统级别
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "APIMacro.h"
#import "AppMacro.h"
//数据模型层
#import "VDBaseModel.h"
#import "CMRequest.h"//网络请求框架
#import "ZFMRACNetworkTool.h"//网络请求
#import "GKTimer.h"
#import "CommonAppKey.h"//视频合成
#import "MHVideoTool.h"//视频合成
#import "PostVideoModel.h"//视频合成
//#import "ZHKeyChainManager.h"//钥匙串

//类拓展
#import "NSString+HDExtension.h"
#import "UIImage+FKColor.h"
#import "UIColor+FKColor.h"
#import "UIView+EdwFrame.h"
#import "NSString+Extension.h"
#import "NSString+Emoji.h"
#import "NSBundle+Language.h"
#import "NSString+tool.h"
#import "NSArray+Extension.h"
#import "UIDevice+TFDevice.h"
#import "AABlock.h"

#endif /* Base_h */
