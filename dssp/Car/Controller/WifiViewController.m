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
#import <IQUIView+IQKeyboardToolbar.h>

@interface WifiViewController ()
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UILabel *available;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *secureBtn;
@property (nonatomic, copy) NSString *originPassword;
@end

@implementation WifiViewController
- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"WifiViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"WifiViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"WifiViewController"];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"车载WIFI", nil);
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    
    
    UIView *bgV = [[UIView alloc] init];
    bgV.layer.cornerRadius = 4;
    bgV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:bgV];
    [bgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(20*HeightCoefficient);
        make.height.equalTo(70 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.right.equalTo(-16*WidthCoefficient);
    }];
    
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"wifi背景"];
    [bgV addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(0*HeightCoefficient);
        
    }];
    
    self.wifiLabel = [[UILabel alloc] init];
    _wifiLabel.textColor = [UIColor whiteColor];
     _wifiLabel.textAlignment = NSTextAlignmentCenter;
    _wifiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _wifiLabel.text = @"WIFI名:未知";
    [bgImgV addSubview:_wifiLabel];
    [_wifiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImgV);
         make.top.equalTo(18*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    self.available = [[UILabel alloc] init];
//    _available.textColor = [UIColor whiteColor];
    _available.textAlignment = NSTextAlignmentCenter;
    _available.font = [UIFont fontWithName:FontName size:12];
    _available.text = @"";
    [bgImgV addSubview:_available];
    [_available makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImgV);
        make.top.equalTo(_wifiLabel.bottom).offset(3*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowOpacity = 0.2;
//    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(80 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(bgImgV.bottom).offset(55*HeightCoefficient);
    }];
    
    
    UIView *redV = [[UIView alloc] init];
    redV.layer.cornerRadius = 2;
    redV.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
    [self.view addSubview:redV];
    [redV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.top.equalTo(bgImgV.bottom).offset(22.5*HeightCoefficient);
    }];
    
    
    UILabel *password = [[UILabel alloc] init];
    password.textAlignment = NSTextAlignmentLeft;
    password.text = NSLocalizedString(@"密码", nil);
    password.textColor = [UIColor colorWithHexString:@"#ffffff"];
    password.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.view addSubview:password];
    [password makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(redV.right).offset(5*WidthCoefficient);
        make.top.equalTo(bgImgV.bottom).offset(22.5*HeightCoefficient);
    }];
    
    self.passwordField = [[UITextField alloc] init];
    _passwordField.textColor = [UIColor colorWithHexString:@"#999999"];
    _passwordField.font = [UIFont fontWithName:FontName size:15];
    [whiteV addSubview:_passwordField];
    [_passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(30 * HeightCoefficient);
    }];
    
    self.secureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secureBtn.selected = YES;
    [_secureBtn addTarget:self action:@selector(secureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secureBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
    [_secureBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
    [whiteV addSubview:_secureBtn];
    [_secureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(20 * WidthCoefficient);
        make.height.equalTo(13 * WidthCoefficient);
        make.centerY.equalTo(_passwordField);
        make.right.equalTo(-15 * WidthCoefficient);
    }];
    
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
//    [whiteV addSubview:line];
//    [line makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(313 * WidthCoefficient);
//        make.height.equalTo(1 * HeightCoefficient);
//        make.centerX.equalTo(0);
//        make.top.equalTo(_passwordField.bottom).offset(14 * HeightCoefficient);
//    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"*请输入除去I、O的字母任意组合的八位字符";
    tipLabel.font = [UIFont systemFontOfSize:11];
    tipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
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
        make.top.equalTo(whiteV.bottom).offset(40 * HeightCoefficient);
    }];
    
    [self getWifiInfo];
}

- (void)secureBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordField.secureTextEntry = !sender.selected;
    [self setupPlaceHoler];
}

- (void)setupPlaceHoler {
    if (_passwordField.secureTextEntry) {
        NSMutableString *str = [NSMutableString string];
        for (NSInteger i = 0; i < self.originPassword.length; i++) {
            [str appendString:@"•"];
        }
        _passwordField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:18]}];
        _passwordField.toolbarPlaceholder = str;
    } else {
        _passwordField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:self.originPassword attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        _passwordField.toolbarPlaceholder = self.originPassword;
    }
}

- (void)modifyBtnClick:(UIButton *)sender {
    
    if ([KuserName isEqualToString:@"18911568274"]) {
        InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [popupView initWithTitle:@"当前您为游客账户，不能做此操作" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
        //            InputalertView.delegate = self;
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: popupView];
        
        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
            
            if(btn.tag ==100)
            {
                
                
            }
            
        };
        
        
    }
    else
    {
        if (![self checkWifi:_passwordField.text]) {
            [MBProgressHUD showText:NSLocalizedString(@"请输入正确的八位字符串!", nil)];
            return;
        }
        //大写
        NSString *upper = [_passwordField.text uppercaseString];
        [self modifyWifiWithPassword:upper];
    }

}

- (void)getWifiInfo {
    [CUHTTPRequest POST:getWifi parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        NSLog(@"123%@", [dic objectForKey:@"msg"]);
        
        if ([dic[@"code"] isEqualToString:@"200"]) {
            NSString *wifiSsid = dic[@"data"][@"wifiSsid"];
            NSString *wifiPassword = dic[@"data"][@"wifiPassword"];
            NSString *available = dic[@"data"][@"available"];
            if (wifiSsid) {
                self.originPassword = wifiPassword;
                _wifiLabel.text = [NSString stringWithFormat:@"WIFI名: %@",wifiSsid];
//                _passwordField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:self.originPassword attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
                _passwordField.text = self.originPassword;
                
                if([available isEqualToString:@"1"])
                {
//                    _available.textColor = [UIColor colorWithHexString:@"#999999"];
//                    _available.text = @"可用";
                    
              [_wifiLabel makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(0);
                        make.centerY.equalTo(0);
                    }];
                    
//            [_available updateConstraints:^(MASConstraintMaker *make) {
//                    make.centerX.equalTo(0);
//                    make.centerY.equalTo(0);
//                          }];
                    
                }
                else
                {
                    _available.textColor = [UIColor colorWithHexString:@"#AC0042"];
                    _available.text = @"当前wifi不可用";
                    
                }
                
                
            }
        } else {
            //                [MBProgressHUD showText:NSLocalizedString(@"获取wifi失败", nil)];
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
        }
    } failure:^(NSInteger code) {
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
    }];
}

- (void)modifyWifiWithPassword:(NSString *)password {
    NSDictionary *paras = @{
                            @"wifiPassword": password
                            };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:setWifi parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            self.originPassword = password;
            [self setupPlaceHoler];
            hud.label.text = NSLocalizedString(@"wifi密码提交服务器成功", nil);
            [hud hideAnimated:YES afterDelay:1];
        }
        else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (BOOL)checkWifi:(NSString *)wifi
{
    NSString *pattern = @"[0-9A-HhJ-NP-Za-hj-np-z]{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:wifi];
}

@end
