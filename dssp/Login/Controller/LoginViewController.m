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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(250);
        make.height.equalTo(2);
        make.top.equalTo(self.view).offset(200);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginBtn.layer.borderWidth = 1;
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(300);
        make.height.equalTo(50);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kBottomHeight - 50);
    }];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_registerBtn];
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.height.equalTo(30);
        make.top.equalTo(_loginBtn.bottom).offset(10);
        make.centerX.equalTo(_loginBtn.centerX).offset(20);
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
    
}

@end
