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
#import "AgreementViewController.h"

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
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, copy) NSString *agree;
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
    
    self.view.clipsToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    [self setupUI];
}

- (void)setupUI {
    

    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"注册登录背景"];
    [self.view addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(375 * WidthCoefficient);
        make.height.equalTo(194 * HeightCoefficient+kStatusBarHeight);
        make.top.equalTo( kStatusBarHeight);
    }];
    
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = NSLocalizedString(@"欢迎注册", nil);
    topLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    [topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(42.5 * WidthCoefficient);
        make.top.equalTo(84 * HeightCoefficient+kStatusBarHeight);
        make.width.equalTo(150 * WidthCoefficient);
        make.height.equalTo(30 * HeightCoefficient);
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
                                     @(281.5 * HeightCoefficient + kStatusBarHeight),
                                     @(346.5 * HeightCoefficient + kStatusBarHeight),
                                     @(411.5* HeightCoefficient + kStatusBarHeight)
//                                     ,
//                                     @(446.0 * HeightCoefficient + kStatusBarHeight)
                          ];
    
    for (NSInteger i = 0; i < placeHolders.count; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#2F2726"];
        [self.view addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.height.equalTo(1 * HeightCoefficient);
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
            [_eyeBtn setImage:[UIImage imageNamed:@"密码不可见_icon"] forState:UIControlStateNormal];
            [_eyeBtn setImage:[UIImage imageNamed:@"密码可见_icon"] forState:UIControlStateSelected];
            [self.view addSubview:_eyeBtn];
            [_eyeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(16 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.centerY.equalTo(field);
                make.right.equalTo(line);
            }];
            
            
            UILabel *botLabel = [[UILabel alloc] init];
            botLabel.text = NSLocalizedString(@"*请输入不少于八位字母和数字的混合密码", nil);
          
            botLabel.font = [UIFont fontWithName:FontName size:11];
            botLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
            [self.view addSubview:botLabel];
            [botLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(42.5 * WidthCoefficient);
                make.top.equalTo(line.bottom).offset(0 * HeightCoefficient);
                make.width.equalTo(260);
                make.height.equalTo(20 * HeightCoefficient);
            }];
            
            
            
            
        } else if (i == 3) {
            self.confirmPasswordField = field;
//            self.confirmPasswordField.secureTextEntry = YES;
            
//            self.checkImgV = [[UIImageView alloc] init];
//            _checkImgV.image = [UIImage imageNamed:@"check grey"];
//            [self.view addSubview:_checkImgV];
//            [_checkImgV makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(12 * WidthCoefficient);
//                make.centerY.equalTo(field);
//                make.right.equalTo(line);
//            }];
        }
    }
    
    
