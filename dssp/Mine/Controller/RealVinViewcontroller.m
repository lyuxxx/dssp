//
//  RealVinViewcontroller.m
//  dssp
//
//  Created by qinbo on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RealVinViewcontroller.h"
#import <YYCategoriesSub/YYCategories.h>
#import "CarInfoViewController.h"
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
#import "RNRViewController.h"
#import "RNRPhotoViewController.h"
@interface RealVinViewcontroller () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *vinField;
@end

@implementation RealVinViewcontroller

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
//    if(_isSuccess)
//    {
//        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//    }
//    else
//    {
//
//    }
    self.navigationItem.title = NSLocalizedString(@"实名制认证", nil);
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 2;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowOpacity = 0.2;
//    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(262 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"logo"];
    [whiteV addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(131 * WidthCoefficient);
        make.height.equalTo(99.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.textAlignment = NSTextAlignmentCenter;
    intro.textColor = [UIColor whiteColor];
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"输入车辆VIN号", nil);
    [whiteV addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(logo.bottom).offset(24 * HeightCoefficient);
    }];
    
    self.vinField = [[UITextField alloc] init];
    _vinField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _vinField.delegate = self;
//    _vinField.text = [kVin isEqualToString:@""]?kVins:kVin;
    _vinField.text = kVin;
    _vinField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * WidthCoefficient, 22.5 * HeightCoefficient)];
    _vinField.leftViewMode = UITextFieldViewModeAlways;
    _vinField.textColor = [UIColor colorWithHexString:@"#040000"];
    _vinField.font = [UIFont fontWithName:FontName size:16];
    _vinField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入17位VIN号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
    _vinField.layer.cornerRadius = 2;
    _vinField.backgroundColor = [UIColor colorWithHexString:@"#eae9e9"];
    [whiteV addSubview:_vinField];
    [_vinField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(313 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(intro.bottom).offset(27.5 * HeightCoefficient);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    nextBtn.needNoRepeat = YES;
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(270 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(30 * HeightCoefficient);
    }];
}

- (void)nextBtnClick:(UIButton *)sender {
  
    if (_vinField.text.length !=17) {
        
        [MBProgressHUD showText:NSLocalizedString(@"请输入17位VIN号", nil)];
    }
    else if (_vinField.text.length == 17)
    {
        NSDictionary *paras = @{
                                @"vin": _vinField.text
                                };
        
        
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        
        
        [CUHTTPRequest POST:checkCerStatusByVin parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                   [hud hideAnimated:YES];
               BOOL result = [[dic objectForKey:@"data"] boolValue];
                if (result) {
                    ///未实名
                    RNRViewController *vc = [[RNRViewController alloc] init];
                    vc.bingVin = _vin?_vin:_vinField.text;
                    [self.navigationController pushViewController:vc animated:YES];

                }
                else 
                {
                    [hud hideAnimated:YES];
                    ///已实名
                    [MBProgressHUD showText:NSLocalizedString(@"实名认证信息已提交，请勿重复提交", nil)];
                }
                
            } else {
                [hud hideAnimated:YES];
                [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                
            }
        } failure:^(NSInteger code) {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
        }];
        
    }
        

    
//    if (![_vinField.text isEqualToString:@""]) {
//        NSDictionary *paras = @{
//                                @"vin": _vinField.text
//                                };
//        [CUHTTPRequest POST:checkCerStatusByVin parameters:paras success:^(id responseData) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//
//            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//
//                NSString *str = [NSString stringWithFormat: @"%@", dic[@"data"]];
//                if ([str isEqualToString:@"0"]) {
//                    ///未实名
//                    RNRViewController *vc = [[RNRViewController alloc] init];
//                    vc.bingVin = _vin?_vin:_vinField.text;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                }
//                else if ([str isEqualToString:@"1"])
//                {
//                    ///已实名
//                    [MBProgressHUD showText:NSLocalizedString(@"该vin已实名", nil)];
//                }
//
//            } else {
//
//                [MBProgressHUD showText:[dic objectForKey:@"msg"]];
//
//            }
//        } failure:^(NSInteger code) {
//            [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
//        }];
//
//        //        CarInfoViewController *vc = [[CarInfoViewController alloc] init];
//        //        vc.vin = _vinField.text;
//        //        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        RNRViewController *vc = [[RNRViewController alloc] init];
//        vc.bingVin = _vin?_vin:_vinField.text;
//        [self.navigationController pushViewController:vc animated:YES];
//        [MBProgressHUD showText:NSLocalizedString(@"请输入VIN号", nil)];
//    }
}

#pragma mark - UITextFieldDelegate -
//vin号大写
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}

@end


