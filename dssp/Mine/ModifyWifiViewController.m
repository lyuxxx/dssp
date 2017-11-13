//
//  ModifyWifiViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ModifyWifiViewController.h"
#import <YYCategoriesSub/YYCategories.h>

@interface ModifyWifiViewController ()

@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UIButton *secureBtn;

@property (nonatomic, strong) UITextField *modifyField;
@property (nonatomic, strong) UITextField *confirmField;

@end

@implementation ModifyWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"修改密码", nil);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"wifi密码"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(126 * HeightCoefficient + kNaviHeight);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"wifi"];
    [self.view addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(23 * WidthCoefficient);
        make.height.equalTo(19.5 * HeightCoefficient);
        make.left.equalTo(138 * WidthCoefficient);
        make.top.equalTo(90 * HeightCoefficient);
    }];
    
    self.wifiLabel = [[UILabel alloc] init];
    _wifiLabel.textColor = [UIColor whiteColor];
    _wifiLabel.font = [UIFont fontWithName:FontName size:16];
    _wifiLabel.text = @"DS9292";
    [self.view addSubview:_wifiLabel];
    [_wifiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgV);
        make.height.equalTo(19 * HeightCoefficient);
        make.left.equalTo(imgV.right).offset(15.5 * WidthCoefficient);
    }];
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(227 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(135 * HeightCoefficient);
    }];
    
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = NSLocalizedString(@"密码更换", nil);
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [whiteV addSubview:passwordLabel];
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(214 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    NSArray<NSString *> *titles = @[NSLocalizedString(@"原密码", nil),NSLocalizedString(@"新密码", nil),NSLocalizedString(@"确认密码", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:FontName size:15];
        label.text = titles[i];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15 * WidthCoefficient);
            make.top.equalTo((66.5 + 49 * i) * HeightCoefficient);
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.text = @"532523522fs";
        field.textColor = [UIColor colorWithHexString:@"#040000"];
        field.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(30 * WidthCoefficient);
            make.centerY.equalTo(label);
            make.height.equalTo(20 * HeightCoefficient);
            make.width.equalTo(150 * WidthCoefficient);
        }];
        if (i == 0) {
            field.textColor = [UIColor colorWithHexString:@"#999999"];
            field.userInteractionEnabled = NO;
        }
        
        if (i == 1) {
            self.modifyField = field;
            
            self.secureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _secureBtn.selected = YES;
            [_secureBtn addTarget:self action:@selector(secureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_secureBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
            [_secureBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
            [whiteV addSubview:_secureBtn];
            [_secureBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(20 * WidthCoefficient);
                make.height.equalTo(10 * HeightCoefficient);
                make.centerY.equalTo(field);
                make.right.equalTo(-15 * WidthCoefficient);
            }];
        }
        if (i == 2) {
            self.confirmField = field;
        }
        
        if (i < 2) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
            [whiteV addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(313 * WidthCoefficient);
                make.height.equalTo(1 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(field.bottom).offset(14 * HeightCoefficient);
            }];
        }
    }
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.layer.cornerRadius = 2;
    [modifyBtn addTarget:self action:@selector(modifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [modifyBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [modifyBtn setTitle:NSLocalizedString(@"修改密码", nil) forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyBtn.titleLabel setFont:[UIFont fontWithName:NSFontAttributeName size:16]];
    [self.view addSubview:modifyBtn];
    [modifyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
    
}

- (void)secureBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _modifyField.secureTextEntry = !sender.selected;
    _confirmField.secureTextEntry = !sender.selected;
}

- (void)modifyBtnClick:(UIButton *)sender {
    
}

@end
