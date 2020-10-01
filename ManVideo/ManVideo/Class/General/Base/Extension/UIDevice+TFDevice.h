//
//  UIDevice+TFDevice.h
//  PLTest
//
//  Created by mac on 2017/12/9.
//  Copyright © 2017年 腾飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (TFDevice)
/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
