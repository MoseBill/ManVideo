//
//  VDHorizontalScrollView.m
//  Clipyeu ++
//
//  Created by Josee on 12/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDHorizontalScrollView.h"
#import "VDHorizontalScrollCell.h"
#import "VideoChooseCell.h"
#import "ClassModel.h"
#import "TCSCollectionViewCell.h"

@interface VDHorizontalScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,VideoChooseDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isNib;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, weak) id<CDHorizontalScrollViewDelegate> scrollViewDelegate;
@property (nonatomic, strong) NSMutableArray    *sumArr;

@property (nonatomic, strong) NSMutableArray    *selectedArr;

@end

@implementation VDHorizontalScrollView

- (instancetype)initWithFrame:(CGRect)frame withClassCell:(Class)classCell isNib:(BOOL)isNib withDelegate:(id<CDHorizontalScrollViewDelegate>)deleagte {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"151023"];
        self.cellClass = classCell;
        self.scrollViewDelegate = deleagte;
        self.isNib = isNib;
        [self setupView];
         self.listMutaArray = [[NSMutableArray alloc]initWithObjects:@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png", nil];
    }
    return self;
}


#pragma mark - Intial Methods
- (void)setupView {
    
    [self addSubview:self.collectionView];
}
#pragma mark - Target Methods

#pragma mark - Public Methods
- (void)reloadData {
    
    [self.listMutaArray removeAllObjects];
    [self.listMutaArray addObjectsFromArray:[self.scrollViewDelegate numberOfColumnsInCollectionView:self]];
    [self.collectionView reloadData];
    //    JMLog(@"吐槽推荐%@",self.listMutaArray);
}
#pragma mark - Private Method

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //    return [self.listMutaArray count];
    return self.listMutaArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString*cellClass = [NSString stringWithFormat:@"%@%zd", NSStringFromClass(self.cellClass), indexPath.row];
//    ZFDouYinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    VideoChooseCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
        cell.userInteractionEnabled = YES;
    cell.indexPath = indexPath;

//    cell.likeBtn.tag = 300+indexPath.row;
//    cell.collectionBtn.tag = 200+indexPath.row;
//    for (int i =0; i <self.articleArr.count; i++) {
//        VideoUploadingList *model = self.articleArr[i];
//        DLog(@"分类数据%@",model);
//    }
//    cell.videoArr = self.articleArr[indexPath.row];
    cell.sd_indexPath = indexPath;
    cell.delagte = self;
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    VideoChooseCell *horizonCell = (VideoChooseCell *)cell;
    if (indexPath.row < self.listMutaArray.count) {
        horizonCell.model = self.listMutaArray[indexPath.row];
//        horizonCell.videoArr = self.articleArr[indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if (self.scrollViewDelegate && [self.scrollViewDelegate respondsToSelector:@selector(didselectItemAtIndexPath:)]) {
        [self.scrollViewDelegate didselectItemAtIndexPath:indexPath];
    }
}

//MARK: - UICollectionViewDelegateLeftAlignedLayout
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(105/375.0f*SCREEN_WIDTH, 162*SCREEN_HEIGHT/(IS_IPHONE_X ? 812 : (kiPhone5 ? 568 : 667)));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self.scrollViewDelegate collectionViewMinimumInteritemSpacingForSectionAtIndex:section];
}
//每行之间竖直之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self.scrollViewDelegate collectionViewMinimumInteritemSpacingForSectionAtIndex:section];
}

#pragma mark - Setter Getter Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.userInteractionEnabled = YES;
        //        _collectionView.showsVerticalScrollIndicator = false;
        //        _collectionView.allowsMultipleSelection = true;
        //水平方向滑动
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
        //        _collectionView.bounces = false;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"151023"];
        //        _collectionView.scrollsToTop = false;
        if (self.isNib) {
            [_collectionView registerNib:[UINib nibWithNibName: NSStringFromClass(self.cellClass) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(self.cellClass)];
        } else {
            [_collectionView registerClass:[self.cellClass class] forCellWithReuseIdentifier: NSStringFromClass(self.cellClass)];
        }
    }
    return _collectionView;
}

