//
//  WifiViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "WifiViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <CUHTTPRequest.h>
#import <MBProgressHUD+CU.h>

@interface WifiViewController ()
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *secureBtn;
@end

@implementation WifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"Wifi密码", nil);
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
    _wifiLabel.text = @"";
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
        make.height.equalTo(190 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(135 * HeightCoefficient);
    }];
    
    UILabel *password = [[UILabel alloc] init];
    password.textAlignment = NSTextAlignmentCenter;
    password.text = NSLocalizedString(@"密码", nil);
    password.textColor = [UIColor colorWithHexString:@"#333333"];
    password.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [whiteV addSubview:password];
    [password makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(214 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.centerX.equalTo(whiteV);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    self.passwordField = [[UITextField alloc] init];
    _passwordField.textColor = [UIColor colorWithHexString:@"#040000"];
    _passwordField.font = [UIFont fontWithName:FontName size:15];
    [whiteV addSubview:_passwordField];
    [_passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(password.bottom).offset(24 * HeightCoefficient);
    }];
    
    self.secureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secureBtn.selected = YES;
    [_secureBtn addTarget:self action:@selector(secureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secureBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
    [_secureBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
    [whiteV addSubview:_secureBtn];
    [_secureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(20 * WidthCoefficient);
        make.height.equalTo(10 * HeightCoefficient);
        make.centerY.equalTo(_passwordField);
        make.right.equalTo(-15 * WidthCoefficient);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [whiteV addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(313 * WidthCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_passwordField.bottom).offset(14 * HeightCoefficient);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"*请输入除去0、1以外的数字,除去I、O的大写字母任意组合的八位字符";
    tipLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [whiteV addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(line.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(30 * HeightCoefficient);
    }];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    
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
    
    [self getWifiInfo];
}

- (void)secureBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordField.secureTextEntry = !sender.selected;
}

- (void)modifyBtnClick:(UIButton *)sender {
    if (![self checkWifi:_passwordField.text]) {
        [MBProgressHUD showText:NSLocalizedString(@"字符不合法!", nil)];
        return;
    }
    [self modifyWifiWithPassword:_passwordField.text];
}

- (void)getWifiInfo {
  
    [CUHTTPRequest POST:getWifi parameters:@{} response:^(id responseData) {
        if (responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"code"] isEqualToString:@"200"]) {
                NSString *wifiSsid = dic[@"data"][@"wifiSsid"];
                NSString *wifiPassword = dic[@"data"][@"wifiPassword"];
                _wifiLabel.text = wifiSsid;
                _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:wifiPassword?wifiPassword:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
            } else {
//                [MBProgressHUD showText:NSLocalizedString(@"获取wifi失败", nil)];
                 [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                
            }
        } else {
            [MBProgressHUD showText:NSLocalizedString(@"连接失败", nil)];
        }
    }];
}

- (void)modifyWifiWithPassword:(NSString *)password {
    NSDictionary *paras = @{
                            @"wifiPassword": password
                            };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:setWifi parameters:paras response:^(id responseData) {
        if (responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            BOOL setFinish = [dic[@"data"] boolValue];
            if (setFinish) {
                hud.label.text = dic[@"msg"];
                [hud hideAnimated:YES afterDelay:1];
            } else {
                hud.label.text = NSLocalizedString(@"修改失败", nil);
                [hud hideAnimated:YES];
            }
        } else {
            hud.label.text = NSLocalizedString(@"连接失败", nil);
            [hud hideAnimated:YES afterDelay:1];
        }
    }];
}

- (BOOL)checkWifi:(NSString *)wifi
{
    NSString *pattern = @"[2-9A-HJ-NP-Z]{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:wifi];
}

@end
