//
//  MembershipController.m
//  Clipyeu ++
//
//  Created by Josee on 28/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "MembershipController.h"

@interface MembershipController ()

@property (nonatomic, strong) UILabel    *memberShip;

@property (nonatomic, strong) UIButton    *leftBtn;

@property (nonatomic, strong) UIButton    *rightBtn;

@property (nonatomic, assign) int  count;

@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, strong) UIImageView  *imageMembers;

@end

@implementation MembershipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navTitle =  NSLocalizedString(@"VDMembership", nil);
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
        self.gk_navBarAlpha = 0;
    self.gk_navBackgroundColor = [UIColor colorWithHexString:@"050013"];
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
//    self.gk_navLineHidden = YES;
    self.gk_backStyle =  GKNavigationBarBackStyleWhite;
    self.count = 0;
    [self setupView];
}

- (void)setupView {
    
    [self.view addSubview:self.memberShip];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageMembers];
    
    NSString *titleLabel = [NSString stringWithFormat:@"Cấp Bạc \nSố Lượng subscribe0~300"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
    UIFont *font = [UIFont systemFontOfSize:15];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,8)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(8,titleLabel.length-8)];
    self.memberShip.attributedText = attrString;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(Height_NavBar+7);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(Height_NavBar+7);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    self.leftBtn.layer.masksToBounds = YES;
    self.leftBtn.layer.cornerRadius = 15;
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 15;
    [self.memberShip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftBtn.mas_centerY);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(Height_NavBar+7);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
        
    }];
    self.memberShip.layer.masksToBounds = YES;
    self.memberShip.layer.cornerRadius = 8.0f;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.memberShip.mas_bottom).offset(35);
         make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(0);
        
    }];
    [self.imageMembers mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
        make.top.mas_equalTo(38);
         make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
         make.width.mas_equalTo(SCREEN_WIDTH);
        
          make.bottom.mas_equalTo(-40);
    }];
}

- (NSMutableAttributedString*)changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:20];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,4)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,needText.length-4)];
    
    return attrString;
}


- (UILabel *)memberShip {
    if (!_memberShip) {
        _memberShip = [[UILabel alloc]init];
        _memberShip.textAlignment = NSTextAlignmentCenter;
        _memberShip.textColor = kWhiteColor;
        _memberShip.numberOfLines = 2;
        _memberShip.backgroundColor = [UIColor colorWithHexString:@"BE3462"];
    }
    return _memberShip;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        
        _leftBtn.backgroundColor = [UIColor colorWithHexString:@"807F7F"];
        [_leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"return_right"] forState:UIControlStateNormal];
        
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"807F7F"];
        [_rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
//        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.contentSize = CGSizeMake(0,SCREEN_HEIGHT*2);
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
    }
    return _scrollView;
}

#pragma mark ===================== 点击事件===================================
-(void)refreshAction:(UIButton *)sender{
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (void)leftAction:(UIButton *)sender {
    _count--;
    if (self.count == 1) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp Vàng\nSố Lượng subscribe301 - 1500"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,8)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(8,titleLabel.length-8)];
        self.memberShip.attributedText = attrString;
        self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageB", nil)];
    } else if (self.count == 2) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp Kim Cương\nSố Lượng subscribe1501 - 10000"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,13)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(13,titleLabel.length-13)];
        self.memberShip.attributedText = attrString;
        self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageA", nil)];
    } else if (self.count == 3) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp VIP\nSố Lượng subscribe10001"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,7)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(7,titleLabel.length-7)];
        self.memberShip.attributedText = attrString;
         self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageVIP", nil)];
    } else if (self.count == 0) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp Bạc \nSố Lượng subscribe0~300"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,8)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(8,titleLabel.length-8)];
        self.memberShip.attributedText = attrString;
        self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageC", nil)];
    }
    DLog(@"点击事件%ld",(long)sender.tag);
    [sender setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
    [self.rightBtn setBackgroundColor:[UIColor colorWithHexString:@"807F7F"]];
    
}

- (void)rightAction:(UIButton *)sender {
    
    _count++;
    if (self.count == 1) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp Vàng\nSố Lượng subscribe301 - 1500"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,8)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(8,titleLabel.length-8)];
        self.memberShip.attributedText = attrString;
         self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageB", nil)];
    } else if (self.count == 2) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp Kim Cương\nSố Lượng subscribe1501 - 10000"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,13)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(13,titleLabel.length-13)];
        self.memberShip.attributedText = attrString;
         self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageA", nil)];
    } else if (self.count == 3) {
        NSString *titleLabel = [NSString stringWithFormat:@"Cấp VIP\nSố Lượng subscribe10001"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleLabel];
        UIFont *font = [UIFont systemFontOfSize:15];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,7)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:7] range:NSMakeRange(7,titleLabel.length-7)];
        self.memberShip.attributedText = attrString;
          self.imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageVIP", nil)];
    }
    self.leftBtn.backgroundColor = [UIColor colorWithHexString:@"807F7F"];
    [sender setBackgroundColor:[UIColor colorWithHexString:@"BE3462"]];
}

- (UIImageView *)imageMembers {
    if (!_imageMembers) {
        _imageMembers = [UIImageView new];
        _imageMembers.image = [UIImage imageNamed:NSLocalizedString(@"VIPImageC", nil)];
        _imageMembers.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageMembers;
}

@end
