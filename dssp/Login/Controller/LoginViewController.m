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
@property (nonatomic, strong) UIView *container;

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
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"注册"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
   
    
    self.userNameField = [[UITextField alloc] init];
    self.userNameField.textColor = [UIColor whiteColor];
//    self.userNameField.clearsOnBeginEditing=UITextFieldViewModeAlways;
    self.userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用户名", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#82756d"]}];
    [self.view addSubview:self.userNameField];
    [self.userNameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(209.5*HeightCoefficient);
        make.left.equalTo(50 * WidthCoefficient);
        make.height.equalTo(25*HeightCoefficient);
        make.width.equalTo(120*WidthCoefficient);
    }];
    
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:@"#82756d"];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(275 * WidthCoefficient);
        make.bottom.equalTo(self.userNameField.bottom).offset(10 * HeightCoefficient);
    }];
    
  
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.secureTextEntry = true;
    self.passwordField.textColor = [UIColor whiteColor];
//    self.passwordField.clearButtonMode=UITextFieldViewModeAlways;
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#82756d"]}];
    [self.view addSubview:self.passwordField];
    [self.passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(264.5*HeightCoefficient);
        make.right.left.height.equalTo(self.userNameField);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#82756d"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(275 * WidthCoefficient);
        make.bottom.equalTo(self.passwordField.bottom).offset(10 * HeightCoefficient);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginBtn.layer.borderWidth = 0.5;
  _loginBtn.layer.cornerRadius = 3; 
    
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(275 * WidthCoefficient);
        make.height.equalTo(45 * HeightCoefficient);
        make.top.equalTo(540 * HeightCoefficient);
       
    }];
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"还没有账号?", nil);
    botLabel.textColor = [UIColor colorWithHexString:@"#7b7b7b"];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(110 * WidthCoefficient);
        make.top.equalTo(_loginBtn.bottom).offset(30 * HeightCoefficient);
        make.width.equalTo(100 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(botLabel.right).offset(5 * WidthCoefficient);
        make.width.equalTo(50 * WidthCoefficient);
    }];
}

- (void)loginBtnClick:(UIButton *)sender {
    [self loginSuccess];
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

- (void)loginSuccess {
    TabBarController *tabVC = [[TabBarController alloc] init];
    [self presentViewController:tabVC animated:NO completion:nil];
}

- (void)registerBtnClick:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:NO completion:nil];
}

@end
