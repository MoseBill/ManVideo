//
//  DemoVC9.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "CommentVC.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "WTBottomInputView.h"
#import "CommentModel.h"
#import "SDTimeLineCellCommentView.h"
#import "CancelIMGV.h"
#import "CommentVC+VM.h"

//#import "SDTimeLineCellModel.h"
//#import "NSDictionary+XHLogHelper.h"
//#import "LEETheme.h"
//#import "LZTabBarVC.h"
//#import "UITableView+SDAutoTableViewCellHeight.h"
//#import "UIView+SDAutoLayout.h"
//#import "CommentsTableViewCell.h"
//#import "HeaderCollectionViewCell.h"
//#import "SJAvatarBrowser.h"
//#import "CommentDetail.h"
//#import "JYEqualCellSpaceFlowLayout.h"
//#import "MiddleViewController.h"
//#import "SDTimeLineTableHeaderView.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;

@interface CommentVC ()
<
//SDTimeLineCellDelegate,
UITextFieldDelegate,
WTBottomInputViewDelegate,
//ReplyInformationDelegate,
ReplyActionDelegate,
UITableViewDelegate,
UITableViewDataSource
>


@property(nonatomic,strong)WTBottomInputView *bottomView;
@property(nonatomic,strong)CancelIMGV *cancel;
@property(nonatomic,strong)PersonalCenterVC *personal;
@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;
@property(nonatomic,strong)ViewForHeader *viewForHeader;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *childCommentArr;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *replyArr;

@end

@implementation CommentVC{
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
    NSIndexPath *_currentEditingIndexthPath;
    CGFloat cellHeight;
    CGFloat bottomViewHeight;
}

- (void)dealloc{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
    [self.bottomView.textView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    if (self = [super init]) {
//        _isRequestFinish = NO;//刚进入界面是没有完成请求数据的
    }return self;
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

#pragma mark —— lifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
    self.title = NSLocalizedString(@"VDcommentsText", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"050013"];
    self.tableView.alpha = 1;
    self.bottomView.alpha = 1;
    extern LZTabBarVC *tabBarVC;
    tabBarVC.tabBar.hidden = YES;//隐藏 LZTabBarVC
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bottomView showView];  //此句用于在跳回时让bottomBox显示
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bottomView.textView resignFirstResponder];
    [self.bottomView hideView]; //此句用于在跳出其他页时让bottomBox消失
}
#pragma mark —— WTBottomInputViewDelegate
- (void)WTBottomInputViewSendTextMessage:(NSString *)message{
    [self sendMeg:message];
}
#pragma mark —— SDTimeLineCellDelegate
- (void)didPushUserView:(UITapGestureRecognizer *)tap {
    [self.navigationController pushViewController:self.personal
                                         animated:YES];
}
#pragma mark —— UITableViewDelegate & UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    self.viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    [self.viewForHeader actionBlock:^(id  _Nonnull data) {
        //点击viewForHeader回调
        if (self.block) {
            self.block(@1);
        }
    }];
    return self.viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(30);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    if (!cell) {
        cell = [[SDTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:ReuseIdentifier];
    }
    cell.indexPath = indexPath;
//    cell.backgroundColor = RandomColor;
    cell.userInteractionEnabled = YES;
//    cell.delegate = self;
    @weakify(self)
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            @strongify(self)
            SDTimeLineCellModel *model = self.commentArr[indexPath.row];
            model.isOpening = !model.isOpening;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                               withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    [cell richElementsInCellWithModel:self.commentArr[indexPath.row]];
    cellHeight = [cell cellHeightWithModel:self.commentArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
//
//    //  1.实例化UIAlertController对象
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"VDTishi", nil)
//                                                                   message:nil
//                                                            preferredStyle:UIAlertControllerStyleActionSheet];
//    @weakify(self)
//    //  2.1实例化UIAlertAction按钮:确定按钮
//    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDhuifu", nil)
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * _Nonnull action) {
//                                                              @strongify(self)
//                                                              // 点击按钮，调用此block
//                                                                  [self didClickcCommentButtonInCell:cell];
//                                                          }];
//    [alert addAction:defaultAction];
//    //  2.3实例化UIAlertAction按钮:取消按钮
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"VDCancelText", nil)
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * _Nonnull action) {
//                                                             // 点击取消按钮，调用此block
//                                                             DLog(@"取消按钮被按下！");
//                                                         }];
//    [alert addAction:cancelAction];
//    //  3.显示alertController
//    [self presentViewController:alert
//                       animated:YES
//                     completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
#pragma mark —— private method
-(void)pullToRefresh{
    [self loadDataView];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

-(void)loadMoreRefresh{
    [self loadDataView];
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}

-(void)sendMeg:(NSString *)message{
    [self.view endEditing:YES];
    [self loadNetWork:message];
    self.bottomView.textView.text = @"";
}

- (void)keyboardNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (endFrame.origin.y < beginFrame.origin.y) {//展开键盘
        bottomViewHeight = self.bottomView.mj_y;

        self.bottomView.mj_y = endFrame.origin.y - self.bottomView.mj_h - (isiPhoneX_series() ? 80 : 50);
    }else{//收回键盘
        self.bottomView.mj_y = bottomViewHeight - SCALING_RATIO(20);
        [self.bottomView removeFromSuperview];
        [self.view removeFromSuperview];
    }
}

- (void)cancelClick{
//    [self.bottomView hideView];
//    [self.bottomView removeFromSuperview];
//    [self.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell{
    [self.bottomView.textView becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.commentArr[_currentEditingIndexthPath.row];
    // 创建一个通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary *dic = @{@"articId":[NSString stringWithFormat:@"%ld",(long)model.articleId],
                          @"Id":[NSString stringWithFormat:@"%ld",(long)model.ID]};
    // 发送通知. 其中的Name填写第一界面的Name， 系统知道是第一界面来相应通知， object就是要传的值。 UserInfo是一个字典， 如果要用的话，提前定义一个字典， 可以通过这个来实现多个参数的传值使用。
    [center postNotificationName:@"comment"
                          object:@"zhangheng"
                        userInfo:dic];
}
#pragma mark —— UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.bottomView.textView resignFirstResponder];
}

