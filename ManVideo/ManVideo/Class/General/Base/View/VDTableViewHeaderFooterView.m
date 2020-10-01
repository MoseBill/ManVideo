//
//  VDTableViewHeaderFooterView.m
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDTableViewHeaderFooterView.h"

@implementation VDTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self yd_setupViews];
    }
    return self;
}

- (void)yd_setupViews{}

@end
