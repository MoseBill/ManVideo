//
//  ViewForHeader.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ViewForHeader.h"

@interface ViewForHeader()

@property(nonatomic,copy)DataBlock block;

@end

@implementation ViewForHeader

- (instancetype)initWithRequestParams:(id)requestParams{
    if (self = [super init]) {
        self.header.alpha = 1;

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

#pragma mark —— lazyLoad
-(UILabel *)header{
    if (!_header) {
        _header = UILabel.new;
        _header.frame = CGRectMake(0,
                                   0,
                                   SCREEN_WIDTH,
                                   SCALING_RATIO(165));
//        _header.backgroundColor = KYellowColor;
        _header.text = NSLocalizedString(@"VDNomoreText", nil);
        _header.textColor = [UIColor colorWithHexString:@"E5E5E5"];
        _header.font = [UIFont systemFontOfSize:12.0f];
        _header.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_header];
        [_header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }return _header;
}

@end
