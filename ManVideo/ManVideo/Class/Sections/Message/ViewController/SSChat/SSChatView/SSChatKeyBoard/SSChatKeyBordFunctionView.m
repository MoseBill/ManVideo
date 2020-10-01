//
//  SSChatKeyBordFunctionView.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatKeyBordFunctionView.h"
#import "SSChatController.h"
#import "VDHorizontalScrollView.h"
#import "VideoChooseCell.h"
#import "SSChatKeyBoardInputView.h"

@interface SSChatKeyBordFunctionView ()<CDHorizontalScrollViewDelegate,SSChatKeyBoardInputViewDelegate>

@property (nonatomic, strong) VDHorizontalScrollView *horizontalScrollView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) int page; // 页数
@property (nonatomic,strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray * articIdArr;
@property (nonatomic, strong) UIButton    *sendBtn;
@property (nonatomic, strong) UIButton    *photoBtn;

@property (nonatomic, strong) SSChatKeyBordFunctionView    *keyBord;

@property (nonatomic, strong) NSMutableArray    *selectedArr;

@end

@implementation SSChatKeyBordFunctionView {
    NSArray *titles,*images;
    NSInteger count;
    NSInteger number;
    UIView  *backView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
     
        self.backgroundColor = [UIColor colorWithHexString:@"050013"];
        self.horizontalScrollView.collectionView.alwaysBounceVertical = NO;
      
//        self.userInteractionEnabled = YES;
        [self setupView];
//        /注册通知(接收,监听,一个通知)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSum:) name:@"sumNotification" object:nil];
        self.articIdArr = [[NSMutableArray alloc]initWithObjects:@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png",@"http://www.baidu.com/image.png", nil];
    }
    return self;
}

- (void)showAlertViewinSuperView:(UIView *)superView{
    
    [superView addSubview: self];
}

- (void)setupView {
    
    count = 8;
    //添加功能只需要在标题和图片数组里面直接添加就行
    titles = @[@"照片",@"",@"",@"发送"];
    NSInteger number = titles.count/count+1;
    _mScrollView = [UIScrollView new];
    _mScrollView.frame = self.bounds;
    _mScrollView.centerY = self.height * 0.5;
    _mScrollView.backgroundColor = SSChatCellColor;
    _mScrollView.pagingEnabled = YES;
    _mScrollView.delegate = self;
    _mScrollView.userInteractionEnabled = YES;
    [self addSubview:_mScrollView];

    _mScrollView.maximumZoomScale = 2.0;
    _mScrollView.minimumZoomScale = 0.5;
    _mScrollView.canCancelContentTouches = NO;
    _mScrollView.delaysContentTouches = YES;
    _mScrollView.showsVerticalScrollIndicator = FALSE;
    _mScrollView.showsHorizontalScrollIndicator = FALSE;
    _mScrollView.backgroundColor = [UIColor colorWithHexString:@"151023"];
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH *number, self.height);

   
    _pageControll = [[UIPageControl alloc] init];
    _pageControll.bounds = CGRectMake(0, 0, 160, 30);
    _pageControll.centerX  = SCREEN_WIDTH * 0.5;
    _pageControll.top = SCREEN_HEIGHT - 50;
    _pageControll.numberOfPages = number;
    _pageControll.currentPage = 0;
    _pageControll.currentPageIndicatorTintColor = [UIColor grayColor];
    _pageControll.pageIndicatorTintColor = BackGroundColor;
    _pageControll.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControll];
    
    for(NSInteger i=0; i<number; ++i) {
        
        backView = [UIView new];
        backView.userInteractionEnabled = YES;
        backView.frame = CGRectMake(0, 160, SCREEN_WIDTH, self.height);
        backView.top = 160;
        backView.backgroundColor = [UIColor clearColor];
        backView.hidden = NO;
        [_mScrollView addSubview:backView];
       
        for(NSInteger j= (i * count); j<(i+1)*count && j<titles.count; ++j) {
            
            UIView *btnView = [UIView new];
            btnView.bounds = CGRectMake(0, -10, backView.width/4, backView.height*0.5);
            btnView.tag = 10+j;
            btnView.left = j%4 * btnView.width;
            btnView.top = j/4*btnView.height;
            [backView addSubview:btnView];
            btnView.tag = 10+j;
            btnView.backgroundColor = [UIColor clearColor];
            if(btnView.top>btnView.height)btnView.top = 0;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.bounds = CGRectMake(0, 0, 50, 24);
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 5.0f;
            btn.top = 15;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.centerX = btnView.width*0.5;
            [btnView addSubview:btn];
            [btn setTitle:titles[j] forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
            if (j == 0) {
                btnView.left = 0;
                [btn setTitleColor:[UIColor colorWithHexString:@"F72067"]
                          forState:UIControlStateNormal];
            }
            if (j == 3) {
                btn.backgroundColor = [UIColor colorWithHexString:@"007AFF"];
            }
            UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(footerGestureClick:)];
            [btnView addGestureRecognizer:gesture];
        }
    }
    self.horizontalScrollView.userInteractionEnabled = YES;
    //上传聊天视频
    self.horizontalScrollView.hidden = YES;
    [kAPPWindow addSubview:self.horizontalScrollView];
    [self.horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(200*SCREEN_HEIGHT/(IPhoneX ? 812 : (kiPhone5 ?  568 : 667)));
        make.bottom.mas_equalTo(-Height_TabBar+10);
    }];
    
  
}

