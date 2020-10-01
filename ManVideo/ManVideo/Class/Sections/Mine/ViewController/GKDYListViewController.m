//
//  GKDYListViewController.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYListViewController.h"
#import "GKDYListCollectionViewCell.h"
//#import "GKDYPlayerViewController.h"
#import "ZFDouYinViewController.h"

@interface GKDYListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, strong) NSArray           *videos;

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) BOOL              isRefresh;

@end

@implementation GKDYListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_navigationBar.hidden = YES;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟刷新，获取本地数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"video1" ofType:@"json"];
            
            NSData *jsonData = [NSData dataWithContentsOfFile:videoPath];
            NSDictionary *dic;
            if (jsonData) {
                dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            }
            NSArray *videoList = dic[@"data"][@"video_list"];
            NSMutableArray *array = [NSMutableArray new];
            for (NSDictionary *dict in videoList) {
                GKDYVideoModel *model = [GKDYVideoModel yy_modelWithDictionary:dict];
                [array addObject:model];
            }
            self.isRefresh = YES;
            self.videos = array;
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        });
    }];
}

- (void)refreshData {
    if (self.isRefresh) return;
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GKDYListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GKDYListCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.videos[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFDouYinViewController *douYinVC = [[ZFDouYinViewController alloc] init];
    douYinVC.videosArr = self.videos;
    [douYinVC playTheIndex:indexPath.item];
    douYinVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:douYinVC animated:YES];
    // 这样back回来的时候，tabBar会恢复正常显示
    self.hidesBottomBarWhenPushed = NO;
   
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ? : self.scrollCallback(scrollView);
}

#pragma mark - GKPageListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
//        CGFloat width = (SCREEN_WIDTH - 2) / 3;
//        CGFloat height = width * 16 / 9;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(120/375.0f*SCREEN_WIDTH, 170/667.0f*SCREEN_HEIGHT);
        layout.minimumLineSpacing = 10.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        [_collectionView registerClass:[GKDYListCollectionViewCell class] forCellWithReuseIdentifier:@"GKDYListCollectionViewCell"];
    }
    return _collectionView;
}

@end