//    NSMutableAttributedString *agreement = [[NSMutableAttributedString alloc] initWithString:@"注册即表示同意<用户协议>"];
//    agreement.yy_font = [UIFont fontWithName:FontName size:12];
//    agreement.yy_color = [UIColor colorWithHexString:@"#999999"];
//    NSRange range = [@"注册即表示同意<用户协议>" rangeOfString:@"<用户协议>"];
//    [agreement yy_setTextHighlightRange:range color:[UIColor colorWithHexString:@"#AC0042 "] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//
//    }];
//    YYLabel *agreeLabel = [[YYLabel alloc] init];
//    agreeLabel.attributedText = agreement;
//    [self.view addSubview:agreeLabel];
//    [agreeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(125 * WidthCoefficient);
//        make.top.equalTo(438 * HeightCoefficient + kStatusBarHeight);
//        make.width.equalTo(220 * WidthCoefficient);
//        make.height.equalTo(16 * HeightCoefficient);
//    }];
    
    
    self.agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _agreeBtn.selected = NO;
    [_agreeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBtn setImage:[UIImage imageNamed:@"check grey"] forState:UIControlStateNormal];
    [_agreeBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.view addSubview:_agreeBtn];
    [_agreeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(12 * WidthCoefficient);
        make.top.equalTo(440 * HeightCoefficient + kStatusBarHeight);
        make.left.equalTo(103 * WidthCoefficient);
    }];
    
    
    self.agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreementBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _agreementBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    _agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_agreementBtn setTitle:NSLocalizedString(@"注册即表示同意<用户协议>", nil) forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.view addSubview:self.agreementBtn];
    [_agreementBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(125 * WidthCoefficient);
                make.top.equalTo(438 * HeightCoefficient + kStatusBarHeight);
                make.width.equalTo(220 * WidthCoefficient);
                make.height.equalTo(16 * HeightCoefficient);
//        make.top.equalTo(_registerBtn.bottom).offset(46*HeightCoefficient);
//        make.centerX.equalTo(0);
//        make.width.equalTo(130*WidthCoefficient);
//        make.height.equalTo(28*HeightCoefficient);
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
        make.top.equalTo(_agreementBtn.bottom).offset(30.5 * HeightCoefficient);
    }];
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"已有账号?", nil);
    CGSize size = [botLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:FontName size:14],NSFontAttributeName,nil]];
    // 名字的H
    //    CGFloat nameH = size.height;
    // 名字的W
    CGFloat nameW = size.width;
    botLabel.font = [UIFont fontWithName:FontName size:14];
    botLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(126.5 * WidthCoefficient);
        make.top.equalTo(_registerBtn.bottom).offset(25 * HeightCoefficient);
        make.width.equalTo(nameW+1);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_loginBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
    make.left.equalTo(botLabel.right).offset(5);
        make.width.equalTo(30);
    }];
    
    UIImageView *jumpImg = [[UIImageView alloc] init];
    jumpImg.image = [UIImage imageNamed:@"跳转_icon"];
    jumpImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpImg1)];
    [jumpImg addGestureRecognizer:tap];
    [self.view addSubview:jumpImg];
    [jumpImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(_loginBtn.right).offset(5);
        make.width.equalTo(16 * WidthCoefficient);
        make.height.equalTo(16 * WidthCoefficient);
    }];
}

-(void)jumpImg1
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    RTRootNavigationController *naVC = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:naVC animated:NO completion:nil];
}

- (void)btnClick:(UIButton *)sender {
    
//    [self registerSuccess];
    if (sender == self.eyeBtn) {
        sender.selected = !sender.selected;
        self.passwordField.secureTextEntry = !sender.selected;
    }
    if (sender == self.agreeBtn) {
        if (self.agreeBtn.selected == YES) {
            self.agreeBtn.selected = NO;
        }
        else
        {
            weakifySelf
            AgreementViewController *AgreementVC = [[AgreementViewController alloc] init];
            AgreementVC.callBackBlocks = ^(NSString *text){   // 1
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongifySelf
                    self.agreeBtn.selected = YES;
                    
                });
            };
            [self presentViewController:AgreementVC animated:NO completion:nil];
        }
    }
    if (sender == self.loginBtn) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        RTRootNavigationController *naVC = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:NO completion:nil];
//         [self.navigationController pushViewController:naVC animated:YES];
    }
    if (sender == self.registerBtn) {
        [self.view endEditing:YES];
        
        if (_attentionImgV.hidden == NO) {
           [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
        }
        else if (_passwordField.text.length <8 || ![self checkPassWord:_passwordField.text])
        {
         [MBProgressHUD showText:NSLocalizedString(@"密码格式有误", nil)];
        }
        else if(![_passwordField.text isEqualToString:_confirmPasswordField.text] )
        {
            [MBProgressHUD showText:NSLocalizedString(@"请再次确认密码", nil)];
            
        }
//        else if (![UIImagePNGRepresentation(_checkImgV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"check"])]) {
//             [MBProgressHUD showText:NSLocalizedString(@"请再次确认密码", nil)];
//         }
         else if (_agreeBtn.selected == NO) {
            [MBProgressHUD showText:NSLocalizedString(@"请同意用户协议", nil)];
         }
         else
         {
            NSDictionary *paras = @{
                                    
                                    @"randomCode": _authField.text,
                                    @"userName": _phoneField.text,
                                    @"userPassword": [_passwordField.text md5String]
                                    
                                    };
            
            NSLog(@"6666%@",paras);
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:registerUrl parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                    [hud hideAnimated:YES];
                    [self registerSuccess];
                } else {
                    hud.label.text = [dic objectForKey:@"msg"];
                    [hud hideAnimated:YES afterDelay:1];
                }
            } failure:^(NSInteger code) {
                hud.label.text = NSLocalizedString(@"网络异常", nil);
                [hud hideAnimated:YES afterDelay:1];
            }];
            
            
        }
        
        
