//
//  RNRFinishedViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RNRFinishedViewController.h"
#import <YYCategoriesSub/YYCategories.h>
@interface RNRFinishedViewController ()

@end

@implementation RNRFinishedViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:GeneralColorString];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.text = NSLocalizedString(@"实名制已完成", nil);
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(39.5 * HeightCoefficient);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 2;
    [btn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    btn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(self.view).offset(136 * HeightCoefficient);
    }];
}

- (void)btnClick:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
