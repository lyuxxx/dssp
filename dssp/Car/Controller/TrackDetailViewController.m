//
//  TrackDetailViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrackDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "MapUtility.h"
#import "TrackObject.h"
#import <YYLabel.h>

@interface TrackDetailViewController () <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *endAnnotation;

@property (nonatomic, strong) UIView *top;

@property (nonatomic, strong) TrackInfo *trackInfo;
@property (nonatomic, strong) NSArray<TrackDetailRecordItem *> *coordinates;

@property (nonatomic, strong) UILabel *harshBrakeLabel;
@property (nonatomic, strong) UILabel *harshAccLabel;
@property (nonatomic, strong) UILabel *harshTurnLabel;
@property (nonatomic, strong) UILabel *autoBrakeLabel;
@property (nonatomic, strong) YYLabel *startAddressLabel;
@property (nonatomic, strong) YYLabel *endAddressLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *averageSpeedLabel;
@property (nonatomic, strong) UILabel *fuelConsumedLabel;

@end

@implementation TrackDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (instancetype)initWithTrackInfo:(TrackInfo *)trackInfo {
    self = [super init];
    if (self) {
        self.trackInfo = trackInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"arrow行车轨迹"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(32 * WidthCoefficient);
    }];
    
    [self createGradientBg];
    [self createMapView];
    [self setupUI];
    [self showStatisWithTrackInfo:self.trackInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"TrackDetailViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"TrackDetailViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"TrackDetailViewController"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self pullData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_top.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _top.bounds;
    maskLayer.path = maskPath.CGPath;
    _top.layer.mask = maskLayer;
    _top.layer.masksToBounds = YES;
    
    self.mapView.logoCenter = CGPointMake(35, 299 * HeightCoefficient);
}

- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pullData {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    NSDictionary *paras = @{
                            @"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"],
//                            @"vin":@"VFNCA5GRMFW000000",
                            @"tripId":self.trackInfo.properties.tripId,
                            @"pageNo":@"1",
                            @"pageSize":@"50000"
                            };
    [CUHTTPRequest POST:getTrackDetailURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            TrackDetailResponse *response = [TrackDetailResponse yy_modelWithJSON:dic];
            self.coordinates = response.data.record;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTrackWithCoordinates:self.coordinates];
            });
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)showStatisWithTrackInfo:(TrackInfo *)trackInfo {
    self.harshBrakeLabel.text = trackInfo.properties.harshDecelerationTimes;
    self.harshAccLabel.text = trackInfo.properties.harshAccelerationTimes;
    self.harshTurnLabel.text = trackInfo.properties.harshTurnTimes;
    self.autoBrakeLabel.text = trackInfo.properties.autoBrakeTimes;
    self.startAddressLabel.text = trackInfo.geometry.afterCoordinates[0].address;
    self.endAddressLabel.text = trackInfo.geometry.afterCoordinates[1].address;
    self.startTimeLabel.text = trackInfo.properties.startTime;
    self.endTimeLabel.text = trackInfo.properties.endTime;
    self.mileageLabel.text = [NSString stringWithFormat:@"%@km",trackInfo.properties.mileage];
    self.durationLabel.text = trackInfo.properties.duration;
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@km/h",trackInfo.properties.averageSpeed];
    self.fuelConsumedLabel.text = [NSString stringWithFormat:@"%@L",trackInfo.properties.fuelConsumed];
}

