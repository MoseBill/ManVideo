//
//  VDViewControllerProtocol.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VDViewModelProtocol;

@protocol VDViewControllerProtocol <NSObject>


@optional
- (instancetype)initWithViewModel:(id <VDViewModelProtocol>)viewModel;

- (void)vd_bindViewModel;
- (void)vd_addSubviews;
- (void)vd_layoutNavigation;
- (void)vd_getNewData;
- (void)recoverKeyboard;

@end

NS_ASSUME_NONNULL_END
