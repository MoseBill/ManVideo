//
//  LZTabBarVC.m
//  WebViewTest
//
//  Created by Josee on 2019/3/4.
//  Copyright © 2019年 Josee. All rights reserved.
//

#import "LZTabBarVC.h"
#import "LZCustomTabbar.h"
#import "VDClassificationController.h"
#import "MessageViewController.h"
#import "MXNavigationBarManager.h"

#import "VDViewModel.h"

//#import "LoadDataListContainerViewController.h"

CGFloat TopY;

@interface LZTabBarVC ()
<UITabBarControllerDelegate>
{

}

@property(nonatomic,copy)NSString *imageString;
@property(nonatomic,assign)BOOL hideen;

@property(nonatomic,strong)VDClassificationController *vc2;
@property(nonatomic,strong)MessageViewController *vc3;
@property(nonatomic,strong)PersonalCenterVC *vc4;
//@property(nonatomic,strong)LoadDataListContainerViewController *vc5;
@property(nonatomic,strong)MARFaceBeautyVC *vc5;


@end

@implementation LZTabBarVC

- (void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 类的初始化方法，只有第一次使用类的时候会调用一次该方法
+ (void)initialize{
    //tabbar去掉顶部黑线
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"3E394B"
                                                                 alpha:0.3]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithHexString:@"3E394B"
                                                                    alpha:0.3]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playHidden:)
                                                 name:@"hiddenViewPhoto"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenView)
                                                 name:@"hiddenView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tokenPassAction)
                                                 name:@"tokenPass"
                                               object:nil];

    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];

//    [self regionalRestrictions];
     [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initBarManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MXNavigationBarManager reStoreToSystemNavigationBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    TopY = [LZCustomTabbar setTabBarUI:self.tabBar.subviews
                                tabBar:self.tabBar
                          topLineColor:[UIColor colorWithHexString:@""
                                                             alpha:0.28]
                       backgroundColor:self.tabBar.barTintColor];
}

- (void)initUI{

    self.delegate = self;
    UINavigationController *NC1 = [self addChildVc:self.homeVC
                                             title:NSLocalizedString(@"VDHomePage", nil)
                                             image:@"home_unselected"
                                     selectedImage:@"home_selected"];
    NC1.navigationBarHidden = YES;
    
//    UINavigationController *NC2 = [self addChildVc:self.vc2
//                                             title:NSLocalizedString(@"VDclassification", nil)
//                                             image:@"classification_unselected"
//                                     selectedImage:@"classification_selected"];

    UINavigationController *NC3 = [self addChildVc:self.vc5
                                             title:@""
                                             image:@"组 9"
                                     selectedImage:@"组 9"];

//    UINavigationController *NC4 = [self addChildVc:self.vc3
//                                              title:NSLocalizedString(@"VDmessage", nil)
//                                              image:@"message_unselected"
//                                      selectedImage:@"message_selected"];

    UINavigationController *NC5 = [self addChildVc:self.vc4
                                             title:NSLocalizedString(@"VDMine", nil)
                                             image:@"userCenter_unselected"
                                     selectedImage:@"userCenter_unselected"];

    self.viewControllers = @[NC1,
//                             NC2,
                             NC3,
//                             NC4,
                             NC5];
}

- (void)initBarManager {
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:kClearColor];
    //optional
    [MXNavigationBarManager setTintColor:kWhiteColor];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 添加子控制器  设置图片
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (UINavigationController *)addChildVc:(UIViewController *)childVc
                                 title:(NSString *)title
                                 image:(NSString *)image
                         selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色  system为系统字体
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"D0D1D2"],
                                                 NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}
                                      forState:UIControlStateNormal];
    //选中字体颜色
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}
                                      forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    return nav;
}
/**
 * 功能：禁止横屏
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark —— UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.title isEqualToString:@"分类"] ||
        [viewController.title isEqualToString:@"消息"]) {
        return NO;
    }return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    DLog(@"点击了第几个基础控制器 = %lu",(unsigned long)tabBarController.selectedIndex);
}

#pragma mark —— 通知方法
- (void)tokenPassAction {
    [self presentViewController:VDLoginViewController.new
                       animated:YES
                     completion:^{}];

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
//                                                   message:NSLocalizedString(@"VDtichu", nil)
//                                                  delegate:self
//                                         cancelButtonTitle:nil
//                                         otherButtonTitles:NSLocalizedString(@"VDDetermine", nil), nil];
//    [alert show];
}

- (void)hiddenView {
    //    self.animationView.hidden = YES;
    //    self.promptBtn.hidden = YES;
}

- (void)playHidden:(NSNotification *)noti {

    //    self.animationView.hidden = NO;
    //     self.promptBtn.hidden = NO;
}

#pragma mark —— lazyLoad
-(HomeVC *)homeVC{
    if (!_homeVC) {
        _homeVC = HomeVC.new;
    }return _homeVC;
}

-(VDClassificationController *)vc2{
    if (!_vc2) {
        _vc2 = VDClassificationController.new;
    }return _vc2;
}

-(MessageViewController *)vc3{
    if (!_vc3) {
        _vc3 = MessageViewController.new;
    }return _vc3;
}

-(PersonalCenterVC *)vc4{
    if (!_vc4) {
        _vc4 = PersonalCenterVC.new;
    }return _vc4;
}

-(MARFaceBeautyVC *)vc5{
    if (!_vc5) {
        _vc5 = MARFaceBeautyVC.new;
    }return _vc5;
}

//-(LoadDataListContainerViewController *)vc5{
//    if (!_vc5) {
//        _vc5 = LoadDataListContainerViewController.new;
//        _vc5.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
//    }return _vc5;
//}

#pragma mark —— 疑似废弃
//- (void)regionalRestrictions {
//
//    self.hideen = NO;
//    NSMutableDictionary *ipDic = [[NSMutableDictionary alloc]init];
//    //方法二，速度比较快
//    NSError *error;
//    NSURL *ipURL = [NSURL URLWithString:@"http://ifconfig.me/ip"];
//    NSString *ip = [NSString stringWithContentsOfURL:ipURL
//                                            encoding:NSUTF8StringEncoding
//                                               error:&error];
//    ipDic[@"ip"] = ip;
//    DLog(@"地域限制传参%@",ipDic);
//    [CMRequest requestNetSecurityGET:@"/member/listIp"
//                      paraDictionary:ipDic
//                        successBlock:^(NSDictionary * _Nonnull dict) {
//                            DLog(@"地区限制成功%@",dict);
//                            self.hideen = YES;
//                            [self initUI];
//
//                        } errorBlock:^(NSString * _Nonnull message) {
//                            self.hideen = NO;
//                            DLog(@"地区限制错误%@",message);
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
//                                                                           message:NSLocalizedString(@"VDjinzhichina", nil)
//                                                                          delegate:self
//                                                                 cancelButtonTitle:nil
//                                                                 otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
//                            [alert show];
//                        } failBlock:^(NSError * _Nonnull error) {
//                            self.hideen = NO;
//                            DLog(@"地区限制网络失败%@",error);
//                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
//                                                                           message:NSLocalizedString(@"VDNoNetwork", nil)
//                                                                          delegate:self
//                                                                 cancelButtonTitle:nil
//                                                                 otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
//                            [alert show];
//                        }];
//}

@end
