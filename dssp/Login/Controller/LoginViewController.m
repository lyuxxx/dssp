//
//  LoginViewController.m
//  dssp
//
//  Created by yxliu on 2017/10/31.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LoginViewController.h"
#import <CUHTTPRequest.h>
#import <YYCategoriesSub/YYCategories.h>
#import "TabBarController.h"
#import "RegisterViewController.h"
#import "LoginResult.h"
#import <YYModel/YYModel.h>
#import <MBProgressHUD+CU.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passWordField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *phoneCodeField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *forgotPassword;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn;
@property (nonatomic, strong) UIButton *authBtn;
@end

@implementation LoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(131 * WidthCoefficient);
        make.height.equalTo(99.5 * HeightCoefficient);
        make.top.equalTo(44 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipBtn.enabled = NO;
    [_skipBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _skipBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _skipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_skipBtn setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
    [_skipBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [self.view addSubview:_skipBtn];
    [_skipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24 * HeightCoefficient+kStatusBarHeight);
        make.right.equalTo(-18 * WidthCoefficient);
        make.width.equalTo(50 * WidthCoefficient);
         make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    self.userNameField = [[UITextField alloc] init];
    _userNameField.textColor = [UIColor whiteColor];
    _userNameField.delegate = self;
    _userNameField.font = [UIFont fontWithName:FontName size:15];
    _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用户名", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_userNameField];
    [_userNameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(191.5 * HeightCoefficient +kStatusBarHeight);
        make.left.equalTo(42.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(150 * WidthCoefficient);
    }];
    
    
    self.phoneField = [[UITextField alloc] init];
    _phoneField.textColor = [UIColor whiteColor];
    _phoneField.delegate = self;
    _phoneField.hidden = YES;
    _phoneField.font = [UIFont fontWithName:FontName size:15];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneField];
    [_phoneField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(191.5 * HeightCoefficient +kStatusBarHeight);
        make.left.equalTo(42.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(150 * WidthCoefficient);
    }];
    

    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(216.5 * HeightCoefficient +kStatusBarHeight);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    
    self.passWordField = [[UITextField alloc] init];
    _passWordField.secureTextEntry = true;
    _passWordField.delegate = self;
    _passWordField.textColor = [UIColor whiteColor];
    _passWordField.font = [UIFont fontWithName:FontName size:15];
    _passWordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_passWordField];
    [_passWordField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(249 * HeightCoefficient + kStatusBarHeight);
        make.right.left.height.equalTo(_userNameField);
    }];
    
    
    self.phoneCodeField = [[UITextField alloc] init];
