//
//  ZFDouYinCell.h
//  ZFPlayer_Example
//
//  Created by Josee on 2018/6/4.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdwPlayerProgressView.h"
#import "EdwVideoLanternView.h"
#import "EdwVideoMusicView.h"
#import "EdwVideoSoundSlider.h"
#import <MediaPlayer/MediaPlayer.h>

#import "RecommendedModel.h"
#import "GKDYVideoModel.h"
#import "ClassModel.h"
#import "HotModel.h"
#import "CommonModel.h"

@protocol VDCommentDelegate <NSObject>

- (void)upCommentId:(NSArray *_Nullable)idArr;
- (void)shareClickDelegate:(UIButton *_Nonnull)sender;
- (void)playerIndexPath:(NSIndexPath*_Nonnull)index;
- (void)PopUpView:(NSString *_Nonnull)view;
- (void)focusOnAction:(UIButton *_Nonnull)action;
- (void)likeClickDelegate:(EmitterBtn *_Nonnull)click
                    Index:(NSInteger)index;

@end

@interface ZFDouYinCell : UITableViewCell

@property(nonatomic,strong)UILabel * _Nonnull likeCount;

@property(strong,nonatomic)EdwVideoLanternView *_Nonnull lanternView;
@property(nonatomic,weak)id<VDCommentDelegate> _Nullable delegate;
@property(nonatomic,strong)NSIndexPath *_Nonnull index;
@property(nonatomic,strong)CommonModel *_Nullable commonModel;
@property(nonatomic,copy)NSString *_Nullable shareCountString;
@property(nonatomic,copy)NSString *_Nullable messageCountString;

+(instancetype _Nonnull)cellWith:(UITableView *_Nonnull)tableView;

- (void)richElementsInCellWithModel:(id _Nullable)model
                   isSecondaryPages:(BOOL)isSecondaryPages;

@end
