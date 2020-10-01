//
//  VDHotViewController.m
//  iOSMovie
//
//  Created by Josee on 11/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDHotViewController.h"
#import "DetailViewController.h"


@interface VDHotViewController ()

@end

@implementation VDHotViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//  
//    
//}
- (void)vd_addSubviews {
      self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    UIButton *test = [[UIButton alloc]initWithFrame:CGRectMake(100, 400, 100, 100)];
    [test setTitle:@"测试按钮" forState:UIControlStateNormal];
    [test setTitleColor:red_color forState:UIControlStateNormal];
    test.backgroundColor = red_color;
    [test addTarget:self action:@selector(testBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
}

- (void)testBtnClick:(UIButton *)btn {

    UIViewController *peopleInfo=[[CTMediator sharedInstance] yt_mediator_DetailViewControllerWithParams:@{}];

    [self.navigationController pushViewController:peopleInfo animated:YES];

}

@end
