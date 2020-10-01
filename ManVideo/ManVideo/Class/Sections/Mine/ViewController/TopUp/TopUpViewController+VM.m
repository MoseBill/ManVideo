//
//  TopUpViewController+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/10/10.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "TopUpViewController+VM.h"

@implementation TopUpViewController (VM)

-(void)netWorking{

    if(self.iphoneString && self.codeString){
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_GET
                                                               path:@"/videoUploading/bankCard"
                                                         parameters:@{
                                                             @"status":@"2",
                                                             @"phone":self.iphoneString,
                                                             @"money":[self.integralString stringByReplacingOccurrencesOfString:@"." withString:@","],
                                                             @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                                             @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
                                                         }
                              ];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            if (response.isSuccess) {
                NSLog(@"--%@",response.reqResult);
                self.cashSuccess.type = NSLocalizedString(@"VDphoneText", nil);
                [self.navigationController pushViewController:self.cashSuccess
                                                     animated:YES];
            }
        }];
    }else{
        BaseUrl;
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDComplete", nil)];
    }
}



@end
