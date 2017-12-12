//
//  CarBindingViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarBindingViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "CarSeriesViewController.h"
#import <CUHTTPRequest.h>
#import "CarBindingInput.h"
#import "RNRViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import <MBProgressHUD+CU.h>
#import "RealVinViewcontroller.h"

@interface CarBindingViewController ()

@property (nonatomic, strong) CarBindingInput *bindingInput;

@property (nonatomic, strong) UITextField *customerNameField;
@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, strong) UITextField *doptField;
@property (nonatomic, strong) UILabel *carSeries;
@property (nonatomic, strong) UITextField *vhlLicenceField;

@end

@implementation CarBindingViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"车辆绑定", nil);
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.cornerRadius = 4;
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(313.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient + kNaviHeight);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.textAlignment = NSTextAlignmentCenter;
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"填写车辆信息完成车辆绑定", nil);
    [whiteV addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    NSArray<NSString *> *titles = @[NSLocalizedString(@"车主姓名", nil),NSLocalizedString(@"VIN", nil),NSLocalizedString(@"发动机号", nil),NSLocalizedString(@"车系", nil),NSLocalizedString(@"车牌号", nil)];
    NSArray<NSString *> *placeHolders = @[NSLocalizedString(@"请填写姓名", nil),NSLocalizedString(@"请填写VIN号", nil),NSLocalizedString(@"请填写发动机号", nil),NSLocalizedString(@"", nil),NSLocalizedString(@"请填写车牌号", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:FontName size:15];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.text = titles[i];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
            make.top.equalTo((66.5 + 49 * i) * HeightCoefficient);
        }];
        
        if (i != 3) {
            UITextField *field = [[UITextField alloc] init];
            field.font = [UIFont fontWithName:FontName size:15];
            field.textColor = [UIColor colorWithHexString:@"333333"];
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
         
            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [whiteV addSubview:field];
            [field makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
                make.centerY.equalTo(label);
                make.height.equalTo(label);
                make.width.equalTo(190 * WidthCoefficient);
            }];
            
            if (i == 0) {
                field.text = _carInfo.customerName;
                self.customerNameField = field;
            } else if (i == 1) {
                field.text = _carInfo.vin;
                self.vinField = field;
                field.userInteractionEnabled=NO;
            } else if (i == 2) {
               
                self.doptField = field;
            } else if (i == 4) {
                self.vhlLicenceField = field;
            }
            
        } else {
            self.carSeries = [[UILabel alloc] init];
            _carSeries.userInteractionEnabled = YES;
            _carSeries.text = NSLocalizedString(@"请选择车系", nil);
            _carSeries.font = [UIFont fontWithName:FontName size:15];
            _carSeries.textColor = [UIColor colorWithHexString:@"#040000"];
            [whiteV addSubview:_carSeries];
            [_carSeries makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
                make.centerY.equalTo(label);
                make.height.equalTo(label);
                make.width.equalTo(150 * WidthCoefficient);
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seriesLabelTap:)];
            [_carSeries addGestureRecognizer:tap];
        }
        
        if (i < titles.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
            [whiteV addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(313 * WidthCoefficient);
                make.height.equalTo(1 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
            }];
        }
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 2;
    [confirmBtn setTitle:NSLocalizedString(@"确认并绑定", nil) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:confirmBtn];
    [confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.doptField) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringToIndex:7];
        }
    }
}

- (void)confirmBtnClick:(UIButton *)sender {
    
    if (!_customerNameField.text || [_customerNameField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写姓名", nil)];
        return;
    } else if (!_vinField.text || [_vinField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写VIN号", nil)];
        return;
    } else if (!_doptField.text || [_doptField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写发动机号", nil)];
        return;
    } else if ([_carSeries.text isEqualToString:NSLocalizedString(@"请选择车系", nil)]) {
        [MBProgressHUD showText:NSLocalizedString(@"请选择车系", nil)];
        return;
    } else if (!_vhlLicenceField.text || [_vhlLicenceField.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写车牌号", nil)];
        return;
    }
    
    self.bindingInput.vin = _vinField.text;
    self.bindingInput.customerName = _carInfo.customerName?_carInfo.customerName:@"";
    self.bindingInput.credentials = _carInfo.customerCredentials?_carInfo.customerCredentials:@"";
    self.bindingInput.credentialsNum = _carInfo.customerCredentialsNum;
    self.bindingInput.sex = _carInfo.customerSex?_carInfo.customerSex:@"";
    self.bindingInput.mobilePhone = _carInfo.customerMobilePhone?_carInfo.customerMobilePhone:@"";
    self.bindingInput.phone = _carInfo.customerHomePhone?_carInfo.customerHomePhone:@"15871707603";
    self.bindingInput.email = _carInfo.customerEmail?_carInfo.customerEmail:@"";
    self.bindingInput.vhlType =  _carSeries.text;
    self.bindingInput.vhlLicence = _vhlLicenceField.text;
    self.bindingInput.remark = _carInfo.remark?_carInfo.remark:@"备注";
    self.bindingInput.doptCode = _doptField.text;
    NSDictionary *paras = @{
                            @"vin": self.bindingInput.vin,
                            @"customerName": self.bindingInput.customerName,
                            @"credentials": self.bindingInput.credentials,
                            @"credentialsNum": self.bindingInput.credentialsNum,
                            @"sex": self.bindingInput.sex,
                            @"mobilePhone": self.bindingInput.mobilePhone,
                            @"phone": self.bindingInput.phone,
                            @"email": self.bindingInput.email,
                            @"vhlType": self.bindingInput.vhlType,
                            @"vhlLicense": self.bindingInput.vhlLicence,
                            @"remark": self.bindingInput.remark,
                            @"doptCode": self.bindingInput.doptCode
                            };
    [CUHTTPRequest POST:bind parameters:paras response:^(id responseData) {
        if (responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] isEqualToString:@"200"]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBinded"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                NSString *isPush = [defaults objectForKey:@"isPush"];
              
                if (isPush) {
                    
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                    message:@"车辆绑定成功,是否跳转实名制页面"
                    preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        //响应事件
                        //跳实名制vin
                        RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
                        vc.vin=_carInfo.vin;
                        vc.isSuccess = @"1";
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        MineViewController *vc=[[MineViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                    [alert addAction:defaultAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else
                {
                    NSLog(@"是从MineViewController过来的页面");
                    [MBProgressHUD showText:NSLocalizedString(@"绑定成功", nil)];
                    
                }
                
//                NSArray *viewControllers = self.navigationController.viewControllers;
//                [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj isKindOfClass:[HomeViewController class]]) {
//                        NSLog(@"是从HomeViewController过来的页面");
//                        RNRViewController *vc=[[RNRViewController alloc] init];
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                    else
//                    {
//                        NSLog(@"是从MineViewController过来的页面");
//                        [MBProgressHUD showText:NSLocalizedString(@"绑定成功", nil)];
//                    }
//                }];
            }
            
            else {
                [MBProgressHUD showText:dic[@"msg"]];
            }
        } else {
            [MBProgressHUD showText:NSLocalizedString(@"请求失败", nil)];
        }
    }];
    
    
}

- (void)seriesLabelTap:(UITapGestureRecognizer *)sender {
    CarSeriesViewController *vc = [[CarSeriesViewController alloc] init];
    vc.carSeriesSelct = ^(NSString *carSeries) {
        _carSeries.text = carSeries;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CarBindingInput *)bindingInput {
    if (!_bindingInput) {
        _bindingInput = [[CarBindingInput alloc] init];
    }
    return _bindingInput;
}

@end
