//
//  ContractdetailViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractdetailViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
#import "TopImgButton.h"
#import "NSArray+Sudoku.h"
@interface ContractdetailViewController ()

@end

@implementation ContractdetailViewController

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
                            @"contractCode": _contractCode?_contractCode:@"0"
                            };
    
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:findServiceByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
//            contract = [ContractModel yy_modelWithDictionary:dic[@"data"]];
//            [_tableView reloadData];
            
            //响应事件
            
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}



-(void)setupUI
{
    
    self.navigationItem.title = NSLocalizedString(@"合同详细", nil);
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kTabbarHeight, 0));
    }];
    
    UIView *content = [[UIView alloc] init];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(kScreenWidth);
    }];
    
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOpacity = 0.5;// 阴影透明度
    whiteV.layer.shadowOffset = CGSizeMake(0,7.5);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 20.5;//阴影半径，默认3

    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [content addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(200 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    
    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.textAlignment = NSTextAlignmentLeft;
    vipLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    vipLabel.text = NSLocalizedString(@"尊享VIP套餐", nil);
    vipLabel.textColor=[UIColor colorWithHexString:@"#A18E79"];
    [whiteV addSubview:vipLabel];
    [vipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    typeLabel.text = NSLocalizedString(@"类型:", nil);
    typeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:typeLabel];
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(41.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(vipLabel.bottom).offset(10 * HeightCoefficient);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    timeLabel.text = NSLocalizedString(@"有效时间:", nil);
    timeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(70 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(typeLabel.bottom).offset(10 * HeightCoefficient);
    }];
    
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.textAlignment = NSTextAlignmentLeft;
    describeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    describeLabel.text = NSLocalizedString(@"描述:", nil);
    describeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:describeLabel];
    [describeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(41.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(timeLabel.bottom).offset(10 * HeightCoefficient);
    }];
    
    
    
    UIButton *testdriveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    testdriveBtn.layer.cornerRadius = 10;
    [testdriveBtn setTitle:NSLocalizedString(@"试驾", nil) forState:UIControlStateNormal];
    [testdriveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testdriveBtn.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [testdriveBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [whiteV addSubview:testdriveBtn];
    [testdriveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
        make.right.equalTo(whiteV.right).offset(-10 * HeightCoefficient);
    }];
    
    
    UILabel *service = [[UILabel alloc] init];
    service.textAlignment = NSTextAlignmentLeft;
    service.textColor=[UIColor colorWithHexString:@"#333333"];
    service.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    service.text = NSLocalizedString(@"可用服务", nil);
    [whiteV addSubview:service];
    [service makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(whiteV.bottom).offset(20*HeightCoefficient);
    }];
    
    
    UIView *btnContainer = [[UIView alloc] init];
    btnContainer.backgroundColor = [UIColor whiteColor];
    [content addSubview:btnContainer];
    [btnContainer makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(270 * WidthCoefficient);
        make.top.equalTo(service.bottom).offset(15 * HeightCoefficient);
        make.centerX.equalTo(self.view);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"智慧出行", nil),NSLocalizedString(@"智慧停车", nil),NSLocalizedString(@"智慧加油", nil),NSLocalizedString(@"违章查询", nil),NSLocalizedString(@"wifi密码", nil),NSLocalizedString(@"流量查询", nil),NSLocalizedString(@"紧急救援", nil),NSLocalizedString(@"盗车提醒", nil),NSLocalizedString(@"车况检测", nil),NSLocalizedString(@"驾驶行为", nil),NSLocalizedString(@"预约保养", nil),NSLocalizedString(@"道路救援", nil)];
    NSArray *imgTitles = @[@"智慧出行_icon",@"智慧停车_icon",@"智慧加油_icon",@"违章查询_icon",@"wifi密码_icon",@"流量查询_icon",@"紧急救援_icon",@"盗车提醒_icon",@"车况检测_icon",@"驾驶行为_icon",@"预约保养_icon",@"道路救援_icon"];
    NSMutableArray<TopImgButton *> *btns = [NSMutableArray new];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        TopImgButton *btn = [TopImgButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"#040000"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FontName size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgTitles[i]] forState:UIControlStateNormal];
        [btnContainer addSubview:btn];
        [btns addObject:btn];
    }
    
    
    [btns mas_distributeSudokuViewsWithFixedItemWidth:52.5 * WidthCoefficient fixedItemHeight:62 * WidthCoefficient warpCount:4 topSpacing:14.5 * WidthCoefficient bottomSpacing:23.5 * WidthCoefficient leadSpacing:29 * WidthCoefficient tailSpacing:29 * WidthCoefficient];

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
