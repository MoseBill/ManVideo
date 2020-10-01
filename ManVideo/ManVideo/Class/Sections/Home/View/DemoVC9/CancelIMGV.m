//
//  testBtn.m
//  ManVideo
//
//  Created by 刘赓 on 2019/8/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "CancelIMGV.h"

@implementation CancelIMGV

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    if (self.MyBlock) {
        self.MyBlock();
    }return self;
}


@end
