//
//  HomeViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "HomeViewController.h"
#import <MBProgressHUD+CU.h>
#import <YYCategoriesSub/YYCategories.h>
#import <YYText.h>
#import "TopImgButton.h"
#import "HomeTopView.h"
#import <NSObject+FBKVOController.h>
#import "VINBindingViewController.h"
#import <CUHTTPRequest.h>
#import "MapHomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "dssp-Swift.h"
#import <CUAlertController.h>
#import "InputAlertView.h"
#import <MapSearchManager.h>
#import "CarflowViewController.h"
#import "UITabBar+badge.h"
#import "StoreTabViewController.h"
#import "UpkeepViewController.h"
#import "TrafficReportModel.h"
@interface HomeViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, FSPagerViewDelegate, FSPagerViewDataSource,InputAlertviewDelegate>

@property (nonatomic, strong) UIButton *robotBtn;
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) FSPagerView *banner;
@property (nonatomic, strong) FSPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray<NSString *> *imgTitles;
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) TrafficReporData *trafficReporData;
@end

@implementation HomeViewController

- (BOOL)needGradientImg {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self.tabBarController.tabBar showBadgeOnItemIndex:1];
 
    [self setupUI];
    [self requestData];
    
}

-(void)requestData
{
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", queryTheVehicleHealthReportForLatestSevenDays,@"1"];
    //    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:@{} success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            //            [hud hideAnimated:YES];
            _trafficReporData =[TrafficReporData yy_modelWithDictionary:dic[@"data"]];
            self.topView.trafficReporData = _trafficReporData;
            
        } else {
            self.topView.trafficReporData = _trafficReporData;
            //            [hud hideAnimated:YES];
            //[MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        self.topView.trafficReporData = _trafficReporData;
        //        [hud hideAnimated:YES];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopupView" object:nil userInfo:nil];
    
    [self postCustByMobile];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"HomeViewController"];
    [self.mgr startUpdatingLocation];
    self.imgTitles = [NSMutableArray arrayWithArray:@[
                                                      @"广告",
                                                      @"广告",
                                                      @"广告"
                                                      ]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"HomeViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"HomeViewController"];
}

- (void)postCustByMobile
{
    //    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    //    NSString *vin = [defaults1 objectForKey:@"vin"];
    //
    //    非车
    if ([kVin isEqualToString:@""]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
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
           
            
            
            
        }
        else if ([CuvhlTStatus isEqualToString:@"1"])
        {
            //T车辆
            
            
            
            
        }
    }
}

- (void)setupUI {
    
    self.robotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.robotBtn setContentMode:UIViewContentModeScaleAspectFill];
    [_robotBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_robotBtn setImage:[UIImage imageNamed:@"机器人"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_robotBtn];
    [_robotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    self.topView = [[HomeTopView alloc] init];
    [self.view addSubview:_topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(0);
        make.height.equalTo(375 * HeightCoefficient);
    }];
    
    self.scroll = [[UIScrollView alloc] init];
    _scroll.contentInset = UIEdgeInsetsMake(375 * HeightCoefficient, 0, 0, 0);
    _scroll.scrollIndicatorInsets = UIEdgeInsetsMake(375 * HeightCoefficient, 0, 0, 0);
    _scroll.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kTabbarHeight, 0));
    }];
    
    UIView *content = [[UIView alloc] init];
    [_scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scroll);
        make.width.equalTo(_scroll);
    }];
    
