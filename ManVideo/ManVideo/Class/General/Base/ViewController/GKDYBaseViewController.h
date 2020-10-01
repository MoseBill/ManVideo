//
//  GKDYBaseViewController.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "JXCategoryListContainerView.h"
#import "JXCategoryBaseView.h"
#import <GKNavigationBarViewController/GKNavigationBarViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKDYBaseViewController : GKNavigationBarViewController
<
UIGestureRecognizerDelegate
,UINavigationControllerDelegate
>

@property(nonatomic,strong)UIImageView *noNetImage;
@property(nonatomic,strong)UIButton *refreshBtn;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *nonetLabel;
@property(nonatomic,strong)UILabel *noContent;
@property(nonatomic,strong)RACSignal *reqSignal;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *password;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isPush;

@property(nonatomic,assign)BOOL isRequestFinish;//数据请求是否完毕
@property(nonatomic,copy)void (^UnknownNetWorking)(void);
@property(nonatomic,copy)void (^NotReachableNetWorking)(void);
@property(nonatomic,copy)void (^ReachableViaWWANNetWorking)(void);
@property(nonatomic,copy)void (^ReachableViaWiFiNetWorking)(void);

-(void)AFNReachability;
-(void)pushToSysConfig;
-(void)showLoginAlertView;
-(void)showAlertViewTitle:(NSString *)title
                  message:(NSString *)message
           alertBtnAction:(NSArray *)alertBtnActionArr;
                                    
@end

NS_ASSUME_NONNULL_END
