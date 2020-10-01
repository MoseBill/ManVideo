//
//  ViewForHeader.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewForHeader : UITableViewHeaderFooterView

@property(nonatomic,strong)UILabel *header;

-(void)actionBlock:(DataBlock)block;

- (instancetype)initWithRequestParams:(id)requestParams;

@end

NS_ASSUME_NONNULL_END
