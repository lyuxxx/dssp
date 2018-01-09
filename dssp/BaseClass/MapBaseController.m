//
//  MapBaseController.m
//  dssp
//
//  Created by yxliu on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapBaseController.h"
#import <CUAlertController.h>

@interface MapBaseController ()
@property (nonatomic, strong) UIButton *favoriteBtn;
@property (nonatomic, strong) UIButton *carLocationBtn;
@property (nonatomic, strong) UIButton *locationBtn;
@end

@implementation MapBaseController

static dispatch_once_t mapBaseOnceToken;

- (instancetype)initWithType:(PoiType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)checkPoiWithCpid:(NSString *)cpid inResult:(void (^)(BOOL,NSString *))result {
    [MBProgressHUD showMessage:@""];
    NSDictionary *paras = @{@"cpId":cpid,@"vin":kVin};
    [CUHTTPRequest POST:checkPOICollected parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            NSString *isFavorite = dic[@"data"][@"result"];
            if ([isFavorite isEqualToString:@"true"]) {
                NSString *serviceID = dic[@"data"][@"id"];
                if (![serviceID isEqualToString:@""]) {
                    [MBProgressHUD hideHUD];
                    result(YES,serviceID);
                    return;
                }
            }
            [MBProgressHUD hideHUD];
            result(NO,nil);
        } else {
            [MBProgressHUD hideHUD];
            result(NO,nil);
        }
    } failure:^(NSInteger code) {
        [MBProgressHUD hideHUD];
        result(NO,nil);
    }];
}

- (void)addPoiWithName:(NSString *)name address:(NSString *)address location:(CLLocationCoordinate2D)location tel:(NSString *)tel cpid:(NSString *)cpid type:(PoiType)type inResult:(void (^)(BOOL,NSString *))result {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    NSString *typeStr = @"";
    if (type == PoiTypeAmap) {
        typeStr = @"amap";
    }
    if (type == PoiTypeOil) {
        typeStr = @"oil";
    }
    if (type == PoiTypePark) {
        typeStr = @"park";
    }
    NSDictionary *paras = @{
                            @"vin":kVin,
                            @"poiName": name,
                            @"longitude": [NSString stringWithFormat:@"%f",location.longitude],
                            @"latitude": [NSString stringWithFormat:@"%f",location.latitude],
                            @"tel": tel,
                            @"address": address,
                            @"cpId": cpid,
                            @"poiType": typeStr
                            };
    [CUHTTPRequest POST:addPoiFavoritesService parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            NSString *msg = dic[@"msg"];
            if ([msg isEqualToString:@"SUCCESS"]) {
                NSString *serviceID = dic[@"data"][@"id"];
                [hud hideAnimated:YES];
                result(YES,serviceID);
            } else {
                [hud hideAnimated:YES];
                result(NO,nil);
            }
        } else {
            NSString *msg = dic[@"msg"];
            if (dic[@"data"][@"id"]) {
                msg = NSLocalizedString(@"该点已收藏!", nil);
                hud.label.text = msg;
                [hud hideAnimated:YES afterDelay:1];
                result(YES,dic[@"data"][@"id"]);
                return;
            }
            hud.label.text = msg;
            [hud hideAnimated:YES afterDelay:1];
            result(NO,nil);
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"请求失败:%ld",code];
        [hud hideAnimated:YES afterDelay:1];
        result(NO,nil);
    }];
}

- (void)deletePoisWithPoiIds:(NSArray<NSString *> *)ids inResult:(void (^)(BOOL))result {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    NSString *idStr = [ids componentsJoinedByString:@","];
    NSDictionary *paras = @{
                            @"id": idStr
                            };
    [CUHTTPRequest POST:deletePoiFavoritesService parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            result(YES);
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
            result(NO);
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"请求失败:%ld",code];
        [hud hideAnimated:YES afterDelay:1];
        result(NO);
    }];
}

- (void)sendPoiWithName:(NSString *)name address:(NSString *)address location:(CLLocationCoordinate2D)location inResult:(void (^)(BOOL))result {
    NSDictionary *paras = @{
                            @"routeType": @"0",
                            @"vin": kVin,
                            @"destinationPoiName": name,
                            @"address": address,
                            @"destinationLongitude": [NSString stringWithFormat:@"%f",location.longitude],
                            @"destinationLatitude": [NSString stringWithFormat:@"%f",location.latitude]
                            };
    [CUHTTPRequest POST:pushPoiService parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            result(YES);
        } else {
            result(NO);
        }
    } failure:^(NSInteger code) {
        result(NO);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.rt_disableInteractivePop = YES;
    
    self.favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favoriteBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_favoriteBtn setImage:[UIImage imageNamed:@"favoritesfolder"] forState:UIControlStateNormal];
    [self.view addSubview:_favoriteBtn];
    [_favoriteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(48 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(299 * HeightCoefficient + kStatusBarHeight);
    }];
    
    self.carLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_carLocationBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_carLocationBtn setImage:[UIImage imageNamed:@"location_car"] forState:UIControlStateNormal];
    [self.view addSubview:_carLocationBtn];
    [_carLocationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_favoriteBtn);
        make.top.equalTo(_favoriteBtn.bottom).offset(7.5 * HeightCoefficient);
    }];
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [_locationBtn setImage:[UIImage imageNamed:@"map_location"] forState:UIControlStateNormal];
    [self.view addSubview:_locationBtn];
    [_locationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(_carLocationBtn);
        make.top.equalTo(_carLocationBtn.bottom).offset(7.5 * HeightCoefficient);
    }];
    
}

