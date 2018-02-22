//
//  InvoiceEnterpriseViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InvoiceEnterpriseViewController.h"

@interface InvoiceEnterpriseViewController ()

@end

@implementation InvoiceEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    bg.layer.cornerRadius = 4;
    [self.view addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(150.5 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    NSArray *titles = @[@"税号",@"地址",@"纳税人姓名"];
    for (NSInteger i = 0; i < titles.count; i++) {
        
    }
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:submitBtn];
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    submitBtn.layer.cornerRadius = 4;
    [self.view addSubview:submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(bg.bottom).offset(24 * WidthCoefficient);
    }];
}

@end
