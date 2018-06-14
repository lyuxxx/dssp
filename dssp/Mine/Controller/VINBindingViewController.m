//
//  VinBindingViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "VINBindingViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "CarInfoViewController.h"
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
#import "CarBindingViewController.h"
#import "MineViewController.h"
#import "CarBindingTViewController.h"
@interface VINBindingViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, strong) UITextField *enginenNumber;
@property (nonatomic, strong) CarbindModel *carbind;

@end

@implementation VINBindingViewController

- (BOOL)needGradientBg {
    return YES;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"车辆绑定", nil);
    
    self.rt_disableInteractivePop = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToHome2) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    self.navigationItem.leftBarButtonItem = left;
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)backToHome2 {
 
 [self.navigationController popViewControllerAnimated:YES];

}

- (void)setupUI {
    
//    self.navigationItem.leftBarButtonItem=nil;

    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 2;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(328 * HeightCoefficient);
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
    intro.text = NSLocalizedString(@"输入车辆VIN号和发动机号", nil);
    [whiteV addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(logo.bottom).offset(24 * HeightCoefficient);
    }];
    
    self.vinField = [[UITextField alloc] init];
    _vinField.delegate = self;
    _vinField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _vinField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * WidthCoefficient, 22.5 * HeightCoefficient)];
    _vinField.leftViewMode = UITextFieldViewModeAlways;
    _vinField.textColor = [UIColor colorWithHexString:@"#040000"];
    _vinField.font = [UIFont fontWithName:FontName size:16];
    _vinField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入17位VIN号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
    _vinField.layer.cornerRadius = 2;
    _vinField.backgroundColor = [UIColor colorWithHexString:@"#eae9e9"];
    [whiteV addSubview:_vinField];
    [_vinField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(280 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(intro.bottom).offset(27.5 * HeightCoefficient);
    }];
    
    
    self.enginenNumber = [[UITextField alloc] init];
    _enginenNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * WidthCoefficient, 22.5 * HeightCoefficient)];
     _enginenNumber.keyboardType = UIKeyboardTypePhonePad;
    _enginenNumber.leftViewMode = UITextFieldViewModeAlways;
    _enginenNumber.textColor = [UIColor colorWithHexString:@"#040000"];
    _enginenNumber.font = [UIFont fontWithName:FontName size:16];
    _enginenNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入发动机号后七位" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
    _enginenNumber.layer.cornerRadius = 2;
    _enginenNumber.backgroundColor = [UIColor colorWithHexString:@"#eae9e9"];
    [whiteV addSubview:_enginenNumber];
    [_enginenNumber makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(280 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_vinField.bottom).offset(20 * HeightCoefficient);
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
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(30 * HeightCoefficient);
    }];
}

- (void)nextBtnClick:(UIButton *)sender {

    if (_vinField.text.length !=17) {
       
         [MBProgressHUD showText:NSLocalizedString(@"请输入17位VIN号", nil)];
        
    }
    else if (_enginenNumber.text.length !=7) {
        
         [MBProgressHUD showText:NSLocalizedString(@"请输入发动机号后七位", nil)];
    }
    else if (_vinField.text.length == 17 &&_enginenNumber.text.length ==7)
    {
        
                NSDictionary *paras = @{
                                        @"vin": _vinField.text,
                                        @"doptCode":_enginenNumber.text
                                        };
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:checkBindByVin parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    _carbind = [CarbindModel yy_modelWithDictionary:dic[@"data"]];

                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                          [hud hideAnimated:YES];
                        if (_carbind.isExist) {
                            
                            if([_carbind.vhlTStatus isEqualToString:@"1"])
                            {
                                if (![_carbind.doptCode isEqualToString:_enginenNumber.text]) {
                                        [MBProgressHUD showText:@"发动车号有误"];
                                    
                                }else{
                                    ///T车跳绑定详细页面
                                    CarBindingTViewController *vc = [[CarBindingTViewController alloc] init];
                                    vc.carbind = _carbind;
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }
                            else
                            {
                                
                                InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                                [InputalertView initWithTitle:@"您当前输入的是非T车,是否继续绑定?" img:@"账号警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否",nil] ];
                                //            InputalertView.delegate = self;
                                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                                [keywindow addSubview: InputalertView];
                                
                                InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                                    if (btn.tag == 100) {//左边按钮
                                        ///非T跳车辆绑定填写页面
                                        CarBindingViewController *vc = [[CarBindingViewController alloc] init];
                                        vc.bingVin = _vinField.text;
                                        vc.doptCode = _enginenNumber.text;
                                        vc.carbind = _carbind;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                    if(btn.tag ==101)
                                    {
                                        //右边按钮
                                    }
                                };
                            }
                        }
                        else
                        {
                          
                            InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                            [InputalertView initWithTitle:@"您当前输入的是非T车,是否继续绑定?" img:@"账号警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否",nil] ];
                            //            InputalertView.delegate = self;
                            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                            [keywindow addSubview: InputalertView];
                            
                            InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                                if (btn.tag == 100) {//左边按钮
                                    ///非T跳车辆绑定填写页面
                                    CarBindingViewController *vc = [[CarBindingViewController alloc] init];
                                    vc.bingVin = _vinField.text;
                                    vc.doptCode = _enginenNumber.text;
                                    vc.carbind = _carbind;
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                                if(btn.tag ==101)
                                {
                                    //右边按钮
                                }
                            };
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
//        else {
////
////                [MBProgressHUD showText:NSLocalizedString(@"请输入VIN号", nil)];
////            }
//    
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
