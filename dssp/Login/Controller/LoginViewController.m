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
#import "ForgotViewController.h"
#import "NewPasswordViewController.h"
#import "UITabBar+badge.h"
#import <MapSearchManager.h>
#import "AppDelegate.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passWordField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *phoneCodeField;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *touristBtn;
@property (nonatomic, strong) UIButton *forgotPassword;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, copy) NSString *phoneCode;
@property (nonatomic, strong) UILabel *topLabel;
//@property (nonatomic, copy) NSString *cid;
@end

@implementation LoginViewController

{
    dispatch_source_t cidTimer;
}

- (BOOL)needGradientBg {
    return NO;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cidnotification:) name:@"Refreshcid" object:nil];
    
    self.navigationItem.title = NSLocalizedString(@"", nil);
    self.navigationController.navigationBarHidden = YES;
    
    self.view.clipsToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
    // Do any additional setup after loading the view.
    [self setupUI];
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refreshcid" object:nil];
//}
//
//- (void)cidnotification:(NSNotification *)notification {
//    self.cid = notification.userInfo[@"cid"];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *user = CONF_GET(@"user");
    _userNameField.text =[user objectForKey:@"userName"];
    _passWordField.text = [user objectForKey:@"passWord"];
  
}

- (void)setupUI {
    
//    UIImageView *bgImgV = [[UIImageView alloc] init];
//    bgImgV.image = [UIImage imageNamed:@"backgroud1"];
//    [self.view addSubview:bgImgV];
//    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"注册登录背景"];
    [self.view addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(375 * WidthCoefficient);
        make.height.equalTo(194 * HeightCoefficient+kStatusBarHeight);
        make.top.equalTo( kStatusBarHeight);
    }];
    
    
    
    self.topLabel = [[UILabel alloc] init];
    _topLabel.text = NSLocalizedString(@"欢迎登录", nil);
    _topLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    _topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_topLabel];
    [_topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(42.5 * WidthCoefficient);
        make.top.equalTo(84 * HeightCoefficient+kStatusBarHeight);
        make.width.equalTo(160 * WidthCoefficient);
        make.height.equalTo(30 * HeightCoefficient);
    }];
    
    
    
    
    /**
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _skipBtn.enabled = NO;
    [_skipBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    **/
    
    self.userNameField = [[UITextField alloc] init];
    _userNameField.keyboardType = UIKeyboardTypePhonePad;
    _userNameField.textColor = [UIColor whiteColor];
    _userNameField.delegate = self;
    _userNameField.font = [UIFont fontWithName:FontName size:15];
    _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_userNameField];
    [_userNameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(191.5 * HeightCoefficient +kStatusBarHeight);
        make.left.equalTo(42.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(150 * WidthCoefficient);
    }];

//     _userNameField.text = @"15871707603";
//    _userNameField.text =@"13419506934";
//     _userNameField.text = @"15907157363";
//    _userNameField.text = @"15810817108";
//     _userNameField.text =@"18911568273";
//    _userNameField.text =@"15697179380";

    self.phoneField = [[UITextField alloc] init];
    _phoneField.keyboardType = UIKeyboardTypePhonePad;
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
    line0.backgroundColor = [UIColor colorWithHexString:@"#2F2726"];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(216.5 * HeightCoefficient +kStatusBarHeight);
        make.height.equalTo(1 * HeightCoefficient);
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
        make.top.equalTo(line0.bottom).offset(40*HeightCoefficient);
        make.right.left.height.equalTo(_userNameField);
    }];
    
    
//     NSDictionary *user = CONF_GET(@"user");
//    _userNameField.text =[user objectForKey:@"userName"];
//    _passWordField.text = [user objectForKey:@"passWord"];
//     _passWordField.text = @"lu123456";
//    _passWordField.text = @"1234567q";

    self.phoneCodeField = [[UITextField alloc] init];
    _phoneCodeField.keyboardType = UIKeyboardTypeNumberPad;
