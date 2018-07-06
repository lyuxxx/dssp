//
//  CarStatisticsViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarStatisticsViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "CarInfoModel.h"
#import "VhlModel.h"
#import "InputAlertView.h"


@interface CarStatisticsViewController () <UITextFieldDelegate>
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
@property (nonatomic, strong) UILabel *typeNameLabel;

@property (nonatomic, strong) UIImageView *modifyImg;
@property (nonatomic, strong) UIImageView *modifyImg1;
@property (nonatomic, strong) VhlModel *vhl;

@property (nonatomic, strong) NSArray<NSString *> *titles;
@end

@implementation CarStatisticsViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = NSLocalizedString(@"车辆信息", nil);
    [self requestData];
  
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"CarStatisticsViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics staticsvisitTimesDataWithViewControllerType:@"CarStatisticsViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"CarStatisticsViewController"];
}

-(void)requestData
{
 
    NSDictionary *paras = @{
//                            @"vin": @"VF7CAPSA000020944"
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
              
                CGSize typeSize = [_vhl.vhlTypeName boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.typeNameLabel.font} context:nil].size;
                
                if(_vhl.vhlTypeName)
                {
                    [_typeNameLabel updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(typeSize.height);
                          }];
                }
                else
                {
                    [_typeNameLabel updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(20*HeightCoefficient);
                    }];
                    
                }
                
               
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view setNeedsUpdateConstraints];
                    [self.view updateConstraintsIfNeeded];
                    [self.view layoutIfNeeded];
                    _typeNameLabel.text = _vhl.vhlTypeName;
                });
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
                //                self.typeNameLabel.text = _vhl.vhlTypeName;
                
                CGSize typeSize = [_vhl.vhlTypeName boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.typeNameLabel.font} context:nil].size;
                if(_vhl.vhlTypeName)
                {
                    [_typeNameLabel updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(typeSize.height);
                    }];
                }
                else
                {
                    [_typeNameLabel updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(20*HeightCoefficient);
                    }];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view setNeedsUpdateConstraints];
                    [self.view updateConstraintsIfNeeded];
                    [self.view layoutIfNeeded];
                    _typeNameLabel.text = _vhl.vhlTypeName;
                });
                
                
            }
            
          
//            if ([_vhl.vhlTStatus isEqualToString:@"1"]) {
//                self.vinField.text = _vhl.vin;
//                self.doptCodeField.text = _vhl.doptCode;
//                self.vhlLisenceField.text =_vhl.vhlLicence;
//                self.colorField.text =_vhl.vhlColorName;
//                self.vhlStatusField.text = _vhl.vhlBrandName;
//                self.isTestField.text = @"T车辆";
//                //            self.vhlBrandField.text = _vhl.brandName;
//                //            self.vhlTStatusField.text = _vhl.vhlTStatus;
//                self.seriesNameField.text = _vhl.vhlSeriesName;
//                self.typeNameLabel.text = _vhl.vhlTypeName;
//            }
//            else
//            {
//
//                self.vinField.text = _vhl.vin;
//                self.doptCodeField.text = _vhl.doptCode;
//                self.vhlLisenceField.text =_vhl.vhlLicence;
//                self.colorField.text =_vhl.vhlColorName;
//                self.vhlStatusField.text = @"非T车辆";
//                self.isTestField.text = _vhl.vhlTypeName;
//                //            self.vhlBrandField.text = _vhl.brandName;
//                //            self.vhlTStatusField.text = _vhl.vhlTStatus;
////                self.seriesNameField.text = _vhl.vhlSeriesName;
////                self.typeNameLabel.text = _vhl.vhlTypeName;
//
//
//            }
////
            
            
    
          
//            NSLog(@"%@555",_vhl.vhlTStatus);
        } else {

            [self blankUI];
            [hud hideAnimated:YES];
//            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {

        [self blankUI];
        [hud hideAnimated:YES];
//        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
//        [hud hideAnimated:YES afterDelay:1];
    }];
}

-(void)blankUI{
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"暂无内容"];
    [bgImgV setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top .equalTo(50 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.height.equalTo(175 * HeightCoefficient);
        make.width.equalTo(278 * WidthCoefficient);
        
    }];
}

