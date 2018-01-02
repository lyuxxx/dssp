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
@property (nonatomic, strong) UILabel *carSeries;
@property (nonatomic, strong) UILabel *carModels;
@property (nonatomic, strong) UITextField *vhlLicenceField;
@property (nonatomic, strong) UIScrollView *sc;
@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, strong) UITextField *doptField;
@property (nonatomic, strong) UITextField *vhlColorName;
@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *mobilePhone;
@property (nonatomic, strong) UITextField *sex;
@property (nonatomic, copy) NSString *vhlTStatustr;
@property (nonatomic, copy) NSString *isExiststr;
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
        make.height.equalTo(461.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20.5 * HeightCoefficient);
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
    
    
    NSArray<NSString *> *titles = @[
                                    
                                    NSLocalizedString(@"VIN", nil),
                                    NSLocalizedString(@"发动机号", nil),
                                    NSLocalizedString(@"车型", nil),
                                    NSLocalizedString(@"车系", nil),
                                    NSLocalizedString(@"颜色", nil),
                                    NSLocalizedString(@"用户名", nil),
                                    NSLocalizedString(@"联系方式", nil),
                                    NSLocalizedString(@"性别", nil)
                                  
                                    ];
    NSArray<NSString *> *placeHolders = @[
                                          
                                          NSLocalizedString(@"请填写VIN号", nil),
                                          NSLocalizedString(@"请填写发动机号", nil),
                                          NSLocalizedString(@"", nil),
                                          NSLocalizedString(@"", nil),
                                          NSLocalizedString(@"请填写车辆颜色", nil),
                                          NSLocalizedString(@"请填写用户名", nil),
                                          NSLocalizedString(@"请填写手机号", nil),
                                          NSLocalizedString(@"请填写性别", nil)
                            
                                          ];
    
    self.sc = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [whiteV addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(whiteV).offset(UIEdgeInsetsMake(66 * HeightCoefficient, 0, 50 * HeightCoefficient, 0));
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.width.equalTo(whiteV.width);
        }];
        
        UILabel *lastLabel = nil;
        UIView *lastView = nil;
        for (NSInteger i = 0 ; i < titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = titles[i];
            label.textColor = [UIColor colorWithHexString:@"#040000"];
            label.font = [UIFont fontWithName:FontName size:15];
            [contentView addSubview:label];
            
            
            UIView *whiteV = [[UIView alloc] init];
            [contentView addSubview:whiteV];
            
            UIView *whiteView = [[UIView alloc] init];
            whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
            [contentView addSubview:whiteView];
            
            
            if (i == 0) {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                
                
                [whiteV makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(0);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(20*WidthCoefficient);
                    make.top.equalTo(0);
                }];
                
                
                [whiteView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(34 * HeightCoefficient);
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            } else{
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(29 * HeightCoefficient);
                }];
                
                
                [whiteV makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(0);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(20*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(29*HeightCoefficient);
                }];
                
                [whiteView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.bottom).offset(48 * HeightCoefficient);
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            }
            lastLabel = label;
            lastView =whiteView;
            
            
            if (i != 2 && i !=3) {
                
                self.field = [[UITextField alloc] init];
                _field.font = [UIFont fontWithName:FontName size:15];
                _field.textColor = [UIColor colorWithHexString:@"333333"];
                _field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
//                _field.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_field];
                [_field makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(120 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                
                if (i == 0) {
                    _field.text = _bingVin;
                    self.vinField = _field;
                } else if (i == 1) {
                    _field.text = _doptCode;
                    self.doptField = _field;
                    
                } else if (i == 4) {
                    _field.text = @"";
                    self.vhlColorName = _field;
                    
                } else if (i == 5) {
                    _field.text = @"";
                    self.userName = _field;
                    
                } else if (i == 6) {
                    _field.text = @"";
                    self.mobilePhone = _field;
                    
                } else if (i == 7) {
                    _field.text = @"";
                    self.sex = _field;
                    
                }
            }
            else if (i==2)
            {
                self.carModels = [[UILabel alloc] init];
                _carModels.userInteractionEnabled = YES;
                _carModels.text = NSLocalizedString(@"请选择车型", nil);
                _carModels.font = [UIFont fontWithName:FontName size:15];
                _carModels.textColor = [UIColor colorWithHexString:@"#040000"];
                [whiteV addSubview:_carModels];
                [_carModels makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(0 * WidthCoefficient);
                    make.centerY.equalTo(label);
                    make.height.equalTo(label);
                    make.width.equalTo(150 * WidthCoefficient);
                }];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modelsLabelTap:)];
                [_carModels addGestureRecognizer:tap];
        
            
              
                
            }
            else if (i==3)
            {
                
                self.carSeries = [[UILabel alloc] init];
                _carSeries.userInteractionEnabled = YES;
                _carSeries.text = NSLocalizedString(@"请选择车系", nil);
                _carSeries.font = [UIFont fontWithName:FontName size:15];
                _carSeries.textColor = [UIColor colorWithHexString:@"#040000"];
                [whiteV addSubview:_carSeries];
                [_carSeries makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(0 * WidthCoefficient);
                    make.centerY.equalTo(label);
                    make.height.equalTo(label);
                    make.width.equalTo(150 * WidthCoefficient);
                }];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seriesLabelTap:)];
                [_carSeries addGestureRecognizer:tap];
               
            
            }
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastLabel.bottom).offset(0);
            
        }];
        
        scroll;
    });
    
    
    
