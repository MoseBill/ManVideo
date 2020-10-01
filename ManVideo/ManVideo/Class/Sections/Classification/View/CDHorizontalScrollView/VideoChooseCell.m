//
//  VideoChooseCell.m
//  Clipyeu ++
//
//  Created by Josee on 11/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VideoChooseCell.h"
#import <CoreGraphics/CoreGraphics.h>

@interface VideoChooseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageVideo;

@property (nonatomic, strong) UIButton    *seletedBtn;

@end

@implementation VideoChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
    [self setupView];
}

- (void)videoChoose:(NSNotification *)noti {
    
    NSString *videoString = [noti object];
    if ([videoString isEqualToString:@"selected"]) {
        
//        [self.seletedBtn setImage:[UIImage imageNamed:@"选中状态"] forState:UIControlStateNormal];
        
    } else {
        
//        [self.seletedBtn setImage:[UIImage imageNamed:@"未选中状态"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - Intial Methods
- (void)setupView {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Bigger_animation" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:imageData];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(0.0, 0.0,self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    self.seletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.seletedBtn setImage:[UIImage imageNamed:@"未选中状态"] forState:UIControlStateNormal];
    [self.seletedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.seletedBtn];
    [self.seletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoChoose:) name:@"selectVideo" object:nil];
    
}

#pragma mark - Public Methods
- (void)setModel:(VideoUploadingList *)model {
    
    _model = model;
    
}
- (void)setObj:(id)obj {
    
    ClassModel  *model = obj;
    
    //    NSString *stringImage = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.avatorId];
    //    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:stringImage] placeholderImage:[UIImage imageNamed:@"user"]];
    //    self.nameLabel.text = model.nickname;
    //    self.contentLabel.text = model.content;
    //    NSString *stringPath = [NSString stringWithFormat:@"%@%@",REQUEST_URL,model.imgPath];
    //    NSArray *array = [stringPath componentsSeparatedByString:@","];
    //    NSArray *array = [stringPath componentsSeparatedByString:@","];
    //    [self.backGround sd_setImageWithURL:[NSURL URLWithString:[array firstObject]] placeholderImage:[UIImage imageNamed:@""]];
    //    self.likeCount.text = [NSString stringWithFormat:@"%ld",(long)model.likes];
    //    NSMutableArray *arrayMutable = [[NSUserDefaults standardUserDefaults]objectForKey:@"titleArray"];
    //    //判断title是否在数组中，
    //    for (int i = 0; i < arrayMutable.count; i ++) {
    //        if ([model.title isEqualToString:arrayMutable[i]]) {
    //            model.isCollection = YES;
    //        }
    //    }
    //    if (model.isCollection == NO) {
    //        [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    //    }else{
    //        [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like-red"] forState:UIControlStateNormal];
    //    }
    //    JMLog(@"分割%@",array);
    //    self.lable.text = (NSString *)obj;
    
}
#pragma mark - Private Method
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)selectedAction:(UIButton *)sender {

    if ([self.delagte respondsToSelector:@selector(chooseVideoDelegate:indexPath:)]) {
        [self.delagte chooseVideoDelegate:sender indexPath:self.indexPath];
    }
}

- (void)setUpView:(UIView *)view byRoundingCorners:(UIRectCorner)corners withSize:(CGSize)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners: corners  cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
