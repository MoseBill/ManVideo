//
//  KHTRealNameController.m
//  BasicApp
//
//  Created by Jacky-song on 2018/8/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "KHTRealNameController.h"



@interface KHTRealNameController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
  CGFloat keyboardHeight;
  BOOL _selected;
}
@property (weak, nonatomic) IBOutlet UITextField *nameFeild;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *manBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *womanBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeCard;
@property (weak, nonatomic) IBOutlet UITextField *cardId;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeDelegate;

@property (nonatomic, strong) NSMutableArray *userArr;

@property (nonatomic,copy) NSString *name;

@property (nonatomic, copy) NSString *card;
/** 身份证类型 */
@property (nonatomic, copy) NSString  *cardType;

@property (nonatomic, copy) NSString *birthDate;
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *agreebtn;

@property (nonatomic, strong) NSMutableArray *informationArr;

@property (nonatomic, copy) NSString *userCount;
@property (nonatomic, copy) NSString *cardCount;
@property (nonatomic, copy) NSString *typeCount;
@property (nonatomic, copy) NSString *dateCount;

/** cif号 */
@property (nonatomic, strong) NSString *cifNumer;

/** 手机号 */
@property (nonatomic, strong) NSString *iphoneNumer;

/** 邮箱 */
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *sexType;
/** 传参 */
@property (nonatomic, strong) NSDictionary *dicUser;
/** 请求地址 */
@property (nonatomic, copy) NSString *urlReal;

/** 获取的手机号 */
@property (nonatomic, strong) NSMutableArray *iphoneArr;
/** 获取的邮箱 */
@property (nonatomic, strong) NSMutableArray *emailArr;

@end



@implementation KHTRealNameController

#pragma mark ===================== Life Cycle（生命周期）==================================
- (void)viewDidAppear:(BOOL)animated{
      [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate =self;
        
          }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate =nil;
        
    }
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    
      return NO;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self fk_createViewForConctroller];
    
}


#pragma mark ===================== Initial Function（初始化方法）===========================

#pragma mark ===================== AutoLayout（UI布局）====================================
- (void)createView {
  
  self.nextBtn.layer.masksToBounds = YES;
  self.nextBtn.layer.cornerRadius = 4.0f;
  self.nextBtn.userInteractionEnabled = NO;
  
  
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}


#pragma mark ===================== Notification Event Response（通知的回调）=================

- (void)lessonToDate:(NSNotification *)notifcation {
  
  UILabel *date = (UILabel *)[notifcation object];
  
  if (date.text != nil) {
    [self theValueOfCard:nil andWithName:nil andWithCardType:nil andWithDate:date.text];
    
  }
}

- (void)lessonToCardType:(NSNotification *)notication {
  
  UILabel *laebl = (UILabel *)[notication object];
  
  if (laebl.text != nil ) {

//      self.nextBtn.userInteractionEnabled = YES;
//
//      self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"#0E6DCF"];
    [self theValueOfCard:nil andWithName:nil andWithCardType:@"QT" andWithDate:nil];
  
    
  }
  
}

//这里可以通过发送object消息获取注册时指定的UITextField对象
/**
 *   键盘出现触发的事件
 *   @param notifiaction
 */
- (void)textFieldDidChangeValue:(NSNotification *)notification
{
  UITextField *sender = (UITextField *)[notification object];
  
  sender.clearButtonMode = UITextFieldViewModeAlways;

  if (sender.text.length > 0) {
    self.name = sender.text;
    [self theValueOfCard:nil andWithName:sender.text andWithCardType:nil andWithDate:nil];
  }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
  
  // 获得键盘动画时长
//  NSDictionary *userInfo   = [notification userInfo];
//  CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
}

