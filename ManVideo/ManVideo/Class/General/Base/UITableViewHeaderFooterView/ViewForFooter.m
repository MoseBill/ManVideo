//
//  ViewForFooter.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ViewForFooter.h"

@interface ViewForFooter()

@property(nonatomic,weak)DataBlock block;

@end

@implementation ViewForFooter

- (instancetype)initWithRequestParams:(id)requestParams{
    if (self = [super init]) {

    }return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.block) {
        self.block(@1);
    }
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

@end
