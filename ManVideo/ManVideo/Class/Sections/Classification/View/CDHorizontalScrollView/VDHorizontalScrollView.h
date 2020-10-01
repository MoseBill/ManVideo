//
//  VDHorizontalScrollView.h
//  Clipyeu ++
//
//  Created by Josee on 12/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDHorizontalScrollViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface VDHorizontalScrollView : UIView

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
@property (nonatomic, weak) id<CDHorizontalScrollViewDelegate> delegate;


@end

@protocol CDHorizontalScrollViewDelegate <NSObject>

@optional

// cell数量
- (NSArray *)numberOfColumnsInCollectionView:(VDHorizontalScrollView *)collectionView;

// 每个item大小
- (CGSize)cellSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

// 每个上左下右内边距
- (UIEdgeInsets)collectionViewInsetForSectionAtIndex:(NSInteger)section;

// 每个item之间的间距
- (CGFloat)collectionViewMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

// 选中cell
- (void)didselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)cellTapClick:(UITapGestureRecognizer *)tap;

- (void)clickActionVideoDelegateArr:(NSMutableArray *)arr;

@end


NS_ASSUME_NONNULL_END
