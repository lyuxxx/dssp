//
//  LoveCarViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LoveCarViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "TopImgButton.h"
#import "NSArray+Sudoku.h"
#import "MapHomeViewController.h"
#import "RefuelViewController.h"
#import "MapUpdateViewController.h"
#import "StoreTabViewController.h"
#import "TrafficReportModel.h"
#import "VINBindingViewController.h"
@interface LoveCarViewController ()

@property (nonatomic, strong) UILabel *plateLabel;
@property (nonatomic, strong) UIImageView *carImgV;
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *oilLeftLabel;
@property (nonatomic, strong) UILabel *healthLabel;
@property (nonatomic, strong) TrafficReporData *trafficReporData;
@end

@implementation LoveCarViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self requestData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"LoveCarViewController"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopupView" object:nil userInfo:nil];
    [self postCustByMobile];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"LoveCarViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"LoveCarViewController"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_plateLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _plateLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _plateLabel.layer.mask = maskLayer;
    _plateLabel.layer.masksToBounds = YES;
}

- (void)postCustByMobile
{
    //    非车
    if ([kVin isEqualToString:@""]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
        [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"首页弹窗背景" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
        //            InputalertView.delegate = self;
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: popupView];
        
        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
            if(btn.tag ==100)
            {
                //响应事件
                VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
    }
    else
    {
        //非T车
        if([CuvhlTStatus isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
            [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"首页弹窗背景1" type:12 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: popupView];
            
            popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                
                
            };
            
            
        }
        else if ([CuvhlTStatus isEqualToString:@"1"])
        {
            //                    是否实名
            if([KcertificationStatus isEqualToString:@"1"])
            {
                //T车辆
                //                CarflowViewController *carflow = [[CarflowViewController alloc] init];
                //                carflow.hidesBottomBarWhenPushed = YES;
                //                [self.navigationController pushViewController:carflow animated:YES];
                
            }
            else
            {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"首页弹窗背景1" type:12 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"",nil] ];
                //            InputalertView.delegate = self;
                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                [keywindow addSubview: popupView];
                
                popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                    //                    if (btn.tag == 100) {//左边按钮
                    //
                    //
                    //
                    //                    }
                    
                };
                
            }
            
        
        }
        
    }
}
-(void)requestData
{
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", queryTheVehicleHealthReportForLatestSevenDays,kVin];
//    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:@{} success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [hud hideAnimated:YES];
            _trafficReporData =[TrafficReporData yy_modelWithDictionary:dic[@"data"]];
            
            self.trafficReporData =_trafficReporData;
        } else {
            self.trafficReporData =_trafficReporData;
//            [hud hideAnimated:YES];
            //[MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
       self.trafficReporData =_trafficReporData;
//        [hud hideAnimated:YES];
        
    }];
}

