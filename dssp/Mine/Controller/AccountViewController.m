//
//  AccountViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "AccountViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <CUHTTPRequest.h>
#import <MBProgressHUD+CU.h>
#import "CUAlertController.h"
#import "LoginViewController.h"
#import "InputAlertView.h"
@interface AccountViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField * originalField;
@property (nonatomic, strong) UITextField * newsPasswordField;
@property (nonatomic, strong) UITextField * confirmField;
@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UIButton *eyeBtn1;
@property (nonatomic, strong) UIButton *modifyBtn;

@property (nonatomic, strong) UIButton *eyeView;
@property (nonatomic, strong) UIButton *eyeView1;
@end

@implementation AccountViewController

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
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"AccountViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics staticsvisitTimesDataWithViewControllerType:@"AccountViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"AccountViewController"];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"账户管理", nil);
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    
//    UIImageView *bgImgV = [[UIImageView alloc] init];
//    bgImgV.image = [UIImage imageNamed:@"wifi密码"];
//    [self.view addSubview:bgImgV];
//    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(0);
//        make.height.equalTo(140 * HeightCoefficient + kStatusBarHeight);
//    }];
    
    
    UIView *V = [[UIView alloc] init];
    V.layer.cornerRadius = 2;
    V.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
    [self.view addSubview:V];
    [V makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 *WidthCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.top.equalTo(22 * HeightCoefficient);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.textAlignment = NSTextAlignmentLeft;
    intro.textColor = [UIColor whiteColor];
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"请填写新密码", nil);
    [self.view addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(24*WidthCoefficient);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
 
    
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 2;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowOpacity = 0.2;
//    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E "];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(152 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(55 * HeightCoefficient);
    }];
    

    
    NSArray *placeHolders = @[
                              NSLocalizedString(@"原密码", nil),
                              NSLocalizedString(@"新密码", nil),
                              NSLocalizedString(@"确认密码", nil)
                              ];
    
    
    
    for (NSInteger i = 0 ; i < placeHolders.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = placeHolders[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithHexString:@"#A18E79"];
        label.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(20 * HeightCoefficient);
            make.width.equalTo(60 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo(15 + 49 * HeightCoefficient * i);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
        [whiteV addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
            make.height.equalTo(1 * HeightCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.right.equalTo(-10 * WidthCoefficient);
            
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.delegate = self;
        field.secureTextEntry = true;
        field.textColor = [UIColor colorWithHexString:@"#ffffff"];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        field.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(15*WidthCoefficient);
            make.right.equalTo(-30 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.top.equalTo(15 + 49 * HeightCoefficient * i);
        }];
        if (i == 0) {
            
            self.originalField = field;
             field.textColor = [UIColor colorWithHexString:@"#999999"];
            //  self.originalField.secureTextEntry = YES;
            
        } else if (i == 1){
            
            self.newsPasswordField = field;
            
            self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eyeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_eyeBtn setImage:[UIImage imageNamed:@"密码不可见_icon"] forState:UIControlStateNormal];
            [_eyeBtn setImage:[UIImage imageNamed:@"密码可见_icon"] forState:UIControlStateSelected];
            [whiteV addSubview:_eyeBtn];
            [_eyeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(16 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.centerY.equalTo(_newsPasswordField);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            self.eyeView = [UIButton buttonWithType:UIButtonTypeCustom];
//            _eyeView.backgroundColor = [UIColor redColor];
            [_eyeView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

            [whiteV addSubview:_eyeView];
            [_eyeView makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(26 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.centerY.equalTo(_newsPasswordField);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            
        }
        else if (i == 2)
        {
            
            line.hidden = YES;
            self.confirmField = field;
//            self.confirmField.secureTextEntry = true;
//            self.confirmField.enabled = NO;
            self.eyeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eyeBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_eyeBtn1 setImage:[UIImage imageNamed:@"密码不可见_icon"] forState:UIControlStateNormal];
            [_eyeBtn1 setImage:[UIImage imageNamed:@"密码可见_icon"] forState:UIControlStateSelected];
            [whiteV addSubview:_eyeBtn1];
            [_eyeBtn1 makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(16 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.centerY.equalTo(_confirmField);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            self.eyeView1 = [UIButton buttonWithType:UIButtonTypeCustom];
            _eyeView1.backgroundColor = [UIColor clearColor];
            [_eyeView1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

            [whiteV addSubview:_eyeView1];
            [_eyeView1 makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(26 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.centerY.equalTo(_confirmField);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            
        
        }
        
    }
    
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"*请输入不少于八位字母和数字的混合密码", nil);
    
    botLabel.font = [UIFont fontWithName:FontName size:11];
    botLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
    [self.view addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16 * WidthCoefficient);
       make.top.equalTo(whiteV.bottom).offset(0 * HeightCoefficient);
        make.width.equalTo(260);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _modifyBtn.layer.cornerRadius = 2;
    [_modifyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_modifyBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [_modifyBtn setTitle:NSLocalizedString(@"确认修改", nil) forState:UIControlStateNormal];
    [_modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_modifyBtn.titleLabel setFont:[UIFont fontWithName:NSFontAttributeName size:16]];
    [self.view addSubview:_modifyBtn];
    [_modifyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(30 * HeightCoefficient);
    }];
    
    //    [self getWifiInfo];
}


- (void)btnClick:(UIButton *)sender {
    if (sender == self.eyeView) {
        _eyeBtn.selected = !_eyeBtn.selected;
        self.newsPasswordField.secureTextEntry = !_eyeBtn.selected;
    }
    if (sender == self.eyeView1) {
        _eyeBtn1.selected = !_eyeBtn1.selected;
        self.confirmField.secureTextEntry = !_eyeBtn1.selected;
    }
    if (sender == self.modifyBtn) {
        
        if ([KuserName isEqualToString:@"18911568274"]) {
            
            [MBProgressHUD showText:NSLocalizedString(@"当前为游客模式，无此操作权限", nil)];
            
        }
        else
        {
        
        if (![self checkPassWord:_originalField.text]||_originalField.text.length <8)
        {
         [MBProgressHUD showText:NSLocalizedString(@"原始密码格式有误", nil)];
        }
        else if (![self checkPassWord:_newsPasswordField.text]||_newsPasswordField.text.length <8)
        {
          [MBProgressHUD showText:NSLocalizedString(@"新密码格式有误", nil)];
        }
        else if (_confirmField.text.length <8 || ![self checkPassWord:_confirmField.text])
        {
          [MBProgressHUD showText:NSLocalizedString(@"确认密码格式有误", nil)];
        }
        else if (![_newsPasswordField.text isEqualToString:_confirmField.text])
        {
            [MBProgressHUD showText:NSLocalizedString(@"两次密码不一致", nil)];
            
        }
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userName = [defaults objectForKey:@"userName"];
            
            NSDictionary *paras = @{
                                    @"userName":userName,
                                    @"newPassword":[_newsPasswordField.text md5String],
                                    @"password":[_originalField.text md5String]

                                    };
            
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:resetPWD parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                    [hud hideAnimated:YES];
                    
                    //改
                    NSMutableDictionary *result = [NSMutableDictionary new];
                    [result setObject:@"" forKey:@"userName"];
                    [result setObject:@"" forKey:@"passWord"];
                    CONF_SET(@"user",result);
                    
                    InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                    [InputalertView initWithTitle:@"密码修改成功,是否退出重新登录?" img:@"警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否", nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview:InputalertView];
                    
                    InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                            
                            LoginViewController *vc=[[LoginViewController alloc] init];
                            RTRootNavigationController *navc = [[RTRootNavigationController alloc] initWithRootViewController:vc];
                            navc.hidesBottomBarWhenPushed = YES;
                            [[UIApplication sharedApplication].delegate.window setRootViewController:navc];
                            
                        }
                        if(btn.tag ==101)
                        {
                            //右边按钮
                            NSLog(@"666%@",str);
                            
                    
                        }
                    };
                    
        
                } else {
                    [MBProgressHUD showText:dic[@"msg"]];
                    [hud hideAnimated:YES];
                }
            } failure:^(NSInteger code) {
                hud.label.text = NSLocalizedString(@"网络异常", nil);
                [hud hideAnimated:YES afterDelay:1];
                [hud hideAnimated:YES];
            }];
            
        }
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

//- (void)secureBtnClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    _passwordField.secureTextEntry = !sender.selected;
//}
//
//- (void)modifyBtnClick:(UIButton *)sender {
//    if (![self checkWifi:_passwordField.text]) {
//        [MBProgressHUD showText:NSLocalizedString(@"字符不合法!", nil)];
//        return;
//    }
//    [self modifyWifiWithPassword:_passwordField.text];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

