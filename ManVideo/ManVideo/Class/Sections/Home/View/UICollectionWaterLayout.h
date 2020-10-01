//
//  UICollectionWaterLayout.h
//  瀑布流
//
//  Created by FDC-Fabric on 2018/12/14.
//  Copyright © 2018年 FDC-Fabric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDIconModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UICollectionWaterLayout : UICollectionViewFlowLayout

/**
 列数
 */
@property(nonatomic,assign)int  colunms;

@property(nonatomic,strong)NSMutableArray *iconArray;
+(instancetype)layoutWithColoumn:(int)coloumn  data:(NSMutableArray *)dataA   verticleMin:(float)minv  horizonMin:(float)minh  leftMargin:(float)leftMargin  rightMargin:(float)rightMargin;
@end

NS_ASSUME_NONNULL_END
