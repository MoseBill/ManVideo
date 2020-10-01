//
//  RecommendedController.h
//  Clipyeu ++
//
//  Created by Josee on 19/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HiddenViewDelegate <NSObject>

- (void)hiddenView:(NSString *_Nullable)viewString;

- (void)changePlayStatus:(NSString *_Nullable)status;

@end
NS_ASSUME_NONNULL_BEGIN

@interface RecommendedController : UIView

@property (nonatomic, strong) id<HiddenViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
