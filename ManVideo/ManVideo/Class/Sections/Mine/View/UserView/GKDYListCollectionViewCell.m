//
//  GKDYListCollectionViewCell.m
//  GKDYVideo
//
//  Created by gaokun on 2018/12/14.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYListCollectionViewCell.h"

@interface GKDYListCollectionViewCell()

@property(nonatomic,strong)UIImageView *coverImgView;
@property(nonatomic,strong)UIButton *starBtn;
@property(nonatomic,strong)FLAnimatedImageView *imageAnimated;

@end

@implementation GKDYListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self.contentView addSubview:self.coverImgView];
        
//        [self.contentView addSubview:self.starBtn];
        
//        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView);
//        }];
    }return self;
}

- (void)taskImageToCell:(GKDYListCollectionViewCell *)cell
                 andTag:(NSIndexPath*)index {
    if (_model.videoUrlGif) {
        NSString *signstr=@"Kef9lkpzEBQD8WSged";
        NSString *md5String = [NSString stringWithFormat:@"%@%@",_model.videoUrlGif,signstr];
        NSString *signUrl = [NSString md5String:md5String];
        NSString *imageString = [NSString stringWithFormat:@"%@%@?secretKeyStr=%@",REQUEST_URL,_model.videoUrlGif,signUrl];
        NSLog(@"imageString = %@",imageString);
        @weakify(self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @strongify(self)
            NSData *dataImage =  [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
             FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:dataImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                     @strongify(self)
                    self.imageAnimated.animatedImage = image;
                });
        });
        [UIView transitionWithView:self.contentView
                          duration:0.3 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            @strongify(self)
                            [self.contentView addSubview:self.imageAnimated];
        }
                        completion:^(BOOL finished) {}];
    }
}



#pragma mark - 懒加载
- (FLAnimatedImageView *)imageAnimated {
    if (!_imageAnimated) {
        _imageAnimated = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0.0,
                                                                              0.0,
                                                                              self.frame.size.width,
                                                                              self.frame.size.height)];
        _imageAnimated.image = [UIImage imageNamed:@"附近占位"];
         _imageAnimated.userInteractionEnabled = YES;
    }return _imageAnimated;
}

//- (UIImageView *)coverImgView {
//    if (!_coverImgView) {
//        _coverImgView = [UIImageView new];
//        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
//        _coverImgView.clipsToBounds = YES;
//    }
//    return _coverImgView;
//}


@end
