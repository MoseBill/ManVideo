//
//  ChooseMusicTableViewCell.m
//  ManVideo
//
//  Created by Josee on 20/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChooseMusicTableViewCell.h"
#import "UIControl+controlButton.h"
#import "LoadDataListContainerListViewController.h"

@interface ChooseMusicTableViewCell ()

@property (nonatomic, assign) BOOL isSelect;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameMusic;
@property (weak, nonatomic) IBOutlet UILabel *autherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLong;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shootingBtn;
//@property (nonatomic, strong) UIButton    *shootingBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *cellBtn;

@property (nonatomic, assign) NSInteger    indexRow;

@end
@implementation ChooseMusicTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
    [self setView];
}
- (void)setView {
    self.backgroundColor = [UIColor colorWithHexString:@"1A142D"];
    //注册通知：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicClick:) name:@"musicClick" object:nil];
    self.headerImage.image = [UIImage imageNamed:@"huazai"];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 15.0f/667.0f*SCREEN_HEIGHT;
    
    [self.likeBtn setImage:[UIImage imageNamed:@"形状 3"] forState:UIControlStateNormal];
    
    self.shootingBtn.layer.masksToBounds = YES;
    self.shootingBtn.layer.cornerRadius = 10.0f;
//    self.shootingBtn.hidden = YES;
//    self.cellBtn addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>
    
    
    [self.contentView addSubview:self.shootingBtn];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)updateConstraints {

//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(10);
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//        [self.shootingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    
//            make.top.mas_equalTo(self.cellBtn.mas_bottom).offset(18);
//            make.left.mas_equalTo(13);
//            make.right.mas_equalTo(-13);
//        }];
    
    [super updateConstraints];
}
//- (void)layoutSubviews {
//
//}

- (void)musicClick:(NSNotification *)noti {
    
}

- (IBAction)likeBtn:(UIButton *)sender {
 
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"形状 5"] forState:UIControlStateNormal];
    } else {
          [sender setImage:[UIImage imageNamed:@"形状 3"] forState:UIControlStateNormal];
    }
}

- (void)cellSelectClick:(UIButton *)click Indexpath:(NSInteger)index {
    click.selected = !click.selected;
    if (click.selected) {
        if (self.musicBtnBlock) {
            self.musicBtnBlock(index);
        }
        self.shootingBtn.hidden = NO;
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.shootingBtn.mas_bottom).offset(7);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
        //        [self updateFocusIfNeeded];
        //        [self updateLayout];
        //        [self updateConstraintsIfNeeded];
        //        [self updateConstraintsIfNeeded];
        //        [self setNeedsUpdateConstraints];
        //        [self updateConstraints];
        //
    } else {
        if (self.musicBtnBlock) {
            self.musicBtnBlock(index);
        }
    }
    self.indexRow = index;
    NSLog(@"选择音乐%ld",index);
    
}

- (IBAction)cellbtnClick:(UIButton *)sender {

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (UIButton *)shootingBtn {
    if (!_shootingBtn) {
        _shootingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shootingBtn setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
        [_shootingBtn setTitle:@"确认使用并开拍" forState:UIControlStateNormal];
        [_shootingBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
    }
    return _shootingBtn;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"musicClick" object:self];
}

@end
