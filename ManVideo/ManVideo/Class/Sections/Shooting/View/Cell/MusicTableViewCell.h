//
//  MusicTableViewCell.h
//  Clipyeu ++
//
//  Created by Josee on 01/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MusicClickBtnDelegate <NSObject>

- (void)clickMusicPlayDeleagte:(NSString *)indexString;

@end

@interface MusicTableViewCell : UITableViewCell


@property (nonatomic, strong) id<MusicClickBtnDelegate> delegate;

@property (nonatomic, strong) NSString    *backString;

@end

NS_ASSUME_NONNULL_END
