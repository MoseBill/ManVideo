//
//  ZMCusCommentListView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Josee. All rights reserved.
//

#import "ZMCusCommentListView.h"
#import "DemoVC9.h"
#import <Masonry.h>
#import "UIColor+FKColor.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "WTBottomInputView.h"
#import "CommentModel.h"
#import "NSDictionary+XHLogHelper.h"
#define kTimeLineTableViewCellId @"SDTimeLineCell"

static CGFloat textFieldH = 40;

@interface ZMCusCommentListView()<UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate, UITextFieldDelegate,WTBottomInputViewDelegate,ReplyInformationDelegate>
{
    NSMutableArray * _dataSource;
    NSMutableDictionary * paramDic;
    WTBottomInputView * bottomView;
    
}
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, strong) NSMutableArray *dataArray1;

@property (nonatomic, strong) NSMutableArray * commentArr;

@property (nonatomic, strong) NSMutableArray * childCommentArr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong)  UITableView * tableView;


@end


@implementation ZMCusCommentListView
{
    SDTimeLineRefreshFooter *_refreshFooter;
    SDTimeLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    //    UITextField *_textField;
    CGFloat _totalKeybordHeight;
    NSIndexPath *_currentEditingIndexthPath;
}

- (NSMutableArray *)modelArr
{
    if (_modelArr == nil)
    {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15;
            [bottomView showView];  //此句用于在跳回时让bottomBox显示
//        [bottomView.textView resignFirstResponder];
//        [bottomView hideView];   //此句用于在跳出其他页时让bottomBox消失
        //    self.automaticallyAdjustsScrollViewInsets = NO;
        //    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
//        [self loadNetWork];
        [self setupView];
        //     [self exampleRefresh];
     
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
      
    }
    return self;
}

- (void)setupView {
    
    self.tableView = [[UITableView alloc]init];
    [self addSubview:self.tableView];
    bottomView = [[WTBottomInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    bottomView.delegate = self;
    bottomView.delegateReply = self;
    bottomView.backgroundColor = yellow_color;
   [self.tableView addSubview:bottomView];
//    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
//    [keyWindow addSubview:bottomView];
   
    //添加分隔线颜色设置
//    self.tableView.lee_theme
//    .LeeAddSeparatorColor(DAY , [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
//    .LeeAddSeparatorColor(NIGHT , [[UIColor grayColor] colorWithAlphaComponent:0.5f]);
    
    self.tableView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 50);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, TAB_BAR_HEIGHT, 0);
    self.tableView.backgroundColor =  kWhiteColor;
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    // 解决在iOS11上朋友圈demo文字收折或者展开时出现cell跳动问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
}


- (void)WTBottomInputViewSendTextMessage:(NSString *)message
{
    NSLog(@"=======>>%@",message);
    [self loadNetWork:message];
    if (message) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    bottomView.textView.text = @"";
}
#pragma mark ===================== 评论 ==================================
- (void)loadNetWork:(NSString *)text {
    
//    NSString *packageName = @"com.MOA.MOABBS";
//    NSString *articleId = [NSString stringWithFormat:@"%d",self.artId];
//    NSDictionary *dic = @{@"articleId":articleId,@"comment":text,@"packageName":packageName};
    //    NetWorkManager *netWork = [[NetWorkManager alloc]init];
    //    WS(weakSelf)
    //    //    @weakify(self);
    //    [netWork requestNetworkUrl:@"/bbs/comment/add" paraDict:dic successBlock:^(NSDictionary *dict) {
    //        NSLog(@"评论接口%@",dict);
    //        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    //        // 并发队列的创建方法
    //        //        dispatch_queue_t queue = dispatch_queue_create("net.bujige.tcsQueue", DISPATCH_QUEUE_CONCURRENT);
    //        //        dispatch_async(queue, ^{
    //        //            @strongify(self);
    //
    //        //            dispatch_async(dispatch_get_main_queue(), ^{
    //
    //        //                [self.collectView1 reloadData];
    //        //            [self loadNetWork];
    //        //            });
    //        [weakSelf loadNetWork];
    //
    //        //        });
    //
    //    } errorBlock:^(NSString *message) {
    //        [SVProgressHUD showErrorWithStatus:@"上传资料错误"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
    
}
#pragma mark ===================== 回复 ==================================

- (void)loadNetWorkReply:(NSDictionary *)dict {
    
    NSString *string = dict[@"articId"];
    
    NSString *packageName = @"com.MOA.MOABBS";
    NSString *articleId = [NSString stringWithFormat:@"%@",string];
    
    NSDictionary *dic = @{@"articleId":articleId,@"comment":dict[@"message"],@"packageName":packageName,@"parent_id":dict[@"Id"]};
    //    NetWorkManager *netWork = [[NetWorkManager alloc]init];
    //
    //    //    @weakify(self);
    //
    //    [netWork requestNetworkUrl:@"/bbs/comment/add" paraDict:dic successBlock:^(NSDictionary *dict) {
    //        [SVProgressHUD showSuccessWithStatus:@"回复成功"];
    //        //        if ([self.delegate respondsToSelector:@selector(endEiet:)]) {
    //        //            [self.delegate endEiet:@"回复成功"];
    //        //        }
    //        NSLog(@"回复接口%@",dict);
    //        [self loadNetWork];
    //
    //    } errorBlock:^(NSString *message) {
    //        [SVProgressHUD showErrorWithStatus:@"上传资料错误"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
    
}

