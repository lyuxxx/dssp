//
//  LoveCarViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LoveCarViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "TopImgButton.h"
#import "NSArray+Sudoku.h"

@interface LoveCarViewController ()

@property (nonatomic, strong) UILabel *plateLabel;
@property (nonatomic, strong) UIImageView *carImgV;
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *oilLeftLabel;
@property (nonatomic, strong) UILabel *healthLabel;

@end

@implementation LoveCarViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"爱车", nil);
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kTabbarHeight, 0));
    }];
    
    UIView *content = [[UIView alloc] init];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(kScreenWidth);
    }];
    
    UIImageView *previewImgV = [[UIImageView alloc] init];
    previewImgV.layer.cornerRadius = 4;
    previewImgV.layer.shadowOffset = CGSizeMake(0, 0);
    previewImgV.layer.shadowColor = [UIColor colorWithHexString:@"#333333"].CGColor;
    previewImgV.layer.shadowOpacity = 0.5;
    previewImgV.layer.shadowRadius = 14.5;
    previewImgV.backgroundColor = [UIColor colorWithHexString:@"#3a302f"];
    [content addSubview:previewImgV];
    [previewImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(content);
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(167.5 * HeightCoefficient);
        make.top.equalTo(content).offset(20 * HeightCoefficient);
    }];
    
    self.plateLabel = [[UILabel alloc] init];
    _plateLabel.text = @"鄂A12345";
    _plateLabel.font = [UIFont fontWithName:@"PingFangSC" size:16];
    _plateLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    [previewImgV addSubview:_plateLabel];
    [_plateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(164.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(8 * HeightCoefficient);
    }];
    
    self.carImgV = [[UIImageView alloc] init];
    _carImgV.image = [UIImage imageNamed:@"11"];
    [previewImgV addSubview:_carImgV];
    [_carImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(230 * WidthCoefficient);
        make.height.equalTo(106.5 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(48 * HeightCoefficient);
    }];
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.font = [UIFont fontWithName:FontName size:11];
    label0.textAlignment = NSTextAlignmentRight;
    label0.text = NSLocalizedString(@"总里程", nil);
    label0.textColor = [UIColor colorWithHexString:GeneralColorString];
    [previewImgV addSubview:label0];
    [label0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.right.equalTo(-15 * WidthCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont fontWithName:FontName size:11];
    label1.textAlignment = NSTextAlignmentRight;
    label1.text = NSLocalizedString(@"剩余油量", nil);
    label1.textColor = [UIColor colorWithHexString:GeneralColorString];
    [previewImgV addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.right.equalTo(-15 * WidthCoefficient);
        make.top.equalTo(61 * HeightCoefficient);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label1.font = [UIFont fontWithName:FontName size:11];
    label2.textAlignment = NSTextAlignmentRight;
    label2.text = NSLocalizedString(@"车况健康", nil);
    label2.textColor = [UIColor colorWithHexString:GeneralColorString];
    [previewImgV addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.right.equalTo(-15 * WidthCoefficient);
        make.top.equalTo(112 * HeightCoefficient);
    }];
    
    self.mileageLabel = [[UILabel alloc] init];
    _mileageLabel.font = [UIFont fontWithName:FontName size:16];
    _mileageLabel.textAlignment = NSTextAlignmentRight;
    _mileageLabel.textColor = [UIColor whiteColor];
    _mileageLabel.text = @"12903 km";
    [previewImgV addSubview:_mileageLabel];
    [_mileageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(21 * HeightCoefficient);
        make.top.equalTo(25.5 * HeightCoefficient);
        make.right.equalTo(- 15.2 * WidthCoefficient);
    }];
    
    self.oilLeftLabel = [[UILabel alloc] init];
    _oilLeftLabel.font = [UIFont fontWithName:FontName size:16];
    _oilLeftLabel.textAlignment = NSTextAlignmentRight;
    _oilLeftLabel.textColor = [UIColor whiteColor];
    _oilLeftLabel.text = @"28 L";
    [previewImgV addSubview:_oilLeftLabel];
    [_oilLeftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(21 * HeightCoefficient);
        make.top.equalTo(74.5 * HeightCoefficient);
        make.right.equalTo(- 15.2 * WidthCoefficient);
    }];
    
    self.healthLabel = [[UILabel alloc] init];
    _healthLabel.font = [UIFont fontWithName:FontName size:16];
    _healthLabel.textAlignment = NSTextAlignmentRight;
    _healthLabel.textColor = [UIColor whiteColor];
    _healthLabel.text = @"健康";
    [previewImgV addSubview:_healthLabel];
    [_healthLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(25 * HeightCoefficient);
        make.top.equalTo(128 * HeightCoefficient);
        make.right.equalTo(- 15.2 * WidthCoefficient);
    }];
    
    UIView *btnContainer = [[UIView alloc] init];
    btnContainer.backgroundColor = [UIColor whiteColor];
    [content addSubview:btnContainer];
    [btnContainer makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(content);
        make.height.equalTo(270 * HeightCoefficient);
        make.top.equalTo(previewImgV.bottom).offset(12 * HeightCoefficient);
        make.centerX.equalTo(content);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"智慧出行", nil),NSLocalizedString(@"智慧停车", nil),NSLocalizedString(@"智慧加油", nil),NSLocalizedString(@"收藏夹", nil),NSLocalizedString(@"wifi密码", nil),NSLocalizedString(@"预约保养", nil),NSLocalizedString(@"流量查询", nil),NSLocalizedString(@"盗车提醒", nil),NSLocalizedString(@"车况报告", nil),NSLocalizedString(@"驾驶行为", nil),NSLocalizedString(@"违章查询", nil),NSLocalizedString(@"环保驾驶", nil)];
    NSArray *imgTitles = @[@"智慧出行_icon",@"智慧停车_icon",@"智慧加油_icon",@"收藏夹_icon",@"wifi密码_icon",@"预约保养_icon",@"流量查询_icon",@"盗车提醒_icon",@"车况报告_icon",@"驾驶行为_icon",@"违章查询_icon",@"环保驾驶_icon"];
    NSMutableArray<TopImgButton *> *btns = [NSMutableArray new];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        TopImgButton *btn = [TopImgButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"#040000"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FontName size:13];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgTitles[i]] forState:UIControlStateNormal];
        [btnContainer addSubview:btn];
        [btns addObject:btn];
    }
    
    [btns mas_distributeSudokuViewsWithFixedLineSpacing:23.5 * HeightCoefficient fixedInteritemSpacing:35.5 * WidthCoefficient warpCount:4 topSpacing:14.5 * HeightCoefficient bottomSpacing:26.5 * HeightCoefficient leadSpacing:29 * WidthCoefficient tailSpacing:29 * WidthCoefficient];
    
    UIView *space = [[UIView alloc] init];
    space.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
    [content addSubview:space];
    [space makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(scroll);
        make.height.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(btnContainer.bottom);
    }];
    
    UILabel *storeLabel = [[UILabel alloc] init];
    storeLabel.text = NSLocalizedString(@"DS商城", nil);
    storeLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    storeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [content addSubview:storeLabel];
    [storeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(71.2 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(space.bottom).offset(15 * HeightCoefficient);
    }];
    
    UIImageView *storeImgV = [[UIImageView alloc] init];
    storeImgV.image = [UIImage imageNamed:@"背景图"];
    [content addSubview:storeImgV];
    [storeImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(342.5 * WidthCoefficient);
        make.height.equalTo(158 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(storeLabel.bottom).offset(10 * HeightCoefficient);
        make.bottom.equalTo(content.bottom).offset(-40.5 * HeightCoefficient);
    }];
    
    UILabel *innerLabel = [[UILabel alloc] init];
    innerLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    innerLabel.numberOfLines = 0;
    innerLabel.text = @"DS商城\n更多优惠 邀您选购";
    innerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [storeImgV addSubview:innerLabel];
    [innerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(210 * WidthCoefficient);
        make.height.equalTo(50 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 104) {
        UIViewController *vc = [[NSClassFromString(@"WifiViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
