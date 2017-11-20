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
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    NSDictionary *paras = @{
                            @"vin": vin,
                           
                            };
    [CUHTTPRequest POST:getBasicInfo parameters:paras response:^(id responseData) {
        if (responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            CarInfoModel *CarInfo = [CarInfoModel yy_modelWithDictionary:dic];
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                [hud hideAnimated:YES];
                
                
                
            } else {
                hud.label.text = [dic objectForKey:@"msg"];
                [hud hideAnimated:YES afterDelay:1];
            }
        } else {
            hud.label.text = NSLocalizedString(@"请求失败", nil);
            [hud hideAnimated:YES afterDelay:1];
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
    _sc.contentSize = CGSizeMake(whiteV.frame.size.width, 750*HeightCoefficient);
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
        NSLocalizedString(@"车主名称", nil),
        NSLocalizedString(@"证件类型", nil),
        NSLocalizedString(@"证件号码", nil),
        NSLocalizedString(@"性别",nil),
        NSLocalizedString(@"移动电话",nil),
        NSLocalizedString(@"家庭电话",nil),
        NSLocalizedString(@"邮箱",nil),
        NSLocalizedString(@"车辆颜色",nil),
        NSLocalizedString(@"车辆品牌",nil),
        NSLocalizedString(@"车系",nil),
        NSLocalizedString(@"车型",nil),
        NSLocalizedString(@"车牌号",nil),
        NSLocalizedString(@"备注",nil),
        NSLocalizedString(@"车辆状态",nil),
        NSLocalizedString(@"服务等级",nil),
        NSLocalizedString(@"保险公司名称",nil),
        NSLocalizedString(@"保单号",nil),
        NSLocalizedString(@"保险到期日",nil),
        NSLocalizedString(@"销售时间",nil),
        NSLocalizedString(@"记录状态",nil),
        NSLocalizedString(@"套餐id",nil),
        NSLocalizedString(@"套餐名称",nil),
        NSLocalizedString(@"创建时间",nil)
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