#pragma mark ===================== 刷新数据 ==================================
- (void)exampleRefresh
{
    __weak typeof(self) weakSelf = self;
    // 上拉加载
    _refreshFooter = [SDTimeLineRefreshFooter refreshFooterWithRefreshingText:@"正在加载数据..."];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    [_refreshFooter addToScrollView:self.tableView refreshOpration:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.commentArr addObjectsFromArray:[weakSelf creatModelsWithCount:10]];
            
            [weakSelf loadNetWork];
            
            [weakSelf.tableView reloadDataWithExistedHeightCache];
            
            [weakRefreshFooter endRefreshing];
        });
    }];
}

- (void)loadNetWork {
    
    [self.dataArray1 removeAllObjects];
    
    NSDictionary *dic = [[NSDictionary alloc]init];
    //    NetWorkManager *netWork = [[NetWorkManager alloc]init];
    //    NSString *packageName = @"com.MOA.MOABBS";
    //    NSString *urlString = [NSString stringWithFormat:@"/bbs/article/find/%d/%@",self.artId,packageName];
    //    WS(weakSelf)
    //    [netWork requestSecurityGET:urlString paraDictionary:dic successBlock:^(NSDictionary *dict) {
    //        JMLog(@"查看评论详情%@",[dict descriptionWithLocale:dict]);
    //        [self.commentArr removeAllObjects];
    //        SDTimeLineCellModel *model = [SDTimeLineCellModel mj_objectWithKeyValues:dict[@"data"]];
    //        NSArray *arr = [SDTimeLineCellModel mj_objectArrayWithKeyValuesArray:dict[@"data"][@"commentList"]];
    //        self.dataSource = (NSMutableArray *)arr;
    //        [self.dataArray1 addObject:model];
    //        for (int i =0; i < arr.count; i++) {
    //            SDTimeLineCellModel *models = arr[i];
    //            [self.commentArr addObject:models];
    //        }
    //
    //        [self.tableView reloadData];
    //        NSLog(@"评论模型%@",self.commentArr);
    //
    //    } errorBlock:^(NSString *message) {
    //        [SVProgressHUD showErrorWithStatus:@"上传资料错误"];
    //    } failBlock:^(NSError *error) {
    //        [SVProgressHUD showErrorWithStatus:@"当前无网络"];
    //    }];
}

- (void)dealloc
{
    [bottomView.textView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 右栏目按钮点击事件
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        
        [LEETheme startTheme:NIGHT];
        
    } else {
        [LEETheme startTheme:DAY];
    }
}

- (NSArray *)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        
        
        // 模拟“随机图片”
        int random = arc4random_uniform(6);
        
        NSMutableArray *temp = [NSMutableArray new];
        
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
        
        // 模拟随机评论数据
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            commentItemModel.firstUserName = namesArray[index];
            commentItemModel.firstUserId = @"666";
            if (arc4random_uniform(10) < 5) {
                commentItemModel.secondUserName = namesArray[arc4random_uniform((int)namesArray.count)];
                commentItemModel.secondUserId = @"888";
            }
            commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        
        // 模拟随机点赞数据
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            SDTimeLineCellLikeItemModel *model = [SDTimeLineCellLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        
        model.likeItemsArray = [tempLikes copy];
        
        
        
        [resArr addObject:model];
    }
    return [resArr copy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    cell.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.commentArr[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        cell.delegate = self;
    }
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.model = self.commentArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.commentArr[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [bottomView.textView resignFirstResponder];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - SDTimeLineCellDelegate

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
    [bottomView.textView becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    NSLog(@"人才%ld",(long)_currentEditingIndexthPath.row);
    SDTimeLineCellModel *model = self.commentArr[_currentEditingIndexthPath.row];
    //    JMLog(@"评论回复ID%@",model.ID);
    // 创建一个通知中心
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSDictionary *dic = @{@"articId":[NSString stringWithFormat:@"%ld",(long)model.articleId],@"Id":[NSString stringWithFormat:@"%@",model.ID]};
    // 发送通知. 其中的Name填写第一界面的Name， 系统知道是第一界面来相应通知， object就是要传的值。 UserInfo是一个字典， 如果要用的话，提前定义一个字典， 可以通过这个来实现多个参数的传值使用。
    [center postNotificationName:@"comment" object:@"zhangheng" userInfo:dic];
    
    //    [self adjustTableViewToFitKeyboard];
    
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    SDTimeLineCellModel *model = self.dataArray1[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    if (!model.isLiked) {
        SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
        likeModel.userName = @"GSD_iOS";
        likeModel.userId = @"gsdios";
        [temp addObject:likeModel];
        model.liked = YES;
    } else {
        SDTimeLineCellLikeItemModel *tempLikeModel = nil;
        for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
            if ([likeModel.userId isEqualToString:@"gsdios"]) {
                tempLikeModel = likeModel;
                break;
            }
        }
        [temp removeObject:tempLikeModel];
        model.liked = NO;
    }
    model.likeItemsArray = [temp copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [bottomView.textView resignFirstResponder];
        
        SDTimeLineCellModel *model = self.commentArr[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.chlid_commentList];
        
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        commentItemModel.firstUserName = @"GSD_iOS";
        commentItemModel.commentString = textField.text;
        commentItemModel.firstUserId = @"GSD_iOS";
        [temp addObject:commentItemModel];
        
        model.chlid_commentList = [temp copy];
        
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        return YES;
    }
    return NO;
}



- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        //        self->_textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}

- (void)replyInformationMessage:(NSDictionary *)dict {
    
    [self loadNetWorkReply:dict];
}

- (NSMutableArray *)childCommentArr {
    
    if (!_childCommentArr) {
        _childCommentArr = [NSMutableArray new];
    }
    return _childCommentArr;
}

//- (NSMutableArray *)dataArray1 {
//
//    if (!_dataArray1) {
//        _dataArray1 = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _dataArray1;
//}

- (NSMutableArray *)commentArr {
    
    if (!_commentArr) {
        _commentArr = [NSMutableArray new];
    }
    return _commentArr;
}

@end
