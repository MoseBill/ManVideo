//
//  TCSCollectionViewCell.m
//  MOABBS
//
//  Created by odin on 2019/1/22.
//  Copyright © 2019 odin. All rights reserved.
//

#import "TCSCollectionViewCell.h"
#import <CoreGraphics/CoreGraphics.h>

@interface TCSCollectionViewCell ()

@property(nonatomic,copy)NSString *imageString;
@property(nonatomic,strong)FLAnimatedImageView *imageAnimated;
@property(nonatomic,strong)FLAnimatedImage *image;

@end

@implementation TCSCollectionViewCell

- (void)taskImageToCell:(TCSCollectionViewCell*)cell
                 andTag:(NSIndexPath*)index {
    @weakify(self)
    if (_model.videoUrlGif) {
        NSString *signstr = @"Kef9lkpzEBQD8WSged";
        NSString *md5String = [NSString stringWithFormat:@"%@%@",_model.videoUrlGif,signstr];
        NSString *signUrl = [NSString md5String:md5String];
        NSString *imageString = [NSString stringWithFormat:@"%@%@?secretKeyStr=%@",REQUEST_URL,_model.videoUrlGif,signUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @strongify(self)
            NSData *dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]];
            self.image = [FLAnimatedImage animatedImageWithGIFData:dataImage];
            @weakify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                self.imageAnimated.animatedImage = self.image;
                [UIView transitionWithView:self.contentView
                                  duration:0.3f
                                   options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [self.contentView addSubview:self.imageAnimated];
                                    [self.imageAnimated mas_makeConstraints:^(MASConstraintMaker *make) {
                                        make.edges.mas_equalTo(0);
                                    }];
                                }
                                completion:^(BOOL finished) {
                                }];
            });
        });
    }
}

#pragma mark —— 点击事件
- (IBAction)focusBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self focusOnNetwork];
        [sender setBackgroundColor:kWhiteColor];
        //        [sender setTintColor:[UIColor je_gradientFromColor:[UIColor colorWithHexString:@"54ceee"] toColor:[UIColor colorWithHexString:@"31acf1"] withHeight:sender.height]];
        [sender setTitleColor:[UIColor je_gradientFromColor:[UIColor colorWithHexString:@"54ceee"]
                                                    toColor:[UIColor colorWithHexString:@"31acf1"]
                                                 withHeight:sender.height]
                     forState:UIControlStateSelected];
        sender.layer.borderColor = [UIColor je_gradientFromColor:[UIColor colorWithHexString:@"54ceee"]
                                                         toColor:[UIColor colorWithHexString:@"31acf1"]
                                                      withHeight:sender.height].CGColor;
        sender.layer.borderWidth = 1.0f;

    } else {
        [self focusOnNetworkCancell];
        [sender setBackgroundColor:[UIColor je_gradientFromColor:[UIColor colorWithHexString:@"54ceee"]
                                                         toColor:[UIColor colorWithHexString:@"31acf1"]
                                                      withHeight:sender.height]];
        [sender setTitleColor:kWhiteColor
                     forState:UIControlStateNormal];
        sender.layer.borderWidth = 0.0f;
    }
}

- (IBAction)likeClickBtn:(UIButton *)sender {
    //    if (self.likeBtnBlock) {
    //        self.likeBtnBlock(sender);
    //    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_praise_pre"]
                forState:UIControlStateNormal];
        //        NSString *userId = [NSString stringWithFormat:@"%ld",(long)self.model.articleId];
        //        [self praiseClick:userId];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_praise_nor"]
                forState:UIControlStateNormal];
        //        [weakself cancelNetWork:indexPath];
        //        NSString *userId = [NSString stringWithFormat:@"%ld",(long)self.model.articleId];
        //        [self stepOnClick:userId];
    }
}

- (IBAction)collectionClick:(UIButton *)sender {
    if (self.collectionBtnBlock) {
        self.collectionBtnBlock(sender);
    }
}

- (void)focusOnNetwork {
    //
    //    NetWorkManager *m = [NetWorkManager new];
    //
    //    NSString *userId = [NSString stringWithFormat:@"%ld",(long)self.model.articleId];
    //    NSDictionary *dict = @{@"userId":userId,@"flag":@"0"};
    //    JMLog(@"关注的ID%@",userId);
    //
    //    [m requestNetworkUrl:@"/bbs/article/clickTrample" paraDict:dict successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    //
    //
    //    } errorBlock:^(NSString *message) {
    ////        [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
}

- (void)focusOnNetworkCancell {

    //    NetWorkManager *m = [NetWorkManager new];
    //
    //    NSString *userId = [NSString stringWithFormat:@"%ld",(long)self.model.articleId];
    //    NSDictionary *dict = @{@"userId":userId,@"flag":@"1"};
    //    JMLog(@"关注的ID%@",userId);
    //
    //    [m requestNetworkUrl:@"/bbs/article/clickTrample" paraDict:dict successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
    //
    //
    //    } errorBlock:^(NSString *message) {
    ////        [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
}

- (void)praiseClick:(NSString*)clickId {

    //    NetWorkManager *m = [NetWorkManager new];
    //
    //    NSDictionary *dict = @{@"commentId":clickId,@"flag":@"0"};
    //
    //
    //    [m requestNetworkUrl:@"/bbs/article/clickPraise" paraDict:dict successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
    //
    //
    //    } errorBlock:^(NSString *message) {
    ////        [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
}

- (void)stepOnClick:(NSString *)clickId {
    //    NetWorkManager *m = [NetWorkManager new];
    //
    //    NSDictionary *dict = @{@"commentId":clickId,@"flag":@"1"};
    //
    //
    //    [m requestNetworkUrl:@"/bbs/article/clickPraise" paraDict:dict successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"取消点赞"];
    //
    //
    //    } errorBlock:^(NSString *message) {
    ////        [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
}

#pragma mark - lazyLaod
- (FLAnimatedImage *)image {
    if (!_image) {
        _image = FLAnimatedImage.new;
    }return _image;
}

- (FLAnimatedImageView *)imageAnimated {
    if (!_imageAnimated) {
        _imageAnimated = FLAnimatedImageView.new;
        _imageAnimated.image = [UIImage imageNamed:@"附近占位"];
        _imageAnimated.contentMode = UIViewContentModeScaleAspectFill;
        _imageAnimated.userInteractionEnabled = YES;
        _imageAnimated.layer.masksToBounds = YES;
        _imageAnimated.layer.cornerRadius = 8/667.0f*SCREEN_HEIGHT;
    }return _imageAnimated;
}

@end
