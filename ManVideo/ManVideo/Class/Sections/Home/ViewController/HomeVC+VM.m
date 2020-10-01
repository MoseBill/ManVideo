//
//  HomeVC+VM.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/24.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "HomeVC+VM.h"

@implementation HomeVC (VM)

-(void)addressBook{
    [CMRequest httpWithUrl:@"/addressList/save"
                      body:@{
                             @"addressListList":self.adressArr
                             }
                parameters:NSDictionary.dictionary
              successBlock:^(NSDictionary * _Nonnull dict) {

              } errorBlock:^(NSString * _Nonnull message) {

              } failBlock:^(NSError * _Nonnull error) {

              }];

//    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
//                                                           path:@"/addressList/save"
//                                                     parameters:@{
//                                                         @"addressListList":self.adressArr
//                                                     }];
//    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
////    @weakify(self)
//    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
////        @strongify(self)
//        if (response.isSuccess) {
//            NSLog(@"--%@",response.reqResult);
//
//        }
//    }];
}

@end