- (void)setupUI {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16 * WidthCoefficient, kNaviHeight - kStatusBarHeight - 37 * WidthCoefficient, 79.5 * WidthCoefficient, 30 * WidthCoefficient)];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"爱车", nil);
    [self.navigationController.navigationBar addSubview:title];
    
    UIButton *robotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    robotBtn.tag = 1111;
    [robotBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [robotBtn setImage:[UIImage imageNamed:@"机器人"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:robotBtn];
    [robotBtn makeConstraints:^(MASConstraintMaker *make) {
       make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *content = [[UIView alloc] init];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(kScreenWidth);
    }];
    
    UIImageView *previewImgV = [[UIImageView alloc] init];
    previewImgV.image = [UIImage imageNamed:@"home_bg"];
    [content addSubview:previewImgV];
    [previewImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(content);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(225 * WidthCoefficient);
        make.top.equalTo(content);
    }];
    
    UILabel *ds = [[UILabel alloc] init];
    ds.textAlignment = NSTextAlignmentCenter;
    ds.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:55];
    ds.textColor = [UIColor colorWithHexString:@"#443938"];
    ds.text = @"DS 7";
    [previewImgV addSubview:ds];
    [ds makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(40 * WidthCoefficient);
        make.height.equalTo(55.5 * WidthCoefficient);
        make.width.equalTo(kScreenWidth);
    }];
    
    self.plateLabel = [[UILabel alloc] init];
    _plateLabel.hidden = YES;
    _plateLabel.textAlignment = NSTextAlignmentCenter;
    _plateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _plateLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _plateLabel.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [previewImgV addSubview:_plateLabel];
    [_plateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(98 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
        make.left.equalTo(0);
        make.top.equalTo(30 * WidthCoefficient);
    }];
    
    
    self.carImgV = [[UIImageView alloc] init];
    _carImgV.image = [UIImage imageNamed:@"DS 7"];
    [previewImgV addSubview:_carImgV];
    [_carImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(251.7 * WidthCoefficient);
        make.height.equalTo(133.5 * WidthCoefficient);
        make.left.equalTo(62 * WidthCoefficient);
        make.top.equalTo(68.5 * WidthCoefficient);
    }];
    /**
    UIView *dataContainer = [[UIView alloc] init];
    [content addSubview:dataContainer];
    [dataContainer makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(75 * WidthCoefficient);
        make.top.equalTo(previewImgV.bottom);
        make.centerX.equalTo(0);
    }];
    
    NSArray *dataTitles = @[NSLocalizedString(@"总里程", nil),NSLocalizedString(@"剩余油量", nil),NSLocalizedString(@"车况健康", nil)];
    for (NSInteger i = 0; i < dataTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:12];
        label0.textAlignment = NSTextAlignmentCenter;
        label0.text = dataTitles[i];
        label0.textColor = [UIColor colorWithHexString:GeneralColorString];
        [dataContainer addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(114 * WidthCoefficient);
            make.height.equalTo(15 * WidthCoefficient);
            make.left.equalTo((16 + 114 * i) * WidthCoefficient);
            make.top.equalTo(20 * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        [dataContainer addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(114 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.top.equalTo(label0.bottom);
            make.centerX.equalTo(label0);
        }];
        
        if (i == 0) {
            self.mileageLabel = label1;
        } else if (i == 1) {
            self.oilLeftLabel = label1;
        } else if (i == 2) {
            self.healthLabel = label1;
        }
    }
    **/
    UIImageView *line = [[UIImageView alloc] init];
    line.image = [UIImage imageNamed:@"bg_line"];
    [content addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(1 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(previewImgV.bottom);
    }];
    
    UIView *btnContainer = [[UIView alloc] init];
    btnContainer.backgroundColor = [UIColor clearColor];
    [content addSubview:btnContainer];
    [btnContainer makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(243 * WidthCoefficient);
        make.top.equalTo(line.bottom).offset(10 * WidthCoefficient);
        make.centerX.equalTo(content);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"智慧出行", nil),NSLocalizedString(@"油价查询", nil),NSLocalizedString(@"车载WIFI", nil),NSLocalizedString(@"预约保养", nil),NSLocalizedString(@"车载流量", nil),NSLocalizedString(@"车辆追踪", nil),NSLocalizedString(@"车况报告", nil),NSLocalizedString(@"驾驶行为", nil),NSLocalizedString(@"违章查询", nil),NSLocalizedString(@"行车日志", nil),NSLocalizedString(@"地图升级", nil)];
    NSArray *imgTitles = @[@"智慧出行_icon",@"智慧加油_icon",@"车载WIFI_icon",@"预约保养_icon",@"流量查询_icon",@"车辆追踪_icon",@"车况报告_icon",@"驾驶行为_icon",@"违章查询_icon",@"行车日志_icon",@"地图升级_icon"];
    NSMutableArray<TopImgButton *> *btns = [NSMutableArray new];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        TopImgButton *btn = [TopImgButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:FontName size:13];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgTitles[i]] forState:UIControlStateNormal];
        [btnContainer addSubview:btn];
        [btns addObject:btn];
    }
    
    [btns mas_distributeSudokuViewsWithFixedItemWidth:61 * WidthCoefficient fixedItemHeight:61 * WidthCoefficient warpCount:4 topSpacing:10 * WidthCoefficient bottomSpacing:10 * WidthCoefficient leadSpacing:16 * WidthCoefficient tailSpacing:16 * WidthCoefficient];
    
    UILabel *storeLabel = [[UILabel alloc] init];
    storeLabel.text = NSLocalizedString(@"商城", nil);
    storeLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    storeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [content addSubview:storeLabel];
    [storeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(70 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
        make.left.equalTo(24 * WidthCoefficient);
        make.top.equalTo(btnContainer.bottom).offset(20 * WidthCoefficient);
    }];
    
    UIImageView *redV = [[UIImageView alloc] init];
    redV.image = [UIImage imageNamed:@"red_vertical"];
    [content addSubview:redV];
    [redV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 * WidthCoefficient);
        make.height.equalTo(15 * WidthCoefficient);
        make.centerY.equalTo(storeLabel);
        make.right.equalTo(storeLabel.left).offset(-5 * WidthCoefficient);
    }];
    
    UIImageView *storeImgV = [[UIImageView alloc] init];
    storeImgV.userInteractionEnabled = YES;
    storeImgV.image = [UIImage imageNamed:@"背景图"];
    [content addSubview:storeImgV];
    [storeImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(158 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(storeLabel.bottom).offset(10 * WidthCoefficient);
        make.bottom.equalTo(content.bottom).offset(-30 * WidthCoefficient);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoStore:)];
    [storeImgV addGestureRecognizer:tap];
}

