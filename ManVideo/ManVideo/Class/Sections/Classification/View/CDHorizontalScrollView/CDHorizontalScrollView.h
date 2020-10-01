//
//  CDHorizontalScrollView.h
//  CDProgramme
//
//  Created by cqz on 2018/8/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassCollectionTBVCell.h"

@protocol CDHorizontalScrollViewDelegate;


@interface CDHorizontalScrollView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *listMutaArray;

@property (nonatomic, strong) NSMutableArray   *articleArr;
/**
 初始化方法

 @param frame frame
 @param classCell 自定义的Cell
 @param isNib  是否Xib
 @param deleagte  代理
 @return CDHorizontalScrollView
 */
- (instancetype)initWithFrame:(CGRect)frame withClassCell:(Class)classCell isNib:(BOOL)isNib withDelegate:(id<CDHorizontalScrollViewDelegate>)deleagte;

// 重新加载
- (void)reloadData;



//- (void)addRefreshEvent;
@end


@protocol CDHorizontalScrollViewDelegate <NSObject>

@optional

// cell数量
- (NSArray *)numberOfColumnsInCollectionView:(CDHorizontalScrollView *)collectionView;

// 每个item大小
- (CGSize)cellSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

// 每个上左下右内边距
- (UIEdgeInsets)collectionViewInsetForSectionAtIndex:(NSInteger)section;

// 每个item之间的间距
- (CGFloat)collectionViewMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

// 选中cell
- (void)didselectItemAtIndexPath:(NSIndexPath *)indexPath;


@end
