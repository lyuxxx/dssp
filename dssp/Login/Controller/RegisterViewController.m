//
//  RegisterViewController.m
//  dssp
//
//  Created by yxliu on 2017/10/31.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RegisterViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "LoginViewController.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *authField;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *authBtn;

@end

@implementation RegisterViewController

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
    bgImgV.image = [UIImage imageNamed:@"注册"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSArray *placeHolders = @[
                              NSLocalizedString(@"手机号", nil),
                              NSLocalizedString(@"手机验证码", nil),
                              NSLocalizedString(@"用户名", nil),
                              NSLocalizedString(@"密码", nil),
                              NSLocalizedString(@"确认密码", nil)
                              ];
    
    UITextField *lastField;
    for (NSInteger i = 0; i < placeHolders.count; i++) {
        UITextField *field = [[UITextField alloc] init];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#82756d"]}];
        [self.view addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(50 * WidthCoefficient);
            make.width.equalTo(120 * WidthCoefficient);
            make.height.equalTo(25 * HeightCoefficient);
        }];
        if (i == 0) {
            [field makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(209.5 * HeightCoefficient);
            }];
        } else {
            [field makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastField.bottom).offset(30 * HeightCoefficient);
            }];
        }
        lastField = field;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#82756d"];
        [self.view addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.height.equalTo(0.5 * HeightCoefficient);
            make.width.equalTo(275 * WidthCoefficient);
            make.bottom.equalTo(field.bottom).offset(10 * HeightCoefficient);
        }];
        
        if (i == 0) {
            self.phoneField = field;
        } else if (i == 1) {
            self.authField = field;
            
            self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _authBtn.layer.cornerRadius = 3;
            _authBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [_authBtn setTitle:NSLocalizedString(@"获取手机验证码", nil) forState:UIControlStateNormal];
            [_authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_authBtn setBackgroundColor:[UIColor colorWithHexString:@"#82756d"]];
            [self.view addSubview:_authBtn];
            [_authBtn makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(field);
                make.right.equalTo(line.right);
                make.width.equalTo(105 * WidthCoefficient);
            }];
            
        } else if (i == 2) {
            self.userNameField = field;
        } else if (i == 3) {
            self.passwordField = field;
        } else if (i == 4) {
            self.confirmPasswordField = field;
        }
    }
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _registerBtn.layer.borderWidth = 0.5;
    _registerBtn.layer.cornerRadius = 3;
    [_registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_registerBtn];
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(275 * WidthCoefficient);
        make.height.equalTo(45 * HeightCoefficient);
        make.top.equalTo(540 * HeightCoefficient);
    }];
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"已经有账号?", nil);
    botLabel.textColor = [UIColor colorWithHexString:@"#7b7b7b"];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(110 * WidthCoefficient);
        make.top.equalTo(_registerBtn.bottom).offset(30 * HeightCoefficient);
        make.width.equalTo(100 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(botLabel.right).offset(5 * WidthCoefficient);
        make.width.equalTo(50 * WidthCoefficient);
    }];
}

- (void)loginBtnClick:(UIButton *)sender {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:NO completion:nil];
}

@end
