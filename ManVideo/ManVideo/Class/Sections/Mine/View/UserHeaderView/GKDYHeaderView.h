//
//  GKDYHeaderView.h
//  ManVideo
//
//  Created by 刘赓 on 2019/9/21.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ZoomHeaderView.h"
#import "GKDYVideoModel.h"
#import "GKDYPersonalModel.h"

#define kDYHeaderHeight (SCREEN_WIDTH * 260.0f / 345.0f)
#define kDYBgImgHeight  (SCREEN_WIDTH * 110.0f / 345.0f)

@protocol GKDYHeaderDelegate <NSObject>

- (void)userPushViewDelegate:(UIButton *_Nonnull)sender;
- (void)clickQuestDelegateButton:(UIButton *_Nonnull)btn;
- (void)tapActionDelegateClick:(UITapGestureRecognizer *_Nonnull)click;
- (void)focusOnActionDelegate:(UIButton *_Nonnull)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GKDYHeaderView : ZoomHeaderView

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *signatureLabel;/*签名*/
@property(nonatomic,strong)UILabel *genderLabel;/*性别*/
@property(nonatomic,strong)UILabel *ageLabel;/*年龄*/
@property(nonatomic,strong)UILabel *focusLabel;/*关注*/
@property(nonatomic,strong)UILabel *focusCount;
@property(nonatomic,strong)UILabel *praiseLabel;/*获赞*/
@property(nonatomic,strong)UILabel *praiseCount;
@property(nonatomic,strong)UILabel *fansLabel;/*粉丝*/
@property(nonatomic,strong)UILabel *fansCount;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *dyIdLabel;
@property(nonatomic,strong)UIButton *pointsBtn;/*积分兑换*/
@property(nonatomic,strong)UIButton *userIconBtn;
//@property(nonatomic,strong)UIButton *userBtn;/*用户信息按钮*/
//@property(nonatomic,strong)UILabel *cityLabel;/*所在城市*/

@property(nonatomic,weak)id<GKDYHeaderDelegate> delegate;
@property(nonatomic,strong)GKDYVideoModel *model;
@property(nonatomic,strong)GKDYPersonalModel *userModel;
@property(nonatomic,strong)NSMutableDictionary *dictionary;
@property(nonatomic,strong)NSMutableArray *userArr;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,assign)BOOL isPush;

-(NSString *)imagePathForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
