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
@interface NewPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *newpassphoneField;
@property (nonatomic, strong) UITextField *confirmField;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn;
@property (nonatomic, strong) UIButton *smallEyeBtn1;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"backgroud"] forBarMetrics:UIBarMetricsDefault];
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"重置密码", nil);
    
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
    
    
    self.newpassphoneField = [[UITextField alloc] init];
    _newpassphoneField.keyboardType = UIKeyboardTypePhonePad;
    _newpassphoneField.textColor = [UIColor whiteColor];
    _newpassphoneField.delegate = self;
    //    _phoneField.hidden = YES;
    _newpassphoneField.font = [UIFont fontWithName:FontName size:15];
    _newpassphoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"新密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_newpassphoneField];
    [_newpassphoneField makeConstraints:^(MASConstraintMaker *make) {
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
    
    self.confirmField = [[UITextField alloc] init];
    _confirmField.keyboardType = UIKeyboardTypeNumberPad;
    //    _phoneCodeField.secureTextEntry = true;
    //    _phoneCodeField.hidden = YES;
    _confirmField.delegate = self;
    _confirmField.textColor = [UIColor whiteColor];
    _confirmField.font = [UIFont fontWithName:FontName size:15];
    _confirmField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"确认新密码", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
    [self.view addSubview:_confirmField];
    [_confirmField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(255.5 * HeightCoefficient + kStatusBarHeight);
        make.right.left.height.equalTo(_newpassphoneField);
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
    
    self.smallEyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateNormal];
    [_smallEyeBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateSelected];
    [_smallEyeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn];
    [_smallEyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(line0);
        make.height.equalTo(10 * HeightCoefficient);
        make.top.equalTo(206 * HeightCoefficient + kStatusBarHeight);
    }];
    
    self.smallEyeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_smallEyeBtn1 setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateNormal];
    [_smallEyeBtn1 setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateSelected];
    [_smallEyeBtn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_smallEyeBtn1];
    [_smallEyeBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(16 * WidthCoefficient);
        make.right.equalTo(line);
        make.height.equalTo(10 * HeightCoefficient);
        make.top.equalTo(263.5 * HeightCoefficient + kStatusBarHeight);
    }];
    
    self.nextBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _nextBtn.layer.borderWidth = 0.75;
    _nextBtn.layer.cornerRadius = 2;
    _nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_nextBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
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
    if (sender == self.smallEyeBtn) {
        
        sender.selected = !sender.selected;
        self.newpassphoneField.secureTextEntry = !sender.selected;
       
    }
    if (sender == self.smallEyeBtn1) {
        sender.selected = !sender.selected;
        self.confirmField.secureTextEntry = !sender.selected;
    }
    if (self.nextBtn) {
     
        if (_newpassphoneField.text.length==0) {
            [MBProgressHUD showText:NSLocalizedString(@"新密码不能为空", nil)];
        }
        else if(_confirmField.text.length==0)
        {
            [MBProgressHUD showText:NSLocalizedString(@"确认新密码不能为空", nil)];
        }
        else if ([_newpassphoneField.text isEqualToString:_confirmField.text])
        {
            NSDictionary *paras = @{
                                    @"userName":_phone,
                                    @"newPassword":_newpassphoneField.text
                                    };
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:resetNewPWD parameters:paras response:^(id responseData) {
                if (responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                
                    if ([dic[@"code"] isEqualToString:@"200"]) {
                        
                         [hud hideAnimated:YES];
                         [MBProgressHUD showText:NSLocalizedString(@"重置密码成功", nil)];
                    }
                    else {
                        [hud hideAnimated:YES];
                        [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                        
                    }
                }
                else {
                    [hud hideAnimated:YES];
                    [MBProgressHUD showText:NSLocalizedString(@"请求失败", nil)];
                }
            }];
        }
        }
        else
        {
             [MBProgressHUD showText:NSLocalizedString(@"两次密码不一致，请重新输入", nil)];
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
