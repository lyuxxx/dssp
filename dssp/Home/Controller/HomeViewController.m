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
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "dssp-Swift.h"
#import <CUAlertController.h>

@interface HomeViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, FSPagerViewDelegate, FSPagerViewDataSource>

@property (nonatomic, strong) UIButton *robotBtn;
@property (nonatomic, strong) HomeTopView *topView;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) FSPagerView *banner;
@property (nonatomic, strong) FSPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray<NSString *> *imgTitles;
@property (nonatomic, strong) CLLocationManager *mgr;
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
  
    [self postCustByMobile];
    [self setupUI];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mgr startUpdatingLocation];
    self.imgTitles = [NSMutableArray arrayWithArray:@[
                                                      @"广告",
                                                      @"广告",
                                                      @"广告"
                                                      ]];
}

- (void)postCustByMobile
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *isbool = [defaults objectForKey:@"isBinded"];
    //根据键值取
    if (isbool) {
        
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"检测到您未绑定车辆信息,请绑定!" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
        
        CUAlertController *alert = [CUAlertController alertWithImage:[UIImage imageNamed:@"警告"] attributedMessage:message];
        [alert addButtonWithTitle:@"确定" type:CUButtonTypeCancel clicked:^{
            
            //响应事件
            VINBindingViewController *vc=[[VINBindingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }];
        [alert addButtonWithTitle:@"取消" type:CUButtonTypeNormal clicked:^{
            
         
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
    }
    
    //    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    //    NSDictionary *paras = @{
    //                            @"userId": @"",
    //                            @"userName": @"",
    //
    //                            };
    //    [CUHTTPRequest POST:queryCustByMobile parameters:paras response:^(id responseData) {
    //        if (responseData) {
    //
    //        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    ////        CarInfoModel *CarInfo = [CarInfoModel yy_modelWithDictionary:dic];
    //        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
    ////            [hud hideAnimated:YES];
    //
    //
    //        } else {
    //            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
    //            message:@"检测到您未绑定车辆信息,请绑定！"
    //            preferredStyle:UIAlertControllerStyleAlert];
    //
    //            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    //                //响应事件
    //                VINBindingViewController *vc=[[VINBindingViewController alloc] init];
    //                vc.hidesBottomBarWhenPushed = YES;
    //                [self.navigationController pushViewController:vc animated:YES];
    //
    //            }];
    //            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    //
    //            }];
    //            [alert addAction:defaultAction];
    //            [alert addAction:cancelAction];
    //            [self presentViewController:alert animated:YES completion:nil];
    //        }
    //
    //        }
    //    }];
}

- (void)setupUI {
    
    self.robotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_robotBtn setImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_robotBtn];
    [_robotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    self.topView = [[HomeTopView alloc] init];
    [self.view addSubview:_topView];
    [_topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(0);
        make.height.equalTo(355 * HeightCoefficient);
    }];
    
    weakifySelf
    self.topView.clickBlock = ^(UIButton *btn) {
        strongifySelf
        if (btn.tag == 1000 + 1) {//出行
            MapViewController *mapVC = [[MapViewController alloc] init];
            mapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
    };
    
    self.scroll = [[UIScrollView alloc] init];
    _scroll.contentInset = UIEdgeInsetsMake(355 * HeightCoefficient, 0, 0, 0);
    _scroll.scrollIndicatorInsets = UIEdgeInsetsMake(355 * HeightCoefficient, 0, 0, 0);
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
    
    self.banner = [[FSPagerView alloc] init];
    _banner.automaticSlidingInterval = 3.0;
    _banner.isInfinite = YES;
    _banner.delegate = self;
    _banner.dataSource = self;
    _banner.itemSize = CGSizeZero;
    [_banner registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"FSPagerViewCell"];
    [content addSubview:_banner];
    [_banner makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(101.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(4 * HeightCoefficient);
    }];
    
    self.pageControl = [[FSPageControl alloc] init];
    _pageControl.numberOfPages = self.imgTitles.count;
    _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    [_banner addSubview:_pageControl];
    [_pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_banner);
        make.bottom.equalTo(_banner);
        make.width.equalTo(_banner);
        make.height.equalTo(15);
    }];
    
    UILabel *reportLabel = [[UILabel alloc] init];
    reportLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    reportLabel.font = [UIFont fontWithName:FontName size:16];
    reportLabel.text = NSLocalizedString(@"行车报告", nil);
    [content addSubview:reportLabel];
    [reportLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(71.2 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.top.equalTo(_banner.bottom).offset(20 * HeightCoefficient);
        make.left.equalTo(7.5 * WidthCoefficient);
    }];
    
    UIImageView *reportImgV = [[UIImageView alloc] init];
    reportImgV.userInteractionEnabled = YES;
    reportImgV.layer.cornerRadius = 4;
    reportImgV.backgroundColor = [UIColor colorWithHexString:@"#4d443e"];
    [content addSubview:reportImgV];
    [reportImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(158 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(reportLabel.bottom).offset(10 * HeightCoefficient);
        make.bottom.equalTo(content.bottom).offset(-40 * HeightCoefficient);
    }];
    
    UILabel * innerLabel = [[UILabel alloc] init];
    innerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    innerLabel.textColor = [UIColor whiteColor];
    innerLabel.font = [UIFont fontWithName:FontName size:14];
    innerLabel.numberOfLines = 0;
    innerLabel.text = @"驾驶行为周\n2017-12-07";
    [reportImgV addSubview:innerLabel];
    [innerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(152.5 * WidthCoefficient);
        make.height.equalTo(50 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    detailBtn.layer.cornerRadius = 11 * HeightCoefficient;
    [detailBtn setTitle:NSLocalizedString(@"查看详细", nil) forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    detailBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    [reportImgV addSubview:detailBtn];
    [detailBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(75 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.left.equalTo(9.5 * WidthCoefficient);
        make.top.equalTo(73 * HeightCoefficient);
    }];
    
    [self.view insertSubview:_scroll atIndex:0];
    
    [self.KVOController observe:self.scroll keyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        //        CGFloat newOffset = offset.y + 355 * HeightCoefficient;
        CGFloat newOffset = offset.y + 92 * WidthCoefficient + 53 * HeightCoefficient + 210 * HeightCoefficient;
        if (offset.y >= -(92 * WidthCoefficient + 53 * HeightCoefficient)) {
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
}

- (void)detailBtnClick:(UIButton *)sender {
    NSLog(@"detail");
}

- (void)didTap:(UITapGestureRecognizer *)sender {
    [self.topView didTapWithPoint:[sender locationInView:_topView]];
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
    NSLog(@"定位失败");
    [_mgr stopUpdatingLocation];//关闭定位
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"定位成功");
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
            
            NSArray *location=[test objectForKey:@"FormattedAddressLines"];
            NSString *str= [location objectAtIndex:0];
            self.topView.locationStr = str;
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
