//
//  ZFDouYinCell.h
//  ZFPlayer_Example
//
//  Created by Josee on 2018/6/4.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableData.h"
#import "EdwPlayerProgressView.h"
#import "EdwVideoLanternView.h"
#import "EdwVideoMusicView.h"
#import "EdwVideoSoundSlider.h"
#import <MediaPlayer/MediaPlayer.h>

@protocol VDCommentDelegate <NSObject>

- (void)upComment:(UIButton *)btn;

- (void)likeClickDelegate:(UIButton *)click;

- (void)shareClickDelegate:(UIButton *)sender;

@end

@interface ZFDouYinCell : UITableViewCell

@property (nonatomic, strong) id<VDCommentDelegate> delegate;


@property (nonatomic, strong) ZFTableData *data;

@property (strong, nonatomic) EdwVideoMusicView *musicView;
@property (nonatomic, strong) NSTimer *timer;


@property (strong, nonatomic) EdwVideoLanternView *lanternView;

@end
