//
//  VDViewModel.h
//  iOSMovie
//
//  Created by Josee on 10/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface VDViewModel : NSObject<VDViewModelProtocol>

@property (nonatomic, strong) NSString    *advertisement;

@end

NS_ASSUME_NONNULL_END