- (void)showPoiSendAletWithSuccess:(BOOL)success {
    CUAlertController *alert = [CUAlertController alertWithImage:[UIImage imageNamed:@"car"] message:[NSString stringWithFormat:@"位置发送%@！",success? @"成功":@"失败"]];
    [alert addButtonWithTitle:NSLocalizedString(@"关闭", nil) type:CUButtonTypeNormal clicked:^{
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clear {
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.mapView.annotations];
    for (NSInteger i = 0; i < tmp.count; i++) {
        id<MAAnnotation> obj = tmp[i];
        if ([obj isKindOfClass:[MAUserLocation class]] || [obj isKindOfClass:[CarAnnotation class]]) {
            [tmp removeObject:obj];
            break;
        }
    }
    [self.mapView removeAnnotations:tmp];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (NSString *)distanceFromUsr:(CLLocationCoordinate2D)location {
    MAMapPoint userPoint = MAMapPointForCoordinate(self.mapView.userLocation.coordinate);
    MAMapPoint point = MAMapPointForCoordinate(location);
    CLLocationDistance distance = MAMetersBetweenMapPoints(userPoint, point);
    NSString *str = [NSString stringWithFormat:@"%.0fm",distance];
    if (distance >= 1000) {
        str = [NSString stringWithFormat:@"%.0fkm",distance/1000.0];
    }
    return str;
}

- (void)click:(UIButton *)sender {
    if (sender == _favoriteBtn) {//收藏夹按钮
        [self favoritesClick:sender];
    }
    if (sender == _locationBtn) {//定位按钮
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
    if (sender == _carLocationBtn) {//车定位按钮
        [self checkCarLocation];
    }
}

- (void)favoritesClick:(UIButton *)sender {
    
}

- (void)checkCarLocation {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:[NSString stringWithFormat:@"%@/%@",getLastPositionService,kVin] parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            CLLocationDegrees latitude = [dic[@"data"][@"position"][@"latitude"] doubleValue];
            CLLocationDegrees longitude = [dic[@"data"][@"position"][@"longitude"] doubleValue];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
            weakifySelf
            [[MapSearchManager sharedManager] reGeoInfo:location returnBlock:^(MapReGeoInfo *regeoInfo) {
                strongifySelf
                if (self.carAnnotation) {
                    [self.mapView removeAnnotation:self.carAnnotation];
                    self.carAnnotation = nil;
                }
                self.carAnnotation = [[CarAnnotation alloc] init];
                _carAnnotation.coordinate = location;
                _carAnnotation.title = NSLocalizedString(@"车辆位置", nil);
                _carAnnotation.subtitle = [regeoInfo.formattedAddress substringFromIndex:regeoInfo.province.length + regeoInfo.city.length + regeoInfo.district.length + regeoInfo.township.length];
                [self.mapView addAnnotation:_carAnnotation];
                [self.mapView setCenterCoordinate:location];
                [hud hideAnimated:YES];
            }];
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.checkCarLocationOver) {
                self.checkCarLocationOver();
            }
        });
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"请求失败:%ld",code];
        [hud hideAnimated:YES afterDelay:1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.checkCarLocationOver) {
                self.checkCarLocationOver();
            }
        });
    }];
}

- (CLLocationCoordinate2D)getCarLocation {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"carLocation"];
    return CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView = [MapView sharedMapView];
    [self.view addSubview:self.mapView];
    [self.view insertSubview:self.mapView atIndex:0];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    weakifySelf
    [MapSearchManager sharedManager].searchFailBlock = ^(NSError *error) {
        strongifySelf
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", nil) message:[NSString stringWithFormat:@"请检查网络，%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    };
    if ([self isKindOfClass:NSClassFromString(@"SearchAroundViewController")]) {
        return;
    }
    dispatch_once(&mapBaseOnceToken, ^{
        if (self.carAnnotation) {
            [self.mapView removeAnnotation:self.carAnnotation];
            self.carAnnotation = nil;
        }
        CLLocationCoordinate2D location = [self getCarLocation];
        self.carAnnotation = [[CarAnnotation alloc] init];
        _carAnnotation.coordinate = location;
        [self.mapView addAnnotation:_carAnnotation];
        if (self.checkCarLocationOver) {
            self.checkCarLocationOver();
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
}

- (void)dealloc {
    if ([self isKindOfClass:NSClassFromString(@"SearchAroundViewController")]) {
        return;
    }
    mapBaseOnceToken = 0l;
}

@end
