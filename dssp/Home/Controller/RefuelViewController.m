//
//  RefuelViewController.m
//  dssp
//
//  Created by yxliu on 2017/12/27.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RefuelViewController.h"
#import "LeftImgButton.h"
#import <MapSearchObject.h>
#import "OilStation.h"
#import <CUHTTPRequest.h>
#import <YYCategories.h>
#import "POISendBtn.h"
#import <CUAlertController.h>

@interface RefuelViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) LeftImgButton *infoFavoriteBtn;
@property (nonatomic, strong) POISendBtn *poiSendBtn;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *detailTop;
@property (nonatomic, strong) UILabel *detailNameLabel;
@property (nonatomic, strong) UILabel *detailAddressLabel;
@property (nonatomic, strong) LeftImgButton *detailFavoriteBtn;
@property (nonatomic, strong) POISendBtn *detailSendBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *shrinkBtn;

@property (nonatomic, strong) NSMutableArray<OilStation *> *stations;
@property (nonatomic, strong) MAAnnotationView *currentAnnotaionView;
@property (nonatomic, strong) OilStation *currentStation;
@property (nonatomic, strong) NSMutableArray<NSAttributedString *> *dataSource;

@property (nonatomic, strong) MAPointAnnotation *outerAnnotation;
@property (nonatomic, strong) OilStation *outerStation;

@end

@implementation RefuelViewController

static dispatch_once_t oilOnceToken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"RefuelViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"RefuelViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"RefuelViewController"];
}


- (void)dealloc {
    oilOnceToken = 0l;
}

- (void)favoritesClick:(UIButton *)sender {
    weakifySelf
    FavoritesViewController *vc = [[FavoritesViewController alloc] initWithType:self.type checkPoi:self.currentStation.serviceID block:^(BOOL isFavorite) {
        strongifySelf
        if (self.infoFavoriteBtn) {
            self.infoFavoriteBtn.selected = isFavorite;
        }
        if (self.detailFavoriteBtn) {
            self.detailFavoriteBtn.selected = isFavorite;
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupBackBtn {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"oil_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    
    weakifySelf
    self.favoriteCallBack = ^(ResultItem *item) {//收藏夹选择后回调
        strongifySelf
        for (NSInteger i = 0; i < self.mapView.annotations.count; i++) {
            MAPointAnnotation *annotation = self.mapView.annotations[i];
            if (annotation.coordinate.longitude == item.longitude.doubleValue && annotation.coordinate.latitude == item.latitude.doubleValue) {
                ///移除之前的数据与点标注
                if (self.outerStation) {
                    [self.stations removeObject:self.outerStation];
                    self.outerStation = nil;
                }
                if (self.outerAnnotation) {
                    [self.mapView removeAnnotation:self.outerAnnotation];
                    self.outerAnnotation = nil;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView deselectAnnotation:annotation animated:NO];
                    [self.mapView selectAnnotation:annotation animated:YES];
                });
                return;
            }
        }
        ///点不在范围内且不在数据源内
        
        ///移除之前的数据与点标注
        if (self.outerStation) {
            [self.stations removeObject:self.outerStation];
            self.outerStation = nil;
        }
        if (self.outerAnnotation) {
            [self.mapView removeAnnotation:self.outerAnnotation];
            self.outerAnnotation = nil;
        }
        
        ///添加新的数据与点标注
        self.outerStation = [[OilStation alloc] init];
        self.outerStation.serviceID = item.poiId;
        self.outerStation.stationid = item.cpId.integerValue;
        self.outerStation.address = item.address;
        self.outerStation.name = item.poiName;
        self.outerStation.coordinatex = item.longitude.doubleValue;
        self.outerStation.coordinatey = item.latitude.doubleValue;
        [self.stations addObject:self.outerStation];
        
        self.outerAnnotation = [[MAPointAnnotation alloc] init];
        self.outerAnnotation.title = item.poiName;
        self.outerAnnotation.subtitle = item.address;
        self.outerAnnotation.coordinate = CLLocationCoordinate2DMake(item.latitude.doubleValue, item.longitude.doubleValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:self.outerAnnotation];
            [self.mapView setCenterCoordinate:self.outerAnnotation.coordinate animated:YES];
            [self.mapView selectAnnotation:self.outerAnnotation animated:YES];
        });
    };
    
    self.checkCarLocationOver = ^{
        dispatch_once(&oilOnceToken, ^{
            strongifySelf
            [self pullData];
        });
    };
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
    [MapView destroy];
    [MapSearchManager destroyManager];
}