//    _phoneCodeField.secureTextEntry = true;
    _phoneCodeField.hidden = YES;
    _phoneCodeField.delegate = self;
    _phoneCodeField.textColor = [UIColor whiteColor];
    _phoneCodeField.font = [UIFont fontWithName:FontName size:15];
    _phoneCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机验证码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneCodeField];
    [_phoneCodeField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(249 * HeightCoefficient + kStatusBarHeight);
        make.right.left.height.equalTo(_phoneField);
    }];

    
    self.smallEyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
    [_smallEyeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn];
    [_smallEyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(line0);
        make.height.equalTo(10 * HeightCoefficient);
        make.top.equalTo(254.5 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(273.5 * HeightCoefficient + kStatusBarHeight);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    
    self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _authBtn.layer.cornerRadius = 2;
    _authBtn.hidden = YES;
    [_authBtn.titleLabel setFont:[UIFont fontWithName:FontName size:11]];
    [_authBtn setTitle:NSLocalizedString(@"获取手机验证码", nil) forState:UIControlStateNormal];
    [_authBtn setTitleColor:[UIColor colorWithHexString:@"c4b7a6"] forState:UIControlStateNormal];
    [_authBtn setBackgroundColor:[UIColor colorWithHexString:@"#2f2726"]];
    [self.view addSubview:_authBtn];
    [_authBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line.right);
        make.width.equalTo(105 * WidthCoefficient);
        make.height.equalTo(28 * HeightCoefficient);
        make.bottom.equalTo(line.top).offset(- 4.5 * HeightCoefficient);
    }];
    
   
    self.switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _switchBtn.titleLabel.font = [UIFont fontWithName:FontName size:14];

    [_switchBtn setTitle:NSLocalizedString(@"用短信验证码登录", nil) forState:UIControlStateNormal];
    [_switchBtn setTitle:NSLocalizedString(@"用账号密码登录", nil) forState:UIControlStateSelected];
    _switchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_switchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchBtn];
    [_switchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(112 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(line);
        make.top.equalTo(286 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
    self.forgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgotPassword.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [_forgotPassword setTitle:NSLocalizedString(@"忘记密码", nil) forState:UIControlStateNormal];
    _forgotPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgotPassword setTitleColor:[UIColor colorWithHexString:  GeneralColorString] forState:UIControlStateNormal];
    [_forgotPassword addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgotPassword];
    [_forgotPassword makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(70.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.right.equalTo(line);
        make.top.equalTo(286 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _loginBtn.layer.borderWidth = 0.75;
    _loginBtn.layer.cornerRadius = 2;
    _loginBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#C4B7A6"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(290 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.top.equalTo(370 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"还没有账号?", nil);
    botLabel.font = [UIFont fontWithName:FontName size:14];
    botLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(131.5 * WidthCoefficient);
        make.top.equalTo(_loginBtn.bottom).offset(32 * HeightCoefficient);
        make.width.equalTo(78.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _registerBtn.titleLabel.font = [UIFont fontWithName:FontName size:14];
    _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
    [self.view addSubview:self.registerBtn];
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(215.5 * WidthCoefficient);
        make.width.equalTo(30.5 * WidthCoefficient);
    }];
}

- (void)loginWithUserName:(NSString *)username password:(NSString *)password {
    NSDictionary *paras = @{
                            @"userName": username,
                            @"userPassword": password
                            };
    [CUHTTPRequest POST:appLogin parameters:paras response:^(id responseData) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//        LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
    }];
}

- (void)BtnClick:(UIButton *)sender {
    if (sender == self.skipBtn) {
        TabBarController *tabVC = [[TabBarController alloc] init];
        [self presentViewController:tabVC animated:NO completion:nil];
    }
    if (sender == self.smallEyeBtn) {
        sender.selected = !sender.selected;
        self.passWordField.secureTextEntry = !sender.selected;
    }
    if(sender == self.authBtn) {
      
        __block NSInteger time = 59; //倒计时时间
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if(time <= 0){ //倒计时结束，关闭
                
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置按钮的样式
                    [self.authBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                    [self.authBtn setTitleColor:[UIColor colorWithHexString:@"c4b7a6"] forState:UIControlStateNormal];
                     [_authBtn.titleLabel setFont:[UIFont fontWithName:FontName size:11]];
                    self.authBtn.userInteractionEnabled = YES;
                });
                
            }else{
                int seconds = time % 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置按钮显示读秒效果
                    [self.authBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2ds)", seconds] forState:UIControlStateNormal];
                    [self.authBtn setTitleColor:[UIColor colorWithHexString:@"c4b7a6"] forState:UIControlStateNormal];
                    [_authBtn.titleLabel setFont:[UIFont fontWithName:FontName size:11]];
                    self.authBtn.userInteractionEnabled = NO;
                });
                time--;
            }
        });
        dispatch_resume(_timer);
        
       
    }
    if (sender == self.forgotPassword) {
        
    }
    if (sender == self.switchBtn) {
         sender.selected = !sender.selected;
        if(sender.selected)
        {
            _authBtn.hidden = NO;
            _phoneField.hidden = NO;
            _phoneCodeField.hidden = NO;
            _userNameField.hidden = YES;
            _passWordField.hidden =YES;
            _smallEyeBtn.hidden=YES;
            
        }
        else
        {
            _authBtn.hidden = YES;
            _phoneField.hidden = YES;
            _phoneCodeField.hidden = YES;
            _userNameField.hidden = NO;
            _passWordField.hidden =NO;
             _smallEyeBtn.hidden=NO;
        }
    }
    if (sender == self.loginBtn) {
        [self.view endEditing:YES];
        if(self.switchBtn.selected)
        {
            if (_phoneField.text.length == 0 || _phoneCodeField.text.length == 0) {
                [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
            }
            else
            {
                NSDictionary *paras = @{
//                                        @"userName": userName,
//                                        @"userPassword": passWord
                                        };
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:appLogin parameters:paras response:^(id responseData) {
                    if (responseData) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                        LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                        if ([result.code isEqualToString:@"200"]) {
                            
                            [hud hideAnimated:YES];
                            TabBarController *tabVC = [[TabBarController alloc] init];
                            [self presentViewController:tabVC animated:NO completion:nil];
                            
                        } else {
                            hud.label.text = [dic objectForKey:@"msg"];
                            [hud hideAnimated:YES afterDelay:1];
                        }
                    } else {
                        hud.label.text = NSLocalizedString(@"请求失败", nil);
                        [hud hideAnimated:YES afterDelay:1];
                    }
                    
                }];
                
            }
            
        }
        else
        {
            if (_userNameField.text.length == 0 || _passWordField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"用户名或密码不能为空", nil)];
            }
            else
            {
                NSDictionary *paras = @{
                        @"userName": _userNameField.text,
                        @"userPassword": _passWordField.text
                                        };
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:appLogin parameters:paras response:^(id responseData) {
                if (responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                if ([result.code isEqualToString:@"200"]) {
                    
                   [hud hideAnimated:YES];
                   TabBarController *tabVC = [[TabBarController alloc] init];
                   [self presentViewController:tabVC animated:NO completion:nil];
            
                } else {
                    hud.label.text = [dic objectForKey:@"msg"];
                    [hud hideAnimated:YES afterDelay:1];
                }
                } else {
                    hud.label.text = NSLocalizedString(@"请求失败", nil);
                    [hud hideAnimated:YES afterDelay:1];
                    }
                }];
            
                    }
        }
    }
    if (sender == self.registerBtn) {
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self presentViewController:registerVC animated:NO completion:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // 当输入框获得焦点时，执行该方法 （光标出现时）。
    //开始编辑时触发，文本字段将成为first responder
    textField.attributedPlaceholder = nil;
 
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    if (textField == self.passWordField) {
        _passWordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
         _passWordField.font = [UIFont fontWithName:FontName size:15];
    }
    else if(textField == self.userNameField)
    {
        _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用户名", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _userNameField.font = [UIFont fontWithName:FontName size:15];
    }
    
    else if(textField == self.phoneField) {
        _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _phoneField.font = [UIFont fontWithName:FontName size:15];
    }
    else
    {
        _phoneCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机验证码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _phoneCodeField.font = [UIFont fontWithName:FontName size:15];
    }

    return YES;
}



@end
