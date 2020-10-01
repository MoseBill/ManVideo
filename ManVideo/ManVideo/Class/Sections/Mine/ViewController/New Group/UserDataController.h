//
//  UserDataController.h
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "GKDYBaseViewController.h"
#import "GKDYPersonalModel.h"

typedef NS_ENUM(NSInteger, findPicStyle) {
    SourceTypeCamera = 0,  // 默认 imagePicker
    SourceTypeSavedPhotosAlbum,//相册
    SourceTypePhotoLibrary//图库
};

NS_ASSUME_NONNULL_BEGIN

@interface UserDataController : GKDYBaseViewController

@property(nonatomic,copy)__block NSString *birthDay;
@property(nonatomic,copy)__block NSString *genderString;
@property(nonatomic,copy)__block NSString *nameString;
@property(nonatomic,copy)__block NSString *signString;
@property(nonatomic,strong)__block UIImage *upImageData;
@property(nonatomic,strong)GKDYPersonalModel *modelPersonal;
//@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UIButton *headerImageBtn;

//@property(nonatomic,copy)void(^headerImageBlock)(UIImage *image);
@property(nonatomic,copy)void(^birthDayBlock)(NSString *birthString);
@property(nonatomic,copy)void(^genderBlock)(NSString *genderString);
@property(nonatomic,copy)void(^regionBlock)(NSString *regionString);

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