//    _phoneCodeField.secureTextEntry = true;
    _phoneCodeField.hidden = YES;
    _phoneCodeField.delegate = self;
    _phoneCodeField.textColor = [UIColor whiteColor];
    _phoneCodeField.font = [UIFont fontWithName:FontName size:15];
    _phoneCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机验证码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneCodeField];
    [_phoneCodeField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line0.bottom).offset(40*HeightCoefficient);
        make.right.left.height.equalTo(_phoneField);
    }];

    
    self.smallEyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"密码不可见_icon"] forState:UIControlStateNormal];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"密码可见_icon"] forState:UIControlStateSelected];
    [_smallEyeBtn setContentMode:UIViewContentModeScaleAspectFill];
    [_smallEyeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn];
    [_smallEyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(line0);
        make.height.equalTo(16 * WidthCoefficient);
        make.top.equalTo(254.5 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#2F2726"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(line0.bottom).offset(65*HeightCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    
    self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    [_switchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchBtn];
    [_switchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(150 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(line);
         make.top.equalTo(line.bottom).offset(15 * HeightCoefficient);
    }];
    
    
    self.forgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgotPassword.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [_forgotPassword setTitle:NSLocalizedString(@"忘记密码", nil) forState:UIControlStateNormal];
    _forgotPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgotPassword setTitleColor:[UIColor colorWithHexString:  GeneralColorString] forState:UIControlStateNormal];
    [_forgotPassword addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgotPassword];
    [_forgotPassword makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(70.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.right.equalTo(line);
        make.top.equalTo(line.bottom).offset(15 * HeightCoefficient);
 
    }];
    
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _loginBtn.layer.borderWidth = 0.75;
    _loginBtn.layer.cornerRadius = 2;
    _loginBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#C4B7A6"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [_loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(290 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.top.equalTo(370 * HeightCoefficient + kStatusBarHeight);
    }];
    
    
//    UIFont *fnt = [UIFont fontWithName:@"Courier New" size:24.0f];
//    lbl_text.font = fnt;
//    // 根据字体得到NSString的尺寸
//    CGSize size = [lbl_text.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil]];
//    // 名字的H
//    CGFloat nameH = size.height;
//    // 名字的W
//    CGFloat nameW = size.width;
//    lbl_text.frame = CGRectMake(100,100, nameW,nameH);
//    [self.view addSubview:lbl_text];
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"还没有账号?", nil);
    CGSize size = [botLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:FontName size:14],NSFontAttributeName,nil]];
    // 名字的H
//    CGFloat nameH = size.height;
    // 名字的W
    CGFloat nameW = size.width;
    botLabel.font = [UIFont fontWithName:FontName size:14];
    botLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//    botLabel.backgroundColor =[UIColor redColor];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(117 * WidthCoefficient);
        make.top.equalTo(_loginBtn.bottom).offset(32 * HeightCoefficient);
        make.width.equalTo(nameW+1);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _registerBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
    [self.view addSubview:self.registerBtn];
    [_registerBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
    make.left.equalTo(botLabel.right).offset(5);
        make.width.equalTo(30);
    }];
    
    
    UIImageView *jumpImg = [[UIImageView alloc] init];
    jumpImg.image = [UIImage imageNamed:@"跳转_icon"];
    jumpImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpImg)];
    [jumpImg addGestureRecognizer:tap];
    [self.view addSubview:jumpImg];
    [jumpImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(botLabel);
        make.left.equalTo(_registerBtn.right).offset(5);
        make.width.equalTo(16 * WidthCoefficient);
        make.height.equalTo(16 * WidthCoefficient);
    }];
    
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.image = [UIImage imageNamed:@"Line"];
    [self.view addSubview:lineImg];
    [lineImg makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
        make.height.equalTo(1 * HeightCoefficient);
    make.top.equalTo(_registerBtn.bottom).offset(30*HeightCoefficient);
        make.left.equalTo(40*WidthCoefficient);
        make.right.equalTo(-40*WidthCoefficient);
    }];
    
    
    
    self.touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _touristBtn.layer.borderColor = [UIColor colorWithHexString:@"#1E1918"].CGColor;
    _touristBtn.layer.borderWidth = 0.75;
    _touristBtn.layer.cornerRadius = 14;
    [_touristBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _touristBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _touristBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_touristBtn setTitle:NSLocalizedString(@"游客模式", nil) forState:UIControlStateNormal];
    [_touristBtn setTitleColor:[UIColor colorWithHexString:@"#A18E79 "] forState:UIControlStateNormal];
    [self.view addSubview:self.touristBtn];
    [_touristBtn makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_registerBtn.bottom).offset(46*HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(130*WidthCoefficient);
        make.height.equalTo(28*HeightCoefficient);
    }];

}

