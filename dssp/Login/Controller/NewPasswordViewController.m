//
//  NewPasswordViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/13.
//  Copyright © 2017年 capsa. All rights reserved.
//





#import "NewPasswordViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "NewPasswordViewController.h"
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "InputAlertView.h"
@interface NewPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *newpassphoneField;
@property (nonatomic, strong) UITextField *confirmField;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn1;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation NewPasswordViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroud"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.clipsToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"重置密码", nil);
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"找回密码背景"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = NSLocalizedString(@"输入新密码", nil);
    topLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    [topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(42.5 * WidthCoefficient);
        make.top.equalTo(38.5 * HeightCoefficient);
        make.width.equalTo(190 * WidthCoefficient);
        make.height.equalTo(30 * HeightCoefficient);
    }];
    
    
    self.newpassphoneField = [[UITextField alloc] init];
//    _newpassphoneField.keyboardType = UIKeyboardTypePhonePad;
    _newpassphoneField.textColor = [UIColor whiteColor];
    _newpassphoneField.delegate = self;
    //    _phoneField.hidden = YES;
    _newpassphoneField.font = [UIFont fontWithName:FontName size:15];
    _newpassphoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_newpassphoneField];
    [_newpassphoneField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLabel.bottom).offset(70*HeightCoefficient);
        make.left.equalTo(42.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(150 * WidthCoefficient);
    }];
    
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:@"#2F2726"];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    make.top.equalTo(_newpassphoneField.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    self.confirmField = [[UITextField alloc] init];
//    _confirmField.keyboardType = UIKeyboardTypeNumberPad;
//    _confirmField.secureTextEntry = false;
    //    _phoneCodeField.hidden = YES;
    _confirmField.delegate = self;
    _confirmField.textColor = [UIColor whiteColor];
    _confirmField.font = [UIFont fontWithName:FontName size:15];
    _confirmField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"确认密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_confirmField];
    [_confirmField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line0.bottom).offset(40*HeightCoefficient);
       
        make.right.left.height.equalTo(_newpassphoneField);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#2F2726"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_confirmField.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    self.smallEyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"密码可见_icon"] forState:UIControlStateNormal];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"密码不可见_icon"] forState:UIControlStateSelected];
    [_smallEyeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn];
    [_smallEyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(line0);
        make.height.equalTo(16 * WidthCoefficient);
        make.top.equalTo(146.2 * HeightCoefficient);
    }];
    
    self.smallEyeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn1 setImage:[UIImage imageNamed:@"密码可见_icon"] forState:UIControlStateNormal];
    [_smallEyeBtn1 setImage:[UIImage imageNamed:@"密码不可见_icon"] forState:UIControlStateSelected];

    [_smallEyeBtn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn1];
    [_smallEyeBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(line);
        make.height.equalTo(16 * WidthCoefficient);
        make.top.equalTo(211 * HeightCoefficient);
    }];
    
    self.nextBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _nextBtn.layer.borderWidth = 0.75;
    _nextBtn.layer.cornerRadius = 2;
    _nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_nextBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#C4B7A6"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    [_nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(290 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
       make.top.equalTo(line.bottom).offset(50*HeightCoefficient);
    }];
    
}

- (void)BtnClick:(UIButton *)sender {
    if (sender == self.smallEyeBtn) {
        sender.selected = !sender.selected;
        self.newpassphoneField.secureTextEntry = sender.selected;
       
    }
    if (sender == self.smallEyeBtn1) {
        sender.selected = !sender.selected;
        self.confirmField.secureTextEntry = sender.selected;
    }
    if (sender == self.nextBtn) {
     
        if (_newpassphoneField.text.length==0|| ![self checkPassWord:_newpassphoneField.text]) {
            [MBProgressHUD showText:NSLocalizedString(@"请输入八位字母和数字混合的新密码", nil)];
        }
        else if(_confirmField.text.length==0|| ![self checkPassWord:_confirmField.text])
        {
            [MBProgressHUD showText:NSLocalizedString(@"请输入八位字母和数字混合的确认密码", nil)];
        }
        else if ([_newpassphoneField.text isEqualToString:_confirmField.text])
        {
            NSDictionary *paras = @{
                            @"userName":_phone,
                            @"newPassword":[_newpassphoneField.text md5String]
                                    };
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:resetNewPWD parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                
                if ([dic[@"code"] isEqualToString:@"200"]) {
                    
                    [hud hideAnimated:YES];
                    InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                    [InputalertView initWithTitle:@"重置密码成功，是否重新登录?" img:@"警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否", nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview:InputalertView];
                    
                    InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                          
                        [self.navigationController popToRootViewControllerAnimated:YES];
                          
                        }
                        if(btn.tag ==101)
                        {
                            //右边按钮
                            NSLog(@"666%@",str);
 
                        }
                        
                    };
                    
                    
//                    [MBProgressHUD showText:NSLocalizedString(@"重置密码成功", nil)];
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
        
        else
        {
            [MBProgressHUD showText:NSLocalizedString(@"两次密码不一致，请重新输入", nil)];
        }
        }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // 当输入框获得焦点时，执行该方法 （光标出现时）。
    //开始编辑时触发，文本字段将成为first responder
    textField.attributedPlaceholder = nil;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    
    if(textField == self.newpassphoneField) {
        _newpassphoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _newpassphoneField.font = [UIFont fontWithName:FontName size:15];
    }
    else
    {
        _confirmField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"确认新密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
        _confirmField.font = [UIFont fontWithName:FontName size:15];
    }
    return YES;
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