//        if (_attentionImgV.hidden == YES && [UIImagePNGRepresentation(_checkImgV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"check"])] && _agreeBtn.selected == YES) {
//            NSDictionary *paras = @{
//
//            @"randomCode": _authField.text,
//            @"userName": _phoneField.text,
//            @"userPassword": [_passwordField.text md5String]
//
//               };
//
//            NSLog(@"6666%@",paras);
//            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
//            [CUHTTPRequest POST:registerUrl parameters:paras success:^(id responseData) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                    [hud hideAnimated:YES];
//                    [self registerSuccess];
//                } else {
//                    hud.label.text = [dic objectForKey:@"msg"];
//                    [hud hideAnimated:YES afterDelay:1];
//                }
//            } failure:^(NSInteger code) {
//                hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
//                [hud hideAnimated:YES afterDelay:1];
//            }];
//        } else {
//            if (_attentionImgV.hidden == NO) {
//                [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
//            } else {
//                if (![UIImagePNGRepresentation(_checkImgV.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"check"])]) {
//                    [MBProgressHUD showText:NSLocalizedString(@"请再次确认密码", nil)];
//                } else {
//                    if (_agreeBtn.selected == NO) {
//                        [MBProgressHUD showText:NSLocalizedString(@"请同意用户协议", nil)];
//                    }
//                }
//            }
//        }
    }
    if (sender == self.skipBtn) {
        TabBarController *tabVC = [[TabBarController alloc] init];
        [[UIApplication sharedApplication].delegate.window setRootViewController:tabVC];
    }
    if (sender == self.authBtn) {//验证码按钮
        
        if (_phoneField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
        }
        else
        {
            if([self valiMobile:_phoneField.text])
            {
//                [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
//            }
//            else{
                NSDictionary *paras = @{
                        @"telephone":_phoneField.text,
                        @"randomCodeType":@"register"
                                        };
                [CUHTTPRequest POST:getRandomCode parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:NSLocalizedString(@"验证码已发送,请查看短信", nil)];
//                        _authField.text = dic[@"data"];
                    } else {
                        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                        hud.label.text = [dic objectForKey:@"msg"];
                        [hud hideAnimated:YES afterDelay:1];
                    }
                } failure:^(NSInteger code) {
                    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                    hud.label.text = NSLocalizedString(@"获取验证码失败", nil);
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
                [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
            }
        }
    }
    if (sender == self.agreementBtn) {

        if (self.agreeBtn.selected == YES) {
            self.agreeBtn.selected = NO;
        }
        else
        {
            weakifySelf
            AgreementViewController *AgreementVC = [[AgreementViewController alloc] init];
            AgreementVC.callBackBlocks = ^(NSString *text){   // 1
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongifySelf
                    self.agreeBtn.selected = YES;
                    
                });
            };
            [self presentViewController:AgreementVC animated:NO completion:nil];
        }

    }
    
}


-(BOOL)checkPassWord:(NSString *)str
{
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:str]) {
        return YES ;
    }else
        return NO;
}


- (void)registerSuccess {
    
    __block NSInteger time = 3;
    
    //缓存
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:@"" forKey:@"userName"];
    [result setObject:@"" forKey:@"passWord"];
    CONF_SET(@"user",result);
    
    
    UIImageView *container = [[UIImageView alloc] init];
    container.image = [UIImage imageNamed:@"launch"];
    [self.view addSubview:container];
    [container makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    UIImageView *logo = [[UIImageView alloc] init];
//    logo.image = [UIImage imageNamed:@"logo"];
//    [container addSubview:logo];
//    [logo makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(131 * WidthCoefficient);
//        make.height.equalTo(99.5 * HeightCoefficient);
//        make.centerX.equalTo(container);
//        make.top.equalTo(64 * HeightCoefficient);
//    }];
    
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
        if ([self valiMobile:content]) {
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

//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
//    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

@end
