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
#import "YYText.h"

@interface WifiViewController ()
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UILabel *available;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *secureBtn;
@property (nonatomic, copy) NSString *originPassword;
@property (nonatomic, strong) UIImageView *wifiImg;
@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, copy) NSString *wifiSsid;
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
        make.top.equalTo(20*HeightCoefficient);
        make.height.equalTo(70 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.right.equalTo(-16*WidthCoefficient);
    }];
    
    
    
    self.bgImgV = [[UIImageView alloc] init];
    _bgImgV.image = [UIImage imageNamed:@"wifi背景"];
    [bgV addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(0*HeightCoefficient);
        
    }];
    
    self.wifiLabel = [[UILabel alloc] init];
    _wifiLabel.textColor = [UIColor whiteColor];
     _wifiLabel.textAlignment = NSTextAlignmentCenter;
    _wifiLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _wifiLabel.text = @"WIFI:未知";
    [_bgImgV addSubview:_wifiLabel];
    [_wifiLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgV);
         make.top.equalTo(18*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    self.wifiImg = [[UIImageView alloc] init];
    _wifiImg.image = [UIImage imageNamed:@"wifitag"];
    //    wifiImg.backgroundColor=[UIColor redColor];
    _wifiImg.hidden = YES;
    [_bgImgV addSubview:_wifiImg];
    [_wifiImg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgV);
        make.bottom.equalTo(0*HeightCoefficient);
        make.height.equalTo(17 * HeightCoefficient);
        make.width.equalTo(90.5 * HeightCoefficient);
    }];
    
    self.available = [[UILabel alloc] init];
//    _available.textColor = [UIColor whiteColor];
    _available.textAlignment = NSTextAlignmentCenter;
    _available.font = [UIFont fontWithName:FontName size:12];
    _available.text = @"";
    [_bgImgV addSubview:_available];
    [_available makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgV);
        make.top.equalTo(_wifiLabel.bottom).offset(3*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"- 请在车辆启动状态下修改WIFI密码 -";
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_bgImgV.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
    }];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    
    
    
    UIView *redV = [[UIView alloc] init];
    redV.layer.cornerRadius = 2;
    redV.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
    [self.view addSubview:redV];
    [redV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.top.equalTo(tipLabel.bottom).offset(20*HeightCoefficient);
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
        make.top.equalTo(tipLabel.bottom).offset(20*HeightCoefficient);
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
        make.top.equalTo(password.bottom).offset(15*HeightCoefficient);
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
    
    UILabel *tipLabel1 = [[UILabel alloc] init];
    tipLabel1.text = @"*请输入除去I、O的字母任意组合的八位字符";
    tipLabel1.font = [UIFont systemFontOfSize:11];
    tipLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:tipLabel1];
    [tipLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
    }];
    tipLabel1.adjustsFontSizeToFitWidth = YES;
    
    
    self.modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _modifyBtn.layer.cornerRadius = 2;
    [_modifyBtn addTarget:self action:@selector(modifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_modifyBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [_modifyBtn setTitle:NSLocalizedString(@"修改密码", nil) forState:UIControlStateNormal];
    [_modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_modifyBtn.titleLabel setFont:[UIFont fontWithName:NSFontAttributeName size:16]];
    [self.view addSubview:_modifyBtn];
    [_modifyBtn makeConstraints:^(MASConstraintMaker *make) {
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
//    [self setupPlaceHoler];
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
         [MBProgressHUD showText:NSLocalizedString(@"当前为游客模式，无此操作权限", nil)];
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
    
    NSDictionary *dic =@{
                         @"vin":kVin
                         };

    [CUHTTPRequest POST:getWifi parameters:dic success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        NSLog(@"123%@", [dic objectForKey:@"msg"]);
        
        if ([dic[@"code"] isEqualToString:@"200"]) {
            NSString *wifiSsid = dic[@"data"][@"wifiSsid"];
            NSString *wifiPassword = dic[@"data"][@"wifiPassword"];
            NSString *available = dic[@"data"][@"actived"];
            
            if([available isEqualToString:@"1"])
            {
//                self.wifiImg.hidden = YES;
                _bgImgV.image = [UIImage imageNamed:@"wifi背景"];
                
            }
            else
            {
                self.wifiImg.hidden = NO;
                _bgImgV.image = [UIImage imageNamed:@"wifi不可用背景"];
                
            }
            
            if (wifiSsid) {
                self.wifiSsid = wifiSsid;
                self.originPassword = wifiPassword;
                _wifiLabel.text = [NSString stringWithFormat:@"WIFI: %@",wifiSsid];
//                _passwordField.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:self.originPassword attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
                _passwordField.text = self.originPassword;
                
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
                            @"wifiSsid": self.wifiSsid,
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
    
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.modifyBtn setTitle:@"修改密码" forState:UIControlStateNormal];
                [self.modifyBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [self.modifyBtn.titleLabel setFont:[UIFont fontWithName:FontName size:16]];
                self.modifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.modifyBtn setTitle:[NSString stringWithFormat:@"修改密码(%.2ds)", seconds] forState:UIControlStateNormal];
                [self.modifyBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [_modifyBtn setBackgroundColor:[UIColor colorWithHexString:@"#999999"]];
                [self.modifyBtn.titleLabel setFont:[UIFont fontWithName:FontName size:16]];
                self.modifyBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);

    
}

- (BOOL)checkWifi:(NSString *)wifi
{
    NSString *pattern = @"[0-9A-HhJ-NP-Za-hj-np-z]{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:wifi];
}

@end
