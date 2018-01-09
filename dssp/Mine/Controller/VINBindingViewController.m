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
#import "CarbinddetailViewController.h"
@interface VINBindingViewController ()

@property (nonatomic, strong) UITextField *vinField;
@property (nonatomic, strong) UITextField *enginenNumber;
@property (nonatomic, strong) CarbindModel *carbind;

@end

@implementation VINBindingViewController

- (BOOL)needGradientImg {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    
//    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.title = NSLocalizedString(@"车辆绑定", nil);
   
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
        make.height.equalTo(320 * HeightCoefficient);
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
    _vinField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * WidthCoefficient, 22.5 * HeightCoefficient)];
    _vinField.leftViewMode = UITextFieldViewModeAlways;
    _vinField.textColor = [UIColor colorWithHexString:@"#040000"];
    _vinField.font = [UIFont fontWithName:FontName size:16];
    _vinField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写VIN号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
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
    _enginenNumber.leftViewMode = UITextFieldViewModeAlways;
    _enginenNumber.textColor = [UIColor colorWithHexString:@"#040000"];
    _enginenNumber.font = [UIFont fontWithName:FontName size:16];
    _enginenNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写发动机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:16]}];
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
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
}

- (void)nextBtnClick:(UIButton *)sender {
    
    if (![_vinField.text isEqualToString:@""]) {
        NSDictionary *paras = @{
                                @"vin": _vinField.text,
                                @"doptCode":_enginenNumber.text
                                };
        [CUHTTPRequest POST:checkBindByVin parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
             _carbind = [CarbindModel yy_modelWithDictionary:dic[@"data"]];
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                if (_carbind.isExist) {
                    ///T车跳绑定详细页面
                    CarbinddetailViewController *vc = [[CarbinddetailViewController alloc] init];
                    vc.carbind = _carbind;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    ///非T跳车辆绑定填写页面
                    CarBindingViewController *vc = [[CarBindingViewController alloc] init];
                    vc.bingVin = _vinField.text;
                    vc.doptCode = _enginenNumber.text;
                    vc.carbind = _carbind;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            
            } else {
                [MBProgressHUD showText:[dic objectForKey:@"msg"]];
            }
        } failure:^(NSInteger code) {
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        }];
        
//        CarInfoViewController *vc = [[CarInfoViewController alloc] init];
//        vc.vin = _vinField.text;
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
      
        [MBProgressHUD showText:NSLocalizedString(@"请输入VIN号", nil)];
    }
}

@end
