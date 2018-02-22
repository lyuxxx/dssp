//
//  CarbinddetailViewController.m
//  dssp
//
//  Created by qinbo on 2018/1/2.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CarbinddetailViewController.h"
#import "RealVinViewcontroller.h"
#import "InputAlertView.h"
@interface CarbinddetailViewController ()
@property (nonatomic, strong) UITextField *customerNameField;
@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, strong) UITextField *doptField;
@property (nonatomic, strong) UILabel *carSeries;
@property (nonatomic, strong) UILabel *carModels;
@property (nonatomic, strong) UITextField *vhlLicenceField;
@property (nonatomic, strong) UIScrollView *sc;
@property (nonatomic, strong) UITextField *field;


@property (nonatomic, strong) UILabel *vinLabel;
@property (nonatomic, strong) UILabel *doptCode;
@property (nonatomic, strong) UILabel *vhlTypeName;
@property (nonatomic, strong) UILabel *vhlSeriesName;
@property (nonatomic, strong) UILabel *vhlColorName;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *mobilePhone;
@property (nonatomic, strong) UILabel *sex;

@property (nonatomic, copy) NSString *vhlTStatustr;
@property (nonatomic, copy) NSString *isExiststr;

@end

@implementation CarbinddetailViewController
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
    intro.text = NSLocalizedString(@"绑定详细", nil);
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
//                                    NSLocalizedString(@"用户名", nil),
//                                    NSLocalizedString(@"联系方式", nil),
//                                    NSLocalizedString(@"性别", nil)
                                    ];
    
    NSArray<NSString *> *placeHolders = @[
                                          
                                          NSLocalizedString(@"VIN", nil),
                                          NSLocalizedString(@"发动机号", nil),
                                          NSLocalizedString(@"车型", nil),
                                          NSLocalizedString(@"车系", nil),
                                          NSLocalizedString(@"颜色", nil),
//                                          NSLocalizedString(@"用户名", nil),
//                                          NSLocalizedString(@"联系方式", nil),
//                                          NSLocalizedString(@"性别", nil)
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
            
            
            UILabel *rightLabel = [[UILabel alloc] init];
            rightLabel.text = titles[i];
            rightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            rightLabel.font = [UIFont fontWithName:FontName size:14];
            [whiteV  addSubview:rightLabel];
            [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(0);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(0*WidthCoefficient);
                make.top.equalTo(0);
            }];
            
            
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
            
        
                if (i == 0) {
                  
                    self.vinLabel = rightLabel;
                    self.vinLabel.text = _carbind.vin;
                    
                } else if (i == 1) {
                    
                    self.doptCode = rightLabel;
                    self.doptCode.text = _carbind.doptCode;
                   
                } else if (i == 2) {
                    self.vhlTypeName = rightLabel;
                    self.vhlTypeName.text = _carbind.vhlTypeName;
                   
                    
                } else if (i == 3) {
                     self.vhlSeriesName = rightLabel;
                    self.vhlSeriesName.text = _carbind.vhlSeriesName;
                
                    
                } else if (i == 4) {
                    self.vhlColorName = rightLabel;
                    self.vhlColorName.text = _carbind.vhlColorName;
                    
                } else if (i == 5) {
                    self.userName = rightLabel;
                    self.userName.text = _carbind.userName;
                    
                } else if (i == 6) {
                     self.mobilePhone = rightLabel;
                    self.mobilePhone.text = _carbind.mobilePhone;
                }
                else if (i == 7) {
                    self.sex = rightLabel;
                    self.sex.text = _carbind.sex;
                }
                
            }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastLabel.bottom).offset(0);
            
        }];
        
        scroll;
    });
    
   
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 2;
    [confirmBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
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

-(void)confirmBtnClick:(UIButton *)btn
{
    
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
                            @"vin": _carbind.vin,
                            @"doptCode":_carbind.doptCode,
                            @"vhlLicence": @"",
                            @"vhlBrandId": @"",
                            @"vhlBrandName": @"",
                            @"vhlSeriesName": _carbind.vhlSeriesName,
                            @"vhlTypeId": @"",
                            @"vhlTypeName": _carbind.vhlTypeName,
                            @"vhlColorName": _carbind.vhlColorName,
                            @"vhlColorId":@"",
                            @"isExist":_isExiststr,
                            @"userName": _carbind.userName,
                            @"sex": _carbind.sex,
                            @"mobilePhone": _carbind.mobilePhone,
                            @"vhlTStatus":_carbind.vhlTStatus
                            
                            };
    [CUHTTPRequest POST:bindVhlWithUser parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBinded"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *isPush = [defaults objectForKey:@"isPush"];
            
            NSString *vin = _carbind.vin;
            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
            [defaults1 setObject:vin forKey:@"vin"];
            [defaults1 synchronize];
            
            if (isPush) {
                
                
                InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [InputalertView initWithTitle:@"车辆绑定成功,跳转实名制页面" img:@"绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定", nil] ];
                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                [keywindow addSubview: InputalertView];
                
                InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                    if (btn.tag == 100) {//左边按钮
                        
                        RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
                        vc.vin=_carbind.vin;
                        vc.isSuccess = @"1";
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                };
                
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                               message:@"车辆绑定成功,跳转实名制页面"
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    //响应事件
////                    跳实名制vin
//                    RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
//                    vc.vin=_carbind.vin;
//                    vc.isSuccess = @"1";
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                }];
//                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];
//
//                }];
//                [alert addAction:defaultAction];
////                [alert addAction:cancelAction];
//                [self presentViewController:alert animated:YES completion:nil];
                
            }else
            {
                
                InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [InputalertView initWithTitle:@"车辆绑定成功,跳转实名制页面" img:@"绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定", nil] ];
                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                [keywindow addSubview: InputalertView];
                
                InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                    if (btn.tag == 100) {//左边按钮
                        
                        RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
                        vc.vin=_carbind.vin;
                        vc.isSuccess = @"1";
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                };
//                NSLog(@"是从MineViewController过来的页面");
//                [MBProgressHUD showText:NSLocalizedString(@"绑定成功", nil)];
                
            }
            
        }
        else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
    }];
    
    
//     [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.doptField) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringToIndex:7];
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
