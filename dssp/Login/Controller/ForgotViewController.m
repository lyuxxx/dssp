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
@interface ForgotViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *phoneCodeField;
@property (nonatomic, strong) UIButton *authBtn;
@property (nonatomic, strong) UIButton *nextBtn;
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
//    logoView.backgroundColor=[UIColor redColor];
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
     
    }
    if (sender == self.nextBtn) {
    //下一步
        NewPasswordViewController *VC = [[NewPasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
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
