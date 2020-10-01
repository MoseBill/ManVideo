//
//  UserDataController.m
//  Clipyeu ++
//
//  Created by Josee on 27/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//


#import "UserDataController.h"
#import "UserDataController+VM.h"
#import "EditDataTableViewCell.h"
#import "CGXPickerView.h"

@interface UserDataController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
EditDataTextFieldDlegate
>
{

}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImagePickerController *pickerController;
@property(nonatomic,strong)UILabel *valueDataLabel;
@property(nonatomic,strong)UILabel *bottomLabel;
@property(nonatomic,strong)UIImageView *backGroud;
@property(nonatomic,strong)UIButton *saveBtn;
//@property(nonatomic,strong)UIButton *headerImageBtn;
@property(nonatomic,strong)NSDateFormatter *fmt;
@property(nonatomic,strong)UIImage *userImage;
@property(nonatomic,copy)NSString *regionString;
@property(nonatomic,strong)NSDictionary *info;


@end

@implementation UserDataController

-(void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    UserDataController *vc = [[UserDataController alloc] initWithRequestParams:requestParams
                                                                       success:block];
    vc.modelPersonal = (GKDYPersonalModel *)requestParams;
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        [rootVC.navigationController pushViewController:vc
                                               animated:animated];
    }else{
        vc.isPush = NO;
        vc.isPresent = YES;
        [rootVC presentViewController:vc
                             animated:animated
                           completion:^{}];
    }return vc;
}

-(instancetype)initWithRequestParams:(nullable id)requestParams
                             success:(DataBlock)block{
    if (self = [super init]) {
        self.requestParams = requestParams;
        self.successBlock = block;
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.pickerController.view.alpha = 1;
    self.backGroud.alpha = 1;
//    self.headerImage.alpha = 1;
    self.bottomLabel.alpha = 1;
    self.headerImageBtn.alpha = 1;
    self.tableView.alpha = 1;
    @weakify(self)
//    self.headerImageBlock = ^(UIImage * _Nonnull image) {
//        @strongify(self)
//        self.headerImage.image = image;
//    };
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navTitle =  NSLocalizedString(@"VDEditdataText", nil);
    self.gk_navTintColor = [UIColor whiteColor];
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kWhiteColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
//    self.gk_navTitleView = self.titleView;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];;
}

- (void)upDateHeadIcon:(UIImage *)photo{
    DLog(@"上传的头像%@",photo);
    self.upImageData = photo;
    [self upDateHeadIconNetWorking];
}

-(void)findPic:(findPicStyle)style{
    switch (style) {
        case SourceTypeCamera:///跳转到imagePicker里
            self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case SourceTypeSavedPhotosAlbum://跳转到相册
            self.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case SourceTypePhotoLibrary://跳转图库
            self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    [self presentViewController:_pickerController
                       animated:YES
                     completion:nil];
}

#pragma mark —— 点击事件
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)headerImageClick:(UIButton *)sender {
    DLog(@"点击%ld",(long)sender.tag);
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"VDChoosetouxiang", nil)
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"VDCancelText", nil)
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"VDpaishe", nil),NSLocalizedString(@"VDPhotogallery", nil),NSLocalizedString(@"VDPhoto", nil), nil];
    [actionSheet showInView:kAPPWindow];
}

- (void)saveBtnClick:(UIButton *)click {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self netWorkLoad];
}