- (void)createGradientBg {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.9,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)createMapView {
    self.mapView = [[MAMapView alloc] init];
    _mapView.userInteractionEnabled = NO;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [_mapView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(320 * HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    self.mapView.showsUserLocation = false;
    self.mapView.showsIndoorMap = false;
    self.mapView.showTraffic = false;
    self.mapView.showsScale = false;
    self.mapView.showsCompass = false;
}

- (void)setupUI {
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    self.top = topV;
    [self.view addSubview:topV];
    [topV makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(80 * HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.top.equalTo(self.mapView.bottom).offset(-10 * HeightCoefficient);
        make.centerX.equalTo(self.view);
    }];
    
    NSArray *topTitles = @[NSLocalizedString(@"急刹车", nil),NSLocalizedString(@"急加速", nil),NSLocalizedString(@"急转弯", nil),NSLocalizedString(@"自动刹车", nil)];
    for (NSInteger i = 0; i < topTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:13];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.textAlignment = NSTextAlignmentCenter;
        label0.text = topTitles[i];
        [topV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(78.25 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.top.equalTo(20 * HeightCoefficient);
            make.left.equalTo((16 + 88.5 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"-";
        [topV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(27.5 * WidthCoefficient);
            make.height.equalTo(25 * HeightCoefficient);
            make.top.equalTo(label0.bottom).offset(5 * HeightCoefficient);
            make.centerX.equalTo(label0);
        }];
        if (i == 0) {
            self.harshBrakeLabel = label1;
        } else if (i == 1) {
            self.harshAccLabel = label1;
        } else if (i == 2) {
            self.harshTurnLabel = label1;
        } else if (i == 3) {
            self.autoBrakeLabel = label1;
        }
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line"]];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.top.equalTo(topV.bottom);
        make.centerX.equalTo(self.view);
    }];
    
    UIView *midV = [[UIView alloc] init];
    [self.view addSubview:midV];
    [midV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(100 * HeightCoefficient);
        make.top.equalTo(line.bottom);
        make.centerX.equalTo(self.view);
    }];
    
    NSArray *midTitles = @[NSLocalizedString(@"起点:", nil),NSLocalizedString(@"终点:", nil)];
    for (NSInteger i = 0; i < midTitles.count; i++) {
        UIView *dot = [[UIView alloc] init];
        if (i == 0) {
            dot.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
        } else {
            dot.backgroundColor = [UIColor colorWithHexString:@"ac0042"];
        }
        dot.layer.cornerRadius = 3 * WidthCoefficient;
        [midV addSubview:dot];
        [dot makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(6 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.top.equalTo((17 + 50 * i) * HeightCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.textAlignment = NSTextAlignmentLeft;
        label0.text = midTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(35 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(dot.right).offset(5 * WidthCoefficient);
            make.centerY.equalTo(dot);
        }];
        
        YYLabel *label1 = [[YYLabel alloc] init];
        label1.textVerticalAlignment = YYTextVerticalAlignmentTop;
        label1.textContainerInset = UIEdgeInsetsMake(2 * WidthCoefficient, 0, 2 * WidthCoefficient, 0);
        label1.numberOfLines = 2;
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        label1.textAlignment = NSTextAlignmentLeft;
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(222 * WidthCoefficient);
            make.height.equalTo(40 * HeightCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"12:35:35";
        label2.font = [UIFont fontWithName:FontName size:14];
        label2.adjustsFontSizeToFitWidth = YES;
        label2.textColor = [UIColor colorWithHexString:@"#999999"];
        label2.textAlignment = NSTextAlignmentRight;
        [midV addSubview:label2];
        [label2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.right.equalTo(-16 * WidthCoefficient);
            make.top.equalTo(label1);
        }];
        
        if (i == 0) {
            self.startAddressLabel = label1;
            self.startTimeLabel = label2;
        } else if (i == 1) {
            self.endAddressLabel = label1;
            self.endTimeLabel = label2;
        }
    }
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midV.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(165 * HeightCoefficient);
    }];
    
    UIView *content = [[UIView alloc] init];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.height.equalTo(scroll);
    }];
    
    UIView *lastV;
    
    NSArray *botImgNames = @[@"里程_icon",@"时间_icon",@"速度_icon",@"油耗_icon"];
    NSArray *botTitles = @[NSLocalizedString(@"单次里程", nil),NSLocalizedString(@"所用时间", nil),NSLocalizedString(@"平均速度", nil),NSLocalizedString(@"单次油耗", nil)];
    for (NSInteger i = 0; i < botImgNames.count; i++) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        v.layer.cornerRadius = 4;
        v.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        v.layer.shadowOffset = CGSizeMake(0, 6);
        v.layer.shadowRadius = 7;
        v.layer.shadowOpacity = 0.5;
        [content addSubview:v];
        [v makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(130 * WidthCoefficient);
            make.height.equalTo(125 * HeightCoefficient);
            make.top.equalTo(content).offset(20 * HeightCoefficient);
            if (i == 0) {
                make.left.equalTo(16 * WidthCoefficient);
            } else {
                make.left.equalTo(lastV.right).offset(10 * WidthCoefficient);
            }
        }];
        lastV = v;
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:botImgNames[i]];
        [v addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo(10 * WidthCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        label0.adjustsFontSizeToFitWidth = YES;
        label0.textColor = [UIColor whiteColor];
        label0.text = @"-";
        [v addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(90 * WidthCoefficient);
            make.height.equalTo(25 * HeightCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo(imgV.bottom).offset(10 * HeightCoefficient);
        }];
        
        UIView *botLine = [[UIView alloc] init];
        botLine.backgroundColor = [UIColor colorWithHexString:@"#979797"];
        [v addSubview:botLine];
        [botLine makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(30 * WidthCoefficient);
            make.height.equalTo(1 * HeightCoefficient);
            make.top.equalTo(label0.bottom).offset(10 * HeightCoefficient);
            make.left.equalTo(label0);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor colorWithHexString:@"#999999"];
        label1.text = botTitles[i];
        [v addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(label0);
            make.height.equalTo(20 * HeightCoefficient);
            make.top.equalTo(botLine.bottom).offset(10 * HeightCoefficient);
        }];
        
        if (i == 0) {
            self.mileageLabel = label0;
        } else if (i == 1) {
            self.durationLabel = label0;
        } else if (i == 2) {
            self.averageSpeedLabel = label0;
        } else if (i == 3) {
            self.fuelConsumedLabel = label0;
        }
    }
    [lastV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content).offset(-16 * WidthCoefficient);
    }];
}