- (void)TestAction:(UIButton *)action {
    
    DLog(@"点击上传视频");
}
- (void)notificationSum:(NSNotification *)noti {
    NSString *clickString = [noti object];
    if ([clickString isEqualToString:@"0"]) {
        self.horizontalScrollView.hidden = NO;
    } else {
        self.horizontalScrollView.hidden = YES;
    }
}
//多功能点击10+
- (void)footerGestureClick:(UITapGestureRecognizer *)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(SSChatKeyBordFunctionViewBtnClick:)]){
        [_delegate SSChatKeyBordFunctionViewBtnClick:sender.view.tag];
    }
    
}

#pragma mark ===================== 通知===================================
#pragma mark - CDHorizontalScrollViewDelegate
- (NSArray *)numberOfColumnsInCollectionView:(VDHorizontalScrollView *)collectionView {
    if (self.dataArr) {
        return self.dataArr;
    } else {
        return @[@"",@"",@"",@"",@""];
    }
}
//上左下右
- (UIEdgeInsets)collectionViewInsetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
//每个item之间的间距
- (CGFloat)collectionViewMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

- (void)didselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"选中%@", @(indexPath.row));
 
}
- (void)cellTapClick:(UITapGestureRecognizer *)tap {
    
    DLog(@"点击上传视频%ld",(long)tap.view.tag);
}
#pragma mark - setter getter
- (VDHorizontalScrollView *)horizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[VDHorizontalScrollView alloc] initWithFrame: CGRectMake(0,0, SCREEN_WIDTH,200*SCREEN_HEIGHT/(IPhoneX ? 812 : (kiPhone5 ? 568 : 667))) withClassCell:[VideoChooseCell class] isNib: YES withDelegate:self];
        _horizontalScrollView.articleArr = self.articIdArr;
    }
    return _horizontalScrollView;
}
#pragma mark ===================== 刷新数据 ==================================
- (void)exampleRefresh
{
    __weak __typeof(self) weakSelf = self;
    // 下拉刷新
    self.horizontalScrollView.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf.horizontalScrollView reloadData];
        // 结束刷新
        [weakSelf.horizontalScrollView.collectionView.mj_header endRefreshing];
    }];
    [ self.horizontalScrollView.collectionView.mj_header beginRefreshing];
    // 上拉刷新
    self.horizontalScrollView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [weakSelf.horizontalScrollView reloadData];
        // 结束刷新
        [weakSelf.horizontalScrollView.collectionView.mj_footer endRefreshing];
    }];
    // 默认先隐藏footer
    self.horizontalScrollView.collectionView.mj_footer.hidden = YES;
}

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (NSMutableArray *)articIdArr {
    
    if (!_articIdArr) {
        _articIdArr = [NSMutableArray new];
    }
    return _articIdArr;
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}


- (void)photoAction:(UIButton *)sender {
   
    
}

- (void)sendAction:(UIButton *)sender {
    
    
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
