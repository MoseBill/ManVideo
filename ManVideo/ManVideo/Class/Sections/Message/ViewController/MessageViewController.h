//
//  MessageViewController.h
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

//#import "VDViewController.h"
#import <UIKit/UIKit.h>
#import "VDViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : GKDYBaseViewController

@property (nonatomic,copy) void(^messageRedBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
