//
//  MessageViewController.m
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MessageViewController.h"
#import "MXNavigationBarManager.h"
#import "MessageTableViewCell.h"

#import "SSChatController.h"
#import "Define.h"
#import "UIView+SSAdd.h"
#import "SystemMessageController.h"
#import "RJBadgeKit.h"
#import "FourMessageController.h"

NSString *const DEMO_FANS_PATH = @"root.p365.test1";
NSString *const DEMO_LIKE_PATH = @"root.p365.test2";
NSString *const DEMO_Video_PATH = @"root.p365.test3";
NSString *const DEMO_COMMENT_PATH = @"root.p365.test4";

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView    *headerView;

@property (nonatomic, strong) UITableView    *tableV;

@property (nonatomic, strong)  UIView *tabView;

@property(nonatomic,strong)NSMutableArray *datas;
@property (nonatomic, strong) UILabel    *titleView;

@end

@implementation MessageViewController

- (instancetype)init{
    if(self = [super init]){
        _datas = [NSMutableArray new];
        [_datas addObjectsFromArray:@[@{@"image":@"touxiang1",
                                        @"title":@"系统通知",
                                        @"detail":@"王医生你好，我最近老感觉头晕乏力，是什么原因造成的呢？",
                                        @"sectionId":@"13540033103",
                                        @"type":@"1"
                                        },
                                      @{@"image":@"touxaing2",
                                        @"title":@"系统通知",
                                        @"detail":@"您好，可以给我发送一份你的体检报告吗？便于我了解情况，谁是给我打电话13540033104",
                                        @"sectionId":@"13540033104",
                                        @"type":@"1"
                                        }]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.titleView = [[UILabel alloc]init];
    self.titleView.text = NSLocalizedString(@"VDmessage", nil);
    
    self.titleView.textColor = kWhiteColor;
    self.gk_navTitle =  @"";
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    [RJBadgeController setBadgeForKeyPath:DEMO_FANS_PATH];
    [RJBadgeController setBadgeForKeyPath:DEMO_LIKE_PATH];
    [RJBadgeController setBadgeForKeyPath:DEMO_Video_PATH];
    [RJBadgeController setBadgeForKeyPath:DEMO_COMMENT_PATH];
    [self vd_addSubviews];
    [self vd_layoutNavigation];
    [self setupView];
//    [self performPassportRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [MXNavigationBarManager reStoreToSystemNavigationBar];
}

- (void)initBarManager {
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    //optional
    [MXNavigationBarManager setTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


    [self initBarManager];

}

- (void)vd_layoutNavigation {
}

- (void)vd_addSubviews {
//      self.view.frame = CGRectMake(0, Height_NavBar, SCREEN_WIDTH, SCREEN_HEIGHT+Height_TabBar);
    self.view.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(SCREEN_HEIGHT+Height_TabBar);

}

- (void)setupView {
    
     self.tabView = [UIView new];
     self.tabView.backgroundColor = [UIColor colorWithHexString:@"050013"];
    [self.view addSubview:self.tabView];
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        //         make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(Height_TabBar);
    }];
    self.headerView = [[UIView alloc]init];
    self.headerView.backgroundColor = [UIColor colorWithHexString:@"050013"];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableV];
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(Height_NavBar);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (IS_IPHONE_X ||
            IS_IPHONE_Xs_Max ||
            IS_IPHONE_Xr ||
            IS_IPHONE_Xs) {
         
            make.height.mas_equalTo(137);
        } else {
            make.height.mas_equalTo(100);
        }
       
    }];
 
    
    UIButton *fansBtn = [[UIButton alloc]init];
    [fansBtn setImage:[UIImage imageNamed:@"粉丝"] forState:UIControlStateNormal];
    [fansBtn addTarget:self action:@selector(fansAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:fansBtn];
    UIButton *likeBtn = [[UIButton alloc]init];
      [likeBtn setImage:[UIImage imageNamed:@"love1 拷贝"] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:likeBtn];
    UIButton *videoBtn = [[UIButton alloc]init];
      [videoBtn setImage:[UIImage imageNamed:@"video-1"] forState:UIControlStateNormal];
    [videoBtn addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:videoBtn];
    UIButton *commentBtn = [[UIButton alloc]init];
      [commentBtn setImage:[UIImage imageNamed:@"评 论"] forState:UIControlStateNormal];
    [commentBtn  addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:commentBtn];
    
    UILabel *fansLabel = [[UILabel alloc]init];
    fansLabel.text = NSLocalizedString(@"VDfansText", nil);
    fansLabel.textColor = [UIColor whiteColor];
    fansLabel.font = [UIFont systemFontOfSize:13.0f];
    fansLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:fansLabel];
    UILabel *likeLabel = [[UILabel alloc]init];
    likeLabel.text = NSLocalizedString(@"VDlikeText", nil);
     likeLabel.textColor = [UIColor whiteColor];
     likeLabel.textAlignment = NSTextAlignmentCenter;
    likeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:likeLabel];
    UILabel *videoLabel = [[UILabel alloc]init];
    videoLabel.text = NSLocalizedString(@"VDvideoText", nil);
    videoLabel.textColor = [UIColor whiteColor];
    videoLabel.textAlignment = NSTextAlignmentCenter;
    videoLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:videoLabel];
    UILabel *commentLabel = [[UILabel alloc]init];
    commentLabel.text = NSLocalizedString(@"VDcommentsText", nil);
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.textAlignment = NSTextAlignmentCenter;
    commentLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:commentLabel];
    