- (CGFloat)cellContentViewWith{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait &&
        [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }return width;
}
#pragma mark - SDTimeLineCellDelegate
- (void)clickActionHeaderImage:(NSString *)image {
    if ([self.delegate respondsToSelector:@selector(clickActionPushPerson:)])
        [self.delegate clickActionPushPerson:image];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)replyDidTap:(UIButton *)tap  {

}

- (void)didReplyAction:(SDTimeLineCellModel *)model {
    self.model = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendReplyMessage"
                                                        object:@"replyMesage"];
}

- (void)replyClickView:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didReplyActionDelegate:)]) {
        [self.delegate didReplyActionDelegate:sender];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [self.bottomView.textView resignFirstResponder];
        SDTimeLineCellModel *model = self.commentArr[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.replyList];
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        commentItemModel.firstUserName = @"GSD_iOS";
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = @"GSD_iOS";
        [temp addObject:commentItemModel];
        model.replyList = [temp copy];
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath]
                           withRowAnimation:UITableViewRowAnimationNone];
        return YES;
    }return NO;
}
#pragma mark —— ReplyInformationDelegate
- (void)replyInformationMessage:(NSDictionary *)dict {
    [self.bottomView.textView endEditing:YES];
    [self loadNetWorkReply:dict];
}
#pragma mark —— ReplyActionDelegate
- (void)replyTapClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didReplyActionDelegate:)]) {
        [self.delegate didReplyTapDelegate:0];
    }
}
#pragma mark —— lazyLoad
-(UILabel *)lab{
    if (!_lab) {
        _lab = UILabel.new;
        _lab.textColor = kWhiteColor;
        _lab.font = [UIFont systemFontOfSize:12];
        _lab.textAlignment = NSTextAlignmentCenter;
        [self.viewForHeader addSubview:_lab];
        [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.viewForHeader);
            make.centerY.mas_equalTo(self.viewForHeader);
        }];
    }return _lab;
}

