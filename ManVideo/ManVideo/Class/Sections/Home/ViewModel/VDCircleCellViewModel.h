//
//  VDCircleCellViewModel.h
//  iOSMovie
//
//  Created by Josee on 10/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VDCircleCellViewModel : VDViewModel

@property (nonatomic, copy) NSString *headerImageStr;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *articleNum;

@property (nonatomic, copy) NSString *peopleNum;

@property (nonatomic, copy) NSString *topicNum;

@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
