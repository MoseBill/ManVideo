//
//  HotLabelCollectionCell.m
//  Clipyeu ++
//
//  Created by Josee on 25/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "HotLabelCollectionCell.h"

@interface HotLabelCollectionCell ()

@property (nonatomic, strong) UIButton    *imageBtn;

@end

@implementation HotLabelCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
    
        [self setView];
    }
    return self;
}

- (void)setView {
    
   [self addSubview:self.imageBtn];
    
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(24);
    }];
}

- (UIButton *)imageBtn {
    if (!_imageBtn) {
        
        _imageBtn  = [UIButton new];
        [_imageBtn setTitle:@"" forState:UIControlStateNormal];
        [_imageBtn setTitleColor:[UIColor colorWithHexString:@"D32EA6"] forState:UIControlStateNormal];
        _imageBtn.font = [UIFont systemFontOfSize:13.0f];
    }
    return _imageBtn;
}

@end
