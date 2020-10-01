//
//  VDHomeViewController.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDViewController.h"
#import <UIKit/UIKit.h>
//#import "VDViewControllerProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeVC : GKDYBaseViewController

@property(nonatomic,strong)TXScrollLabelView *scrollLabelView;
@property(nonatomic,strong)NSMutableArray *adressArr;

@end

NS_ASSUME_NONNULL_END
