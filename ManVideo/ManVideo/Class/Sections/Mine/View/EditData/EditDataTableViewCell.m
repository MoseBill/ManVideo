//
//  EditDataTableViewCell.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "EditDataTableViewCell.h"

@interface EditDataTableViewCell ()
<UITextViewDelegate,
UITextFieldDelegate>

@end

@implementation EditDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.titleLabel.alpha = 1;
        self.contentLabel.alpha = 1;
        self.nameTextField.alpha = 1;
        self.textView.alpha = 1;
    }return self;
}

-(void)setUserModel:(GKDYPersonalModel *)userModel{
    _userModel = userModel;
    if (_userModel) {
        NSString *str = (NSString *)_userModel.agentAcct;
        self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/30",str.length];
    }
}

#pragma mark —— lazyLoad
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.text = NSLocalizedString(@"VDnicknameText", nil);
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:_titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(14);
            make.height.mas_equalTo(16);
            make.centerY.mas_equalTo(self);
        }];
    }return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.new;
//        _contentLabel.text = NSLocalizedString(@"VDyourgenderText", nil);
        _contentLabel.textColor = [UIColor colorWithHexString:@"9C9C9D"];
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(21);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.height.mas_equalTo(14);
        }];
    }return _contentLabel;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = UITextField.new;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VDenternicknameText", nil)
                                                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                                                                                NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0
                                                                                                                                                green:156/255.0
                                                                                                                                                 blue:157/255.0
                                                                                                                                                alpha:1.0]}];
        _nameTextField.attributedPlaceholder = string;
        _nameTextField.textAlignment = NSTextAlignmentLeft;
        _nameTextField.textColor = kWhiteColor;
        _nameTextField.delegate = self;
        [self.contentView addSubview:_nameTextField];
        [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(21);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.height.mas_equalTo(20);
        }];
    }return _nameTextField;
}

- (JGPlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [[JGPlaceholderTextView alloc]initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.frame.size.width - 40 * SCREEN_WIDTH / 375.f,
                                                                           100 * SCREEN_HEIGHT/HEIGHT_SCREEN)];
        _textView.backgroundColor = kClearColor;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = kWhiteColor;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.placeholderColor = [UIColor colorWithHexString:@"9C9C9D"];
        _textView.placeholder = NSLocalizedString(@"VDsayText", nil);
        [self.contentView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(21);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(0);
        }];
    }return _textView;
}

-(UILabel *)wordCountLabel{
    if (!_wordCountLabel) {
        _wordCountLabel = UILabel.new;
        _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
        _wordCountLabel.textColor = [UIColor lightGrayColor];
        _wordCountLabel.text = [NSString stringWithFormat:@"0/30"];
        _wordCountLabel.backgroundColor = kClearColor;
        _wordCountLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_wordCountLabel];
        [_wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(44);
            make.height.mas_equalTo(15);
        }];
    }return _wordCountLabel;
}

#pragma mark —— UITextFieldDelegate
//询问委托人是否应该在指定的文本字段中开始编辑
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;

//告诉委托人在指定的文本字段中开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

//询问委托人是否应在指定的文本字段中停止编辑
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;

//告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    if (textField == self.nameTextField) {
        if (self.nameTextFieldBlock) {
            self.nameTextFieldBlock(textField.text);
        }
    }
}

//告诉委托人对指定的文本字段停止编辑
//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason;

//询问委托人是否应该更改指定的文本
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

//询问委托人是否应删除文本字段的当前内容
//- (BOOL)textFieldShouldClear:(UITextField *)textField;

//询问委托人文本字段是否应处理按下返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

#pragma mark —— UITextViewDelegate
//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView{
//    NSLog(@"textView.text = %@",textView.text);
    self.wordCountLabel.text = [NSString stringWithFormat:@"%lu/30",textView.text.length];
    [self wordLimit:textView];
    if ([self.delegate respondsToSelector:@selector(textFieldDelegateText:)]) {
        [self.delegate textFieldDelegateText:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    return textView.text.length + (text.length - range.length) <= 30;
}

#pragma mark —— 超过30字不能输入
- (BOOL)wordLimit:(UITextView *)text {
    if (text == self.textView) {
        if (_textView.text.length > 30) {
            UITextRange *markedRange = [_textView markedTextRange];
            if (markedRange) return -1;
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [_textView.text rangeOfComposedCharacterSequenceAtIndex:30];
            _textView.text = [_textView.text substringToIndex:range.location];
        }
    }return nil;
}


@end