- (void)textFieldDidChangeValueIphoneNumber:(NSNotification *)notification {
    
    UITextField *sender = (UITextField *)[notification object];
    //  sender.keyboardType = UIKeyboardTypeNumberPad;
    sender.clearButtonMode = UITextFieldViewModeAlways;
    self.iphoneNumer= sender.text;
    
}
- (void)textFieldDidChangeValueCardID:(NSNotification *)notification
{
  UITextField *sender = (UITextField *)[notification object];
//  sender.keyboardType = UIKeyboardTypeNumberPad;
  sender.clearButtonMode = UITextFieldViewModeAlways;
  self.card = sender.text;
  
  [self theValueOfCard:sender.text andWithName:nil andWithCardType:@"QT" andWithDate:nil];
 BOOL cardBool = [KHTRealNameController validateIdentityCard:sender.text];
  if (cardBool == YES && [self.cardType isEqualToString:@"身份证"]) {
   
    [self theValueOfCard:sender.text andWithName:nil andWithCardType:@"身份证" andWithDate:nil];
    
  }

}

- (void)keyboardWillHideNotificationCardID:(NSNotification *)notification {
  
  // 获得键盘动画时长
//  NSDictionary *userInfo   = [notification userInfo];
//  CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  
}

- (void)keyboardWillHideNotificationIphoneNumber:(NSNotification *)notification {
    
    // 获得键盘动画时长
//    NSDictionary *userInfo   = [notification userInfo];
//    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

#pragma mark ========================== 网络请求 ===============================

- (void)updateloadData:(NSString *)typeRequest {
  
 
}

#pragma mark ===================== Button Event Response（按钮点击响应方法）==================

- (void)pushFailPage {
  
  
}

- (void)pushNextPage {
  
  

}

#pragma mark ========================== 出生日期 ===============================

- (IBAction)IdCard:(id)sender {
  
 [self textFieldDidEndEditing:self.cardId];
  
  
}

- (IBAction)cardType:(id)sender {

//  PickerView *vi = [[PickerView alloc] init];
//  vi.tag = 101;
//  vi.delegate = self;
//  vi.type = PickerViewTypeHeigh;
//  vi.selectComponent = 2;
  
//  [self.view addSubview:vi];
  
  [self textFieldDidEndEditing:self.nameFeild];
}

- (void)nextPushCard {
  
  
  
}

#pragma mark ===================== actions ===============================================

#pragma mark ===================== Gesture Event Response（手势点击响应方法）=================

#pragma mark ===================== System Delegate（系统代理）===============================

//该方法为点击输入文本框要开始输入是调用的代理方法：就是把view上移到能看见文本框的地方
- (void)textFieldDidBeginEditing:(UITextField *)textField{
  textField.keyboardType = UIKeyboardTypeNumberPad;
  keyboardHeight = 216.0f;
  if (self.view.frame.size.height - keyboardHeight <= textField.frame.origin.y + textField.frame.size.height) {
    CGFloat y = textField.frame.origin.y - (self.view.frame.size.height - keyboardHeight - textField.frame.size.height - 5);
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275f];
    self.view.frame = CGRectMake(self.view.frame.origin.x, -y, (self.view.frame.size.width/375.0f)*SCREEN_WIDTH, (self.view.frame.size.height/HEIGHT_SCREEN)*SCREEN_HEIGHT);
    [UIView commitAnimations];
  }
}

//该方法为点击虚拟键盘Return，要调用的代理方法：隐藏虚拟键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  
  return YES;
}
//该方法为完成输入后要调用的代理方法：虚拟键盘隐藏后，要恢复到之前的文本框地方
- (void)textFieldDidEndEditing:(UITextField *)textField{
  
  [UIView beginAnimations:@"LoginViewController" context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.275f];
 
  [UIView commitAnimations];
  
  
}

#pragma mark ===================== scrollview delegate ===================================

#pragma mark ===================== Custom Delegate（自定义一些控件的代理）=====================

#pragma mark ===================== Public Function（公开可以调用的方法）=======================

#pragma mark ========================== 创建视图控件 ===============================
- (void)fk_createViewForConctroller {
  
  self.title = [NSString stringWithFormat:@"实名认证"];
  _selected = NO;
    self.gk_navTitle =  @"我的认证";
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];

  self.firstView.backgroundColor = [UIColor colorWithHexString:@"1A142D"];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请输入真实姓名" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0 green:156/255.0 blue:157/255.0 alpha:1.0]}];