//    self.banner = [[FSPagerView alloc] init];
//    _banner.automaticSlidingInterval = 3.0;
//    _banner.isInfinite = YES;
//    _banner.delegate = self;
//    _banner.dataSource = self;
//    _banner.itemSize = CGSizeZero;
//    [_banner registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"FSPagerViewCell"];
//    [content addSubview:_banner];
//    [_banner makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(359 * WidthCoefficient);
//        make.height.equalTo(101.5 * HeightCoefficient);
//        make.centerX.equalTo(0);
//        make.top.equalTo(4 * HeightCoefficient);
//    }];
//
//    self.pageControl = [[FSPageControl alloc] init];
//    _pageControl.numberOfPages = self.imgTitles.count;
//    _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    _pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
//    [_banner addSubview:_pageControl];
//    [_pageControl makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_banner);
//        make.bottom.equalTo(_banner);
//        make.width.equalTo(_banner);
//        make.height.equalTo(15);
//    }];
    
    NSArray *labelNames = @[NSLocalizedString(@"车况报告", nil),NSLocalizedString(@"驾驶行为周报", nil),NSLocalizedString(@"行车日志", nil)];
    NSArray *imgNames = @[@"车况报告背景图",@"驾驶行为周报背景图",@"行车日志背景图"];
    NSArray *innerLabelNames = @[NSLocalizedString(@"最新车况报告", nil),NSLocalizedString(@"最新一期驾驶行为周报", nil),NSLocalizedString(@"最新行车日志", nil)];
    
    UILabel *lastLabel;
    
    for (NSInteger i = 0; i < labelNames.count; i++) {
        UILabel *reportLabel = [[UILabel alloc] init];
        reportLabel.textColor = [UIColor colorWithHexString:@"#040000"];
        reportLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        reportLabel.text = labelNames[i];
        [content addSubview:reportLabel];
        [reportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(8 * WidthCoefficient);
            if (i == 0) {
                make.top.equalTo(content).offset(20 * WidthCoefficient);
            } else {
                make.top.equalTo(lastLabel.bottom).offset(198 * WidthCoefficient);
            }
        }];
        
        lastLabel = reportLabel;
        
        UIImageView *reportImgV = [[UIImageView alloc] init];
        reportImgV.tag = 100 + i;
        reportImgV.image = [UIImage imageNamed:imgNames[i]];
        reportImgV.userInteractionEnabled = YES;
        reportImgV.backgroundColor = [UIColor colorWithHexString:@"#1a1515"];
        reportImgV.layer.cornerRadius = 4;
        reportImgV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        reportImgV.layer.shadowOffset = CGSizeMake(0, 6);
        reportImgV.layer.shadowRadius = 7;
        reportImgV.layer.shadowOpacity = 0.3;
        [content addSubview:reportImgV];
        [reportImgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(359 * WidthCoefficient);
            make.height.equalTo(158 * WidthCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(reportLabel.bottom).offset(10 * HeightCoefficient);
            if (i == labelNames.count - 1) {
                make.bottom.equalTo(content.bottom).offset(-40 * HeightCoefficient);
            }
        }];
        
        UITapGestureRecognizer *reportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportTap:)];
        [reportImgV addGestureRecognizer:reportTap];
        
        UILabel * innerLabel = [[UILabel alloc] init];
        innerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        innerLabel.textColor = [UIColor whiteColor];
        innerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        innerLabel.numberOfLines = 1;
        innerLabel.text = innerLabelNames[i];
        [reportImgV addSubview:innerLabel];
        [innerLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.height.equalTo(25 * WidthCoefficient);
            make.top.equalTo(53 * WidthCoefficient);
        }];
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.userInteractionEnabled = NO;
        detailBtn.layer.cornerRadius = 11 * WidthCoefficient;
        detailBtn.layer.masksToBounds = YES;
        [detailBtn setTitle:NSLocalizedString(@"查看详细", nil) forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
        detailBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
        [reportImgV addSubview:detailBtn];
        [detailBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(75 * WidthCoefficient);
            make.height.equalTo(22 * WidthCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(innerLabel.bottom).offset(5 * WidthCoefficient);
        }];
    }
    
    [self.view insertSubview:_scroll atIndex:0];
    
    
    [self.KVOController observe:self.scroll keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        //        CGFloat newOffset = offset.y + 375 * HeightCoefficient;
        CGFloat newOffset = offset.y + 92 * WidthCoefficient + 73 * HeightCoefficient + 210 * HeightCoefficient;
        if (offset.y >= -(92 * WidthCoefficient + 73 * HeightCoefficient)) {
            [_topView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(-210 * HeightCoefficient);
            }];
        } else {
            [_topView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(-newOffset);
            }];
        }
    }];
    
    //处理topView点击事件,因为会与滑动冲突
    UIView *tapView = [[UIView alloc] init];
    [_scroll addSubview:tapView];
    [tapView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topView);
    }];
    [_scroll insertSubview:tapView atIndex:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [tapView addGestureRecognizer:tap];
    
    weakifySelf
    self.topView.clickBlock = ^(UIButton *btn) {
        strongifySelf
        if (btn.tag == 1000 + 1) {
            
            if ([kVin isEqualToString:@""]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
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
                
                
                
//                PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
//                [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
//                //            InputalertView.delegate = self;
//                UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
//                [keywindow addSubview: popupView];
//
//                popupView.clickBlock = ^(UIButton *btn,NSString *str) {
//                    if (btn.tag == 100) {//左边按钮
//                        //右边按钮
//                        //响应事件
//                        VINBindingViewController *vc=[[VINBindingViewController alloc] init];
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                    if(btn.tag ==101)
//                    {
//                        //右边按钮
//                        //响应事件
//                        VINBindingViewController *vc=[[VINBindingViewController alloc] init];
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:vc animated:YES];
//
//                    }
//
//                };
            }
            else
            {
                //非T车
                if([CuvhlTStatus isEqualToString:@"0"])
                {
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                    [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview: popupView];
                    
                    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                            
                            
                        }
                        
                        
                    };
                    
                }
                else if ([CuvhlTStatus isEqualToString:@"1"])
                {
                    //T车辆
                    
                    if([KcertificationStatus isEqualToString:@"1"])
                    {
                        //T车辆
                        //出行
                        MapHomeViewController *mapVC = [[MapHomeViewController alloc] initWithType:PoiTypeAll];
                        mapVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:mapVC animated:YES];
                        
                    }
                    else
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                        [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                        //            InputalertView.delegate = self;
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: popupView];
                        
                        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                
                                
                            }
                            
                        };
                        
                    }
                    
                }
                
            }
            
            
        }
        if (btn.tag == 1000 ) {//实现流量
            
            if ([kVin isEqualToString:@""]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
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
                    [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview: popupView];
                    
                    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                            
                            
                        }
                        
                        
                    };
                    
                }
                else if ([CuvhlTStatus isEqualToString:@"1"])
                {
                    
                    //                    是否实名
                    if([KcertificationStatus isEqualToString:@"1"])
                    {
                        //T车辆
                        CarflowViewController *carflow = [[CarflowViewController alloc] init];
                        carflow.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:carflow animated:YES];
                        
                    }
                    else
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                        [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                        //            InputalertView.delegate = self;
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: popupView];
                        
                        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                
                                
                            }
                            
                        };
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
            
        }
        if (btn.tag == 1000 + 2) {//商城
            
            
            if ([kVin isEqualToString:@""]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
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
                    [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview: popupView];
                    
                    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                            
                            
                        }
                        
                        
                    };
                    
                }
                //T车辆
                else if ([CuvhlTStatus isEqualToString:@"1"])
                {
                    //                    是否实名
                    if([KcertificationStatus isEqualToString:@"1"])
                    {
                        //T车辆
                        StoreTabViewController *storeTab = [[StoreTabViewController alloc] init];
                        storeTab.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:storeTab animated:YES];
                        
                    }
                    else
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                        [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                        //            InputalertView.delegate = self;
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: popupView];
                        
                        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                
                                
                            }
                            
                            
                        };
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        if (btn.tag == 1000 + 3) {//违章查询
            
            if ([kVin isEqualToString:@""]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
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
                    [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview: popupView];
                    
                    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                            
                            
                        }
                        
                        
                    };
                    
                }
                else if ([CuvhlTStatus isEqualToString:@"1"])
                {
                    //T车辆
                    //出行
                    //                    是否实名
                    if([KcertificationStatus isEqualToString:@"1"])
                    {
                        //T车辆
                        UIViewController *vc = [[NSClassFromString(@"LllegalViewController") alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    else
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                        [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                        //            InputalertView.delegate = self;
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: popupView];
                        
                        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                
                                
                            }
                            
                            
                        };
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
        if (btn.tag == 1000 + 4) {
            
            if ([kVin isEqualToString:@""]) {
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
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
                    [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview: popupView];
                    
                    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                        if (btn.tag == 100) {//左边按钮
                            
                            
                        }
                        
                    };
                }
                else if ([CuvhlTStatus isEqualToString:@"1"])
                {
                    
                    if([KcertificationStatus isEqualToString:@"1"])
                    {
                        //T车辆
                        UpkeepViewController *upkeep = [[UpkeepViewController alloc] init];
                        upkeep.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:upkeep animated:YES];
                        
                    }
                    else
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                        [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                        //            InputalertView.delegate = self;
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: popupView];
                        
                        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                
                                
                            }
                            
                            
                        };
                        
                    }
                    
                    
                    
                }
                
            }
        }
    };
    
    self.topView.locationClick = ^(NoResponseYYLabel *label) {
        if ([label.text isEqualToString:@"\U0000fffc未获取到车辆位置"]) {
            strongifySelf
            [self getCarLocation];
        } else {
            strongifySelf
            MapHomeViewController *mapVC = [[MapHomeViewController alloc] initWithType:PoiTypeAll];
            mapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
    };
}

