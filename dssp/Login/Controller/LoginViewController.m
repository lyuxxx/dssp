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

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *forgotPassword;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn;
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
        make.left.equalTo(122*WidthCoefficient);
        make.width.equalTo(131*WidthCoefficient);
        make.height.equalTo(99.5*HeightCoefficient);
        make.top.equalTo(64*HeightCoefficient);
    }];
    
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_skipBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _skipBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _skipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_skipBtn setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
    [_skipBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [self.view addSubview:_skipBtn];
    [_skipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(44 * HeightCoefficient);
        make.right.equalTo(-18 * WidthCoefficient);
        make.width.equalTo(50 * WidthCoefficient);
         make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    self.userNameField = [[UITextField alloc] init];
    _userNameField.textColor = [UIColor whiteColor];
    _userNameField.font = [UIFont fontWithName:FontName size:14];
    _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用户名", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_userNameField];
    [_userNameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(211.5 * HeightCoefficient);
        make.left.equalTo(50 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(120 * WidthCoefficient);
    }];
    
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(236.5 * HeightCoefficient);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(275 * WidthCoefficient);
    }];
    
    
    self.passwordField = [[UITextField alloc] init];
    _passwordField.secureTextEntry = true;
    _passwordField.textColor = [UIColor whiteColor];
    _passwordField.font = [UIFont fontWithName:FontName size:14];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_passwordField];
    [_passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(269 * HeightCoefficient);
        make.right.left.height.equalTo(_userNameField);
    }];
    
    
    self.smallEyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
    [_smallEyeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn];
    [_smallEyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(-50 * WidthCoefficient);
        make.height.equalTo(10 * HeightCoefficient);
        make.top.equalTo(274.5 * HeightCoefficient);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(293.5 * HeightCoefficient);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(275 * WidthCoefficient);
    }];
    
    
    self.forgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgotPassword.titleLabel.font = [UIFont fontWithName:FontName size:13];
    [_forgotPassword setTitle:NSLocalizedString(@"忘记密码", nil) forState:UIControlStateNormal];
    _forgotPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgotPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_forgotPassword addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgotPassword];
    [_forgotPassword makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(70.5 * WidthCoefficient);
        make.right.equalTo(-50 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.top.equalTo(306 * HeightCoefficient);
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
        make.width.equalTo(275 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.top.equalTo(390 * HeightCoefficient);
    }];
    
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"还没有账号?", nil);
    botLabel.font = [UIFont fontWithName:FontName size:13];
    botLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(135 * WidthCoefficient);
        make.top.equalTo(_loginBtn.bottom).offset(32 * HeightCoefficient);
        make.width.equalTo(78.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _registerBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
    [self.view addSubview:self.registerBtn];
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(213.5 * WidthCoefficient);
        make.width.equalTo(30.5 * WidthCoefficient);
    }];
}

- (void)loginWithUserName:(NSString *)username password:(NSString *)password {
    NSDictionary *paras = @{
                            @"userName": username,
                            @"userPassword": password
                            };
    [CUHTTPRequest POST:@"" parameters:paras response:^(id responseData) {
//        LoginResult *result = [LoginResult yy_modelWithDictionary:responseData];
    }];
}

- (void)BtnClick:(UIButton *)sender {
    if (sender == self.skipBtn) {
        TabBarController *tabVC = [[TabBarController alloc] init];
        [self presentViewController:tabVC animated:NO completion:nil];
    }
    if (sender == self.smallEyeBtn) {
        sender.selected = !sender.selected;
        self.passwordField.secureTextEntry = !sender.selected;
    }
    if (sender == self.forgotPassword) {
       
    }
    if (sender == self.loginBtn) {
        TabBarController *tabVC = [[TabBarController alloc] init];
        [self presentViewController:tabVC animated:NO completion:nil];
    }
    if (sender == self.registerBtn) {
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self presentViewController:registerVC animated:NO completion:nil];
    }
}



@end
