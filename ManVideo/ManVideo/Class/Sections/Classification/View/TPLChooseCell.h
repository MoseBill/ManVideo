//
//  TPLChooseCell.h
//  WelfarePlatform
//
//  Created by 万佳阳 on 2018/4/15.
//  Copyright © 2018年 JYWan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Data;
@interface TPLChooseCell : UICollectionViewCell
/** 模  */
@property (nonatomic, strong) Data *item;

//@property (nonatomic, strong) NSArray *array;
- (void)loadDataArr:(NSArray *)array indexPath:(NSIndexPath *)index;



@end
