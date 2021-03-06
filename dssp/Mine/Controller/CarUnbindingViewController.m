//
//  CarUnbindingViewController.m
//  dssp
//
//  Created by qinbo on 2018/1/2.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CarUnbindingViewController.h"
#import "VhlModel.h"
#import "NSObject+YYModel.h"
#import "InputAlertView.h"
@interface CarUnbindingViewController ()
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
@property (nonatomic, strong) UILabel *typeNameField;

@property (nonatomic, strong) UITextField *field;

@property (nonatomic, strong) UIImageView *modifyImg;
@property (nonatomic, strong) UIImageView *modifyImg1;

@property (nonatomic, strong) VhlModel *vhl;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@end

@implementation CarUnbindingViewController

- (BOOL)needGradientBg {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"CarUnbindingViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"CarUnbindingViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"CarUnbindingViewController"];
}

-(void)requestData
{

    NSDictionary *paras = @{
                           
                           };
    NSString *queryVhls = [NSString stringWithFormat:@"%@/%@",queryVhl,[kVin isEqualToString:@""]?kVins:kVin];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryVhls parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
       
        
        
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
             self.vhl =[VhlModel yy_modelWithDictionary:dic[@"data"]];
           
             [self setupUI];
            
            if ([_vhl.vhlTStatus isEqualToString:@"1"]) {
                self.vinField.text = _vhl.vin;
                self.doptCodeField.text = _vhl.doptCode;
                self.vhlLisenceField.text =_vhl.vhlLicence;
                self.colorField.text =_vhl.vhlColorName;
                self.vhlStatusField.text = _vhl.vhlBrandName;
                self.isTestField.text = @"T车辆";
                //            self.vhlBrandField.text = _vhl.brandName;
                //            self.vhlTStatusField.text = _vhl.vhlTStatus;
                self.seriesNameField.text = _vhl.vhlSeriesName;
//                self.typeNameField.text = _vhl.vhlTypeName;
//                self.typeNameField.text =@"sfdsdfjslkfjsdlfjsdklfjsdklfjsdkfjsdkfjsdkfjsdkfjsd";
                
            }
            else
            {
                
                self.vinField.text = _vhl.vin;
                self.doptCodeField.text = _vhl.doptCode;
                self.vhlLisenceField.text =_vhl.vhlLicence;
                self.colorField.text =_vhl.vhlColorName;
                self.vhlStatusField.text = @"非T车辆";
                self.isTestField.text = _vhl.vhlTypeName;
                //            self.vhlBrandField.text = _vhl.brandName;
                //            self.vhlTStatusField.text = _vhl.vhlTStatus;
                //                self.seriesNameField.text = _vhl.vhlSeriesName;
                //                self.typeNameField.text = _vhl.vhlTypeName;
                
                
            }


        } else {
            [self setupUI];
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [self setupUI];
        [hud hideAnimated:YES];
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
    
}



- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"车辆解绑", nil);
    
    UIView *V = [[UIView alloc] init];
    V.layer.cornerRadius = 2;
    V.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
    [self.view addSubview:V];
    [V makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 *WidthCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.top.equalTo(22 * HeightCoefficient);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.textAlignment = NSTextAlignmentLeft;
    intro.textColor = [UIColor whiteColor];
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"您的车辆信息", nil);
    [self.view addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(24*WidthCoefficient);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    

    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 2;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.height.equalTo(405 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(55 * HeightCoefficient);
    }];
    
   
    
    if([_vhl.vhlTStatus isEqualToString:@"1"])
    {
        _titles = @[
                    NSLocalizedString(@"车架号", nil),
                    NSLocalizedString(@"发动机号后七位", nil),
                    NSLocalizedString(@"车牌号", nil),
                    NSLocalizedString(@"颜色", nil),
                    NSLocalizedString(@"品牌", nil),
                    NSLocalizedString(@"车辆T状态", nil),
                    NSLocalizedString(@"车系", nil),
                    NSLocalizedString(@"车型 ", nil)
                    ];
        
        [whiteV updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(415 * HeightCoefficient);
        }];
 
    }
    else
    {
        _titles = @[
                    NSLocalizedString(@"车架号", nil),
                    NSLocalizedString(@"发动机号后七位", nil),
                    NSLocalizedString(@"车牌号", nil),
                    NSLocalizedString(@"颜色", nil),
                    
                    //                                        NSLocalizedString(@"品牌", nil),
                    NSLocalizedString(@"车辆T状态", nil),
                    //                                        NSLocalizedString(@"车系", nil),
                    NSLocalizedString(@"车型 ", nil)
                    ];
        
        [whiteV updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(315 * HeightCoefficient);
            
            
        }];
        
        
    }
    
    

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
            make.edges.equalTo(whiteV).offset(UIEdgeInsetsMake(0 * HeightCoefficient, 0, 0 * HeightCoefficient, 0));
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.width.equalTo(whiteV.width);
        }];
        
        UILabel *lastLabel = nil;
        UIView *lastView = nil;
        
        for (NSInteger i = 0 ; i < _titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text =_titles[i];
            label.textColor = [UIColor colorWithHexString:@"#A18E79"];
            label.font = [UIFont fontWithName:FontName size:15];
            [contentView addSubview:label];
            
            
            UIView *whiteV = [[UIView alloc] init];
//                        whiteV.backgroundColor = [UIColor redColor];
            [contentView addSubview:whiteV];
            
            UIView *whiteView = [[UIView alloc] init];
            whiteView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
            [contentView addSubview:whiteView];
            
            
            if (i == 0) {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(110 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(15*HeightCoefficient);
                    
                }];
                
                
                [whiteV makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(0);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10*WidthCoefficient);
                    make.top.equalTo(15*HeightCoefficient);
                }];
                
                
                [whiteView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(50 * HeightCoefficient);
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            } else{
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(110 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(31 * HeightCoefficient);
                }];
                
                
                [whiteV makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(0);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(31*HeightCoefficient);
                }];
                
                [whiteView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.bottom).offset(50 * HeightCoefficient);
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
                _field.textColor = [UIColor colorWithHexString:@"#ffffff"];