- (void)reportTap:(UITapGestureRecognizer *)sender {
    NSArray *csS = @[@"TrafficReportViewController",@"DrivingWeekReportViewController",@"TrackListViewController"];
    UIViewController *vc = [[NSClassFromString(csS[sender.view.tag - 100]) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClick:(UIButton *)sender {
    UIViewController *vc = [[NSClassFromString(@"InformationCenterViewController") alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTap:(UITapGestureRecognizer *)sender {
    [self.topView didTapWithPoint:[sender locationInView:_topView]];
}

- (void)getCarLocation {
    [CUHTTPRequest POST:[NSString stringWithFormat:@"%@/%@",getLastPositionService,kVin] parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            CLLocationDegrees latitude = [dic[@"data"][@"position"][@"latitude"] doubleValue];
            CLLocationDegrees longitude = [dic[@"data"][@"position"][@"longitude"] doubleValue];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
            [self saveCarLocationWithCoordinate:location];
            weakifySelf
            [[MapSearchManager sharedManager] reGeoInfo:location returnBlock:^(MapReGeoInfo *regeoInfo) {
                strongifySelf
                //                self.topView.locationStr = [regeoInfo.formattedAddress substringFromIndex:regeoInfo.province.length + regeoInfo.city.length + regeoInfo.district.length + regeoInfo.township.length];
                self.topView.locationStr = [regeoInfo.formattedAddress substringFromIndex:regeoInfo.province.length];
            }];
        } else {
            
        }
    } failure:^(NSInteger code) {
        
    }];
}

///存储车辆位置，地图使用
- (void)saveCarLocationWithCoordinate:(CLLocationCoordinate2D)location {
    NSDictionary *dic = @{
                          @"longitude":[NSNumber numberWithDouble:location.longitude],
                          @"latitude":[NSNumber numberWithDouble:location.latitude]
                          };
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"carLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - CLLocationManagerDelegate

/// 代理方法中监听授权的改变,被拒绝有两种情况,一是真正被拒绝,二是服务关闭了
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户未决定");
            break;
        }
            // 系统预留字段,暂时还没用到
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 被拒绝有两种情况 1.设备不支持定位服务 2.定位服务被关闭
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"真正被拒绝");
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                               message:@"请在设置中打开定位服务功能！"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    //响应事件
                    // 跳转到设置界面
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                }];
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                NSLog(@"没有开启此功能");
            }
            break;
        }
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [_mgr stopUpdatingLocation];//关闭定位
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_mgr stopUpdatingLocation];//关闭定位
    CLLocation *newLocation = locations[0];
    //    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            // Country(国家)
            // State(城市) SubLocality(区)
            //            NSString *location= [[test objectForKey:@"State"] stringByAppendingString:[test objectForKey:@"City"]];
            
            //            NSArray *location=[test objectForKey:@"FormattedAddressLines"];
            //            NSString *str= [location objectAtIndex:0];
            //            self.topView.locationStr = str;
            weakifySelf
            [[MapSearchManager sharedManager] weatherLive:test[@"City"] returnBlock:^(MapWeatherLive *weatherInfo) {
                strongifySelf
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"EEEE";
                NSString *week = [formatter stringFromDate:[NSDate date]];
                [self.topView updateWeatherText:[NSString stringWithFormat:@"%@ %@  %@℃",week,weatherInfo.weather,weatherInfo.temperature]];
                [self getCarLocation];
            }];
        }
    }];
}


