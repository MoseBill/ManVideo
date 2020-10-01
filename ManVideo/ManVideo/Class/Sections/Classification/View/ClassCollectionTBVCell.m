//
//  VDClassCollectionViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 24/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ClassCollectionTBVCell.h"
#import "TCSCollectionViewCell.h"
#import "UICollectionView+SideRefresh.h"

@interface ClassCollectionTBVCell ()
<
UICollectionViewDataSource
,UICollectionViewDelegate
>

@property(nonatomic,strong)UILabel *classificationLabel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
//@property(nonatomic,strong)SideRefreshHeader *refreshHeader;
//@property(nonatomic,strong)SideRefreshFooter *refreshFooter;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int totalPage;
@property(nonatomic,assign)CGFloat itemCount;

@end

@implementation ClassCollectionTBVCell

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)init{
    if (self = [super init]) {
        self.page = 1;
        self.itemCount = 0;
    }return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kClearColor;
        self.classificationLabel.alpha = 1;
        self.collectionView.alpha = 1;
        self.colorView.alpha = 1;
        self.collectionView.alpha = 1;
    }return self;
}

//进数据
-(void)setClassTotalDataModel:(ClassTotalDataModel *)classTotalDataModel{
    _classTotalDataModel = classTotalDataModel;
    self.classificationLabel.text = _classTotalDataModel.name;
}

-(void)setRowDataMutArr:(NSMutableArray *)rowDataMutArr{
    _rowDataMutArr = rowDataMutArr;
}

-(void)setVideoArr:(NSMutableArray<NSString *> *)videoArr{
    _videoArr = videoArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
//    return self.itemCount == 0 ? self.videoArr.count : self.itemCount;
    return self.rowDataMutArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TCSCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier
                                                                                        forIndexPath:indexPath];
//    collectionViewCell.backgroundColor = RandomColor;
    collectionViewCell.model = self.rowDataMutArr[indexPath.row];
    [collectionViewCell taskImageToCell:collectionViewCell
                                 andTag:indexPath];
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.videoArr.count > 0) {
        if ([self.delegate respondsToSelector:@selector(videoClickIndexPathRow:
                                                        IndexPathSection:
                                                        actionArr:
                                                        modelArr:)]) {
            [self.delegate videoClickIndexPathRow:indexPath.row
                                 IndexPathSection:self.section
                                        actionArr:self.videoArr
                                         modelArr:self.rowDataMutArr];
        }
    }
}

#pragma mark —— lazyLoad
- (UIView *)colorView {
    if (!_colorView) {
        _colorView = UIView.new;
        _colorView.backgroundColor = [UIColor colorWithHexString:@"DC4E61"];
        [self.contentView addSubview:_colorView];
        [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13/375.0f*SCREEN_WIDTH);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(10/375.0f*SCREEN_WIDTH);
            make.height.mas_equalTo(15/667.0f*(SCREEN_HEIGHT));
        }];
    }return _colorView;
}

- (UILabel *)classificationLabel {
    if (!_classificationLabel) {
        _classificationLabel = UILabel.new;
        _classificationLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        _classificationLabel.font = [UIFont systemFontOfSize:15.0f];
        _classificationLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_classificationLabel];
        [_classificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.colorView.mas_right).offset(SCALING_RATIO(11));
            make.centerY.mas_equalTo(self.colorView.mas_centerY);
            make.width.mas_equalTo(SCALING_RATIO(65));
            make.height.mas_equalTo(SCALING_RATIO(14));
        }];
    }return _classificationLabel;
}

-(UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = UICollectionViewFlowLayout.new;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCALING_RATIO(210.0f - 45.0f));
        _flowLayout.minimumLineSpacing = 5.0f;
    }return _flowLayout;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = kClearColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"TCSCollectionViewCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:ReuseIdentifier];
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10.0f));
            make.top.equalTo(self.classificationLabel.mas_bottom).offset(SCALING_RATIO(5.0f));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10.0f));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-10.0f));
        }];
//        _collectionView.sideRefreshHeader = self.refreshHeader;
//        _collectionView.sideRefreshFooter = self.refreshFooter;
    }return _collectionView;
}

//-(SideRefreshHeader *)refreshHeader{
//    if (!_refreshHeader) {
//        @weakify(self)
//        _refreshHeader = [SideRefreshHeader refreshWithLoadAction:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
//                           dispatch_get_main_queue(), ^{
//                               @strongify(self)
//                               if (self.videoArr.count > 3) {
//                                   self.itemCount = 3;
//                               } else if (self.videoArr.count < 3) {
//                                   return;
//                               } else {
//                                   self.itemCount = self.videoArr.count;
//                               }
//                               [self.collectionView.sideRefreshHeader endLoading];
//                               [self.collectionView reloadData];
//                           });
//        }];
//        _refreshHeader.normalMessage = NSLocalizedString(@"VDshishizaila", nil);
//        _refreshHeader.pullingMessage = NSLocalizedString(@"VDsongkai", nil);
//        _refreshHeader.loadingMessage = NSLocalizedString(@"VDruning", nil);
//    }return _refreshHeader;
//}
//
//-(SideRefreshFooter *)refreshFooter{
//    if (!_refreshFooter) {
//        @weakify(self)
//        _refreshFooter = [SideRefreshFooter refreshWithLoadAction:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
//                           dispatch_get_main_queue(), ^{
//                               @strongify(self)
//                               self.page ++;
//
////                               [self reqestData];
//
//                               if(!(self.itemCount >= self.videoArr.count)) {
//                                   if ((self.videoArr.count - self.itemCount) >= 4 ) {
//                                       self.itemCount += 4;
//                                       [self.collectionView.sideRefreshFooter endLoading];
//                                   } else {
//                                       self.itemCount += (self.videoArr.count - self.itemCount);
//                                       [self.collectionView.sideRefreshFooter endLoading];
//                                   }
//                               } else {
//                                   [self.collectionView.sideRefreshFooter endLoading];
//                               }
//                               [self.collectionView reloadData];
//                           });
//        }];
//        _refreshFooter.normalMessage = NSLocalizedString(@"VDshishizaila", nil);
//        _refreshFooter.pullingMessage = NSLocalizedString(@"VDsongkai", nil);
//        _refreshFooter.loadingMessage = NSLocalizedString(@"VDruning", nil);
//    }return _refreshFooter;
//}

@end