//    fansBtn.sd_layout.leftSpaceToView(self, 40).topSpaceToView(self, Height_NavBar+20).heightIs(44).widthIs(44);
//    likeBtn.sd_layout.leftSpaceToView(fansBtn, 40).centerYEqualToView(fansBtn).heightIs(44).widthIs(44);
//    videoBtn.sd_layout.leftSpaceToView(likeBtn, 40).centerYEqualToView(likeBtn).heightIs(44).widthIs(44);
//    commentBtn.frame = CGRectMake(292, 34, 44, 44);
    CGFloat heightAll = 0.0;
    if (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) {
        heightAll = IS_IPHONE_X || IS_IPHONE_Xs ? 812 : 896;
    } else if (kiPhone6Plus) {
        heightAll = 736.0f;
    } else {
        heightAll = kiPhone5 ? 568 : 667.0f;
    }
    [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(40/375.0f*SCREEN_WIDTH);
        make.top.mas_equalTo(20);
        
        make.height.mas_equalTo(44/667.0f*heightAll);
         make.width.mas_equalTo(44/375.0f*SCREEN_WIDTH);
    }];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(fansBtn.mas_right).offset(40/375.0f*SCREEN_WIDTH);
        make.centerY.mas_equalTo(fansBtn.mas_centerY);
        make.height.mas_equalTo(44/667.0f*heightAll);
         make.width.mas_equalTo(44/375.0f*SCREEN_WIDTH);
    }];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(likeBtn.mas_right).offset(40/375.0f*SCREEN_WIDTH);
        make.centerY.mas_equalTo(likeBtn.mas_centerY);
         make.width.mas_equalTo(44/375.0f*SCREEN_WIDTH);
         make.height.mas_equalTo(44/667.0f*heightAll);
    }];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(videoBtn.mas_right).offset(40/375.0f*SCREEN_WIDTH);
        make.centerY.mas_equalTo(videoBtn.mas_centerY);
         make.width.mas_equalTo(44/375.0f*SCREEN_WIDTH);
         make.height.mas_equalTo(44/667.0f*heightAll);
        make.right.mas_equalTo(-40/375.0f*SCREEN_WIDTH);
    }];

    [fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.left.mas_equalTo(46/375.0f*SCREEN_WIDTH);
        make.centerX.mas_equalTo(fansBtn.mas_centerX);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(fansBtn.mas_bottom).offset(8);
    }];

    [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(137/375.0f*SCREEN_WIDTH);
        make.centerX.mas_equalTo(likeBtn.mas_centerX);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(likeBtn.mas_bottom).offset(8);
    }];
    [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(215/375.0f*SCREEN_WIDTH);
        make.centerX.mas_equalTo(videoBtn.mas_centerX);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(videoBtn.mas_bottom).offset(8);
    }];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-40/375.0f*SCREEN_WIDTH);
        make.centerX.mas_equalTo(commentBtn.mas_centerX);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(commentBtn.mas_bottom).offset(8);
    }];
    
    [self.badgeController observePath:DEMO_FANS_PATH
                            badgeView:fansBtn
                                block:^(id observer, NSDictionary *info) {
                                    DLog(@"粉丝 => %@", info);
                                }];
    [self.badgeController observePath:DEMO_LIKE_PATH
                            badgeView:likeBtn
                                block:^(id observer, NSDictionary *info) {
                                    DLog(@"点赞 => %@", info);
                                }];
    [self.badgeController observePath:DEMO_Video_PATH
                            badgeView:videoBtn
                                block:^(id observer, NSDictionary *info) {
                                    DLog(@"视频 => %@", info);
                                }];
    [self.badgeController observePath:DEMO_COMMENT_PATH
                            badgeView:commentBtn
                                block:^(id observer, NSDictionary *info) {
                                    DLog(@"评论 => %@", info);
                                }];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