//-(void)setVhl:(VhlModel *)vhl
//{
//
//    if ([vhl.vhlTStatus isEqualToString:@"1"]) {
//
//        self.vinField.text = vhl.vin;
//        self.doptCodeField.text = vhl.doptCode;
//        self.vhlLisenceField.text =vhl.vhlLicence;
//        self.colorField.text =vhl.vhlColorName;
//        self.vhlStatusField.text = vhl.vhlBrandName;
//        self.isTestField.text = @"T车辆";
//        //            self.vhlBrandField.text = _vhl.brandName;
//        //            self.vhlTStatusField.text = _vhl.vhlTStatus;
//        self.seriesNameField.text = vhl.vhlSeriesName;
//        self.typeNameLabel.text = vhl.vhlTypeName;
//    }
//    else if([vhl.vhlTStatus isEqualToString:@"0"])
//    {
//        self.vinField.text = _vhl.vin;
//        self.doptCodeField.text = _vhl.doptCode;
//        self.vhlLisenceField.text =_vhl.vhlLicence;
//        self.colorField.text =_vhl.vhlColorName;
//        self.vhlStatusField.text = @"非T车辆";
//        self.isTestField.text = _vhl.vhlTypeName;
//        //            self.vhlBrandField.text = _vhl.brandName;
//        //            self.vhlTStatusField.text = _vhl.vhlTStatus;
//        //                self.seriesNameField.text = _vhl.vhlSeriesName;
//        //                self.typeNameLabel.text = _vhl.vhlTypeName;
//
//
//    }
//
////    if([_vhl.vhlTStatus isEqualToString:@"1"])
////    {
////
////        _titles = @[
////                    NSLocalizedString(@"车架号", nil),
////                    NSLocalizedString(@"发动机号后七位", nil),
////                    NSLocalizedString(@"车牌号", nil),
////                    NSLocalizedString(@"颜色", nil),
////
////                    NSLocalizedString(@"品牌", nil),
////                    NSLocalizedString(@"车辆T状态", nil),
////                    NSLocalizedString(@"车系", nil),
////                    NSLocalizedString(@"车型 ", nil)
////                    ];
////
////
////    }
////    else
////    {
////        _titles = @[
////                    NSLocalizedString(@"车架号", nil),
////                    NSLocalizedString(@"发动机号后七位", nil),
////                    NSLocalizedString(@"车牌号", nil),
////                    NSLocalizedString(@"颜色", nil),
////
////                    //                                        NSLocalizedString(@"品牌", nil),
////                    NSLocalizedString(@"车辆T状态", nil),
////                    //                                        NSLocalizedString(@"车系", nil),
////                    NSLocalizedString(@"车型 ", nil)
////                    ];
////
////
////
////    }
////
//
//
//}

- (void)setupUI {
    
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
        
        
        
            }
    
   
    
   
    
   

//    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(BtnClick:)];
//    [_rightBarItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.rightBarButtonItem = _rightBarItem;
    
    self.rightBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarItem setTitle:@"编辑" forState: UIControlStateNormal];
    [_rightBarItem setTitle:@"完成" forState: UIControlStateSelected];
    _rightBarItem.titleLabel.font = [UIFont fontWithName:FontName size:16];
    
    if ([KuserName isEqualToString:@"18911568274"]) {
        _rightBarItem.hidden = YES;
    }
    else
    {
        _rightBarItem.hidden = NO;
    }
        
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarItem];
    [_rightBarItem addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarItem makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(64 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
    }];
    
   
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
    whiteV.layer.masksToBounds = YES;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowRadius = 7;
//    whiteV.layer.shadowOpacity = 0.5;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(55 * HeightCoefficient);
    }];
    
