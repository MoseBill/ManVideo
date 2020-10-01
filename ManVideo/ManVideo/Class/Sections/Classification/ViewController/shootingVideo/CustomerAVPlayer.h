//
//  CustomerAVPlayer.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/17.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomerAVPlayer : UIView

@property(nonatomic,copy)DataBlock block;

-(void)play;
-(void)stop;
-(instancetype)initWithURL:(NSURL *)movieURL;
-(void)actionBlock:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