- (void)pullData {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    CLLocationDegrees longitude;
    CLLocationDegrees latitude;
    if (self.carAnnotation) {
        longitude = self.carAnnotation.coordinate.longitude;
        latitude = self.carAnnotation.coordinate.latitude;
    } else {
        longitude = self.mapView.userLocation.coordinate.longitude;
        latitude = self.mapView.userLocation.coordinate.latitude;
    }
    [CUHTTPRequest POST:queryNearbyGasCooperateAction parameters:@{@"coordinatex": [NSString stringWithFormat:@"%f",longitude],@"coordinatey": [NSString stringWithFormat:@"%f",latitude],@"distancebig":[NSNumber numberWithInteger:10]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            OilListResponse *response = [OilListResponse yy_modelWithDictionary:dic];
            self.stations = [NSMutableArray arrayWithArray:response.data.stations];
            if (self.stations.count) {
                [self layoutAnnotations];
                [hud hideAnimated:YES];
            } else {
                [hud hideAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showText:@"附近未找到加油站"];
                });
            }
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)layoutAnnotations {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.stations.count + 2];
    for (OilStation *station in self.stations) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(station.coordinatey, station.coordinatex);
        annotation.title = station.name;
        annotation.subtitle = station.address;
        [arr addObject:annotation];
    }
    if (self.mapView.userLocation) {
       [arr addObject:self.mapView.userLocation];
    }
    [self.mapView addAnnotations:arr];
    [self.mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(50 * WidthCoefficient, 50 * WidthCoefficient, 50 * WidthCoefficient, 50 * WidthCoefficient) animated:YES];
}

- (OilStation *)checkCorrespondingStation:(MAAnnotationView *)view {
    for (OilStation *station in self.stations) {
        if (station.coordinatex == view.annotation.coordinate.longitude && station.coordinatey == view.annotation.coordinate.latitude) {
            return station;
        }
    }
    return nil;
}

- (void)showInfoWithStation:(OilStation *)station {
    [self hideDetail];
    self.currentStation = station;
    [self checkPoiWithCpid:[NSString stringWithFormat:@"%ld",station.stationid] inResult:^(BOOL isFavorite, NSString *serviceId) {
        if (isFavorite) {
            station.serviceID = serviceId;
        }
        if (!_infoView) {
            self.infoView = [[UIView alloc] init];
            [self.view addSubview:self.infoView];
            [_infoView makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(360 * WidthCoefficient);
                make.height.equalTo(130 * WidthCoefficient);
                make.centerX.equalTo(0);
                make.bottom.equalTo(- 40 * HeightCoefficient - kBottomHeight);
            }];
            
            UIView *infoTop = [[UIView alloc] init];
            infoTop.backgroundColor = [UIColor whiteColor];
            infoTop.layer.cornerRadius = 1;
            infoTop.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
            infoTop.layer.shadowOffset = CGSizeMake(0, 5);
            infoTop.layer.shadowOpacity = 0.5;
            infoTop.layer.shadowRadius = 15;
            [_infoView addSubview:infoTop];
            [infoTop makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_infoView);
                make.height.equalTo(100 * WidthCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(30 * WidthCoefficient);
            }];
            
            self.nameLabel = [[UILabel alloc] init];
            _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            _nameLabel.textColor = [UIColor colorWithHexString:@"#040000"];
            [infoTop addSubview:_nameLabel];
            [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.height.equalTo(22 * WidthCoefficient);
                make.width.equalTo(165 * WidthCoefficient);
            }];
            
            self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.detailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_detailBtn setTitle:NSLocalizedString(@"详细", nil) forState:UIControlStateNormal];
            _detailBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
            [_detailBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
            [infoTop addSubview:_detailBtn];
            [_detailBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(35 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.centerY.equalTo(_nameLabel);
                make.left.equalTo(_nameLabel.right).offset(10 * WidthCoefficient);
            }];
            
            self.addressLabel = [[UILabel alloc] init];
            _addressLabel.font = [UIFont fontWithName:FontName size:13];
            _addressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            [infoTop addSubview:_addressLabel];
            [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel);
                make.top.equalTo(_nameLabel.bottom).offset(5 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.width.equalTo(infoTop).offset(-20 * WidthCoefficient);
            }];
            
            self.poiSendBtn = [POISendBtn buttonWithType:UIButtonTypeCustom];
            [_poiSendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_poiSendBtn setBackgroundImage:[UIImage imageNamed:@"Group 4"] forState:UIControlStateNormal];
            [_infoView addSubview:_poiSendBtn];
            [_poiSendBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(60 * WidthCoefficient);
                make.top.equalTo(0);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            self.infoFavoriteBtn = [LeftImgButton buttonWithType:UIButtonTypeCustom];
            [_infoFavoriteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_infoFavoriteBtn setTitle:NSLocalizedString(@"收藏", nil) forState:UIControlStateNormal];
            [_infoFavoriteBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [_infoFavoriteBtn setImage:[UIImage imageNamed:@"收藏 4"] forState:UIControlStateNormal];
            [_infoFavoriteBtn setTitle:NSLocalizedString(@"已收藏", nil) forState:UIControlStateSelected];
            [_infoFavoriteBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
            [_infoFavoriteBtn.titleLabel setFont:[UIFont fontWithName:FontName size:13]];
            _infoFavoriteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [infoTop addSubview:_infoFavoriteBtn];
            [_infoFavoriteBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_addressLabel);
                make.top.equalTo(_addressLabel.bottom).offset(10 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.width.equalTo(70 * WidthCoefficient);
            }];
        }
        
        _nameLabel.text = station.name;
        
        _addressLabel.text = [NSString stringWithFormat:@"%@ 丨 %@",[self distanceFromUsr:CLLocationCoordinate2DMake(station.coordinatey, station.coordinatex)],station.address];
        if (!station.address || [station.address isEqualToString:@""]) {
            _addressLabel.text = [self distanceFromUsr:CLLocationCoordinate2DMake(station.coordinatey, station.coordinatex)];
        }
        
        _infoFavoriteBtn.selected = isFavorite;
    }];
    
}

