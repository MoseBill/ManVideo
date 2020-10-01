//
//  TCSCollectionViewCell.h
//  MOABBS
//
//  Created by odin on 2019/1/22.
//  Copyright © 2019 odin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCSCollectionViewCell : UICollectionViewCell

@property(weak,nonatomic)IBOutlet UIImageView *ImageV;
@property(weak,nonatomic)IBOutlet UIButton *likeBtn;
@property(weak,nonatomic)IBOutlet UIButton *collectionBtn;

@property(nonatomic,strong)ClassModel *model;
@property(nonatomic,copy)void(^likeBtnBlock)(UIButton *btn);
@property(nonatomic,copy)void(^collectionBtnBlock)(UIButton *btn);

- (void)taskImageToCell:(TCSCollectionViewCell*)cell
                 andTag:(NSIndexPath*)index;

@end

NS_ASSUME_NONNULL_END