-(void)jumpImg
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:NO completion:nil];
}

- (void)btnClick:(UIButton *)sender {
    if (sender == self.skipBtn) {
        TabBarController *tabVC = [[TabBarController alloc] init];
        [[UIApplication sharedApplication].delegate.window setRootViewController:tabVC];
    }
    if (sender == self.smallEyeBtn) {
        sender.selected = !sender.selected;
        self.passWordField.secureTextEntry = !sender.selected;
    }
    if(sender == self.authBtn) {
        
        if (_phoneField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
        }
        else
        {
            if ([self valiMobile:_phoneField.text]){
                NSDictionary *paras = @{
                @"telephone":_phoneField.text,
                @"randomCodeType":@"login"
                                        };
                [CUHTTPRequest POST:getRandomCode parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    // LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:NSLocalizedString(@"验证码已发送,请查看短信", nil)];
//                        _phoneCodeField.text = dic[@"data"];
                        
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
    if (sender == self.forgotPassword) {
        ForgotViewController *VC = [[ForgotViewController alloc] init];
//         NavigationController *naVC = [[NavigationController alloc] initWithRootViewController:VC];
//        [self presentViewController:naVC animated:NO completion:nil];
       [self.navigationController pushViewController:VC animated:YES];
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
            _forgotPassword.hidden = YES;
            _topLabel.text = NSLocalizedString(@"验证码登录", nil);
        }
        else
        {
            _authBtn.hidden = YES;
            _phoneField.hidden = YES;
            _phoneCodeField.hidden = YES;
            _userNameField.hidden = NO;
            _passWordField.hidden =NO;
            _smallEyeBtn.hidden=NO;
            _forgotPassword.hidden = NO;
            _topLabel.text = NSLocalizedString(@"欢迎登录", nil);
        }
    }
    if (sender == self.loginBtn) {
        [self.view endEditing:YES];
        
      
        if(self.switchBtn.selected)
        {
            if (_phoneField.text.length == 0 || _phoneCodeField.text.length == 0) {
                [MBProgressHUD showText:NSLocalizedString(@"手机号或验证码不能为空", nil)];
            }
            else
            {
                if(![self valiMobile:_phoneField.text])
                {
                    [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
                    return;
                }
                else if(_phoneCodeField.text.length != 6)
                {
                    [MBProgressHUD showText:NSLocalizedString(@"验证码有误", nil)];
                     return;
                }
                else
                {
                    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                    NSString *cid = [defaults1 objectForKey:@"cid"];
                    
                     NSString *telephone = [_phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                     NSString *randomCode = [_phoneCodeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                    NSDictionary *paras = @{
                                @"telephone":telephone,
                                @"randomCode":randomCode,
                                @"phoneToken":cid
                                            };
                    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                    [CUHTTPRequest POST:telephoneLogins parameters:paras success:^(id responseData) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                        LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                        if ([result.code isEqualToString:@"200"]) {
                            
                            NSDictionary *dic1 =dic[@"data"];
                            LoginResultData *loginResult = [LoginResultData yy_modelWithDictionary:dic1];
                            
                            
                            NSString *userName = loginResult.userName;
                            NSString *vin = loginResult.vin;
                            NSString *vhlTStatus=loginResult.vhlTStatus;
                            NSString *certificationStatus = loginResult.certificationStatus;
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:userName forKey:@"userName"];
                            [defaults synchronize];
                            
                            
                            if ([NSString isBlankString:vin]) {
                                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                                [defaults1 setObject:@"" forKey:@"vin"];
                                [defaults1 synchronize];
                            }
                            else
                            {
                                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                                [defaults1 setObject:vin forKey:@"vin"];
                                [defaults1 synchronize];
                                
                            }
                            
                            
                            if ([NSString isBlankString:vhlTStatus]) {
                                NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                                [defaults2 setObject:@"" forKey:@"vhlTStatus"];
                                [defaults2 synchronize];
                            }
                            else
                            {
                                NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                                [defaults2 setObject:vhlTStatus forKey:@"vhlTStatus"];
                                [defaults2 synchronize];
                                
                            }
                          
                           
                            if ([NSString isBlankString:certificationStatus]) {
                                NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                                [defaults3 setObject:@"" forKey:@"certificationStatus"];
                                [defaults3 synchronize];
                            }
                            else
                            {
                                NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                                [defaults3 setObject:certificationStatus forKey:@"certificationStatus"];
                                [defaults3 synchronize];
                                
                            }
                            
                    
                            //缓存
                            NSMutableDictionary *result = [NSMutableDictionary new];
                            [result setObject:@"" forKey:@"userName"];
                            [result setObject:@"" forKey:@"passWord"];
                            CONF_SET(@"user",result);
                            
                            [hud hideAnimated:YES];
                            [self pullData1];
                            TabBarController *tabVC = [[TabBarController alloc] init];
                            [[UIApplication sharedApplication].delegate.window setRootViewController:tabVC];
                        }
                        else {
                            [hud hideAnimated:YES];
                            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                            
                        }
                    } failure:^(NSInteger code) {
                        [hud hideAnimated:YES];
                        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
                      
                    }];
                }
            }
        }
        else
        {
            if (_userNameField.text.length == 0 || _passWordField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号或密码不能为空", nil)];
                 [self setuploading];
            }
            else
            {
                
               [self setuploading];
             

//               NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//               NSString *cid = [defaults1 objectForKey:@"cid"];
          

            NSString *userName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
               if([self valiMobile:userName])

                {
                    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                    __block NSInteger time = 10;
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    cidTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(cidTimer,dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
                    dispatch_source_set_event_handler(cidTimer, ^{
                        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                        NSString *cid = [defaults1 objectForKey:@"cid"];
                       
                        if (time == 0) {//超时
                            [(AppDelegate *)[UIApplication sharedApplication].delegate restartGetui];
                            NSLog(@"cid超时");
                            dispatch_source_cancel(cidTimer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                hud.label.text = NSLocalizedString(@"登录失败", nil);
                                [hud hideAnimated:YES afterDelay:1];
                            });
                            
                        } else {
                            NSLog(@"cid执行");
                            cid = [[NSUserDefaults standardUserDefaults] objectForKey:@"cid"];
                            if (cid) {
                                NSLog(@"cid成功");
                                dispatch_source_cancel(cidTimer);
                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [hud hideAnimated:YES];
                                 
//                           去掉字符串头尾空格
                            NSString *userName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            NSString *userPassword = [_passWordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    
                                    
                                    NSDictionary *paras = @{
                                        @"userName": userName,
                                        @"userPassword": [userPassword md5String],
                                        @"phoneToken":cid
                                                            
                                                    };
                                    
                                    [CUHTTPRequest POST:userNameLogins parameters:paras success:^(id responseData) {
                                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                                        
                                        LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                                        if ([result.code isEqualToString:@"200"]) {
                                            [hud hideAnimated:YES];
                                            [self.tabBarController.tabBar showBadgeOnItemIndex:1];
                                            NSDictionary *dic1 =dic[@"data"];
                                            LoginResultData *loginResult = [LoginResultData yy_modelWithDictionary:dic1];
                                            
                                            NSString *userName = loginResult.userName;
                                            NSString *vin = loginResult.vin;
                                            NSString *vhlTStatus=loginResult.vhlTStatus;
                                            NSString *certificationStatus = loginResult.certificationStatus;
                                            
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setObject:userName forKey:@"userName"];
                                            [defaults synchronize];
                                            
                                            
                                            if ([NSString isBlankString:vin]) {
                                                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                                                [defaults1 setObject:@"" forKey:@"vin"];
                                                [defaults1 synchronize];
                                            }
                                            else
                                            {
                                                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                                                [defaults1 setObject:vin forKey:@"vin"];
                                                [defaults1 synchronize];
                                                
                                            }
                                            
                                            
                                            if ([NSString isBlankString:vhlTStatus]) {
                                                NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                                                [defaults2 setObject:@"" forKey:@"vhlTStatus"];
                                                [defaults2 synchronize];
                                            }
                                            else
                                            {
                                                NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                                                [defaults2 setObject:vhlTStatus forKey:@"vhlTStatus"];
                                                [defaults2 synchronize];
                                                
                                            }
                                            
                                            if ([NSString isBlankString:certificationStatus]) {
                                                NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                                                [defaults3 setObject:@"" forKey:@"certificationStatus"];
                                                [defaults3 synchronize];
                                            }
                                            else
                                            {
                                                NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                                                [defaults3 setObject:certificationStatus forKey:@"certificationStatus"];
                                                [defaults3 synchronize];
                                            }
                                            
                                            //缓存
                                            NSMutableDictionary *result = [NSMutableDictionary new];
                                            [result setObject:_userNameField.text forKey:@"userName"];
                                            [result setObject:_passWordField.text forKey:@"passWord"];
                                            CONF_SET(@"user",result);
                                            
                                            [self pullData1];
                                            TabBarController *tabVC = [[TabBarController alloc] init];
                                            [[UIApplication sharedApplication].delegate.window setRootViewController:tabVC];
                                            
                                        } else {
                                            
                                            //                                        [hud hideAnimated:YES];
                                            hud.label.text = [dic objectForKey:@"msg"];
                                            [hud hideAnimated:YES afterDelay:1];
                                        }
                                    } failure:^(NSInteger code) {
                                        //                        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
                                        hud.label.text = NSLocalizedString(@"网络异常", nil);
                                        [hud hideAnimated:YES afterDelay:1];
                                    }];
                                    
                                    
                                });
                                
                                
        
                            }
                        }
//                        time -= 1;
                        time--;
                    });
                    dispatch_resume(cidTimer);
                    
                    }

              else{
                    [MBProgressHUD showText:NSLocalizedString(@"手机号有误", nil)];
                }
                
            }
        }
        
    }
    if (sender == self.registerBtn) {
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self presentViewController:registerVC animated:NO completion:nil];
    }
    if (sender == self.touristBtn) {

        NSString *userName = @"18911568274";
        NSString *password = @"ye123456";;
//        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//        NSString *cid = [defaults1 objectForKey:@"cid"];
        NSDictionary *paras = @{
                                @"userName": userName,
                                @"userPassword": [password md5String],
                                @"phoneToken":@"0"
                                };
        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        [CUHTTPRequest POST:userNameLogins parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
            if ([result.code isEqualToString:@"200"]) {
                
                NSDictionary *dic1 =dic[@"data"];
                LoginResultData *loginResult = [LoginResultData yy_modelWithDictionary:dic1];
                
                
                NSString *userName = loginResult.userName;
                NSString *vin = loginResult.vin;
                NSString *vhlTStatus=loginResult.vhlTStatus;
                NSString *certificationStatus = loginResult.certificationStatus;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:userName forKey:@"userName"];
                [defaults synchronize];
                
                
                if ([NSString isBlankString:vin]) {
                    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                    [defaults1 setObject:@"" forKey:@"vin"];
                    [defaults1 synchronize];
                }
                else
                {
                    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                    [defaults1 setObject:vin forKey:@"vin"];
                    [defaults1 synchronize];
                    
                }
                
                
                if ([NSString isBlankString:vhlTStatus]) {
                    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                    [defaults2 setObject:@"" forKey:@"vhlTStatus"];
                    [defaults2 synchronize];
                }
                else
                {
                    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                    [defaults2 setObject:vhlTStatus forKey:@"vhlTStatus"];
                    [defaults2 synchronize];
                    
                }
                
                
                
                if ([NSString isBlankString:certificationStatus]) {
                    NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                    [defaults3 setObject:@"" forKey:@"certificationStatus"];
                    [defaults3 synchronize];
                }
                else
                {
                    NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                    [defaults3 setObject:certificationStatus forKey:@"certificationStatus"];
                    [defaults3 synchronize];
                    
                }
                
                [self pullData1];
                [hud hideAnimated:YES];
                TabBarController *tabVC = [[TabBarController alloc] init];
                [[UIApplication sharedApplication].delegate.window setRootViewController:tabVC];
            }
            else {
                [hud hideAnimated:YES];
//                [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                
            }
        } failure:^(NSInteger code) {
            [hud hideAnimated:YES];
//            [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
            
        }];

    }

}