#pragma mark —— EditDataTextFieldDlegate
- (void)textFieldDelegateText:(NSString *)text {
    self.signString = text;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return SCALING_RATIO(60.0f);
    } else return SCALING_RATIO(44.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    EditDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[EditDataTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:ReuseIdentifier];
    }
    cell.backgroundColor =  [UIColor colorWithHexString:@"0F0920"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = YES;
    @weakify(self);
    //昵称回调
    cell.nameTextFieldBlock = ^(NSString * _Nonnull nameString) {
        @strongify(self);
        self.nameString = nameString;
    };
    if (indexPath.row == 0) {
        cell.titleLabel.text = NSLocalizedString(@"VDnicknameText", nil);
        if (self.modelPersonal.username) {
            cell.nameTextField.text = [NSString stringWithFormat:@"%@",self.modelPersonal.username];
        }
        cell.contentLabel.hidden = YES;
        cell.textView.hidden = YES;
        cell.wordCountLabel.hidden = YES;
    } else if (indexPath.row == 1) {
        if (self.modelPersonal.birthday) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",[self.modelPersonal.birthday substringToIndex:10]];
        } else if (self.birthDay) {
            cell.contentLabel.text = self.birthDay;
        } else {
            cell.contentLabel.text = NSLocalizedString(@"VDyourbirthdayText", nil);
        }
        cell.titleLabel.text  = NSLocalizedString(@"VDbirthdayText", nil);
        cell.contentLabel.hidden = NO;
        cell.nameTextField.hidden = YES;
        @weakify(self)
        self.birthDayBlock = ^(NSString * _Nonnull birthString) {
            @strongify(self)
            cell.contentLabel.text = birthString;
            self.birthDay = birthString;
        };
        cell.textView.hidden = YES;
        cell.wordCountLabel.hidden = YES;
    } else if (indexPath.row == 2) {
        if (self.modelPersonal.sex) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.modelPersonal.sex];
        } else if (self.genderString != nil) {
            cell.contentLabel.text = self.genderString;
        } else {
            cell.contentLabel.text = NSLocalizedString(@"VDyourgenderText", nil);
        }
         cell.titleLabel.text  = NSLocalizedString(@"VDgenderText", nil);
        //性别回调
        self.genderBlock = ^(NSString * _Nonnull genderString) {
            cell.contentLabel.text = genderString;
        };
        cell.contentLabel.hidden = NO;
        cell.nameTextField.hidden = YES;
        cell.textView.hidden = YES;
        cell.wordCountLabel.hidden = YES;
    }  else if (indexPath.row == 3) {
        if (self.modelPersonal.agentAcct) {
            cell.textView.text = [NSString stringWithFormat:@"%@",self.modelPersonal.agentAcct];
        }
        cell.titleLabel.text  = NSLocalizedString(@"VDsignatureText", nil);
        cell.contentLabel.hidden = YES;
        cell.nameTextField.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    switch (indexPath.row) {
        case 1:{
            //生日回调
            [CGXPickerView showDatePickerWithTitle:NSLocalizedString(@"VDBirthDayYear", nil)
                                          DateType:UIDatePickerModeDate
                                   DefaultSelValue:nil
                                        MinDateStr:@"1900-01-01 00:00:00"
                                        MaxDateStr:[self.fmt stringFromDate:[NSDate date]]
                                      IsAutoSelect:YES
                                           Manager:nil
                                       ResultBlock:^(NSString *selectValue) {
                @strongify(self)
                DLog(@"年龄%@",selectValue);
                if (self.birthDayBlock) {
                    self.birthDayBlock([NSString stringWithFormat:@"%@",selectValue]);
                }
            }];
        }
            break;
        case 2:{
            //性别回调
            [CGXPickerView showStringPickerWithTitle:NSLocalizedString(@"VDgenderText", nil)
                                          DataSource:@[NSLocalizedString(@"VDmanText", nil),
                                                       NSLocalizedString(@"VDwomanText", nil),
                                                       NSLocalizedString(@"VDSexTong", nil)]
                                     DefaultSelValue:NSLocalizedString(@"VDmanText", nil)
                                        IsAutoSelect:NO
                                             Manager:nil
                                         ResultBlock:^(id selectValue,
                                                       id selectRow) {
                @strongify(self)
                DLog(@"%@",selectValue);
    //            weakSelf.navigationItem.title = selectValue;;
                self.genderString = [NSString stringWithFormat:@"%@",selectValue];
                if (self.genderBlock) {
                    self.genderBlock(self.genderString);
                }
            }];
        }break;
//        case 3:{
//            [CGXPickerView showAddressPickerWithTitle:@"请选择你的城市"
//                                      DefaultSelected:@[@0,@0]
//                                         IsAutoSelect:YES
//                                              Manager:nil
//                                          ResultBlock:^(NSArray *selectAddressArr,
//                                                        NSArray *selectAddressRow) {
//                NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
//                self.regionString = [NSString stringWithFormat:@"%@%@", selectAddressArr[0], selectAddressArr[1]];
//                if (self.regionBlock) {
//                    self.regionBlock(self.regionString);
//                }
//            }];
//        }break;

        default:
            break;
    }
}
#pragma mark —— UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            DLog(@"支持相机");
            [self findPic:SourceTypeCamera];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                           message:@""
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"VDCancelText", nil)
                                                 otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
            [alert show];
        }
    }else if (buttonIndex == 1){//相片
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            DLog(@"支持相册");
            [self findPic:SourceTypeSavedPhotosAlbum];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                           message:NSLocalizedString(@"VDCameraVis", nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"VDCancelText", nil)
                                                 otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
            [alert show];
        }
    }else if (buttonIndex == 2){//图册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            DLog(@"支持图库");
            [self findPic:SourceTypePhotoLibrary];;
            //            [self presentViewController:picker animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"VDTishi", nil)
                                                           message:NSLocalizedString(@"VDCameraVis", nil)
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"VDCancelText", nil)
                                                 otherButtonTitles:NSLocalizedString(@"VDKnow",nil), nil];
            [alert show];
        }
    }
//    else if (buttonIndex == 3){}
}

