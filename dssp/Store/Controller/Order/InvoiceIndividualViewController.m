//
//  InvoiceIndividualViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InvoiceIndividualViewController.h"

@interface InvoiceIndividualViewController ()

@end

@implementation InvoiceIndividualViewController

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
        make.height.equalTo(206.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(10 * HeightCoefficient);
    }];
}

@end
