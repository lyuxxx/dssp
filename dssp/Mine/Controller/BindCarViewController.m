//
//  BindCarViewController.m
//  dssp
//
//  Created by qinbo on 2018/1/2.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "BindCarViewController.h"
#import "VhlModel.h"
#import "NSObject+YYModel.h"
#import "InputAlertView.h"
@interface BindCarViewController ()
@property (nonatomic, strong) UIScrollView *sc;
@property (nonatomic, strong) UIButton *unbindBtn;
@property (nonatomic, strong) UIButton *rightBarItem;

@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, strong) UITextField *doptCodeField;
@property (nonatomic, strong) UITextField *vhlLisenceField;
@property (nonatomic, strong) UITextField *colorField;
@property (nonatomic, strong) UITextField *vhlStatusField;
@property (nonatomic, strong) UITextField *isTestField;
@property (nonatomic, strong) UITextField *vhlBrandField;
@property (nonatomic, strong) UITextField *vhlTStatusField;
@property (nonatomic, strong) UITextField *seriesNameField;
@property (nonatomic, strong) UITextField *typeNameField;

@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) UIImageView *modifyImg;
@property (nonatomic, strong) UIImageView *modifyImg1;

@property (nonatomic, strong) VhlModel *vhl;
@end

@implementation BindCarViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    [self setupUI];
}

-(void)requestData
{

    NSDictionary *paras = @{
                           
                           };
    NSString *queryVhls = [NSString stringWithFormat:@"%@/%@",queryVhl,[kVin isEqualToString:@""]?kVins:kVin];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryVhls parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        self.vhl =[VhlModel yy_modelWithDictionary:dic[@"data"]];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
//            self.vinField.text = _vhl.vin;
//            self.doptCodeField.text = _vhl.doptCode;
//            self.vhlLisenceField.text =_vhl.vhlLisence;
//            self.colorField.text =_vhl.color;
//            self.vhlStatusField.text = _vhl.vhlStatus;
//            self.isTestField.text = _vhl.isTest;
//            self.vhlBrandField.text = _vhl.brandName;
//            self.vhlTStatusField.text = _vhl.vhlTStatus;
//            self.seriesNameField.text = _vhl.seriesName;
//            self.typeNameField.text = _vhl.typeName;
            
            
            self.vinField.text = _vhl.vin;
            self.doptCodeField.text = _vhl.doptCode;
            self.vhlLisenceField.text =_vhl.vhlLisence;
            self.colorField.text =_vhl.vhlColorName;
            self.vhlStatusField.text = _vhl.vhlBrandName;
//            self.isTestField.text = _vhl.isTest;
            self.isTestField.text = [_vhl.vhlTStatus isEqualToString:@"1"]?@"T车辆":@"非T车辆";
//            self.vhlBrandField.text = _vhl.brandName;
//            self.vhlTStatusField.text = _vhl.vhlTStatus;
            self.seriesNameField.text = _vhl.vhlSeriesName;
            self.typeNameField.text = _vhl.vhlTypeName;
            
            
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
         [hud hideAnimated:YES];
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
    
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"车辆解绑", nil);
    
    //    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(BtnClick:)];
    //    [_rightBarItem setTintColor:[UIColor whiteColor]];
    //    self.navigationItem.rightBarButtonItem = _rightBarItem;
    
