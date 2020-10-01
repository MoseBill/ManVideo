//
//  AppDelegate.m
//  ManVideo
//
//  Created by Josee on 12/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+VM.h"
#import "SocketRocketUtility.h"

LZTabBarVC *tabBarVC;
UINavigationController *rootVC;

@interface AppDelegate ()

@property(nonatomic,strong)LZTabBarVC *tbc;
@property(nonatomic,copy)NSString *ipStr;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    [VideoHandleTool clearCacheWithFilePath:path];
    [self login];//登录
//    [self ADnetworking];//广告
    [self hsUpdateApp];//App更新检测
    [self getImei];//获取imei码
    [self Socket];//长链接
//    [self setKeyBoard];

    //小红点
//    UITabBarItem *more = self.tbc.tabBar.items[3];
//    NSString *demoPath = @"root.pbdemo";
//    [RJBadgeController setBadgeForKeyPath:demoPath];
//    [self.badgeController observePath:demoPath
//                            badgeView:more
//                                block:nil];

    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:self.tbc];
    rootVC = (UINavigationController *)self.window.rootViewController;
    rootVC.navigationBarHidden = YES;
//    self.tbc.homeVC.scrollLabelView.scrollTitle = @"12345";//测试用
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}
#pragma mark —— 长链接相关
-(void)NSNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SRWebSocketDidOpen)
                                                 name:kWebSocketDidOpenNote
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SRWebSocketDidReceiveMsg:)
                                                 name:kWebSocketDidCloseNote
                                               object:nil];
}
#pragma mark —— Socket
-(void)Socket{
    //获取ip的
    NSString *successScoket = [NSString stringWithFormat:@"%@?token=%@&userName=%@&imei=%@",scoketUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],UDID];
    DLog(@"长链接参数%@",successScoket);
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:successScoket];
    [self NSNotification];
}

- (void)SRWebSocketDidOpen {
    DLog(@"开启成功");
    //在成功后需要做的操作。。。
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSLog(@"通知的长链接参数:%@",note.object);
    self.tbc.homeVC.scrollLabelView.scrollTitle = note.object;
    DLog(@"收到服务端的信息%@",note.object);
}

- (void)setKeyBoard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}
#pragma mark —— lazyLoad
-(LZTabBarVC *)tbc{
    if (!_tbc) {
        _tbc = LZTabBarVC.new;
        tabBarVC = _tbc;
    }return _tbc;
}

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = NSDateFormatter.new;
        [_formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }return _formatter;
}

-(UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = kWhiteColor;
    }return _window;
}

@end
