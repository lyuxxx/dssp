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


@interface AccountViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextField * originalField;
@property (nonatomic, strong) UITextField * newsPasswordField;
@property (nonatomic, strong) UITextField * confirmField;
@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UIButton *modifyBtn;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"账户管理", nil);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"wifi密码"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(140 * HeightCoefficient + kStatusBarHeight);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.layer.cornerRadius = 31/2;
    imgV.layer.masksToBounds =YES;
    imgV.image = [UIImage imageNamed:@"Image_head"];
    [self.view addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(31 * WidthCoefficient);
        make.height.equalTo(31 * WidthCoefficient);
        make.left.equalTo(142 * WidthCoefficient);
        make.top.equalTo(63 * HeightCoefficient + kStatusBarHeight);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#C4B7A6"];
    _nameLabel.font = [UIFont fontWithName:FontName size:16];
    _nameLabel.text = @"李晓明";
    [self.view addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgV);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(imgV.right).offset(10 * WidthCoefficient);
    }];
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(227 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(115 * HeightCoefficient + kStatusBarHeight);
    }];
    
    UILabel *password = [[UILabel alloc] init];
    password.textAlignment = NSTextAlignmentCenter;
    password.text = NSLocalizedString(@"密码更换", nil);
    password.textColor = [UIColor colorWithHexString:@"#333333"];
    password.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [whiteV addSubview:password];
    [password makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(214 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.centerX.equalTo(whiteV);
        make.top.equalTo(20 * HeightCoefficient);
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
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(20 * HeightCoefficient);
            make.width.equalTo(60 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo(password.bottom).offset(24 + 49 * HeightCoefficient * i);
            
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
        [whiteV addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
            make.height.equalTo(1 * HeightCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.right.equalTo(-10 * WidthCoefficient);
            
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.delegate = self;
        field.textColor = [UIColor colorWithHexString:@"#040000"];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        field.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.right).offset(30*WidthCoefficient);
            make.width.equalTo(150 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.top.equalTo(password.bottom).offset(24 + 49 * HeightCoefficient * i);
        }];
        if (i == 0) {
            
            self.originalField = field;
             field.textColor = [UIColor colorWithHexString:@"#999999"];
            //  self.originalField.secureTextEntry = YES;
            
        } else if (i == 1){
            
            self.newsPasswordField = field;
            
            self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eyeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_eyeBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
            [_eyeBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
            [whiteV addSubview:_eyeBtn];
            [_eyeBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(16 * WidthCoefficient);
                make.height.equalTo(10 * HeightCoefficient);
                make.centerY.equalTo(_newsPasswordField);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            
        }
        else if (i == 2)
        {
            self.confirmField = field;
        }
        
    }
    
    
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
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
    
    //    [self getWifiInfo];
}


- (void)btnClick:(UIButton *)sender {
    if (sender == self.eyeBtn) {
        sender.selected = !sender.selected;
        self.newsPasswordField.secureTextEntry = !sender.selected;
    }
    if (sender == self.modifyBtn) {
        
        if (_originalField.text.length==0) {
        [MBProgressHUD showText:NSLocalizedString(@"原密码不能为空", nil)];
        }
        else if (_newsPasswordField.text.length==0)
        {
          [MBProgressHUD showText:NSLocalizedString(@"新密码不能为空", nil)];
        }
        else if (_confirmField.text==0)
        {
           [MBProgressHUD showText:NSLocalizedString(@"确定密码不能为空", nil)];
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
                                    @"newPassword":_newsPasswordField.text,
                                    @"password":_originalField.text

                                    };
            
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:resetPWD parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                    [hud hideAnimated:YES];
                    //响应事件
                    [MBProgressHUD showText:NSLocalizedString(@"密码修改成功", nil)];
                } else {
                    [MBProgressHUD showText:dic[@"msg"]];
                }
            } failure:^(NSInteger code) {
                hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
                [hud hideAnimated:YES afterDelay:1];
            }];
            
        }
        
    
    }
    
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

