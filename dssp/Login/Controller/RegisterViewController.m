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
#import <YYText.h>
#import "TabBarController.h"
#import <CUHTTPRequest/CUHTTPRequest.h>
#import <MBProgressHUD+CU.h>

@interface RegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *authField;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *confirmPasswordField;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIImageView *attentionImgV;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UIImageView *checkImgV;

@property (nonatomic, strong) UIButton *agreeBtn;

@end

@implementation RegisterViewController

{
    dispatch_source_t _authTimer;
}

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
    
    UIImageView *logoImgV = [[UIImageView alloc] init];
    logoImgV.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImgV];
    [logoImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(131 * WidthCoefficient);
        make.height.equalTo(99.5 * HeightCoefficient);
        make.top.equalTo(44 * HeightCoefficient + kStatusBarHeight);
    }];
    
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipBtn.enabled = NO;
    [_skipBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _skipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_skipBtn.titleLabel setFont:[UIFont fontWithName:FontName size:13]];
    [_skipBtn setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
    [_skipBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [self.view addSubview:_skipBtn];
    [_skipBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24 * HeightCoefficient + kStatusBarHeight);
        make.height.equalTo(20 * HeightCoefficient);
        make.right.equalTo(-18 * WidthCoefficient);
        make.width.equalTo(50 * WidthCoefficient);
    }];
    
    NSArray *placeHolders = @[
                              NSLocalizedString(@"手机号", nil),
                              NSLocalizedString(@"手机验证码", nil),
//                              NSLocalizedString(@"用户名", nil),
                              NSLocalizedString(@"密码", nil),
                              NSLocalizedString(@"确认密码", nil)
                              ];
    
    NSArray<NSNumber *> *yOffset = @[
                                     @(216.5 * HeightCoefficient + kStatusBarHeight),
                                     @(274.0 * HeightCoefficient + kStatusBarHeight),
                                     @(331.0 * HeightCoefficient + kStatusBarHeight),
                                     @(388.5 * HeightCoefficient + kStatusBarHeight)
//                                     ,
//                                     @(446.0 * HeightCoefficient + kStatusBarHeight)
                          ];
    
    for (NSInteger i = 0; i < placeHolders.count; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
        [self.view addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.height.equalTo(0.5 * HeightCoefficient);
            make.width.equalTo(290 * WidthCoefficient);
            make.top.equalTo(yOffset[i].floatValue);
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.delegate = self;
        field.textColor = [UIColor whiteColor];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        field.font = [UIFont fontWithName:FontName size:15];
        [self.view addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line);
            make.width.equalTo(150 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.bottom.equalTo(line.top).offset(-5 * HeightCoefficient);
        }];
        
        if (i == 0) {
            self.phoneField = field;
            
            self.attentionImgV = [[UIImageView alloc] init];
            _attentionImgV.image = [UIImage imageNamed:@"attention"];
            [self.view addSubview:_attentionImgV];
            [_attentionImgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(12 * WidthCoefficient);
                make.centerY.equalTo(field);
                make.right.equalTo(line);
            }];
            
        } else if (i == 1) {
            self.authField = field;
            
            self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_authBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            _authBtn.layer.cornerRadius = 2;
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
            
        }
        
