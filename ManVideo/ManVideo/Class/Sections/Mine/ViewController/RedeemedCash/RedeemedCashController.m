//
//  RedeemedCashController.m
//  Clipyeu ++
//
//  Created by Josee on 16/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "RedeemedCashController.h"
#import "CGXPickerView.h"
#import "CashSuccessController.h"
#import "TopUpViewController.h"

@interface RedeemedCashController ()

//@property (nonatomic, weak) UIButton    *bankBtn;
@property(weak,nonatomic)IBOutlet UIButton *bankBtn;
@property(weak,nonatomic)IBOutlet UITextField *bankCode;
@property(weak,nonatomic)IBOutlet UITextField *iphoneNumber;
@property(weak,nonatomic)IBOutlet UITextField *nameUser;
@property(weak,nonatomic)IBOutlet UIButton *changeBtn;
@property(weak,nonatomic)IBOutlet UILabel *bankLabel;
@property(weak,nonatomic)IBOutlet UIImageView *arrowImage;
@property(weak,nonatomic)IBOutlet UITextField *bankCard;

@property (nonatomic, strong) NSArray    *arrBank;

@property (nonatomic, copy) NSString    *bankCount;
@property (nonatomic, copy) NSString    *iphoneCount;
@property (nonatomic, copy) NSString    *nameString;

@end

@implementation RedeemedCashController

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.gk_navTitle = NSLocalizedString(@"VDRedeemedText", nil);
    self.gk_navBarAlpha = 0;
    self.gk_navigationBar.translucent = NO;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"1A142D"];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
//    self.gk_navTitleView = self.titleView;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;

    [self setupView];
}

- (void)setupView {
    [self.changeBtn setTitle:NSLocalizedString(@"VDDetermineText", nil) forState:UIControlStateNormal];
    [self.bankBtn mas_remakeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(Height_NavBar+60);
        make.left.mas_equalTo(39);
        make.right.mas_equalTo(-39);
        make.height.mas_equalTo(44);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.bankCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:self.bankCode];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValueIphone:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.iphoneNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotificationIphone:) name:UIKeyboardWillHideNotification object:self.iphoneNumber];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValueCardID:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotificationCardID:) name:UIKeyboardWillHideNotification object:self.nameUser];
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"VDbankcardnumberText", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9C9C9D"],
                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
     self.bankCode.attributedPlaceholder = attrString;
    
    NSAttributedString *iphoneString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"VDEntermobileText", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9C9C9D"],
                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    
    NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"VDEnternameText", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9C9C9D"],
                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"VDBankAccount", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9C9C9D"],
                                                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
 
    self.iphoneNumber.attributedPlaceholder = iphoneString;
    self.nameUser.attributedPlaceholder = nameString;
    self.bankCard.attributedPlaceholder = placeHolder;
    
    self.changeBtn.layer.masksToBounds = YES;
    self.changeBtn.layer.cornerRadius = 8.0f;
    
    self.arrBank = @[@"Á Châu",@"Đông Á",@"Đông Nam Á",@"Đại Dương",@"An Bình",@"Bắc Á",@"Dầu khí Toàn Cầu",@"Bản Việt",@"Hàng Hải Việt Nam",@"Kỹ Thương Việt Nam",@"Kiên Long",@"Nam Á",@"Quốc Dân",@"Việt Nam Thịnh Vượng",@"Sài Gòn - Hà Nội",@"Phát Triển Nhà TPHCM",@"Phương Nam",@"Phương Đông",@"Quân Đội",@"Đại chúng",@"Quốc tế",@"Sài Gòn",@"Sài Gòn Công Thương",@"Sài Gòn Thương Tín",@"Việt Á",@"Bảo Việt",@"Việt Nam Thương Tín",@"Xăng dầu Petrolimex",@"Xuất nhập khẩu",@"Bưu điện Liên Việt",@"Tiên Phong",@"Ngoại thương",@"Phát Triển Mê Kông",@"Xây dựng",@"Công thương",@"Đầu tư",@"Nông nghiệp",@"Phát triển Nhà ĐBSCL",@"ANZ Việt Nam",@"Deutsche Bank Việt Nam",@"Citibank Việt Nam",@"HSBC Việt Nam",@"Standard Chartered",@"Shinhan Việt Nam",@"Hong Leong Việt Nam",@"Ngân hàng Đầu tư và Phát triển Campuchia",@"Crédit Agricole",@"Mizuho",@"Tokyo-Mitsubishi UFJ",@"Sumitomo Mitsui Bank",@"Commonwealth Bank Việt Nam",@"Indovina",@"Việt-Nga",@"ShinhanVina",@"VID Public Bank",@"Việt - Thái",@"Việt - Lào"];
}
#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}
#pragma mark ===================== 键盘监听===================================
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    sender.keyboardType = UIKeyboardTypeNumberPad;
    sender.clearButtonMode = UITextFieldViewModeAlways;
    // 获取键盘基本信息（动画时长与键盘高度）
