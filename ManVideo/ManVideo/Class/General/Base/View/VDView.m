//
//  VDView.m
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDView.h"

@implementation VDView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self yd_setupViews];
        [self yd_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<VDViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
        
        [self yd_setupViews];
        [self yd_bindViewModel];
    }
    return self;
}

- (void)yd_bindViewModel {
    
}

- (void)yd_setupViews {
    
}

- (void)yd_addReturnKeyBoard {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window endEditing:YES];
    }];
    [self addGestureRecognizer:tap];
}

@end
