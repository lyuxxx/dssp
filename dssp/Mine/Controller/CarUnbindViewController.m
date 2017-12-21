//
//  CarUnbindViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarUnbindViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "CarInfoModel.h"

@interface CarUnbindViewController ()
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
@end

@implementation CarUnbindViewController

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
                            @"vin": @"LPACAPSA031431810"
                            };
    
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryVhl parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
            
          
            
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}



- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"车辆信息", nil);

//    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(BtnClick:)];
//    [_rightBarItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = _rightBarItem;
    
    self.rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarItem setTitle:@"编辑" forState: UIControlStateNormal];
    [_rightBarItem setTitle:@"完成" forState: UIControlStateSelected];
    _rightBarItem.titleLabel.font = [UIFont fontWithName:FontName size:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];
    [_rightBarItem addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarItem makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(64 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
    }];
    
    
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
                                    NSLocalizedString(@"车辆状态", nil),
                                    NSLocalizedString(@"车辆类型", nil),
                                    NSLocalizedString(@"品牌", nil),
                                    NSLocalizedString(@"车辆T状态", nil),
                                    NSLocalizedString(@"车系名", nil),
                                    NSLocalizedString(@"车型名", nil)
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
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(0 * WidthCoefficient);
                    make.top.equalTo(0);
                  
                }];
                
                if (i == 0) {
                    _field.text = @"123";
                    self.vinField = _field;
                } else if (i == 3) {
                    _field.text = @"";
                    self.colorField = _field;
                    
                } else if (i == 4) {
                    _field.text = @"";
                    self.vhlStatusField = _field;
                    
                } else if (i == 5) {
                    _field.text = @"";
                    self.isTestField = _field;
                    
                } else if (i == 6) {
                    _field.text = @"";
                    self.vhlBrandField = _field;
                    
                } else if (i == 7) {
                    _field.text = @"";
                    self.vhlTStatusField = _field;
                    
                } else if (i == 8) {
                    _field.text = @"";
                    self.seriesNameField = _field;
                    
                } else if (i == 9) {
                    _field.text = @"";
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
    
    
//    self.unbindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_unbindBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _unbindBtn.layer.cornerRadius = 2;
//    [_unbindBtn setTitle:NSLocalizedString(@"解绑车辆", nil) forState:UIControlStateNormal];
//    [_unbindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _unbindBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
//    [_unbindBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
//    [self.view addSubview:_unbindBtn];
//    [_unbindBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(271 * WidthCoefficient);
//        make.height.equalTo(44 * HeightCoefficient);
//        make.centerX.equalTo(0);
//        make.top.equalTo(whiteV.bottom).offset(25 * HeightCoefficient);
//    }];
    
}

-(void)BtnClick:(UIButton *)sender
{
    if (self.rightBarItem == sender) {
         sender.selected = !sender.selected;
        if (!sender.selected) {
            _doptCodeField.userInteractionEnabled=NO;
            _vhlLisenceField.userInteractionEnabled=NO;
            _modifyImg.hidden = YES;
            _modifyImg1.hidden = YES;
            
            NSDictionary *paras = @{
                                    @"vin":_vinField.text,
                                    @"doptCode":_doptCodeField.text,
                                    @"vhlLisence":_vhlLisenceField.text
                                    
                                    };
            
            
            MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
            [CUHTTPRequest POST:updateVhl parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                    [hud hideAnimated:YES];
                    //响应事件
                   [MBProgressHUD showText:NSLocalizedString(@"车辆修改成功", nil)];
                } else {
                    [MBProgressHUD showText:dic[@"msg"]];
                }
            } failure:^(NSInteger code) {
                hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
                [hud hideAnimated:YES afterDelay:1];
            }];
            

            
        }
        else
        {
            _doptCodeField.userInteractionEnabled=YES;
            _vhlLisenceField.userInteractionEnabled=YES;
            _modifyImg.hidden = NO;
            _modifyImg1.hidden = NO;
          
        }
    }
    if (self.unbindBtn == sender) {
        
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