//  self.tableV.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 167).widthIs(SCREEN_WIDTH).heightIs(SCREEN_HEIGHT+Height_TabBar);
    
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(-Height_TabBar);
        
    }];
    
}

#pragma mark ===================== 系统协议===================================
/**
 *  告诉tableView一共有多少组数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
 *  告诉tableView第section组有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

/**
 *  告诉tableView第indexPath行显示怎样的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
    // 2.覆盖数据
//    cell.textLabel.text = [NSString stringWithFormat:@"cell - %zd", indexPath.row];
  
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    if (indexPath.row == 0) {
        NSString *row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageNotification" object:row];
        SystemMessageController *message = [[SystemMessageController alloc]init];
        
        [self.navigationController pushViewController:message animated:YES];
    }
    
//    else {
//        self.hidesBottomBarWhenPushed = YES;
//        SSChatController *vc = [SSChatController new];
//        vc.chatType = (SSChatConversationType)[_datas[indexPath.row][@"type"]integerValue];
//        vc.sessionId = _datas[indexPath.row][@"sectionId"];
//        vc.titleString = _datas[indexPath.row][@"title"];
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//    }
    

}

#pragma mark ===================== 懒加载===================================

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [UITableView new];
        _tableV.delegate=self;
        _tableV.dataSource=self;
        _tableV.backgroundColor = [UIColor colorWithHexString:@"050013"];//设置背景颜色
//        _tableV.separatorColor = [UIColor colorWithHexString:@""];//设置线的颜色
       _tableV.separatorStyle = UITableViewCellAccessoryNone;
        [_tableV registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
    }
    return _tableV;
}

#pragma mark ===================== 点击事件===================================

- (void)fansAction:(UIButton *)sender {
    
    [RJBadgeController clearBadgeForKeyPath:DEMO_FANS_PATH];
    FourMessageController *four = [[FourMessageController alloc]init];
    four.typeString = NSLocalizedString(@"VDfansText", nil);
    [self.navigationController pushViewController:four animated:YES];
    
}

- (void)likeAction:(UIButton *)sender {
    [RJBadgeController clearBadgeForKeyPath:DEMO_LIKE_PATH];
    FourMessageController *four = [[FourMessageController alloc]init];
      four.typeString = NSLocalizedString(@"VDlikeText", nil);
    [self.navigationController pushViewController:four animated:YES];
}

- (void)videoAction:(UIButton *)sender {
     [RJBadgeController clearBadgeForKeyPath:DEMO_Video_PATH];
    FourMessageController *four = [[FourMessageController alloc]init];
      four.typeString = NSLocalizedString(@"VDShare", nil);
    [self.navigationController pushViewController:four animated:YES];
}

- (void)commentBtnAction:(UIButton *)sender {
    [RJBadgeController clearBadgeForKeyPath:DEMO_COMMENT_PATH];
    FourMessageController *four = [[FourMessageController alloc]init];
      four.typeString = NSLocalizedString(@"VDcommentsText", nil);
    [self.navigationController pushViewController:four animated:YES];
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

@end