#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView {
    return self.imgTitles.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"FSPagerViewCell" atIndex:index];
    cell.contentView.layer.shadowRadius = 0;
    cell.imageView.userInteractionEnabled = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.image = [UIImage imageNamed:self.imgTitles[index]];
    return cell;
}

#pragma mark - FSPagerViewDelegate

- (void)pagerViewDidScroll:(FSPagerView *)pagerView {
    if (self.pageControl.currentPage != pagerView.currentIndex) {
        self.pageControl.currentPage = pagerView.currentIndex;
    }
}

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index {
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
    self.pageControl.currentPage = index;
    NSLog(@"%ld",index);
}

#pragma mark - setter and getter

- (CLLocationManager *)mgr
{
    if (_mgr == nil) {
        // 实例化位置管理者
        _mgr = [[CLLocationManager alloc] init];
        // 指定代理,代理中获取位置数据
        _mgr.delegate = self;
        // 兼容iOS8之后的方法
        // 设置定位所需的精度 枚举值 精确度越高越耗电
        self.mgr.desiredAccuracy = kCLLocationAccuracyBest;
        // 每100米更新一次定位
        self.mgr.distanceFilter = 100;
        //    判断位置管理者能否响应iOS8之后的授权方法
        if ([_mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_mgr requestWhenInUseAuthorization];
        }
    }
    return _mgr;
}

- (void)setImgTitles:(NSMutableArray<NSString *> *)imgTitles {
    _imgTitles = imgTitles;
    [self.banner reloadData];
    self.pageControl.numberOfPages = imgTitles.count;
}

@end

