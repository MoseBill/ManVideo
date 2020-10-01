//
//  CDHorizontalScrollView.m
//  CDProgramme
//
//  Created by cqz on 2018/8/2.
//  Copyright © 2018年 ChangDao. All rights reserved.
//

#import "CDHorizontalScrollView.h"
#import "CDHorizontalScrollCell.h"
#import "TCSCollectionViewCell.h"
#import "ClassModel.h"
//#import "MiddleViewController.h"

// 任务block
typedef void(^RunloopBlock)(void);

@interface CDHorizontalScrollView ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isNib;
@property (nonatomic, strong) Class cellClass;

// 最大任务数
@property (nonatomic, assign) NSUInteger maxTaskCount;

@property (nonatomic, strong) NSMutableArray *tasks;

@property (nonatomic, weak) id<CDHorizontalScrollViewDelegate> scrollViewDelegate;
@end

@implementation CDHorizontalScrollView

- (instancetype)initWithFrame:(CGRect)frame withClassCell:(Class)classCell isNib:(BOOL)isNib withDelegate:(id<CDHorizontalScrollViewDelegate>)deleagte {
    
    if (self = [super initWithFrame:frame]) {
        
      
        self.cellClass = classCell;
        self.scrollViewDelegate = deleagte;
        self.isNib = isNib;
        [self setupView];
    }
    return self;
}


#pragma mark - Intial Methods
- (void)setupView {
     _tasks = [NSMutableArray array];
    [self addSubview:self.collectionView];
    [self addRunloopObserver];
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
    
    return self.listMutaArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    TCSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass) forIndexPath:indexPath];
    cell.likeBtn.tag = 300+indexPath.row;
    cell.collectionBtn.tag = 200+indexPath.row;
    cell.backgroundColor = kClearColor;
 
    NSArray  *classArr = [ClassModel mj_objectArrayWithKeyValuesArray:self.listMutaArray];
    @weakify(self)
    for (int i = 0; i < classArr.count; i++) {
        ClassModel *model = classArr[i];
//         cell.model = self.listMutaArray[indexPath.row];
        cell.model = model;
         DLog(@"列表数据%@",model);
    }
    [self addtask:^{
        [cell taskImageToCell:cell andTag:indexPath];
    }];
    __weak typeof(self) weakself = self;
//    cell.likeBtnBlock = ^(UIButton * _Nonnull btn) {
////        JMLog(@"打印了点赞%ld",btn.tag);
//    };
    cell.collectionBtnBlock = ^(UIButton * _Nonnull btn) {
        btn.selected = !btn.selected;
        if (btn.selected) {
             [weakself collectionNetwork:indexPath];
            [btn setImage:[UIImage imageNamed:@"icon_like-red"] forState:UIControlStateSelected];
           
        } else {
             [btn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
            [weakself cancelCollectionIndex:indexPath];
        }
    };
    

    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CDHorizontalScrollCell *horizonCell = (CDHorizontalScrollCell *)cell;
    if (indexPath.row < [self.listMutaArray count]) {
        horizonCell.obj = self.listMutaArray[indexPath.row];
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

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return [self.scrollViewDelegate cellSizeForItemAtIndexPath:indexPath];
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/3-5, 170);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 12/375.0f*SCREEN_WIDTH, 0, 0);
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
//        _collectionView.showsVerticalScrollIndicator = false;
//        _collectionView.allowsMultipleSelection = true;
        //水平方向滑动
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
//        _collectionView.bounces = false;
       
        _collectionView.backgroundColor = kClearColor;
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
//
//- (void)cancelNetWork:(NSIndexPath *)indexWork {
//    
//     JMLog(@"有没有ID%ld",(long)indexWork.row);
//    NetWorkManager *netWork = [[NetWorkManager alloc]init];
//
//    NSDictionary *dic = @{@"articleId":[NSString stringWithFormat:@"%@", self.articleArr[indexWork.row]],@"flag":@"1"};
//    WS(weakSelf)
//    //    @weakify(self);
//    
//    [netWork requestNetworkUrl:@"/bbs/article/clickPraise" paraDict:dic successBlock:^(NSDictionary *dict) {
//        
//        
//    } errorBlock:^(NSString *message) {
//        
//     [SVProgressHUD showErrorWithStatus:@"已取消点赞"];
//        
//    } failBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
//    }];
//    
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
//
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

- (NSMutableArray *)listMutaArray {
    if (!_listMutaArray) {
        _listMutaArray = [NSMutableArray array];
    }
    return _listMutaArray;
}
#pragma mark ===================== 图片优化===================================
#pragma mark - <关于Runloop的>
// 添加任务的方法
- (void)addtask:(RunloopBlock)block{
    [self.tasks addObject:block];
    // 为了保证屏幕以外的图片不用渲染,超出最大显示数量的图片时
    if (self.tasks.count > 4) {
//                [self.tasks removeObjectAtIndex:0];
    }
    
}

// 添加观察者
- (void)addRunloopObserver{
    //拿到当前Runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    //定义观察者
    static CFRunLoopObserverRef runloopObserver;
    
    // 创建上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self, //在会调用中获取到self
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &context);
    
    // 添加到当前的Runloop中,使用kCFRunLoopCommonModes模式可以在拖动时渲染
    CFRunLoopAddObserver(runloop, runloopObserver, kCFRunLoopCommonModes);
    
    CFRelease(runloopObserver);
    
}

static void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    // 在这个函数里self不能用，需要用context转换一下，info就是控制器，从context传过来的
    CDHorizontalScrollView *vc = (__bridge CDHorizontalScrollView *)info;
    // NSLog(@"来了%zd",vc.tasks.count);
    if (vc.tasks.count) {
        // 从数组中获取任务
        RunloopBlock lockRun = vc.tasks.firstObject;
        // 执行任务
        lockRun();
        // 干掉数组中完成的任务
        [vc.tasks removeObjectAtIndex:0];
    }
    
}


@end