//    NSArray<NSString *> *placeHolders = @[NSLocalizedString(@"请填写姓名", nil),NSLocalizedString(@"请填写VIN号", nil),NSLocalizedString(@"请填写发动机号", nil),NSLocalizedString(@"", nil),NSLocalizedString(@"请填写车牌号", nil)];
//    for (NSInteger i = 0; i < titles.count; i++) {
//
//        UILabel *label = [[UILabel alloc] init];
//        label.font = [UIFont fontWithName:FontName size:15];
//        label.textColor = [UIColor colorWithHexString:@"#040000"];
//        label.text = titles[i];
//        [whiteV addSubview:label];
//        [label makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(60 * WidthCoefficient);
//            make.height.equalTo(20 * HeightCoefficient);
//            make.left.equalTo(15 * WidthCoefficient);
//            make.top.equalTo((66.5 + 49 * i) * HeightCoefficient);
//        }];
//
//        if (i != 3) {
//            UITextField *field = [[UITextField alloc] init];
//            field.font = [UIFont fontWithName:FontName size:15];
//            field.textColor = [UIColor colorWithHexString:@"333333"];
//            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
//
//            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//
//            [whiteV addSubview:field];
//            [field makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
//                make.centerY.equalTo(label);
//                make.height.equalTo(label);
//                make.width.equalTo(190 * WidthCoefficient);
//            }];
//
//            if (i == 0) {
//                field.text = _carInfo.customerName;
//                self.customerNameField = field;
//            } else if (i == 1) {
//                field.text = _bingVin;
//                self.vinField = field;
//                field.userInteractionEnabled=NO;
//            } else if (i == 2) {
//
//                self.doptField = field;
//            }
//            else if (i == 4) {
//                self.vhlLicenceField = field;
//            }
//
//        }
//        else {
//
////            UITextField *field = [[UITextField alloc] init];
////            field.font = [UIFont fontWithName:FontName size:15];
////            field.textColor = [UIColor colorWithHexString:@"333333"];
////            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"请填写车系", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
////
////            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
////
////            [whiteV addSubview:field];
////            [field makeConstraints:^(MASConstraintMaker *make) {
////                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
////                make.centerY.equalTo(label);
////                make.height.equalTo(label);
////                make.width.equalTo(190 * WidthCoefficient);
////            }];
//
//
////             self.carSeries = field;
//
//
//            self.carSeries = [[UILabel alloc] init];
//            _carSeries.userInteractionEnabled = YES;
//            _carSeries.text = NSLocalizedString(@"请选择车系", nil);
//            _carSeries.font = [UIFont fontWithName:FontName size:15];
//            _carSeries.textColor = [UIColor colorWithHexString:@"#040000"];
//            [whiteV addSubview:_carSeries];
//            [_carSeries makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
//                make.centerY.equalTo(label);
//                make.height.equalTo(label);
//                make.width.equalTo(150 * WidthCoefficient);
//            }];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seriesLabelTap:)];
//            [_carSeries addGestureRecognizer:tap];
//        }
//
//        if (i < titles.count - 1) {
//            UIView *line = [[UIView alloc] init];
//            line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
//            [whiteV addSubview:line];
//            [line makeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(313 * WidthCoefficient);
//                make.height.equalTo(1 * HeightCoefficient);
//                make.centerX.equalTo(0);
//                make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
//            }];
//        }
//    }
//
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
    if ([_carSeries.text isEqualToString:NSLocalizedString(@"请选择车系", nil)]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写车型", nil)];
        return;
    } else if ([_carSeries.text isEqualToString:NSLocalizedString(@"请选择车系", nil)]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写车系", nil)];
        return;
    } else if (!_vhlColorName.text || [_vhlColorName.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写车辆颜色", nil)];
        return;
    } else if (!_userName.text || [_userName.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写用户名", nil)];
        return;
    }
    else if (!_mobilePhone.text || [_mobilePhone.text isEqualToString:@""]) {
        [MBProgressHUD showText:NSLocalizedString(@"请填写联系方式", nil)];
        return;
    }
    
//    self.bindingInput.vin = _vinField.text;
//    self.bindingInput.customerName = _carInfo.customerName?_carInfo.customerName:@"";
//    self.bindingInput.credentials = _carInfo.customerCredentials?_carInfo.customerCredentials:@"";
//    self.bindingInput.credentialsNum = _carInfo.customerCredentialsNum;
//    self.bindingInput.sex = _carInfo.customerSex?_carInfo.customerSex:@"";
//    self.bindingInput.mobilePhone = _carInfo.customerMobilePhone?_carInfo.customerMobilePhone:@"";
//    self.bindingInput.phone = _carInfo.customerHomePhone?_carInfo.customerHomePhone:@"15871707603";
//    self.bindingInput.email = _carInfo.customerEmail?_carInfo.customerEmail:@"";
//    self.bindingInput.vhlType =  _carSeries.text;
//    self.bindingInput.vhlLicence = _vhlLicenceField.text;
//    self.bindingInput.remark = _carInfo.remark?_carInfo.remark:@"备注";
//    self.bindingInput.doptCode = _doptField.text;
    
    if (_carbind.isExist) {
          _vhlTStatustr =@"1";
        _isExiststr = @"true";
    }
    else
    {
        _vhlTStatustr =@"0";
        _isExiststr = @"false";
    }
    
    NSDictionary *paras = @{
                            @"vin": _bingVin,
                            @"doptCode": _doptCode,
                            @"vhlLicence": @"",
                            @"vhlBrandId": @"",
                            @"vhlBrandName": @"",
                            @"vhlSeriesName": _carSeries.text,
                            @"vhlTypeId": @"",
                            @"vhlTypeName": _carModels.text,
                            @"vhlColorName": _vhlColorName.text,
                            @"vhlColorId":@"",
                            @"isExist": _isExiststr,
                            @"userName": _userName.text,
                            @"sex": _sex.text,
                            @"mobilePhone": _mobilePhone.text,
                            @"vhlTStatus":_vhlTStatustr
                           
                            };
    [CUHTTPRequest POST:bindVhlWithUser parameters:paras success:^(id responseData) {
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
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
                    
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
    } failure:^(NSInteger code) {
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
    }];

}

- (void)seriesLabelTap:(UITapGestureRecognizer *)sender {
    CarSeriesViewController *vc = [[CarSeriesViewController alloc] init];
    vc.carSeriesSelct = ^(NSString *carSeries) {
        _carSeries.text = carSeries;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)modelsLabelTap:(UITapGestureRecognizer *)sender {
    CarSeriesViewController *vc = [[CarSeriesViewController alloc] init];
    vc.carSeriesSelct = ^(NSString *carSeries) {
        _carModels.text = carSeries;
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