//    UILabel *query = [[UILabel alloc] init];
//    query.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    query.textAlignment = NSTextAlignmentCenter;
//    query.text = NSLocalizedString(@"您的车辆信息", nil);
//    [whiteV addSubview:query];
//    [query makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(whiteV);
//        make.width.equalTo(170 * WidthCoefficient);
//        make.height.equalTo(22.5 * HeightCoefficient);
//        make.top.equalTo(20 * HeightCoefficient);
//    }];
    
    
    
    if([_vhl.vhlTStatus isEqualToString:@"1"])
    {
        
        UILabel *lastLabel;
        
        for (NSInteger i = 0 ; i < _titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = _titles[i];
            label.textColor = [UIColor colorWithHexString:@"#A18E79"];
            label.font = [UIFont fontWithName:FontName size:15];
            [whiteV addSubview:label];
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
            [whiteV addSubview:line];
            
            if (i == 0) {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(110 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(15 * HeightCoefficient);
                    
                }];
                
                [line makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(label.bottom).offset(15 * HeightCoefficient);
                    make.height.equalTo(1 * HeightCoefficient);
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
                
                if (i != 7) {
                    [line makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(label.bottom).offset(15 * HeightCoefficient);
                        make.height.equalTo(1 * HeightCoefficient);
                        make.left.equalTo(15 * WidthCoefficient);
                        make.right.equalTo(-15 * WidthCoefficient);
                        
                    }];
                }
                
            }
            lastLabel = label;
            
            if (i != 1 && i !=2) {
                if (i == 7) {
                    self.typeNameLabel = [[UILabel alloc] init];
                    _typeNameLabel.numberOfLines = 0;
                    _typeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    _typeNameLabel.font = [UIFont fontWithName:FontName size:15];
                    _typeNameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                    [whiteV addSubview:_typeNameLabel];
                    [_typeNameLabel makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(223 * WidthCoefficient);
                        make.height.equalTo(20 * HeightCoefficient);
                        make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                        make.top.equalTo(label);
                    }];
                    
                    [line makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_typeNameLabel.bottom).offset(15 * HeightCoefficient);
                        make.height.equalTo(1 * HeightCoefficient);
                        make.left.equalTo(15 * WidthCoefficient);
                        make.right.equalTo(-15 * WidthCoefficient);
                        
                    }];
                    
                    [whiteV makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(line.top);
                    }];
                } else {
                    UITextField *field = [[UITextField alloc] init];
                    field.font = [UIFont fontWithName:FontName size:15];
                    field.textColor = [UIColor colorWithHexString:@"#ffffff"];
                    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                    field.userInteractionEnabled=NO;
                    //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    [whiteV addSubview:field];
                    [field makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(223 * WidthCoefficient);
                        make.height.equalTo(20 * HeightCoefficient);
                        make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                        make.centerY.equalTo(label);
                        
                    }];
                    
                    
                    if (i == 0) {
                        self.vinField = field;
                        self.vinField.text = _vhl.vin;
                        
                    } else if (i == 3) {
                        self.colorField = field;
                        
                    } else if (i == 4) {
                        
                        self.vhlStatusField = field;
                        
                    }
                    else if (i == 5) {
                        
                        self.isTestField = field;
                        
                    } else if (i == 6) {
                        
                        self.seriesNameField = field;
                        
                    }
                }
                
            }
            else if (i==1)
            {
                
                self.doptCodeField = [[UITextField alloc] init];
                _doptCodeField.font = [UIFont fontWithName:FontName size:15];
                //                 _doptCodeField.text = @"999";
                _doptCodeField.keyboardType = UIKeyboardTypePhonePad;
                _doptCodeField.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _doptCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _doptCodeField.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_doptCodeField];
                [_doptCodeField makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                    make.centerY.equalTo(label);
                    
                }];
                
                
                self.modifyImg = [[UIImageView alloc] init];
                _modifyImg.hidden = YES;
                _modifyImg.image = [UIImage imageNamed:@"修改_icon"];
                [whiteV addSubview:_modifyImg];
                [_modifyImg makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(label);
                    make.right.equalTo(-15 * WidthCoefficient);
                    make.width.height.equalTo(16 * WidthCoefficient);
                }];
                
                
            }
            else if (i==2)
            {
                self.vhlLisenceField = [[UITextField alloc] init];
                _vhlLisenceField.font = [UIFont fontWithName:FontName size:15];
                //                _vhlLisenceField.text = @"999";
                _vhlLisenceField.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _vhlLisenceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _vhlLisenceField.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                _vhlLisenceField.delegate = self;
                [whiteV addSubview:_vhlLisenceField];
                [_vhlLisenceField makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                    make.centerY.equalTo(label);
                    
                }];
                
                self.modifyImg1 = [[UIImageView alloc] init];
                _modifyImg1.hidden = YES;
                _modifyImg1.image = [UIImage imageNamed:@"修改_icon"];
                [whiteV addSubview:_modifyImg1];
                [_modifyImg1 makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(label);
                    make.right.equalTo(-15 * WidthCoefficient);
                    make.width.height.equalTo(16 * WidthCoefficient);
                }];
                
            }
            
            
        }
     
    }
    else
    {
        
        UILabel *lastLabel;
        
        for (NSInteger i = 0 ; i < _titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = _titles[i];
            label.textColor = [UIColor colorWithHexString:@"#A18E79"];
            label.font = [UIFont fontWithName:FontName size:15];
            [whiteV addSubview:label];
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
            [whiteV addSubview:line];
            
            if (i == 0) {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(110 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(15 * HeightCoefficient);
                    
                }];
                
                [line makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(label.bottom).offset(15 * HeightCoefficient);
                    make.height.equalTo(1 * HeightCoefficient);
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
                
                if (i != 5) {
                    [line makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(label.bottom).offset(15 * HeightCoefficient);
                        make.height.equalTo(1 * HeightCoefficient);
                        make.left.equalTo(15 * WidthCoefficient);
                        make.right.equalTo(-15 * WidthCoefficient);
                        
                    }];
                }
                
            }
            lastLabel = label;
            
            if (i != 1 && i !=2) {
                if (i == 5) {
                    self.typeNameLabel = [[UILabel alloc] init];
                    _typeNameLabel.numberOfLines = 0;
                    _typeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    _typeNameLabel.font = [UIFont fontWithName:FontName size:15];
                    _typeNameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
                    [whiteV addSubview:_typeNameLabel];
                    [_typeNameLabel makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(223 * WidthCoefficient);
                        make.height.equalTo(20 * HeightCoefficient);
                        make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                        make.top.equalTo(label);
                    }];
                    
                    [line makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_typeNameLabel.bottom).offset(15 * HeightCoefficient);
                        make.height.equalTo(1 * HeightCoefficient);
                        make.left.equalTo(15 * WidthCoefficient);
                        make.right.equalTo(-15 * WidthCoefficient);
                        
                    }];
                    
                    [whiteV makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(line.top);
                    }];
                } else {
                    UITextField *field = [[UITextField alloc] init];
                    field.font = [UIFont fontWithName:FontName size:15];
                    field.textColor = [UIColor colorWithHexString:@"#ffffff"];
                    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                    field.userInteractionEnabled=NO;
                    //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    [whiteV addSubview:field];
                    [field makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(223 * WidthCoefficient);
                        make.height.equalTo(20 * HeightCoefficient);
                        make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                        make.centerY.equalTo(label);
                        
                    }];
                    
                    
                    if (i == 0) {
                        self.vinField = field;
                        self.vinField.text = _vhl.vin;
                        
                    } else if (i == 3) {
                        self.colorField = field;
                        self.colorField.text = _vhl.vhlColorName;
                        
                    } else if (i == 4) {
                        
                        self.vhlStatusField = field;
                        
                    }
                    //                else if (i == 5) {
                    //
                    //                    self.isTestField = _field;
                    //
                    //                }
                    //                else if (i == 6) {
                    //
                    //                    self.vhlBrandField = _field;
                    //
                    //                }
