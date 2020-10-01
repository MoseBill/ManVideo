//
//  VDCollectionViewCell.m
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDCollectionViewCell.h"

@implementation VDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self yd_setupViews];
    }
    return self;
}

- (void)yd_setupViews {}

@end
