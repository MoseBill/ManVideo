//
//  SSChatController.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

//if (IOS7_And_Later) {
//    self.automaticallyAdjustsScrollViewInsets = NO;
//}

#import "SSChatController.h"
#import "SSChatKeyBoardInputView.h"
#import "SSAddImage.h"
#import "SSChatBaseCell.h"
#import "SSChatLocationController.h"
#import "SSImageGroupView.h"
#import "SSChatMapController.h"
#import "MXNavigationBarManager.h"

#import "VDHorizontalScrollView.h"

@interface SSChatController ()<SSChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SSChatBaseCellDelegate,CDHorizontalScrollViewDelegate>

//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;

//表单
@property(nonatomic,strong) UITableView *mTableView;
@property(nonatomic,strong) NSMutableArray *datas;

//底部输入框 携带表情视图和多功能视图
@property(nonatomic,strong) SSChatKeyBoardInputView *mInputView;

//访问相册 摄像头
@property(nonatomic,strong) SSAddImage *mAddImage;


@end

@implementation SSChatController


- (instancetype)init  {
    if(self = [super init]){
        _chatType = SSChatConversationTypeChat;
        _datas = [NSMutableArray new];
        VDHorizontalScrollView *hor = [[VDHorizontalScrollView alloc]init];
        hor.delegate = self;
    }
    return self;
}

//不采用系统的旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MXNavigationBarManager reStoreToSystemNavigationBar];
}

- (void)initBarManager {
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    //optional
    [MXNavigationBarManager setTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initBarManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _titleString;
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    _mInputView = [SSChatKeyBoardInputView new];
    _mInputView.backgroundColor = [UIColor colorWithHexString:@"151023"];
    _mInputView.delegate = self;
    _mInputView.userInteractionEnabled = YES;
    [self.view addSubview:_mInputView];
   
    _backViewH = SCREEN_HEIGHT - SSChatKeyBoardInputViewH-SafeAreaTop_Height-SafeAreaBottom_Height;
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_WIDTH, _backViewH);
    _mBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mBackView];
    
    _mTableView = [[UITableView alloc]initWithFrame:_mBackView.bounds style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundColor = [UIColor colorWithHexString:@"050013"];
    _mTableView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"050013"];
    [_mBackView addSubview:self.mTableView];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
    if (@available(iOS 11.0, *)){
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    [_mTableView registerClass:NSClassFromString(@"SSChatTextCell") forCellReuseIdentifier:SSChatTextCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatImageCell") forCellReuseIdentifier:SSChatImageCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatVoiceCell") forCellReuseIdentifier:SSChatVoiceCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatMapCell") forCellReuseIdentifier:SSChatMapCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatVideoCell") forCellReuseIdentifier:SSChatVideoCellId];
    //单聊
    if(_chatType == SSChatConversationTypeChat){
        [_datas addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithChat:_sessionId]];
    }
    //群聊
    else{
        [_datas addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithGroupChat:_sessionId]];
    }
    [_mTableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count==0?0:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [(SSChatMessagelLayout *)_datas[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SSChatMessagelLayout *layout = _datas[indexPath.row];
    SSChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"050013"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    
    return cell;
}

//视图归位
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}
#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
- (void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime {
 
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_WIDTH, height);
        self.mTableView.frame = self.mBackView.bounds;
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } completion:^(BOOL finished) {
    }];
}
//发送文本 列表滚动至底部
-(void)SSChatKeyBoardInputViewBtnClick:(NSString *)string{
    
    NSDictionary *dic = @{@"text":string};
    [self sendMessage:dic messageType:SSChatMessageTypeText];
}
//发送语音
-(void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second{

    NSDictionary *dic = @{@"voice":voice,
                          @"second":@(second)};
    [self sendMessage:dic messageType:SSChatMessageTypeVoice];
}
#pragma mark ===================== delegate 代理 ===================================
- (void)clickActionVideoDelegateArr:(NSMutableArray *)arr {
    
    for (int i =0; i < arr.count; i++) {
        NSDictionary *dic = @{@"videoLocalPath":[arr objectAtIndex:i]};
        [self sendMessage:dic messageType:SSChatMessageTypeVideo];
    }
}

//多功能视图点击回调  图片10  视频11  位置12
- (void)SSChatKeyBoardInputViewBtnClickFunction:(NSInteger)index {
    DLog(@"点击事件%ld",(long)index);
    if (index==11) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyVideoMessage" object:nil];
    }
    if(index==10){
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];
      
        [_mAddImage getImagePickerWithAlertController:self modelType:SSImagePickerModelImage + index-10 pickerBlock:^(SSImagePickerWayStyle wayStyle, SSImagePickerModelType modelType, id object) {
            
            if(index==10) {
                UIImage *image = (UIImage *)object;
                DLog(@"%@",image);
                NSDictionary *dic = @{@"image":image};
                [self sendMessage:dic messageType:SSChatMessageTypeImage];
                
            } else {
             
                NSString *localPath = (NSString *)object;
                DLog(@"%@",localPath);
                NSDictionary *dic = @{@"videoLocalPath":localPath};
                [self sendMessage:dic messageType:SSChatMessageTypeVideo];
                
            }
        }];
        
    } else {
        
//        SSChatLocationController *vc = [SSChatLocationController new];
//        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
//            [self sendMessage:locationDic messageType:SSChatMessageTypeMap];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
//发送消息
-(void)sendMessage:(NSDictionary *)dic messageType:(SSChatMessageType)messageType{

    [SSChatDatas sendMessage:dic sessionId:_sessionId messageType:messageType messageBlock:^(SSChatMessagelLayout *layout, NSError *error, NSProgress *progress) {
        
        [self.datas addObject:layout];
        [self.mTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }];
    
}


#pragma SSChatBaseCellDelegate 点击图片 点击短视频
- (void)SSChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout {
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    
    for(int i=0;i<self.datas.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        SSChatBaseCell *cell = [_mTableView cellForRowAtIndexPath:ip];
        SSChatMessagelLayout *mLayout = self.datas[i];
        
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == SSChatMessageTypeImage){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.image;
        }
        else if (mLayout.message.messageType == SSChatMessageTypeVideo){
            item.imageType = SSImageGroupVideo;
            item.videoPath = mLayout.message.videoLocalPath;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.videoImage;
        }
        else continue;
        
        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout])currentIndex = groupItems.count;
        [groupItems addObject:item];
        
    }
    
    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    [self.navigationController.view addSubview:imageGroupView];
    
    __block SSImageGroupView *blockView = imageGroupView;
    blockView.dismissBlock = ^{
        [blockView removeFromSuperview];
        blockView = nil;
    };
    
    [self.mInputView SetSSChatKeyBoardInputViewEndEditing];
}

#pragma SSChatBaseCellDelegate 点击定位
-(void)SSChatMapCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout{
    
    SSChatMapController *vc = [SSChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