-(CancelIMGV *)cancel{
    if (!_cancel) {
        _cancel = CancelIMGV.new;
        [_cancel setImage:kIMG(@"close")];
        [self.viewForHeader addSubview:_cancel];
        @weakify(self)
        [_cancel setMyBlock:^{
            @strongify(self)
            [self cancelClick];
        }];
        [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.viewForHeader);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
    }return _cancel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"050013"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        [_tableView registerClass:[ViewForHeader class] forHeaderFooterViewReuseIdentifier:ReuseIdentifier];
        //添加分隔线颜色设置
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(self.view);
            extern CGFloat CommentViewHeight;
            make.height.mas_equalTo(CommentViewHeight - self.bottomView.mj_h - (isiPhoneX_series() ? 50 : 0));
        }];
    }return _tableView;
}

-(MJRefreshGifHeader *)tableViewHeader{
    if (!_tableViewHeader) {
        _tableViewHeader =  [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                       refreshingAction:@selector(pullToRefresh)];
        // 设置普通状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewHeader setTitle:@"Click or drag down to refresh" forState:MJRefreshStateIdle];
        [_tableViewHeader setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_tableViewHeader setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewHeader.stateLabel.textColor = KLightGrayColor;
    }return _tableViewHeader;
}

-(MJRefreshAutoGifFooter *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadMoreRefresh)];
        // 设置普通状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"官方")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewFooter setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
        [_tableViewFooter setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [_tableViewFooter setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewFooter.stateLabel.textColor = KLightGrayColor;
        _tableViewFooter.hidden = YES;
    }return _tableViewFooter;
}

-(WTBottomInputView *)bottomView{
    if (!_bottomView) {
        _bottomView = WTBottomInputView.new;
        _bottomView.backgroundColor = kRedColor;
        _bottomView.userInteractionEnabled = YES;
        _bottomView.delegate = self;
        @weakify(self)
        _bottomView.MyBlock = ^{
            @strongify(self)
            [self.view endEditing:YES];
        };
//        _bottomView.delegateReply = self;
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset( - (isiPhoneX_series() ? 50 : 0));
            make.height.mas_equalTo(isiPhoneX_series() ? SCALING_RATIO(30) : SCALING_RATIO(50));
        }];
        [self.view layoutIfNeeded];
    }return _bottomView;
}

- (NSMutableArray *)childCommentArr {
    if (!_childCommentArr) {
        _childCommentArr = NSMutableArray.array;
    }return _childCommentArr;
}

- (NSMutableArray *)replyArr {
    if (!_replyArr) {
        _replyArr = NSMutableArray.array;
    }return _replyArr;
}

-(NSMutableArray<SDTimeLineCellModel *> *)commentArr{
    if (!_commentArr) {
        _commentArr = NSMutableArray.array;
    }return _commentArr;
}

-(PersonalCenterVC *)personal{
    if (!_personal) {
        _personal = PersonalCenterVC.new;
    }return _personal;
}

#pragma mark —— 疑似被废弃的
//- (void)didClickLikeButtonInCell:(UITableViewCell *)cell{
//    NSIndexPath *index = [self.tableV indexPathForCell:cell];
//    SDTimeLineCellModel *model = self.commentArr[index.row];
//    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.replyList];
//    if (!model.isLiked) {
//        SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
//        likeModel.userName = @"GSD_iOS";
//        likeModel.userId = @"gsdios";
//        [temp addObject:likeModel];
//        model.liked = YES;
//    } else {
//        SDTimeLineCellLikeItemModel *tempLikeModel = nil;
//        for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
//            if ([likeModel.userId isEqualToString:@"gsdios"]) {
//                tempLikeModel = likeModel;
//                break;
//            }
//        }
//        [temp removeObject:tempLikeModel];
//        model.liked = NO;
//    }
//    model.replyList = [temp copy];
//    @weakify(self)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                                 (int64_t)(0.25 * NSEC_PER_SEC)),
//                   dispatch_get_main_queue(), ^{
//                       @strongify(self)
//                       [self.tableV reloadRowsAtIndexPaths:@[index]
//                                          withRowAnimation:UITableViewRowAnimationNone];
//    });
//}

//- (void)replyClickView:(UIButton *)sender {
//
//    if ([self.delegate respondsToSelector:@selector(didReplyActionDelegate:)]) {
//        [self.delegate didReplyActionDelegate:sender];
//    }
//}

@end