//    NSDictionary *userInfo = [notification userInfo];
//    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    DLog(@"输入银行卡%@",sender.text);
    self.bankCount = sender.text;
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    
    // 获得键盘动画时长
//    NSDictionary *userInfo   = [notification userInfo];
//    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
}

- (void)textFieldDidChangeValueCardID:(NSNotification *)notification{
    UITextField *sender = (UITextField *)[notification object];
    //  sender.keyboardType = UIKeyboardTypeNumberPad;
    sender.clearButtonMode = UITextFieldViewModeAlways;
   DLog(@"输入姓名%@",sender.text);
       self.nameString = sender.text;
}

- (void)keyboardWillHideNotificationCardID:(NSNotification *)notification {
    
    // 获得键盘动画时长
//    NSDictionary *userInfo   = [notification userInfo];
//    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (void)textFieldDidChangeValueIphone:(NSNotification *)notification {
    UITextField *sender = (UITextField *)[notification object];
    //  sender.keyboardType = UIKeyboardTypeNumberPad;
    sender.clearButtonMode = UITextFieldViewModeAlways;
    DLog(@"输入手机号%@",sender.text);
    self.iphoneCount = sender.text;
}

- (void)keyboardWillHideNotificationIphone:(NSNotification *)notification {
    // 获得键盘动画时长
//    NSDictionary *userInfo   = [notification userInfo];
//    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

- (IBAction)changeAction:(UIButton *)sender {
    if (self.bankCount != nil && self.iphoneCount != nil && self.nameString != nil) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userString = [user objectForKey:@"userId"];
           NSString *token = [user objectForKey:@"token"];
        int userInt = [userString intValue];
        NSNumber *number = [NSNumber numberWithInt:userInt];
        int bankInt = [self.bankCard.text intValue];
        NSNumber *bankNumber = [NSNumber numberWithInt:bankInt];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict[@"status"] = @"2";
        dict[@"phone"] = self.iphoneNumber.text;
        dict[@"money"] = self.money;
        dict[@"userId"] = number;
        dict[@"bankCard"] = self.bankCode.text;
        dict[@"userName"] = self.nameUser.text;
        dict[@"savings"] = self.bankLabel.text;
        dict[@"account"] = bankNumber;
        dict[@"token"] = token;
        DLog(@"提交信息%@",dict);
        [CMRequest requestNetSecurityGET:@"/videoUploading/bankCard"
                          paraDictionary:dict
                            successBlock:^(NSDictionary * _Nonnull dict) {
                                DLog(@"现金提交请求成功%@",dict);
        } errorBlock:^(NSString * _Nonnull message) {
            DLog(@"现金提交请求失败%@",message);
        } failBlock:^(NSError * _Nonnull error) {
            DLog(@"现金提交请求网络%@",error);
        }];
        CashSuccessController *topUp = [[CashSuccessController alloc]init];
        topUp.type = NSLocalizedString(@"VDRedeemedText", nil);
        [self.navigationController pushViewController:topUp animated:YES];
    } else {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"VDComplete", nil)];
    }
}
- (IBAction)bankAction:(UIButton *)sender {
    self.arrowImage.image = [UIImage imageNamed:@"向上箭头"];
    @weakify(self)
        [CGXPickerView showStringPickerWithTitle:NSLocalizedString(@"VDBank", nil)
                                      DataSource:self.arrBank
                                 DefaultSelValue:NSLocalizedString(@"VDBankChoose", nil)
                                    IsAutoSelect:NO
                                         Manager:nil
                                     ResultBlock:^(id selectValue,
                                                   id selectRow) {
                                         @strongify(self)
                                         DLog(@"%@",selectValue);
                                         if (selectValue) {
                                             self.bankLabel.text = [NSString stringWithFormat:@"%@",selectValue];
                                             self.arrowImage.image = [UIImage imageNamed:@"形状 4"];
                                         }
                                     }];
}




@end