-(void)setTrafficReporData:(TrafficReporData *)trafficReporData
{
    NSString *totalMileage = [[NSString stringWithFormat:@"%@",trafficReporData.totalMileage] stringByAppendingString:@"km"];
    
//    NSString *levelOil = [[NSString stringWithFormat:@"%@",trafficReporData.levelFuel] stringByAppendingString:@"%"];
    
    if([trafficReporData.alertPriority isEqualToString:@"high"]) {
        
        _healthLabel.text = @"需维修";
        
    }
    else if([trafficReporData.alertPriority isEqualToString:@"low"]) {
        _healthLabel.text = @"需检查";
    }
    else
    {
        _healthLabel.text = @"未知";
        
    }
    
    _mileageLabel.text = trafficReporData.totalMileage?totalMileage:@"0km";
//    _oilLeftLabel.text = trafficReporData.levelFuel?levelOil:@"0%";
    
    if(trafficReporData.levelFuel)
    {
    
    NSString *stringInt = trafficReporData.levelFuel;
    int ivalue = [stringInt intValue];
    NSString *levelFuel = [[NSString stringWithFormat:@"%@",trafficReporData.levelFuel] stringByAppendingString:@"%"];
    if (ivalue<10 || ivalue==10) {
        
        _oilLeftLabel.text=NSLocalizedString(levelFuel, nil);
        _oilLeftLabel.textColor = [UIColor redColor];
    }
    else
    {
        _oilLeftLabel.text=NSLocalizedString(levelFuel, nil);
        _oilLeftLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
    }
    }
    else
    {
        _oilLeftLabel.text= @"0%";
        _oilLeftLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
    }
    
}

- (void)gotoStore:(UITapGestureRecognizer *)sender {
    StoreTabViewController *storeTab = [[StoreTabViewController alloc] init];
    storeTab.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeTab animated:YES];
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 1111) {
        
//        if ([KuserName isEqualToString:@"18911568274"]) {
//
//            [MBProgressHUD showText:NSLocalizedString(@"当前为游客模式，无此操作权限", nil)];
//
//        }
//        else
//        {
        
            UIViewController *vc = [[NSClassFromString(@"InformationCenterViewController") alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
//        }
        
    
        
    
    }
    if (sender.tag == 100) {
        MapHomeViewController *vc = [[MapHomeViewController alloc] initWithType:PoiTypeAll];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        UIViewController *vc = [[NSClassFromString(@"TrackDetailViewController") alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 101) {
        RefuelViewController *vc = [[RefuelViewController alloc] initWithType:PoiTypeOil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 102) {
        UIViewController *vc = [[NSClassFromString(@"WifiViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 103) {
        UIViewController *vc = [[NSClassFromString(@"UpkeepViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 104) {
        UIViewController *vc = [[NSClassFromString(@"CarflowViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 105) {
        UIViewController *vc = [[NSClassFromString(@"CarTrackViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 106) {
        UIViewController *vc = [[NSClassFromString(@"TrafficReportController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 107) {
        UIViewController *vc = [[NSClassFromString(@"DrivingWeekReportViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 108) {
        UIViewController *vc = [[NSClassFromString(@"LllegalViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 109) {
        UIViewController *vc = [[NSClassFromString(@"TrackListViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag == 110) {
        if ([KuserName isEqualToString:@"18911568274"]) {
            [MBProgressHUD showText:@"当前为游客模式，无此操作权限"];
            return;
        }
        UIViewController *vc = [[NSClassFromString(@"MapUpdateViewController") alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
