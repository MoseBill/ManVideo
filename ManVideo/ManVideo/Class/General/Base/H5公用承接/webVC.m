//
//  webVC.m
//  ManVideo
//
//  Created by 刘赓 on 2019/8/15.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "webVC.h"
#import <WebKit/WebKit.h>

@interface webVC ()

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation webVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    webVC *vc = [[webVC alloc] initWithRequestParams:requestParams
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

-(instancetype)initWithRequestParams:(nullable id)requestParams
                             success:(DataBlock)block{
    if (self = [super init]) {
        self.requestParams = requestParams;
        self.successBlock = block;
    }return self;
}

#pragma mark —— lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.alpha = 1;
}

-(void)refreshAction:(UIButton *)sender{
     NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

#pragma mark —— lazyLoad
-(WKWebView *)webView{
    if (!_webView) {
        _webView = WKWebView.new;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.requestParams]];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _webView;
}


@end
