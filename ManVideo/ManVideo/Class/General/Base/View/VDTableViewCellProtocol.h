//
//  VDTableViewCellProtocol.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VDTableViewCellProtocol <NSObject>

@optional

- (void)vd_setupViews;
- (void)vd_bindViewModel;

@end

NS_ASSUME_NONNULL_END
