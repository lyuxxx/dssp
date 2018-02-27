//
//  PayCompleteViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "PayCompleteViewController.h"
#import <UIViewController+RTRootNavigationController.h>

@interface PayCompleteViewController ()
@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UILabel *paymentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation PayCompleteViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"支付成功", nil);
    self.rt_disableInteractivePop = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    self.navigationItem.leftBarButtonItem = left;
    [self setupUI];
}

//- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
//    return [[UIBarButtonItem alloc] initWithCustomView:btn];
//}

- (void)setupUI {
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    topV.layer.cornerRadius = 4;
    topV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    topV.layer.shadowOffset = CGSizeMake(0, 6);
    topV.layer.shadowRadius = 7;
    topV.layer.shadowOpacity = 0.5;
    [self.view addSubview:topV];
    [topV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(147.5 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UILabel *okLabel = [[UILabel alloc] init];
    okLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    okLabel.textColor = [UIColor whiteColor];
    okLabel.textAlignment = NSTextAlignmentCenter;
    okLabel.text = NSLocalizedString(@"支付成功", nil);
    [topV addSubview:okLabel];
    [okLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15 * WidthCoefficient);
        make.height.equalTo(22.5 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"payOK"];
    [topV addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(80 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(okLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    UIView *midV = [[UIView alloc] init];
    midV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    midV.layer.cornerRadius = 4;
    midV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    midV.layer.shadowOffset = CGSizeMake(0, 6);
    midV.layer.shadowRadius = 7;
    midV.layer.shadowOpacity = 0.5;
    [self.view addSubview:midV];
    [midV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(100 * WidthCoefficient);
        make.top.equalTo(topV.bottom).offset(10 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    NSArray *midTitles = @[NSLocalizedString(@"订单编号:", nil),NSLocalizedString(@"支付金额:", nil),NSLocalizedString(@"交易时间:", nil)];
    for (NSInteger i = 0; i < midTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor whiteColor];
        label0.text = midTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo((10 + 30 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor whiteColor];
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
        
        if (i == 0) {
            self.orderNoLabel = label1;
        } else if (i == 1) {
            self.paymentLabel = label1;
        } else if (i == 2) {
            self.timeLabel = label1;
        }
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    backBtn.layer.cornerRadius = 4;
    backBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [backBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * WidthCoefficient);
        make.top.equalTo(midV.bottom).offset(24 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
}

- (void)backToHome {
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:NSClassFromString(@"StoreTabViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

@end
