//
//  ViewForFooter.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewForFooter : UITableViewHeaderFooterView

- (instancetype)initWithRequestParams:(id)requestParams;

-(void)actionBlock:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