//                    else if (i == 5) {
//
//                        self.isTestField = field;
//
//                    } else if (i == 6) {
//
//                        self.seriesNameField = field;
//
//                    }
                }
                
            }
            else if (i==1)
            {
                
                self.doptCodeField = [[UITextField alloc] init];
                _doptCodeField.font = [UIFont fontWithName:FontName size:15];
                //                 _doptCodeField.text = @"999";
                _doptCodeField.keyboardType = UIKeyboardTypePhonePad;
                _doptCodeField.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _doptCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _doptCodeField.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_doptCodeField];
                [_doptCodeField makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                    make.centerY.equalTo(label);
                    
                }];
                
                
                self.modifyImg = [[UIImageView alloc] init];
                _modifyImg.hidden = YES;
                _modifyImg.image = [UIImage imageNamed:@"修改_icon"];
                [whiteV addSubview:_modifyImg];
                [_modifyImg makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(label);
                    make.right.equalTo(-15 * WidthCoefficient);
                    make.width.height.equalTo(16 * WidthCoefficient);
                }];
                
                
            }
            else if (i==2)
            {
                self.vhlLisenceField = [[UITextField alloc] init];
                _vhlLisenceField.font = [UIFont fontWithName:FontName size:15];
                //                _vhlLisenceField.text = @"999";
                _vhlLisenceField.textColor = [UIColor colorWithHexString:@"#ffffff"];
                _vhlLisenceField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
                _vhlLisenceField.userInteractionEnabled=NO;
                //            [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                [whiteV addSubview:_vhlLisenceField];
                [_vhlLisenceField makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(10 * WidthCoefficient);
                    make.centerY.equalTo(label);
                    
                }];
                
                self.modifyImg1 = [[UIImageView alloc] init];
                _modifyImg1.hidden = YES;
                _modifyImg1.image = [UIImage imageNamed:@"修改_icon"];
                [whiteV addSubview:_modifyImg1];
                [_modifyImg1 makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(label);
                    make.right.equalTo(-15 * WidthCoefficient);
                    make.width.height.equalTo(16 * WidthCoefficient);
                }];
            }
        }
    }
    

    self.unbindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_unbindBtn addTarget:self action:@selector(UnbindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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

//解绑车辆点击事件
-(void)UnbindBtnClick:(UIButton *)sender
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


-(void)BtnClick:(UIButton *)sender
{
    if (self.rightBarItem == sender) {
        if (!self.vhl) {
            return;
        }
        sender.selected = !sender.selected;
        if (!sender.selected) {
 
            if (_doptCodeField.text.length !=7) {
                
                [MBProgressHUD showText:NSLocalizedString(@"请输入发动机号后七位", nil)];
                
            }
//            else if (_vhlLisenceField.text.length !=7) {
//
//                [MBProgressHUD showText:NSLocalizedString(@"请输入7位车牌号", nil)];
//            }
            else if (_doptCodeField.text.length == 7)
            {
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
                        
                        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                        [InputalertView initWithTitle:@"车辆信息修改成功,返回个人中心" img:@"绑定汽车_icon" type:9 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定", nil] ];
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: InputalertView];
                        
                        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                UIViewController *viewCtl = self.navigationController.viewControllers[0];
                                [self.navigationController popToViewController:viewCtl animated:YES];

                            }
                            
                        };
                        
                        //响应事
//                        [MBProgressHUD showText:NSLocalizedString(@"车辆修改成功", nil)];
                    } else {
                        [hud hideAnimated:YES];
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                } failure:^(NSInteger code) {
                    hud.label.text = NSLocalizedString(@"网络异常", nil);
                    [hud hideAnimated:YES afterDelay:1];
                }];
            
            }
            
           
        }
        else
        {
            
            if ([_vhl.vhlTStatus isEqualToString:@"1"])
            {
            _doptCodeField.userInteractionEnabled=YES;
            _vhlLisenceField.userInteractionEnabled=YES;
            _modifyImg.hidden = NO;
            _modifyImg1.hidden = NO;
                
            }else
            {
//                _doptCodeField.userInteractionEnabled=YES;
                _vhlLisenceField.userInteractionEnabled=YES;
//                _modifyImg.hidden = NO;
                _modifyImg1.hidden = NO;
     
            }
        
        }
    }
        
    if (self.unbindBtn == sender) {
        
    }
    
}

#pragma mark - UITextFieldDelegate -
//车牌号限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *endString;

    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];

//    NSRange punctuationRange = [string rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];
    
    NSMutableCharacterSet *illegalSet = [NSMutableCharacterSet punctuationCharacterSet];
    [illegalSet addCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+"];
    
    NSRange punctuationRange = [string rangeOfCharacterFromSet:illegalSet];

    NSRange whitespaceAndNewlineRange = [string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (lowercaseCharRange.location != NSNotFound || punctuationRange.location != NSNotFound || whitespaceAndNewlineRange.location != NSNotFound) {
        endString = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
        endString = [endString stringByTrimmingCharactersInSet:illegalSet];
        endString = [endString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        textField.text = endString;

        return NO;
    }

    return YES;
    
}

@end
