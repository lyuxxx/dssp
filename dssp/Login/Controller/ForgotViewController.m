//
//  ForgotViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ForgotViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "NewPasswordViewController.h"
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
@interface ForgotViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *phoneCodeField;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic,copy) NSString *codes;
@end

@implementation ForgotViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroud"] forBarMetrics:UIBarMetricsDefault];
    [self setupUI];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"手机验证", nil);
  
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"resetpassword_icon"];
    logoView.layer.cornerRadius = 64 / 2;
    logoView.layer.masksToBounds = YES;
    [self.view addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(64 * WidthCoefficient);
        make.height.equalTo(64 * WidthCoefficient);
        make.top.equalTo(65.5 * HeightCoefficient + kStatusBarHeight);
    }];
    

    self.phoneField = [[UITextField alloc] init];
    _phoneField.keyboardType = UIKeyboardTypePhonePad;
    _phoneField.textColor = [UIColor whiteColor];
    _phoneField.delegate = self;
    _phoneField.font = [UIFont fontWithName:FontName size:15];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机号", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneField];
    [_phoneField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(198 * HeightCoefficient +kStatusBarHeight);
        make.left.equalTo(42.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(150 * WidthCoefficient);
    }];
    
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(223 * HeightCoefficient +kStatusBarHeight);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    self.phoneCodeField = [[UITextField alloc] init];
    _phoneCodeField.keyboardType = UIKeyboardTypeNumberPad;
    //    _phoneCodeField.secureTextEntry = true;
    _phoneCodeField.delegate = self;
    _phoneCodeField.textColor = [UIColor whiteColor];
    _phoneCodeField.font = [UIFont fontWithName:FontName size:15];
    _phoneCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"手机验证码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_phoneCodeField];
    [_phoneCodeField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(255.5 * HeightCoefficient + kStatusBarHeight);
        make.right.left.height.equalTo(_phoneField);
    }];

    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(280.5 * HeightCoefficient + kStatusBarHeight);
        make.height.equalTo(0.5 * HeightCoefficient);
        make.width.equalTo(290 * WidthCoefficient);
    }];
    
    
    self.authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _authBtn.layer.cornerRadius = 2;
//    _authBtn.hidden = YES;
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
    

    self.nextBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _nextBtn.layer.borderWidth = 0.75;
    _nextBtn.layer.cornerRadius = 2;
    _nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor colorWithHexString:@"#C4B7A6"] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    [_nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(290 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.top.equalTo(355 * HeightCoefficient + kStatusBarHeight);
    }];

}


- (void)BtnClick:(UIButton *)sender {
    if (sender == self.authBtn) {
     //获取手机验证码
        if (_phoneField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
        }
        else
        {
            if ([self valiMobile:_phoneField.text]){
                NSDictionary *paras = @{
                                        @"telephone":_phoneField.text,
                                        @"randomCodeType":@"resetPWD"
                                        };
                [CUHTTPRequest POST:getRandomCode parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    // LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:NSLocalizedString(@"验证码已发送,请查看短信", nil)];
                        
//                        _phoneCodeField.text = dic[@"data"];
                        _codes = dic[@"code"];
                        
                    } else {
                        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                        hud.label.text = [dic objectForKey:@"msg"];
                        [hud hideAnimated:YES afterDelay:1];
                    }
                } failure:^(NSInteger code) {
                    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                    hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"获取验证码失败", nil),code];
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
    if (sender == self.nextBtn) {
    
        if (_phoneField.text.length == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"手机号不能为空", nil)];
        }
        else if (_phoneCodeField.text.length == 0)
        {
          [MBProgressHUD showText:NSLocalizedString(@"验证码不能为空", nil)];
            
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
                NSDictionary *paras = @{
                                        @"userName":_phoneField.text,
                                        @"randomCode":_phoneCodeField.text
                                        
                                        };
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:verificationMobile parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    //                        LoginResult *result = [LoginResult yy_modelWithDictionary:dic];
                    if ([dic[@"code"] isEqualToString:@"200"]) {
                        
                        [hud hideAnimated:YES];
                        NewPasswordViewController *VC = [[NewPasswordViewController alloc] init];
                        VC.phone = _phoneField.text;
                        [self.navigationController pushViewController:VC animated:YES];
                        
                    }
                    else {
                        [hud hideAnimated:YES];
                        [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                        
                    }
                } failure:^(NSInteger code) {
                    [hud hideAnimated:YES];
                    [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
                }];
            }
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

    if(textField == self.phoneField) {
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