- (void)pullData1 {
    
    [CUHTTPRequest GET:getDefaultTelephoneNumber parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSString *string = dic[@"data"];
            if ([NSString isBlankString:string]) {
                NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                [defaults2 setObject:@"000-000-0000" forKey:@"phonenumber"];
                [defaults2 synchronize];
            }
            else
            {
                NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                [defaults2 setObject:string forKey:@"phonenumber"];
                [defaults2 synchronize];
                
            }
        } else {
//            [MBProgressHUD showText:dic[@"msg"]];
        }
        
    } failure:^(NSInteger code) {
        
        
    }];
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // 当输入框获得焦点时，执行该方法 （光标出现时）。
    //开始编辑时触发，文本字段将成为first responder
    textField.attributedPlaceholder = nil;
 
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder

    if(textField == self.phoneField) {
        _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _phoneField.font = [UIFont fontWithName:FontName size:15];
    }
    else if(textField == self.phoneCodeField)
    {
        _phoneCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机验证码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _phoneCodeField.font = [UIFont fontWithName:FontName size:15];
    }
    else if(textField == self.passWordField)
    {
        _passWordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _passWordField.font = [UIFont fontWithName:FontName size:15];
    }
    else if(textField == self.userNameField)
    {
        _userNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _userNameField.font = [UIFont fontWithName:FontName size:15];
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

//判断八位字母数字混合
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


//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[1]\\d{10}$"];
    return [predicate evaluateWithObject:mobile];
    
    
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


-(void)setuploading
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/tmp/myJson.txt"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    NSArray<NSData *> *arr = [NSArray arrayWithObjects:data, nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    [filePath removeItemAtPath:jsonString:&err];
    NSLog(@"8889%@",jsonString);
    [CUHTTPRequest POSTUpload:uploading parameters:@{} uploadType:(UploadDownloadType_Images) dataArray:arr success:^(id responseData) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            //             [MBProgressHUD showText:@"上传TXT文件成功"];
            //上传TXT文件成功，就删除
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:filePath];
            if (bRet) {
                NSError *err;
                [fileMgr removeItemAtPath:filePath error:&err];
            }
            
        }
        else
        {
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSInteger code) {
        
        
    }];
    
}



@end