//     NSMutableAttributedString *stringIphone = [[NSMutableAttributedString alloc] initWithString:@"请输入联系电话" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0 green:156/255.0 blue:157/255.0 alpha:1.0]}];
//    NSMutableAttributedString *idString = [[NSMutableAttributedString alloc] initWithString:@"请输入身份证号" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName: [UIColor colorWithRed:156/255.0 green:156/255.0 blue:157/255.0 alpha:1.0]}];
//    self.nameFeild.attributedPlaceholder = string;
//    self.iphoneNumber.attributedPlaceholder = stringIphone;
//    self.cardId.attributedPlaceholder = idString;
  [self createView];
  //这里的object传如的是对应的textField对象,方便在事件处理函数中获取该对象进行操作。
  //注册键盘出现的通知,为了动态获取键盘高度
  // 注册键盘通知
  //这里的object传如的是对应的textField对象,方便在事件处理函数中获取该对象进行操作。
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textFieldDidChangeValue:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self.nameFeild];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:self.nameFeild];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textFieldDidChangeValueCardID:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self.cardId];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotificationCardID:) name:UIKeyboardWillHideNotification object:self.cardId];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValueIphoneNumber:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.cardId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotificationIphoneNumber:) name:UIKeyboardWillHideNotification object:self.iphoneNumber];
  [self updateloadData:@"0"];
    self.agreebtn.layer.masksToBounds = YES;
    self.agreebtn.layer.cornerRadius = self.agreebtn.height/2.0f;
    self.agreebtn.layer.borderColor = [UIColor colorWithHexString:@"BE3462"].CGColor;
    self.agreebtn.layer.borderWidth = 1.0f;
  
}
#pragma mark ========================== 绑定数据模型 ===============================

#pragma mark ========================== 初始化默认视图 ===============================

#pragma mark ========================== 设置导航栏 ===============================

#pragma mark ========================== 键盘设置 ===============================
- (void)recoverKeyboard {
  
}
#pragma mark ===================== Private Function（内部调用的方法）=========================
#pragma mark ========================== 身份证 ===============================
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
  BOOL flag;
  if (identityCard.length <= 0) {
    flag = NO;
    return flag;
  }
  
  NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
  NSPredicate *identityCardPredicate = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",regex2];
  return [identityCardPredicate evaluateWithObject:identityCard];
  
}

- (void)theValueOfCard:(NSString *)card andWithName:(NSString *)nameStr andWithCardType:(NSString *)cardType andWithDate:(NSString *)date {
  
  
 
  DLog(@"身份证 %@ %@ %@ %@",_userCount,_cardCount,_typeCount,_dateCount);

//  if ( date.length != 0 || ([cardType isEqualToString:@"身份证"] && card.length != 0)) {
//
//    if ([cardType isEqualToString:@"身份证"]) {
//      
////      self.btnDate.userInteractionEnabled = NO;
//      
//     
//    }
//    self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"0E6DCF"];
//    self.nextBtn.userInteractionEnabled = YES;
//   
//    [self.nextBtn addTarget:self action:@selector(pushNextPage) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self updateloadData:@"1"];
//    
//
//  } else {
//
//    self.nextBtn.backgroundColor = [UIColor colorWithHexString:@"92BEED"];
//    self.nextBtn.userInteractionEnabled = NO;
//
//  }
}

#pragma mark ===================== Getter（一般放懒加载方法）=================================
- (NSMutableArray *)userArr {
  
  if (_userArr) {
    _userArr = [[NSMutableArray alloc]init];
  }
  return _userArr;
}


#pragma mark ===================== Setter（setter方法）=====================================




- (void)dealloc {
  
  //一般是在dealloc中实现
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self.nameFeild];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.nameFeild];
  //一般是在dealloc中实现
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self.cardId];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.cardId];

  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lessonLabel" object:self.typeCard];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lessonDate" object:self.dateLabel];
  
}
- (IBAction)actionCerification:(id)sender {
    
}
- (IBAction)pushProtocol:(id)sender {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"提交成功", nil)];
}
- (IBAction)agreeProtocol:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
    } else {
          [sender setBackgroundColor:kClearColor];
    }
}

@end
