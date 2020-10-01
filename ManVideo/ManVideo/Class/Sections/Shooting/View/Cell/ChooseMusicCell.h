//
//  ChooseMusicCell.h
//  ManVideo
//
//  Created by Josee on 21/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseMusicCell : UITableViewCell

@property (nonatomic, copy) void(^musicBtnBlock)(NSInteger index);

- (void)cellSelectClick:(UIButton *)click Indexpath:(NSInteger)index;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIButton *shootingBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLong;

@end

NS_ASSUME_NONNULL_END
