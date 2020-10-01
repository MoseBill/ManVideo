//
//  MusicTableViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 01/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    UIButton *actionMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionMusic setTitle:NSLocalizedString(@"VDquedingshi", nil) forState:UIControlStateNormal];
    [actionMusic setTitleColor:kWhiteColor forState:UIControlStateNormal];
    actionMusic.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    actionMusic.font = [UIFont systemFontOfSize:15.0f];
    [actionMusic addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:actionMusic];
    
    [actionMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(7);
          make.bottom.mas_equalTo(-7);
        make.height.mas_equalTo(30);
    }];
    actionMusic.layer.masksToBounds = YES;
    actionMusic.layer.cornerRadius = 10.0f;
}

- (void)musicAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickMusicPlayDeleagte:)]) {
        
        [self.delegate clickMusicPlayDeleagte:self.backString];
    }
}

@end