//        else if (i == 2) {
//            self.userNameField = field;
//        }
        
        else if (i == 2) {
            self.passwordField = field;
            self.passwordField.secureTextEntry = YES;
            
            self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eyeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_eyeBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
            [_eyeBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
            [self.view addSubview:_eyeBtn];
            [_eyeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(16 * WidthCoefficient);
                make.height.equalTo(10 * HeightCoefficient);
                make.centerY.equalTo(field);
                make.right.equalTo(line);
            }];
            
        } else if (i == 3) {
            self.confirmPasswordField = field;
            self.confirmPasswordField.secureTextEntry = YES;
            
            self.checkImgV = [[UIImageView alloc] init];
            _checkImgV.image = [UIImage imageNamed:@"check grey"];
            [self.view addSubview:_checkImgV];
            [_checkImgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(12 * WidthCoefficient);
                make.centerY.equalTo(field);
                make.right.equalTo(line);
            }];
        }
    }
    
    NSMutableAttributedString *agreement = [[NSMutableAttributedString alloc] initWithString:@"注册及表示同意<用户协议>"];
    agreement.yy_font = [UIFont fontWithName:FontName size:12];
    agreement.yy_color = [UIColor colorWithHexString:@"#999999"];
    NSRange range = [@"注册及表示同意<用户协议>" rangeOfString:@"<用户协议>"];
    [agreement yy_setTextHighlightRange:range color:[UIColor redColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];
    YYLabel *agreeLabel = [[YYLabel alloc] init];
    agreeLabel.attributedText = agreement;
    [self.view addSubview:agreeLabel];
    [agreeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(125 * WidthCoefficient);
        make.top.equalTo(466.5 * HeightCoefficient + kStatusBarHeight);
        make.width.equalTo(150 * WidthCoefficient);
        make.height.equalTo(16 * HeightCoefficient);
    }];
    
    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.selected = YES;
    [_agreeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBtn setImage:[UIImage imageNamed:@"check grey"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    [self.view addSubview:_agreeBtn];
    [_agreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(12 * WidthCoefficient);
        make.centerY.equalTo(agreeLabel);
        make.right.equalTo(agreeLabel.left).offset(-12 * WidthCoefficient);
    }];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _registerBtn.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _registerBtn.layer.borderWidth = 0.75;
    _registerBtn.layer.cornerRadius = 2;
    [_registerBtn.titleLabel setFont:[UIFont fontWithName:FontName size:16]];
    [_registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#c4b7a6"] forState:UIControlStateNormal];
    [self.view addSubview:_registerBtn];
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(290 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.top.equalTo(agreeLabel.bottom).offset(30.5 * HeightCoefficient);
    }];
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"已经有账号?", nil);
    botLabel.font = [UIFont fontWithName:FontName size:14];
    botLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(126.5 * WidthCoefficient);
        make.top.equalTo(_registerBtn.bottom).offset(25 * HeightCoefficient);
        make.width.equalTo(91 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_loginBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#ac0042"] forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(botLabel.right);
        make.width.equalTo(31 * WidthCoefficient);
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (sender == self.eyeBtn) {
        sender.selected = !sender.selected;
        self.passwordField.secureTextEntry = !sender.selected;
    }
    if (sender == self.agreeBtn) {
        sender.selected = !sender.selected;
    }
    if (sender == self.loginBtn) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:NO completion:nil];
    }
    if (sender == self.registerBtn) {
        [self.view endEditing:YES];
        if (_attentionImgV.hidden == YES && [UIImagePNGRepresentation(_checkImgV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"check"])] && _agreeBtn.selected == YES) {
            NSDictionary *paras = @{
                                    
            @"randomCode": _authField.text,
            @"userName": _phoneField.text,
            @"userPassword": _passwordField.text
            
        };
            
            NSLog(@"6666%@",paras);
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:registerUrl parameters:paras response:^(id responseData) {
                if (responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [hud hideAnimated:YES];
                        [self registerSuccess];
                    } else {
                        hud.label.text = [dic objectForKey:@"msg"];
                        [hud hideAnimated:YES afterDelay:1];
                    }
                } else {
                    hud.label.text = NSLocalizedString(@"请求失败", nil);
                    [hud hideAnimated:YES afterDelay:1];
                }
            }];
        } else {
            if (_attentionImgV.hidden == NO) {
                [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
            } else {
                if (![UIImagePNGRepresentation(_checkImgV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"check"])]) {
                    [MBProgressHUD showText:NSLocalizedString(@"请确认两次密码", nil)];
                } else {
                    if (_agreeBtn.selected == NO) {
                        [MBProgressHUD showText:NSLocalizedString(@"请同意用户协议", nil)];
                    }
                }
            }
        }
    }
    if (sender == self.skipBtn) {
        TabBarController *tabVC = [[TabBarController alloc] init];
        [self presentViewController:tabVC animated:NO completion:nil];
    }
    if (sender == self.authBtn) {//验证码按钮
        
        if (_phoneField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
        }
        else
        {
            if ([self checkTelNumber:_phoneField.text]){
                NSDictionary *paras = @{
                        @"telephone":_phoneField.text,
                        @"randomCodeType":@"register"
                                        };
                [CUHTTPRequest POST:getRandomCode parameters:paras response:^(id responseData) {
                    if (responseData) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                            [MBProgressHUD showText:NSLocalizedString(@"验证码已发送,请查看短信", nil)];
                    
                        } else {
                            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                            hud.label.text = [dic objectForKey:@"msg"];
                            [hud hideAnimated:YES afterDelay:1];
                        }
                    } else {
                        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                        hud.label.text = NSLocalizedString(@"获取验证码失败", nil);
                        [hud hideAnimated:YES afterDelay:1];
                    }
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
            else
            {
                [MBProgressHUD showText:NSLocalizedString(@"请输入正确的手机号", nil)];
            }
        }
    }
}