- (void)hideInfo {
    if (self.infoView) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
    }
}

- (void)queryStationInfo:(OilStation *)station {
    [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:getStationDetailCooperateAction parameters:@{@"coordinatex":[NSString stringWithFormat:@"%f",station.coordinatex],@"coordinatey":[NSString stringWithFormat:@"%f",station.coordinatey],@"stationid":[NSString stringWithFormat:@"%ld",(long)station.stationid]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            [MBProgressHUD hideHUD];
            StationDetailResponse *response = [StationDetailResponse yy_modelWithDictionary:dic];
            StationInfo *info = response.data.stationinfo;
            [self updateDataSourceWithDetailStationInfo:info];
            [self hideInfo];
            [self showDetailWithInfo:info];
        } else {
            [MBProgressHUD hideHUD];
        }
    } failure:^(NSInteger code) {
        [MBProgressHUD hideHUD];
    }];
}

///获取到油站详情后更新数据源的油站信息,更新telephonenum字段,用于下发poi
- (void)updateDataSourceWithDetailStationInfo:(StationInfo *)info {
    for (OilStation *station in self.stations) {
        if (station.stationid == info.stationid) {
            station.telephonenum = info.telephonenum;
            if (self.currentStation.stationid == station.stationid) {
                self.currentStation.telephonenum = info.telephonenum;
            }
            break;
        }
    }
}

