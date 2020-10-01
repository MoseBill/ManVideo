//
//  EditDataTableViewCell.h
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGPlaceholderTextView.h"

#import "GKDYPersonalModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditDataTextFieldDlegate <NSObject>

- (void)textFieldDelegateText:(NSString *)text;

@end

@interface EditDataTableViewCell : UITableViewCell

@property(nonatomic,strong)id<EditDataTextFieldDlegate> delegate;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)JGPlaceholderTextView *textView;
//@property(nonatomic,strong)UITextField *nameEdit;

//字数的限制
@property(nonatomic,strong)UILabel *wordCountLabel;
@property(nonatomic,copy)void(^nameTextFieldBlock)(NSString *nameString);
@property(nonatomic,strong)GKDYPersonalModel *userModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;



@end

NS_ASSUME_NONNULL_END
