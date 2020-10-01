//
//  ChooseMusicCell.m
//  ManVideo
//
//  Created by Josee on 21/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ChooseMusicCell.h"

@interface ChooseMusicCell ()

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

@implementation ChooseMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //机型封装到单例中 全局都可以使用
    
//    if (CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)) {
//        return UIScreenSizeType_640x960;
//    }
//    else if(CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)){
//        return UIScreenSizeType_640x1136;
//    }else if(CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)){
//        return UIScreenSizeType_750x1334;
//    }else if(CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)){
//        return UIScreenSizeType_1242x2208;
//    }
//    return UIScreenSizeType_000x000;
//
//}
//
//if([UIScreen currentScreenSizeType] == UIScreenSizeType_640x960){
//    _topLayout.constant = 40;
//}else if([UIScreen currentScreenSizeType] == UIScreenSizeType_640x1136){
//    _topLayout.constant = 40;
//}else if([UIScreen currentScreenSizeType] == UIScreenSizeType_750x1334){
//    _topLayout.constant = 40;
//}else if([UIScreen currentScreenSizeType] == UIScreenSizeType_1242x2208){
//    _topLayout.constant = 40;
//}

     self.backgroundColor = [UIColor colorWithHexString:@"1A142D"];
    self.shootingBtn.layer.masksToBounds = YES;
    self.shootingBtn.layer.cornerRadius = 15.0f;
    self.shootingBtn.hidden = YES;
    
//    [self performSelector:@selector(modifyConstant) withObject:nil afterDelay:0.1];//延迟加载,执行
//    Line View.top = Shooting Btn.bottom + 2
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(self.timeLong.mas_bottom).offset(18);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//          make.bottom.mas_equalTo(0);
//    }];
}
//- (void)modifyConstant//把修改的代码放在一个方法里!
//{
////    self.top.constant+=100;
////    self.height.constant+=100;}
//    self.top.constant += 30;
//    self.height.constant += 1;
//}

- (void)cellSelectClick:(UIButton *)click Indexpath:(NSInteger)index {
    click.selected = !click.selected;
    if (click.selected) {
        if (self.musicBtnBlock) {
            self.musicBtnBlock(index);
        }
        self.shootingBtn.hidden = NO;
//        [self updateConstraints];
//        self.lineView.sd_layout
//        .leftSpaceToView(self, 0)
//        .rightSpaceToView(self, 0)
//        .heightIs(1)
//        .topSpaceToView(self.shootingBtn, 7)
//        .bottomSpaceToView(self, 0);
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(self.shootingBtn.mas_bottom).offset(7);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);

        }];
        // 创建视图约束
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            self.animatableConstraint = make.edges.equalTo(superview).insets(paddingInsets).priorityLow();
//            ]];
//        [self.contentView removeConstraint:self.lineView.width];//在父试图上将button的宽度约束删除
//        [self.contentView removeConstraint:self.constraints.];

        
        //        [self updateFocusIfNeeded];
        //        [self updateLayout];
        //        [self updateConstraintsIfNeeded];
        //        [self updateConstraintsIfNeeded];
        //        [self setNeedsUpdateConstraints];
       //         [self updateConstraints];
        
    } else {
        if (self.musicBtnBlock) {
            self.musicBtnBlock(index);
        }
    }
//    self.indexRow = index;
    NSLog(@"选择音乐%ld",index);
    
}

- (void)updateConstraints {
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.baseline.equalTo(self.mas_centerY).with.offset(self.offset);
        make.top.mas_equalTo(self.shootingBtn.mas_bottom).offset(7);
        //            make.left.mas_equalTo(0);
        //            make.right.mas_equalTo(0);
        //            make.height.mas_equalTo(1);
        //            make.bottom.mas_equalTo(0);
    }];
    [super updateConstraints];
}

@end
