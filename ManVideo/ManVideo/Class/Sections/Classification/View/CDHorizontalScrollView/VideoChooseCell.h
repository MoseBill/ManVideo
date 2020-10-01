//
//  VideoChooseCell.h
//  Clipyeu ++
//
//  Created by Josee on 11/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VideoChooseDelegate <NSObject>

- (void)chooseVideoDelegate:(UIButton *)sender
                  indexPath:(NSIndexPath *)index;

- (void)videoHorizontalTap:(UITapGestureRecognizer *)sender;

@end

@interface VideoChooseCell : UICollectionViewCell

@property(nonatomic,strong)id<VideoChooseDelegate> delagte;
@property(nonatomic,strong)VideoUploadingList *model;
@property(nonatomic,strong)NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