//    self.rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_rightBarItem setTitle:@"编辑" forState: UIControlStateNormal];
//    [_rightBarItem setTitle:@"完成" forState: UIControlStateSelected];
//    _rightBarItem.titleLabel.font = [UIFont fontWithName:FontName size:16];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];
//    [_rightBarItem addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_rightBarItem makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(64 * WidthCoefficient);
//        make.height.equalTo(22 * WidthCoefficient);
//    }];
//
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.5;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.height.equalTo(405 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20.5 * HeightCoefficient);
        make.bottom.equalTo(self.view.bottom).offset(-77 * HeightCoefficient - kBottomHeight);
        
    }];
    
    UILabel *query = [[UILabel alloc] init];
    query.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    query.textAlignment = NSTextAlignmentCenter;
    query.text = NSLocalizedString(@"您的车辆信息", nil);
    [whiteV addSubview:query];
    [query makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteV);
        make.width.equalTo(170 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    NSArray<NSString *> *titles = @[
                                    
                                    NSLocalizedString(@"车架号", nil),
                                    NSLocalizedString(@"发动机号", nil),
                                    NSLocalizedString(@"车牌号", nil),
                                    NSLocalizedString(@"颜色", nil),
//                                    NSLocalizedString(@"车辆状态", nil),
//                                    NSLocalizedString(@"车辆类型", nil),
                                    NSLocalizedString(@"品牌", nil),
                                    NSLocalizedString(@"车辆T状态", nil),
                                    NSLocalizedString(@"车系", nil),
                                    NSLocalizedString(@"车型", nil)
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
            //            whiteV.backgroundColor = [UIColor redColor];
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
            
            
            if (i != 1 && i !=2) {
                
                self.field = [[UITextField alloc] init];
                _field.font = [UIFont fontWithName:FontName size:15];
                _field.textColor = [UIColor colorWithHexString:@"333333"];
                _field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _field.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_field];
                [_field makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(180 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                
                if (i == 0) {
            
                    self.vinField = _field;
                } else if (i == 3) {
                   
                    self.colorField = _field;
                    
                } else if (i == 4) {
                 
                    self.vhlStatusField = _field;
                    
                } else if (i == 5) {
                   
                    self.isTestField = _field;
                    
                }
//                else if (i == 6) {
//
//                    self.vhlBrandField = _field;
//
////                }
//                    else if (i == 7) {
//
//                    self.vhlTStatusField = _field;
//
//                }
                else if (i == 6) {
//
                    self.seriesNameField = _field;
//
                }
                    else if (i == 7) {
                  
                    self.typeNameField = _field;
                    
                }
            }
            else if (i==1)
            {
                
                self.doptCodeField = [[UITextField alloc] init];
                _doptCodeField.font = [UIFont fontWithName:FontName size:15];
                //                 _doptCodeField.text = @"999";
                _doptCodeField.textColor = [UIColor colorWithHexString:@"333333"];
                _doptCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _doptCodeField.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_doptCodeField];
                [_doptCodeField makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                
                
                self.modifyImg = [[UIImageView alloc] init];
                _modifyImg.hidden = YES;
                _modifyImg.image = [UIImage imageNamed:@"修改_icon"];
                [whiteV addSubview:_modifyImg];
                [_modifyImg makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(2*HeightCoefficient);
                    make.right.equalTo(-16 * WidthCoefficient);
                    make.width.height.equalTo(16 * WidthCoefficient);
                }];
                
                
            }
            else if (i==2)
            {
                self.vhlLisenceField = [[UITextField alloc] init];
                _vhlLisenceField.font = [UIFont fontWithName:FontName size:15];
                //                _vhlLisenceField.text = @"999";
                _vhlLisenceField.textColor = [UIColor colorWithHexString:@"333333"];
                _vhlLisenceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _vhlLisenceField.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_vhlLisenceField];
                [_vhlLisenceField makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                
                self.modifyImg1 = [[UIImageView alloc] init];
                _modifyImg1.hidden = YES;
                _modifyImg1.image = [UIImage imageNamed:@"修改_icon"];
                [whiteV addSubview:_modifyImg1];
                [_modifyImg1 makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(2*HeightCoefficient);
                    make.right.equalTo(-16 * WidthCoefficient);
                    make.width.height.equalTo(16 * WidthCoefficient);
                }];
                
            }
            
            
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastLabel.bottom).offset(0);
        }];
        
        scroll;
    });
    
    
        self.unbindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unbindBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _unbindBtn.layer.cornerRadius = 2;
        [_unbindBtn setTitle:NSLocalizedString(@"解绑车辆", nil) forState:UIControlStateNormal];
        [_unbindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _unbindBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
        [_unbindBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
        [self.view addSubview:_unbindBtn];
        [_unbindBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(271 * WidthCoefficient);
            make.height.equalTo(44 * HeightCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(whiteV.bottom).offset(25 * HeightCoefficient);
        }];
    
}

-(void)BtnClick:(UIButton *)sender
{
    if (self.unbindBtn == sender) {
    

        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [InputalertView initWithTitle:@"是否解绑车辆?" img:@"解绑汽车_icon" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否", nil] ];
        //            InputalertView.delegate = self;
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: InputalertView];

        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
            if (btn.tag == 100) {//左边按钮

//                NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//                NSString *vin = [defaults1 objectForKey:@"vin"];
                NSDictionary *paras = @{
                                        @"vin": kVin
                                        };
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:removeBindRelWithUser parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [hud hideAnimated:YES];
                        //响应事件

                        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                        [InputalertView initWithTitle:@"车辆解绑成功,返回个人中心" img:@"解绑汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定", nil] ];
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: InputalertView];

                        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮

                            UIViewController *viewCtl = self.navigationController.viewControllers[0];
                            [self.navigationController popToViewController:viewCtl animated:YES];
                            }

                        };


//                        [MBProgressHUD showText:NSLocalizedString(@"车辆解绑成功", nil)];

//                         //车辆解绑成功，保存的vin置为空字符串
//                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                        [defaults setObject:@"" forKey:@"vins"];
//                        [defaults synchronize];
//
                        //车辆解绑成功，登录保存的vin置为空字符串
                        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                        [defaults1 setObject:@"" forKey:@"vin"];
                        [defaults1 synchronize];


                    } else {
                         [hud hideAnimated:YES];
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                } failure:^(NSInteger code) {
                    hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
                    [hud hideAnimated:YES afterDelay:1];
                }];
            }
            if(btn.tag ==101)
            {
                //右边按钮
                NSLog(@"666%@",str);

            }

        };
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
