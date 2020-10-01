//
//  VDCircleListViewModel.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VDCircleListViewModel : VDViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshUI;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

//@property (nonatomic, strong) LSCircleListHeaderViewModel *listHeaderViewModel;
//
//@property (nonatomic, strong) LSCircleListSectionHeaderViewModel *sectionHeaderViewModel;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end

NS_ASSUME_NONNULL_END