- (void)showDetailWithInfo:(StationInfo *)info {
    [self createDataSourceWithInfo:info];
    [self checkPoiWithCpid:[NSString stringWithFormat:@"%ld",info.stationid] inResult:^(BOOL isFavorite, NSString *serviceId) {
        if (isFavorite) {
            self.currentStation.serviceID = serviceId;
        }
        if (!_detailView) {
            NSInteger tableHeight = [self getTableHeightWithInfo:info];
            NSInteger viewHeight = 100 * WidthCoefficient + tableHeight + 54 * WidthCoefficient;
            self.detailView = [[UIView alloc] init];
            [self.view addSubview:self.detailView];
            [_detailView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(8 * WidthCoefficient);
                make.right.equalTo(-8 * WidthCoefficient);
                make.height.equalTo(viewHeight);
                make.bottom.equalTo(- 40 * WidthCoefficient - kBottomHeight);
            }];
            
            self.detailTop = [[UIView alloc] init];
            _detailTop.backgroundColor = [UIColor whiteColor];
            _detailTop.layer.cornerRadius = 1;
            _detailTop.layer.shadowOffset = CGSizeMake(0, 5);
            _detailTop.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
            _detailTop.layer.shadowRadius = 15;
            _detailTop.layer.shadowOpacity = 0.5;
            [_detailView addSubview:_detailTop];
            [_detailTop makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_detailView);
                make.height.equalTo(100 * WidthCoefficient + tableHeight);
                make.centerX.equalTo(0);
                make.top.equalTo(_detailView);
            }];
            
            self.detailNameLabel = [[UILabel alloc] init];
            _detailNameLabel.textColor = [UIColor colorWithHexString:@"#040000"];
            _detailNameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            [_detailTop addSubview:_detailNameLabel];
            [_detailNameLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.height.equalTo(22 * WidthCoefficient);
                make.width.equalTo(_detailTop).offset(-80 * WidthCoefficient);
            }];
            
            self.detailAddressLabel = [[UILabel alloc] init];
            _detailAddressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            _detailAddressLabel.font = [UIFont fontWithName:FontName size:13];
            [_detailTop addSubview:_detailAddressLabel];
            [_detailAddressLabel makeConstraints:^(MASConstraintMaker *make) {
                make.left.width.equalTo(_detailNameLabel);
                make.top.equalTo(_detailNameLabel.bottom).offset(5 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
            }];
            
            self.detailFavoriteBtn = [LeftImgButton buttonWithType:UIButtonTypeCustom];
            [_detailFavoriteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_detailFavoriteBtn setTitle:NSLocalizedString(@"收藏", nil) forState:UIControlStateNormal];
            [_detailFavoriteBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [_detailFavoriteBtn setImage:[UIImage imageNamed:@"收藏 4"] forState:UIControlStateNormal];
            [_detailFavoriteBtn setTitle:NSLocalizedString(@"已收藏", nil) forState:UIControlStateSelected];
            [_detailFavoriteBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
            [_detailFavoriteBtn.titleLabel setFont:[UIFont fontWithName:FontName size:13]];
            _detailFavoriteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_detailTop addSubview:_detailFavoriteBtn];
            [_detailFavoriteBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_detailAddressLabel);
                make.top.equalTo(_detailAddressLabel.bottom).offset(10 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.width.equalTo(70 * WidthCoefficient);
            }];
            
            self.detailSendBtn = [POISendBtn buttonWithType:UIButtonTypeCustom];
            [_detailSendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_detailSendBtn setBackgroundImage:[UIImage imageNamed:@"Group 4"] forState:UIControlStateNormal];
            [_detailTop addSubview:_detailSendBtn];
            [_detailSendBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(60 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.right.equalTo(-10 * WidthCoefficient);
            }];
            
            self.tableView = [[UITableView alloc] init];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            if (@available(iOS 11.0, *)) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            [_detailTop addSubview:_tableView];
            [_tableView makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(_detailTop);
                make.height.equalTo(tableHeight);
            }];
            
            self.shrinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.shrinkBtn setBackgroundColor:[UIColor whiteColor]];
            [_shrinkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            _shrinkBtn.layer.cornerRadius = 1;
            [_shrinkBtn setTitle:NSLocalizedString(@"收起", nil) forState:UIControlStateNormal];
            _shrinkBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            [_shrinkBtn setTitleColor:[UIColor colorWithHexString:@"040000"] forState:UIControlStateNormal];
            [_detailView addSubview:_shrinkBtn];
            [_shrinkBtn makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(_detailView);
                make.height.equalTo(44 * WidthCoefficient);
            }];
        }
        _detailNameLabel.text = info.name;
        _detailAddressLabel.text = info.address;
        _detailFavoriteBtn.selected = isFavorite;
        [self.tableView reloadData];
    }];
}

- (void)hideDetail {
    if (self.detailView) {
        [self.detailView removeFromSuperview];
        self.detailView = nil;
    }
}

- (NSInteger)getTableHeightWithInfo:(StationInfo *)info {
    NSInteger totalHeight = 0;
    NSInteger rowHeight = 44 * WidthCoefficient;
    totalHeight += rowHeight * info.pricelist.count;
    
    //洗车
    totalHeight += rowHeight;
    //电话
    if (info.telephonenum) {
        totalHeight += rowHeight;
    }
    //营业时间
    if (info.opentime) {
        totalHeight += rowHeight;
    }
    //备注
    if (info.noticemsg) {
        totalHeight += rowHeight;
    }
    
    if (totalHeight > rowHeight * 7) {
        totalHeight = 7 * rowHeight;
    }
    
    return totalHeight;
}

- (void)createDataSourceWithInfo:(StationInfo *)info {
    [self.dataSource removeAllObjects];
    if (info.carwashing) {
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:@"支持洗车" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
    } else {
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:@"不支持洗车" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
    }
    if (info.telephonenum) {
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"电话: %@",info.telephonenum] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
    }
    if (info.opentime) {
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"营业时间: %@",info.opentime] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
    }
    if (info.noticemsg) {
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"注意事项:%@",info.noticemsg] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
    }
    for (NSInteger i = 0; i < info.pricelist.count; i++) {
        GasPrice *price = info.pricelist[i];
        NSString *oriStr = [NSString stringWithFormat:@"%@价格: ￥%ld/L 优惠: ￥%ld",price.gasno,(long)price.price,(long)price.cheap];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oriStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        NSRange range0 = [oriStr rangeOfString:[NSString stringWithFormat:@"￥%ld/L",price.price]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ac0042"] range:range0];
        NSRange range1 = [oriStr rangeOfString:[NSString stringWithFormat:@"优惠: ￥%ld",price.cheap]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:range1];
        [self.dataSource addObject:str];
    }
}

