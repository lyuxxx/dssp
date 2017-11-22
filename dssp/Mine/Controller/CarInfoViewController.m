//
//  CarInfoViewController.m
//  dssp
//
//  Created by qinbo on 2017/11/15.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarInfoViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "CarInfoModel.h"
#import "CarBindingViewController.h"
@interface CarInfoViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *sc;
@property (nonatomic, strong) UILabel *carId;
@property (nonatomic, strong) UILabel *vinLabel;
@property (nonatomic, strong) UILabel *customerName;
@property (nonatomic, strong) UILabel *customerCredentials;
@property (nonatomic, strong) UILabel *customerCredentialsNum;
@property (nonatomic, strong) UILabel *customerSex;
@property (nonatomic, strong) UILabel *customerMobilePhone;
@property (nonatomic, strong) UILabel *customerHomePhone;
@property (nonatomic, strong) UILabel *customerEmail;
@property (nonatomic, strong) UILabel *vhlLicence;
@property (nonatomic, strong) UILabel *remark;
@property (nonatomic, strong) UILabel *vhlStatus;
@property (nonatomic, strong) UILabel *serviceLevelId;
@property (nonatomic, strong) UILabel *insuranceCompany;
@property (nonatomic, strong) UILabel *insuranceNum;
@property (nonatomic, strong) UILabel *dueDate;
@property (nonatomic, strong) UILabel *saleDate;
@property (nonatomic, strong) UILabel *recordStatus;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UILabel *updateTime;
@property (nonatomic, strong) UILabel *brandName;
@property (nonatomic, strong) UILabel *dealerName;
@property (nonatomic, strong) UILabel *colorName;
@property (nonatomic, strong) UILabel *seriesName;
@property (nonatomic, strong) UILabel *typeName;
@property (nonatomic, strong) UILabel *credentialsName;
@property (nonatomic, strong) UILabel *recordStatusName;
@property (nonatomic, strong) UILabel *customerSexName;
@property (nonatomic, strong) UILabel *vhlStatusName;
@property (nonatomic, strong) UILabel *userRel;
@end

@implementation CarInfoViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self getCarInfo];
  
}

- (void)getCarInfo
{
    [self carinfoWithVin:_vin];
}

- (void)carinfoWithVin:(NSString *)vin  {
    

    NSDictionary *paras = @{
                            @"vin": vin,
                           
                            };
    [CUHTTPRequest POST:getBasicInfo parameters:paras response:^(id responseData) {
        if (responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            CarInfoModel *CarInfo = [CarInfoModel yy_modelWithDictionary:dic[@"data"]];
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                [hud hideAnimated:YES];
                
                self.carId.text = CarInfo.carId;
                self.vinLabel.text = CarInfo.vin;
                self.customerName.text = CarInfo.customerName;
                self.customerCredentials.text = CarInfo.customerCredentials;
                self.customerCredentialsNum.text = CarInfo.customerCredentialsNum;
                self.customerSex.text = CarInfo.customerSex;
                self.customerMobilePhone.text = CarInfo.customerMobilePhone;
                self.customerHomePhone.text = CarInfo.customerHomePhone;
                self.customerEmail.text = CarInfo.customerEmail;
                self.vhlLicence.text = CarInfo.vhlLicence;
                self.remark.text = CarInfo.remark;
                self.vhlStatus.text=CarInfo.vhlStatus;
                self.serviceLevelId.text = CarInfo.serviceLevelId;
                self.insuranceCompany.text = CarInfo.insruanceCompany;
                self.insuranceNum.text = CarInfo.insruanceNum;
                self.dueDate.text = [self setWithTimeString:CarInfo.dueDate];
                self.saleDate.text = [self setWithTimeString:CarInfo.saleDate];
                self.recordStatus.text = CarInfo.recordStatus;
                self.createTime.text = [self setWithTimeString:CarInfo.createTime];
                self.updateTime.text = [self setWithTimeString:CarInfo.updateTime];
                self.brandName.text = CarInfo.brandName;
                self.dealerName.text = CarInfo.dealerName;
                self.colorName.text = CarInfo.colorName;
                self.seriesName.text = CarInfo.seriesName;
                self.typeName.text = CarInfo.typeName;
                self.credentialsName.text = CarInfo.credentialsName;
                self.recordStatusName.text = CarInfo.recordStatusName;
                self.customerSexName.text = CarInfo.customerSexName;
                self.vhlStatusName.text = CarInfo.vhlStatusName;
                self.userRel.text = CarInfo.userRel;
               
              
            } else {
            [MBProgressHUD showText:NSLocalizedString(@"查询失败", nil)];
               
            }
        } else {
             [MBProgressHUD showText:NSLocalizedString(@"请求失败", nil)];
          
        }
    }];
}


- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"车辆信息", nil);
    
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
    query.text = NSLocalizedString(@"查询结果", nil);
    [whiteV addSubview:query];
    [query makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteV);
        make.width.equalTo(170 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
   
    _sc=[[UIScrollView alloc] init];
    [whiteV addSubview:_sc];
    [_sc makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(whiteV);
        make.top.equalTo(62.5 * HeightCoefficient);
        make.bottom.equalTo(-50*HeightCoefficient);
    }];
    _sc.contentSize = CGSizeMake(whiteV.frame.size.width, 930*HeightCoefficient);
    //    sc.contentOffset = CGPointMake(0, 0);
    _sc.pagingEnabled = NO;
    _sc.showsHorizontalScrollIndicator = YES;
    //隐藏纵向滚动条
    _sc.showsVerticalScrollIndicator = NO;
    _sc.bounces = YES;
    _sc.delegate = self;
  
    
    NSArray<NSString *> *titles = @[
        NSLocalizedString(@"车辆编码", nil),
        NSLocalizedString(@"车架号", nil),
        NSLocalizedString(@"客户姓名", nil),
        NSLocalizedString(@"证件类型编码", nil),
        NSLocalizedString(@"证件号码", nil),
        NSLocalizedString(@"性别编码", nil),
        NSLocalizedString(@"手机号码", nil),
        NSLocalizedString(@"家庭电话", nil),
        NSLocalizedString(@"用户邮箱", nil),
        NSLocalizedString(@"车牌号", nil),
        NSLocalizedString(@"备注", nil),
        NSLocalizedString(@"车辆状态编码",nil),
        NSLocalizedString(@"服务等级",nil),
        NSLocalizedString(@"保险公司名称",nil),
        NSLocalizedString(@"保单号",nil),
        NSLocalizedString(@"保险到期日",nil),
        NSLocalizedString(@"销售时间",nil),
        NSLocalizedString(@"记录状态编码",nil),
        NSLocalizedString(@"创建时间",nil),
        NSLocalizedString(@"最后更新时间",nil),
        NSLocalizedString(@"品牌名称",nil),
        NSLocalizedString(@"经销商姓名",nil),
        NSLocalizedString(@"车辆状态",nil),
        NSLocalizedString(@"记录状态",nil),
        NSLocalizedString(@"经销商姓名",nil),
        NSLocalizedString(@"颜色名称",nil),
        NSLocalizedString(@"车系名称",nil),
        NSLocalizedString(@"客户性别",nil),
        NSLocalizedString(@"车辆状态",nil),
        NSLocalizedString(@"是否绑定信息",nil)
        ];
    

    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.font = [UIFont fontWithName:FontName size:14];
        [_sc  addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(85 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
            make.top.equalTo((0 + 30 * i) * HeightCoefficient);
        }];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.text = titles[i];
        rightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        rightLabel.font = [UIFont fontWithName:FontName size:14];
        [_sc  addSubview:rightLabel];
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(198 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(label.right).offset(27*WidthCoefficient);
            make.top.equalTo((0 + 30 * i) * HeightCoefficient);
        }];
        
        if (i == 0) {
            self.carId = rightLabel;
        } else if (i == 1) {
            self.vinLabel = rightLabel;
        } else if (i == 2) {
            self.customerName = rightLabel;
        } else if (i == 3) {
            self.customerCredentials = rightLabel;
        } else if (i == 4) {
            self.customerCredentialsNum = rightLabel;
        } else if (i == 5) {
            self.customerSex = rightLabel;
        } else if (i == 6) {
            self.customerMobilePhone = rightLabel;
        } else if (i == 7) {
            self.customerHomePhone = rightLabel;
        } else if (i == 8) {
            self.customerEmail = rightLabel;
        } else if (i == 9) {
            self.vhlLicence = rightLabel;
        } else if (i == 10) {
            self.remark = rightLabel;
        } else if (i == 11) {
            self.vhlStatus = rightLabel;
        } else if (i == 12) {
            self.serviceLevelId = rightLabel;
        } else if (i == 13) {
            self.insuranceCompany = rightLabel;
        } else if (i == 14) {
            self.insuranceNum = rightLabel;
        } else if (i == 15) {
            self.dueDate = rightLabel;
        } else if (i == 16) {
            self.saleDate = rightLabel;
        } else if (i == 17) {
            self.recordStatus = rightLabel;
        } else if (i == 18) {
            self.createTime = rightLabel;
        } else if (i == 19) {
            self.updateTime = rightLabel;
        } else if (i == 20) {
            self.brandName = rightLabel;
        } else if (i == 21) {
            self.dealerName = rightLabel;
        } else if (i == 22) {
            self.colorName = rightLabel;
        }
        else if (i == 23) {
            self.seriesName = rightLabel;
        }
        else if (i == 24) {
            self.typeName = rightLabel;
        }
        else if (i == 25) {
            self.credentialsName = rightLabel;
        }
        else if (i == 26) {
            self.recordStatusName = rightLabel;
        }
        else if (i == 27) {
            self.customerSexName = rightLabel;
        }
        else if (i == 28) {
            self.vhlStatusName = rightLabel;
        }
        else if (i == 29) {
            self.userRel = rightLabel;
        }
    }

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 2;
    [confirmBtn setTitle:NSLocalizedString(@"确认信息", nil) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:confirmBtn];
    [confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(25 * HeightCoefficient);
    }];
    
}


- (void)confirmBtnClick:(UIButton *)sender {
    CarBindingViewController *vc = [[CarBindingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(NSString *)setWithTimeString:(NSInteger)time
{
   
    NSString *dueDateStr = [NSString stringWithFormat: @"%ld", time];
    NSTimeInterval times=[dueDateStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *dateString = [formatter stringFromDate: date];
    
    return dateString;
}

@end