//用户取消退出picker时候调用
#pragma mark —— UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    DLog(@"%@",picker);
    [_pickerController dismissViewControllerAnimated:YES
                                          completion:^{}];
}
//用户选中图片之后的回调
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    DLog(@"%s,info == %@",__func__,info);
    self.info = info;
    //保存图片
    [_pickerController dismissViewControllerAnimated:YES
                                          completion:^{}];
//    if (self.headerImageBlock) {
//        self.headerImageBlock(self.userImage);
//    }
    self.userImage = [PicHandleTool scaleImage:self.userImage
                                       toScale:0.3f];
    //照片上传
    [self upDateHeadIcon:[PicHandleTool imageWithImageSimple:self.userImage
                                                scaledToSize:CGSizeMake(60, 60)]];
}

#pragma mark —— lazyLoad
-(UIImage *)userImage{
    if (!_userImage) {
        _userImage = [PicHandleTool fixOrientation:[self.info objectForKey:@"UIImagePickerControllerEditedImage"]];
    }return _userImage;
}

-(UIImagePickerController *)pickerController{
    if (!_pickerController) {
        _pickerController = UIImagePickerController.new;
        _pickerController.view.backgroundColor = kOrangeColor;
        _pickerController.delegate = self;
        _pickerController.allowsEditing = YES;
    }return _pickerController;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor =  [UIColor colorWithHexString:@"050013"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[EditDataTableViewCell class]
//           forCellReuseIdentifier:ReuseIdentifier];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.backGroud.mas_bottom);
        }];
    }return _tableView;
}

-(UIImageView *)backGroud{
    if (!_backGroud) {
        _backGroud = UIImageView.new;
        _backGroud.image = kIMG(@"图层 2800");
        _backGroud.userInteractionEnabled = YES;
        [self.view addSubview:_backGroud];
        [_backGroud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Height_NavBar);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(121);
        }];
    }return _backGroud;
}

//-(UIImageView *)headerImage{
//    if (!_headerImage) {
//        _headerImage = UIImageView.new;
//        [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,self.modelPersonal.headerImage]]
//                        placeholderImage:[UIImage imageNamed:@"userImage"]];
//        _headerImage.layer.masksToBounds = YES;
//        _headerImage.layer.cornerRadius = 75/2.0f;
//        [self.backGroud addSubview:_headerImage];
//        [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(10);
//            make.centerX.mas_equalTo(self.backGroud);
//            make.width.mas_equalTo(75);
//            make.height.mas_equalTo(75);
//        }];
//    }return _headerImage;
//}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = UILabel.new;
        _bottomLabel.text = NSLocalizedString(@"VDavatarText", nil);
        _bottomLabel.textColor = [UIColor colorWithHexString:@"EAEAEA"];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.backGroud addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerImageBtn.mas_bottom).offset(8);
            make.centerX.mas_equalTo(self.headerImageBtn.mas_centerX);
            make.height.mas_equalTo(13);
        }];
    }return _bottomLabel;
}

-(UIButton *)headerImageBtn{
    if (!_headerImageBtn) {
        _headerImageBtn = UIButton.new;
        NSString *headerImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"headerImage"];
        NSString *imageString;
        if (self.modelPersonal.headerImage) {
            imageString  = [NSString stringWithFormat:@"%@%@",REQUEST_URL,self.modelPersonal.headerImage];
        } else {
            imageString  = [NSString stringWithFormat:@"%@%@",REQUEST_URL,headerImage];
        }
        [_headerImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageString]
                                             forState:UIControlStateNormal
                                     placeholderImage:kIMG(@"userCenter_selected")];
        [_headerImageBtn addTarget:self
                            action:@selector(headerImageClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        _headerImageBtn.layer.masksToBounds = YES;
        _headerImageBtn.layer.cornerRadius = SCALING_RATIO(75) / 2;
        [self.backGroud addSubview:_headerImageBtn];
        [_headerImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALING_RATIO(10));
            make.centerX.mas_equalTo(self.backGroud);
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(75), SCALING_RATIO(75)));
        }];
    }return _headerImageBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = UIButton.new;
        [_saveBtn setTitle:NSLocalizedString(@"VDsaveText", nil)
                  forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor colorWithHexString:@"EB3053"]
                       forState:UIControlStateNormal];
        [_saveBtn addTarget:self
                     action:@selector(saveBtnClick:)
           forControlEvents:UIControlEventAllEvents];
        _saveBtn.frame = CGRectMake(0,
                                    0,
                                    60,
                                    40);
    }return _saveBtn;
}

-(NSDateFormatter *)fmt{
    if (!_fmt) {
        _fmt = NSDateFormatter.new;
        _fmt.dateFormat = @"EEE MMM dd HH:mm:ss ZZZ yyyy";
        _fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }return _fmt;
}



@end
