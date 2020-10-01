//
//  VDCircleListView.m
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "VDCircleListView.h"

#import "VDCircleListViewModel.h"
//#import "VDListTableViewCell.h"

@interface VDCircleListView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) VDCircleListViewModel *viewModel;

@property (strong, nonatomic) UITableView *mainTableView;

//@property (strong, nonatomic) LSCircleListHeaderView *listHeaderView;
//
//@property (strong, nonatomic) LSCircleListSectionHeaderView *sectionHeaderView;

@end

@implementation VDCircleListView

#pragma mark - system
//- (instancetype)initWithViewModel:(id<VDViewModelProtocol>)viewModel {
//
//    self.viewModel = (VDCircleListViewModel *)viewModel;
//    return [super initWithViewModel:viewModel];
//}
//
//- (void)updateConstraints {
//
//    @weakify(self)
//    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self)
//        make.edges.equalTo(self);
//    }];
//    [super updateConstraints];
//}
//
//#pragma mark - private
//- (void)yd_setupViews {
//
//    [self addSubview:self.mainTableView];
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//}
//
//- (void)yd_bindViewModel {
//
//    [self.viewModel.refreshDataCommand execute:nil];
//
//    @weakify(self);
//
//    [self.viewModel.refreshUI subscribeNext:^(id x) {
//
//        @strongify(self);
//        [self.mainTableView reloadData];
//    }];
//
//    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
//        @strongify(self);
//
//        [self.mainTableView reloadData];
//
//        switch ([x integerValue]) {
//            case LSHeaderRefresh_HasMoreData: {
//
////                [self.mainTableView.mj_header endRefreshing];
//
//                if (self.mainTableView.mj_footer == nil) {
//
////                    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
////                        @strongify(self);
////                        [self.viewModel.nextPageCommand execute:nil];
////                    }];
//                }
//            }
//                break;
//            case LSHeaderRefresh_HasNoMoreData: {
//
////                [self.mainTableView.mj_header endRefreshing];
////                self.mainTableView.mj_footer = nil;
//            }
//                break;
//            case LSFooterRefresh_HasMoreData: {
//
////                [self.mainTableView.mj_header endRefreshing];
////                [self.mainTableView.mj_footer resetNoMoreData];
////                [self.mainTableView.mj_footer endRefreshing];
//            }
//                break;
//            case LSFooterRefresh_HasNoMoreData: {
////                [self.mainTableView.mj_header endRefreshing];
////                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
//            }
//                break;
//            case LSRefreshError: {
//
////                [self.mainTableView.mj_footer endRefreshing];
////                [self.mainTableView.mj_header endRefreshing];
//            }
//                break;
//
//            default:
//                break;
//        }
//    }];
//}
//
//#pragma mark - lazyLoad
//- (VDCircleListViewModel *)viewModel {
//    if (!_viewModel) {
//
//        _viewModel = [[VDCircleListViewModel alloc] init];
//    }
//
//    return _viewModel;
//}
//
//- (UITableView *)mainTableView {
//
//    if (!_mainTableView) {
//
//        _mainTableView = [[UITableView alloc] init];
//        _mainTableView.delegate = self;
//        _mainTableView.dataSource = self;
////        _mainTableView.backgroundColor = GX_BGCOLOR;
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////        _mainTableView.tableHeaderView = self.listHeaderView;
////        estimatedRowHeight estimatedSectionHeaderHeight estimatedSectionFooterHeight
//        _mainTableView.estimatedRowHeight = 0;
//        _mainTableView.estimatedSectionHeaderHeight = 0;
//        _mainTableView.estimatedSectionFooterHeight = 0;
//        [_mainTableView registerClass:[VDListTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([VDListTableViewCell class])]];
//
////        @weakify(self)
////        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////            @strongify(self)
////            [self.viewModel.refreshDataCommand execute:nil];
////        }];
////        _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////            @strongify(self)
////            [self.viewModel.nextPageCommand execute:nil];
////        }];
//    }
//
//    return _mainTableView;
//}

//- (LSCircleListHeaderView *)listHeaderView {
//
//    if (!_listHeaderView) {
//
//        _listHeaderView = [[LSCircleListHeaderView alloc] initWithViewModel:self.viewModel.listHeaderViewModel];
//        _listHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 160);
//    }
//
//    return _listHeaderView;
//}

//- (LSCircleListSectionHeaderView *)sectionHeaderView {
//
//    if (!_sectionHeaderView) {
//
//        _sectionHeaderView = [[LSCircleListSectionHeaderView alloc] initWithViewModel:self.viewModel.sectionHeaderViewModel];
//    }
//
//    return _sectionHeaderView;
//}

#pragma mark - delegate

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.dataArray.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    LSCircleListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([LSCircleListTableCell class])] forIndexPath:indexPath];
//
//    if (self.viewModel.dataArray.count > indexPath.row) {
//
//        cell.viewModel = self.viewModel.dataArray[indexPath.row];
//    }
//
//    return cell;
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel.cellClickSubject sendNext:nil];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    return self.sectionHeaderView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

@end
