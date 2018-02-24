//
//  GetActivationCodeViewController.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "GetActivationCodeViewController.h"
#import "MapUpdateViewController.h"

@interface GetActivationCodeViewController ()

@end

@implementation GetActivationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"获取激活码", nil);
    [self setupUI];
}

- (void)setupUI {
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"update_backgroud"];
    [self.view addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(95 * WidthCoefficient);
    }];
    
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor whiteColor];
    topV.layer.cornerRadius = 4;
    topV.layer.masksToBounds = YES;
    topV.layer.shadowOffset = CGSizeMake(0, 4);
    topV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    topV.layer.shadowOpacity = 0.5;
    topV.layer.shadowRadius = 7;
    [self.view addSubview:topV];
    [topV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(self.view);
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(100 * HeightCoefficient);
    }];
    
    NSArray *topTitles = @[@"姓名:",@"联系电话:",@"车架号:"];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = topTitles[i];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont fontWithName:FontName size:15];
        [topV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.width.equalTo(80 * WidthCoefficient);
            make.top.equalTo((10 + 30 * i) * HeightCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = [UIColor colorWithHexString:@"#333333"];
        label1.font = [UIFont fontWithName:FontName size:15];
        [topV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(15.5 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.top.equalTo(label.top);
        }];
    }
    
    UIView *botV = [[UIView alloc] init];
    botV.layer.cornerRadius = 4;
    botV.layer.masksToBounds = YES;
    botV.layer.shadowOffset = CGSizeMake(0, 4);
    botV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    botV.layer.shadowOpacity = 0.5;
    botV.layer.shadowRadius = 7;
    [self.view addSubview:botV];
    [botV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topV.bottom).offset(20 * HeightCoefficient);
        make.centerX.equalTo(self.view);
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(217.5 * HeightCoefficient);
    }];
    
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.text = NSLocalizedString(@"请填写以下信息", nil);
    tLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    tLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [botV addSubview:tLabel];
    [tLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(botV);
        make.top.equalTo(20 * HeightCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
    }];
    
    NSArray *botTitles = @[@"硬件码",@"检验码",@"数据版本"];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = botTitles[i];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.font = [UIFont fontWithName:FontName size:15];
        [botV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15 * WidthCoefficient);
            make.height.equalTo(21 * HeightCoefficient);
            make.width.equalTo(75 * WidthCoefficient);
            make.top.equalTo((66.5 + 50 * i) * HeightCoefficient);
        }];
        
        UITextField *field = [[UITextField alloc] init];
        [botV addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(15.5 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.top.equalTo(label.top);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [botV addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(313 * WidthCoefficient);
            make.height.equalTo(1 * HeightCoefficient);
            make.centerX.equalTo(botV);
            make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
        }];
    }
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getBtn setTitle:NSLocalizedString(@"获取激活码", nil) forState:UIControlStateNormal];
    [getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [getBtn addTarget:self action:@selector(getActivationCode:) forControlEvents:UIControlEventTouchUpInside];
    getBtn.layer.cornerRadius = 4;
    getBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    [self.view addSubview:getBtn];
    [getBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(44 * HeightCoefficient);
        make.width.equalTo(271 * WidthCoefficient);
        make.top.equalTo(botV.bottom).offset(24 * HeightCoefficient);
    }];
}

- (void)getActivationCode:(UIButton *)sender {
    if (1) {
        for (NSInteger i =0; i < self.navigationController.viewControllers.count; i++) {
            UIViewController *vc = self.navigationController.viewControllers[i];
            if ([vc isKindOfClass:NSClassFromString(@"MapUpdateViewController")]) {
                MapUpdateViewController *mVC = (MapUpdateViewController *)vc;
                [mVC showCodeView];
                break;
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