//- (void)loadNetWork:(NSIndexPath *)indexWork {
//    JMLog(@"有没有ID%ld",(long)indexWork.row);
//    NetWorkManager *netWork = [[NetWorkManager alloc]init];
//    //    self.dic[@"countPerPage"] = @"20";
//    //     [self.dic setObject:[NSString stringWithFormat:@"%d", self.page] forKey:@"pageNo"];
//    NSDictionary *dic = @{@"articleId":[NSString stringWithFormat:@"%@", self.articleArr[indexWork.row]],@"flag":@"0"};
//    //    MiddleModel *modelMiddle = [[MiddleModel alloc]init];
//    WS(weakSelf)
//    //    @weakify(self);
//
//    [netWork requestNetworkUrl:@"/bbs/article/clickPraise" paraDict:dic successBlock:^(NSDictionary *dict) {
//
//        [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
//    } errorBlock:^(NSString *message) {
//
//        [SVProgressHUD showErrorWithStatus:@"已点赞"];
//
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
//    }];
//}

//- (void)cancelNetWork:(NSIndexPath *)indexWork {
//     JMLog(@"有没有ID%ld",(long)indexWork.row);
//    NetWorkManager *netWork = [[NetWorkManager alloc]init];
//    NSDictionary *dic = @{@"articleId":[NSString stringWithFormat:@"%@", self.articleArr[indexWork.row]],@"flag":@"1"};
//    WS(weakSelf)
//    //    @weakify(self);
//    [netWork requestNetworkUrl:@"/bbs/article/clickPraise" paraDict:dic successBlock:^(NSDictionary *dict) {
//    } errorBlock:^(NSString *message) {
//     [SVProgressHUD showErrorWithStatus:@"已取消点赞"];
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
//    }];
//}

- (void)collectionNetwork:(NSIndexPath *)indexWork {
    
    //    JMLog(@"有没有ID%ld",(long)indexWork.row);
    //    NetWorkManager *netWork = [[NetWorkManager alloc]init];
    //
    //    WS(weakSelf)
    //    //    @weakify(self);
    //    NSString *urlString = [NSString stringWithFormat:@"/bbs/article/collection/%@",self.articleArr[indexWork.row]];
    //    [netWork requestNetworkUrl:urlString paraDict:[NSDictionary new] successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    //
    //    } errorBlock:^(NSString *message) {
    //
    //             [SVProgressHUD showErrorWithStatus:@"已收藏"];
    //
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
    
}

- (void)cancelCollectionIndex:(NSIndexPath *)index {
    
    //    JMLog(@"有没有ID%ld",(long)indexWork.row);
    //    NetWorkManager *netWork = [[NetWorkManager alloc]init];
    //    WS(weakSelf)
    //    //    @weakify(self);
    //    NSString *urlString = [NSString stringWithFormat:@"/bbs/article/cancleCollection/%@",self.articleArr[index.row]];
    //    [netWork requestNetworkUrl:urlString paraDict:[NSDictionary new] successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
    //
    //    } errorBlock:^(NSString *message) {
    //
    //        [SVProgressHUD showErrorWithStatus:@"已取消收藏"];
    //
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
    
}

- (void)chooseVideoDelegate:(UIButton *)sender indexPath:(nonnull NSIndexPath *)index {
    
        sender.selected = !sender.selected;
        if (sender.selected) {
            [sender setImage:[UIImage imageNamed:@"选中状态"] forState:UIControlStateNormal];
            DLog(@"选中的视频%ld",(long)index.row);
            if (self.listMutaArray) {
                 NSString *videoString = [self.listMutaArray objectAtIndex:index.row];
                [self.sumArr addObject:videoString];
                if ([self.delegate respondsToSelector:@selector(clickActionVideoDelegateArr:)]) {
                    [self.delegate clickActionVideoDelegateArr:self.listMutaArray];
                }
            }
        } else {
            [sender setImage:[UIImage imageNamed:@"未选中状态"] forState:UIControlStateNormal];
            if (self.sumArr) {
//                [self.sumArr removeObjectAtIndex:index.row];
                if ([self.delegate respondsToSelector:@selector(clickActionVideoDelegateArr:)]) {
                    [self.delegate clickActionVideoDelegateArr:self.sumArr];
                }
            }
        }
}

- (void)videoHorizontalTap:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellTapClick:)]) {
        [self.delegate cellTapClick:sender];
    }
    
}

- (NSMutableArray *)listMutaArray {
    if (!_listMutaArray) {
        _listMutaArray = [NSMutableArray array];
    }
    return _listMutaArray;
}

- (NSMutableArray *)sumArr {
    if (!_sumArr) {
        _sumArr = [NSMutableArray array];
    }
    return _sumArr;
}


@end
