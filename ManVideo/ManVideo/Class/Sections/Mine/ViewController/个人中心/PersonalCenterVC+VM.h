//
//  PersonalCenterVC+VM.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/20.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "PersonalCenterVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalCenterVC (VM)

- (void)loadDataView_VM;
- (void)cancelFocusonNetWork;//取消关注
- (void)loadNetWorkFocusOn;//关注

@end

NS_ASSUME_NONNULL_END