//                _field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _field.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_field];
                [_field makeConstraints:^(MASConstraintMaker *make) {
            
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                     make.right.equalTo(0 * WidthCoefficient);
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
                  
//                    self.typeNameField = _field;
                        
                        whiteView.hidden = YES;
                        [whiteV updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(60 * HeightCoefficient);
                            
                        }];
                        
                        UILabel *lab2 = [[UILabel alloc] init];
                        lab2.textAlignment = NSTextAlignmentLeft;
                        [lab2 setNumberOfLines:0];
                        lab2.textColor = [UIColor colorWithHexString:@"#ffffff"];
                        lab2.text = _vhl.vhlTypeName?_vhl.vhlTypeName:@"";
                        CGRect tmpRect= [lab2.text boundingRectWithSize:CGSizeMake(343*WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:FontName size:15]} context:nil];
                        
                        CGFloat contentH = tmpRect.size.height;
                        lab2.font = [UIFont fontWithName:FontName size:15];
                        [whiteV addSubview:lab2];
                        [lab2 makeConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(contentH+1);
                            make.top.equalTo(0*HeightCoefficient);
                            make.left.equalTo(0*WidthCoefficient);
                            make.right.equalTo(0*WidthCoefficient);
                        }];
                      
                }
                
            }
            else if (i==1)
            {
                
                self.doptCodeField = [[UITextField alloc] init];
                _doptCodeField.font = [UIFont fontWithName:FontName size:15];
                //                 _doptCodeField.text = @"999";
                _doptCodeField.textColor = [UIColor colorWithHexString:@"#ffffff"];
//                _doptCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
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
                _vhlLisenceField.textColor = [UIColor colorWithHexString:@"#ffffff"];
//                _vhlLisenceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
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
        _unbindBtn.needNoRepeat = YES;
        [_unbindBtn setTitle:NSLocalizedString(@"解绑车辆", nil) forState:UIControlStateNormal];
        [_unbindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _unbindBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
        [_unbindBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
        [self.view addSubview:_unbindBtn];
        [_unbindBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(271 * WidthCoefficient);
            make.height.equalTo(44 * HeightCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(whiteV.bottom).offset(30 * HeightCoefficient);
        }];
    
}

-(void)BtnClick:(UIButton *)sender
{
    
    if ([KuserName isEqualToString:@"18911568274"]) {
          [MBProgressHUD showText:NSLocalizedString(@"当前为游客模式，无此操作权限", nil)];
        
    }
    else
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
                        [InputalertView initWithTitle:@"车辆解绑成功,返回个人中心" img:@"解绑汽车_icon" type:9 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定", nil] ];
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: InputalertView];

                        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮

                            UIViewController *viewCtl = self.navigationController.viewControllers[0];
                            [self.navigationController popToViewController:viewCtl animated:YES];
                            }

                        };



                        //车辆解绑成功，登录保存的vin置为空字符串
                        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                        [defaults1 setObject:@"" forKey:@"vin"];
                        [defaults1 synchronize];
                        
                        //车辆解绑成功，和同为空
                        NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
                        [defaults2 setObject:@"" forKey:@"contractStatus"];
                        [defaults2 synchronize];
                        


                    } else {
                         [hud hideAnimated:YES];
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                } failure:^(NSInteger code) {
                    hud.label.text = NSLocalizedString(@"网络异常", nil);
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