- (void)btnClick:(UIButton *)sender {
    if (sender == self.detailBtn) {
        [self queryStationInfo:self.currentStation];
    }
    if (sender == self.shrinkBtn) {
        [self hideDetail];
        [self showInfoWithStation:self.currentStation];
    }
    if (sender == self.poiSendBtn || sender == self.detailSendBtn) {
        if ([KuserName isEqualToString:@"18911568274"]) {
            [MBProgressHUD showText:@"当前为游客模式，无此操作权限"];
            return;
        }
        NSString *name = self.currentStation.name;
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"是否确定将\"%@\"位置发送到车",name] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
        NSRange range = [[NSString stringWithFormat:@"是否确定将\"%@\"位置发送到车",name] rangeOfString:name];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:172.0/255.0 green:0 blue:66.0/255.0 alpha:1] range:range];
        CUAlertController *alert = [CUAlertController alertWithImage:[UIImage imageNamed:@"mobile-phone-2"] attributedMessage:message];
        [alert addButtonWithTitle:@"取消" type:CUButtonTypeCancel clicked:^{
            
        }];
        [alert addButtonWithTitle:@"发送" type:CUButtonTypeNormal clicked:^{
//            [SendPoiProgressView showWithCancelBlock:^{
//                [self cancelSendPoi];
//            }];
            __block MBProgressHUD *hud;
            dispatch_async(dispatch_get_main_queue(), ^{
                hud = [MBProgressHUD showMessage:@""];
            });
            [self sendPoiWithName:self.currentStation.name address:self.currentStation.address location:CLLocationCoordinate2DMake(self.currentStation.coordinatey, self.currentStation.coordinatex) tel:self.currentStation.telephonenum inResult:^(SendPoiResult result) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SendPoiProgressView dismiss];
                    [hud hideAnimated:YES];
                    [self showPoiSendAletWithResult:result];
                });
            }];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (sender == _infoFavoriteBtn || sender == _detailFavoriteBtn) {
        if (sender.selected) {
            [self deletePoisWithPoiIds:@[self.currentStation.serviceID] inResult:^(BOOL result) {
                if (result) {
                    sender.selected = NO;
                }
            }];
        } else {
            weakifySelf
            [self addPoiWithName:self.currentStation.name address:self.currentStation.address location:CLLocationCoordinate2DMake(self.currentStation.coordinatey, self.currentStation.coordinatex) tel:@"" cpid:[NSString stringWithFormat:@"%ld",self.currentStation.stationid] type:PoiTypeOil inResult:^(BOOL result, NSString *serviceId) {
                if (result) {
                    strongifySelf
                    self.currentStation.serviceID = serviceId;
                    sender.selected = YES;
                }
            }];
        }
    }
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"priceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.font = [UIFont fontWithName:FontName size:15];
    cell.textLabel.attributedText = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 * WidthCoefficient;
}

#pragma mark - MAMapViewDelegate -
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        view.canShowCallout = NO;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[CarAnnotation class]]) {
        static NSString *carId = @"carId";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:carId];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:carId];
        }
        annotationView.image = [UIImage imageNamed:@"car_location"];
        //        annotationView.centerOffset = CGPointMake(0, -18);
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *tipId = @"tipId";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:tipId];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipId];
        }
        annotationView.image = [UIImage imageNamed:@"oilPin"];
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:NSClassFromString(@"MAUserLocationView")]) {
        return;
    }
    if ([view.annotation isKindOfClass:[CarAnnotation class]]) {
        return;
    }
    if (self.currentAnnotaionView) {
        _currentAnnotaionView.image = [UIImage imageNamed:@"oilPin"];
        [self.mapView deselectAnnotation:_currentAnnotaionView.annotation animated:NO];
    }
    _currentAnnotaionView = view;
    view.image = [UIImage imageNamed:@"oilPin_selected"];
    self.currentStation = [self checkCorrespondingStation:view];
    [self showInfoWithStation:self.currentStation];
}

#pragma mark - lazy load

- (NSMutableArray<OilStation *> *)stations {
    if (!_stations) {
        _stations = [[NSMutableArray alloc] init];
    }
    return _stations;
}

- (NSMutableArray<NSAttributedString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