- (void)showTrackWithCoordinates:(NSArray<TrackDetailRecordItem *> *)coordinates {
    //构造折线数据对象
    
    CLLocationCoordinate2D commonPolylineCoords[coordinates.count];

    for (NSInteger i = 0; i < coordinates.count; i++) {
        TrackDetailRecordItem *item = coordinates[i];
        commonPolylineCoords[i].latitude = item.lat;
        commonPolylineCoords[i].longitude = item.lon;

//        if (i == 0) {
//            self.startAnnotation.coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[i].latitude, commonPolylineCoords[i].longitude);
//
//        }
//        if (i == coordinates.count - 1) {
//            self.endAnnotation.coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[i].latitude, commonPolylineCoords[i].longitude);
//        }
    }

    self.startAnnotation.coordinate = CLLocationCoordinate2DMake(_trackInfo.geometry.afterCoordinates[0].lat, _trackInfo.geometry.afterCoordinates[0].lon);

    self.endAnnotation.coordinate = CLLocationCoordinate2DMake(_trackInfo.geometry.afterCoordinates.lastObject.lat, _trackInfo.geometry.afterCoordinates.lastObject.lon);
    
//    CLLocationCoordinate2D commonPolylineCoords[10];
//    commonPolylineCoords[0].latitude = 30.621480;
//    commonPolylineCoords[0].longitude = 114.234748;
//
//    commonPolylineCoords[1].latitude = 30.621362;
//    commonPolylineCoords[1].longitude = 114.234810;
//
//    commonPolylineCoords[2].latitude = 30.621362;
//    commonPolylineCoords[2].longitude = 114.234810;
//
//    commonPolylineCoords[3].latitude = 30.621324;
//    commonPolylineCoords[3].longitude = 114.234703;
//
//    commonPolylineCoords[4].latitude = 30.621271;
//    commonPolylineCoords[4].longitude = 114.234725;
//
//    commonPolylineCoords[5].latitude = 30.621576;
//    commonPolylineCoords[5].longitude = 114.235626;
//
//    commonPolylineCoords[6].latitude = 30.621645;
//    commonPolylineCoords[6].longitude = 114.235840;
//
//    commonPolylineCoords[7].latitude = 30.622088;
//    commonPolylineCoords[7].longitude = 114.237129;
//
//    commonPolylineCoords[8].latitude = 30.622250;
//    commonPolylineCoords[8].longitude = 114.237602;
//
//    commonPolylineCoords[9].latitude = 30.622305;
//    commonPolylineCoords[9].longitude = 114.237595;
    
    
    
//    NSMutableArray<MAPointAnnotation *> *arr = [NSMutableArray array];
//    for (NSInteger i = 0; i < 10; i++) {
//        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
//        annotation.coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[i].latitude, commonPolylineCoords[i].longitude);
//        [arr addObject:annotation];
//    }
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:coordinates.count];
    
    //在地图上添加折线对象
    [_mapView addOverlay:commonPolyline];
    
    [_mapView addAnnotations:@[_startAnnotation,_endAnnotation]];
    
    [self.mapView setVisibleMapRect:[MapUtility mapRectForOverlays:@[commonPolyline]] edgePadding:UIEdgeInsetsMake(100, 100, 100, 100) animated:NO];
//    [_mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
    
}

#pragma mark - MAMapViewDelegate -

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 6.f;
        polylineRenderer.strokeColor  = [UIColor colorWithHexString:@"ac0042"];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *cellId = @"cellId";
        
        MAAnnotationView *pointAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:cellId];
        
        if (pointAnnotationView == nil) {
            pointAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cellId];
        }
        
        pointAnnotationView.canShowCallout = NO;
        if (annotation == self.startAnnotation) {
            pointAnnotationView.image = [UIImage imageNamed:@"track_start"];
        }
        if (annotation == self.endAnnotation) {
            pointAnnotationView.image = [UIImage imageNamed:@"track_end"];
        }
        pointAnnotationView.centerOffset = CGPointMake(0, -14);
        return pointAnnotationView;
    }
    return nil;
}

#pragma mark - lazy load -

- (MAPointAnnotation *)startAnnotation {
    if (!_startAnnotation) {
        _startAnnotation = [[MAPointAnnotation alloc] init];
    }
    return _startAnnotation;
}

- (MAPointAnnotation *)endAnnotation {
    if (!_endAnnotation) {
        _endAnnotation = [[MAPointAnnotation alloc] init];
    }
    return _endAnnotation;
}

@end