- (void)registerSuccess {
    
    __block NSInteger time = 3;
    
    UIImageView *container = [[UIImageView alloc] init];
    container.image = [UIImage imageNamed:@"clearbackgroud"];
    [self.view addSubview:container];
    [container makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"logo"];
    [container addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(131 * WidthCoefficient);
        make.height.equalTo(99.5 * HeightCoefficient);
        make.centerX.equalTo(container);
        make.top.equalTo(64 * HeightCoefficient);
    }];
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.textAlignment = NSTextAlignmentCenter;
    label0.text = NSLocalizedString(@"注册成功", nil);
    label0.font = [UIFont fontWithName:FontName size:31];
    label0.textColor = [UIColor colorWithHexString:@"#c4b7a6"];
    [container addSubview:label0];
    [label0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(300 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(container);
        make.top.equalTo(514.5 * HeightCoefficient);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"开始探索DS精神", nil) attributes:@{NSKernAttributeName:@8.0f}];
    label1.font = [UIFont fontWithName:FontName size:16];
    label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [container addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(300 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.centerX.equalTo(container);
        make.top.equalTo(570.5 * HeightCoefficient);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = [NSString stringWithFormat:@"%lds后自动跳过",time];
    label2.font = [UIFont fontWithName:FontName size:11];
    label2.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [container addSubview:label2];
    [label2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(300 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(container);
        make.top.equalTo(600 * HeightCoefficient);
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        time -= 1;
        label2.text = [NSString stringWithFormat:@"%lds后自动跳过",time];
        if (time == 0) {
            LoginViewController *LoginVC = [[LoginViewController alloc] init];
            [self presentViewController:LoginVC animated:NO completion:nil];
            [timer invalidate];
            timer = nil;
        }
    } repeats:YES];
}

#pragma mark - UITextFieldDelegate -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.attributedPlaceholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSArray *placeHolders = @[
                              NSLocalizedString(@"手机号", nil),
                              NSLocalizedString(@"手机验证码", nil),
                              NSLocalizedString(@"用户名", nil),
                              NSLocalizedString(@"密码", nil),
                              NSLocalizedString(@"确认密码", nil)
                              ];
    if (textField == self.phoneField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[0] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
    } else if (textField == self.authField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[1] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
    } else if (textField == self.userNameField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[2] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
    } else if (textField == self.passwordField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[3] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
    } else if (textField == self.confirmPasswordField) {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[4] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *content = nil;
    if (string.length > 0) {
        content = [NSString stringWithFormat:@"%@%@",textField.text,string];
    } else {
        content = [textField.text substringToIndex:range.location];
    }
    if (textField == self.phoneField) {
        if ([self checkTelNumber:content]) {
            _attentionImgV.hidden = YES;
        } else {
            _attentionImgV.hidden = NO;
        }
    }
    if (textField == self.confirmPasswordField) {
        if ([content isEqualToString:self.passwordField.text]) {
            _checkImgV.image = [UIImage imageNamed:@"check"];
        } else {
            _checkImgV.image = [UIImage imageNamed:@"check grey"];
        }
    }
    return YES;
}

- (BOOL)checkTelNumber:(NSString *)telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

@end
