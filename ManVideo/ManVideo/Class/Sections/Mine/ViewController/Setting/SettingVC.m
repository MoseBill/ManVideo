//
//  SettingViewController.m
//  Clipyeu ++
//
//  Created by Josee on 26/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "SettingVC.h"
#import "SettingVC+VM.h"
#import "KHTRealNameController.h"
#import "SettingTableCell.h"
#import "BlackListViewController.h"
#import "InviteFriendsController.h"
#import "AbountUsController.h"
#import "CacheTool.h"

extern LZTabBarVC *tabBarVC;

@interface SettingVC ()
<UITableViewDelegate
,UITableViewDataSource
,UIGestureRecognizerDelegate>
{
    CGFloat _dataValue;
    CGFloat _folderSize;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *valueDataLabel;
@property(weak,nonatomic)id<UIGestureRecognizerDelegate> restoreInteractivePopGestureDelegate;
@property(nonatomic,strong)UIButton *exitLogin;

@end

@implementation SettingVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    SettingVC *vc = [[SettingVC alloc] initWithRequestParams:requestParams
                                                     success:block];
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

- (instancetype)initWithRequestParams:(nullable id)requestParams
                              success:(DataBlock)block{
    if (self = [super init]) {
        self.requestParams = requestParams;
        self.successBlock = block;
        self.isPresent = YES;
        self.isPush = NO;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_navTitle =  NSLocalizedString(@"Setting", nil);
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
//        self.gk_navTitleView = self.titleView;

    _restoreInteractivePopGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.tableView.alpha = 1;
    self.exitLogin.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    tabBarVC.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = _restoreInteractivePopGestureDelegate;
    }
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)exitClickLogin:(UIButton *)sender {}

#pragma mark -UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}
#pragma mark —— UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f/667.0f*SCREEN_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"SettingTableCell"
                                                              forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"0F0920"];
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image.hidden = YES;
    if (indexPath.row == 0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"VDInviteText", nil);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
    } else if (indexPath.row == 1) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"VDAboutText", nil);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
    } else if (indexPath.row == 2) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"VDUpdatefunctionText", nil);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
    } else if (indexPath.row == 3) {
        cell.accessoryType= UITableViewCellAccessoryNone;
        cell.image.hidden = NO;
        cell.image.image = [UIImage imageNamed:@"facebook"];
        cell.textLabel.text = NSLocalizedString(@"VDlianxiFacebook", nil);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
    } else if (indexPath.row  ==  4) {
        cell.accessoryType= UITableViewCellAccessoryNone;
        cell.image.hidden = NO;
        cell.image.image = [UIImage imageNamed:@"zalo"];
        cell.textLabel.text = NSLocalizedString(@"VDZalo", nil);
        cell.textLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
    }  else  {
        cell.cleanLabel.hidden = NO;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = NSLocalizedString(@"VDClearText", nil);
        cell.mbLabel.text  = [NSString stringWithFormat:@"%.2fMB",[CacheTool cacheSize]];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
    } return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        InviteFriendsController *invite = [[InviteFriendsController alloc]init];
        [self.navigationController pushViewController:invite animated:YES];
    }  else if (indexPath.row == 1) {
        AbountUsController *about = [[AbountUsController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    } else if(indexPath.row == 2){

        [self hsUpdateApp];
    } else if (indexPath.row == 3) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/AppClipyeuCom/"]];
    } else if (indexPath.row ==  4) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://zaloapp.com/qr/p/1fhu9nyw03x6e"]];
    }   else  {
        [self deleteFileSize:[self folderSizeWithPath:nil]];
    }
}

- (void)deleteFileSize:(CGFloat)folderSize {
//    if (folderSize > 0.01){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                                       message:[NSString stringWithFormat:NSLocalizedString(@"VDCleanYES", nil),folderSize]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"VDCancelText", nil)
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction*action) {
        }]];
        @weakify(self)
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil)
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction*action) {
            @strongify(self)
            [CacheTool cleanCaches];
//            //彻底删除文件
//            [self clearCacheWith:[self getPath]];
            self.valueDataLabel.text = [NSString stringWithFormat:@"%.2fMB",[CacheTool cacheSize]];
            [self.tableView reloadData];
        }]];
    
        [self presentViewController:alert animated:YES
                         completion:nil];
        
//    }else{
    
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDTishi", nil) message:NSLocalizedString(@"VDAllClean", nil) preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"VDDetermine", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction*action) {
//
//            [self.tableView reloadData];
//        }]];
//
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

- (void)clearCacheWith:(NSString *)path {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]){
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray){
            //可以过滤掉特殊格式的文件
            if ([fileName hasSuffix:@".png"]){
                //                NSLog(@"不删除");
            }
            else{
                //获取每个子文件的路径
                NSString * filePath = [path stringByAppendingPathComponent:fileName];
                //移除指定路径下的文件
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
}

-(CGFloat)folderSizeWithPath:(NSString *)path {
    //初始化文件管理类
    NSFileManager * fileManager = [NSFileManager defaultManager];float folderSize = 0.0;
    if (path != nil) {

    if ([fileManager fileExistsAtPath:path]){
        //如果存在
        //计算文件的大小
        NSArray * fileArray = [fileManager subpathsAtPath:path];
        for (NSString * fileName in fileArray){
            //获取每个文件的路径
            NSString * filePath = [path stringByAppendingPathComponent:fileName];
            //计算每个子文件的大小
            long fileSize = [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
            //字节数
            folderSize = folderSize + fileSize / 1024.0 / 1024.0;
        }
        //删除缓存文件
        //        [self deleteFileSize:folderSize];
        return folderSize;
    }
        }
    return 0;
}

//首先获取缓存文件的路径
-(NSString *)getPath{
    //沙盒目录下library文件夹下的cache文件夹就是缓存文件夹
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   Height_NavBar+30,
                                                                   SCREEN_WIDTH,
                                                                   SCREEN_HEIGHT - Height_TabBar)
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
        [self.view addSubview:_tableView];
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"SettingTableCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"SettingTableCell"];
    }return _tableView;
}

-(UIButton *)exitLogin{
    if (!_exitLogin) {
        _exitLogin = UIButton.new;
        [_exitLogin setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
        [_exitLogin setTitleColor:kWhiteColor
                         forState:UIControlStateNormal];
        [_exitLogin addTarget:self
                       action:@selector(exitClickLogin:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exitLogin];

        [_exitLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableView.mas_bottom).offset(40/667.0f * SCREEN_HEIGHT);
             make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(44);
        }];
    }return _exitLogin;
}

@end
