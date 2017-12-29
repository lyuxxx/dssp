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

@end

@implementation RefuelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackBtn];
    [self pullData];
}

- (void)setupBackBtn {
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
}

- (void)pullData {
    [CUHTTPRequest POST:queryNearbyGasCooperateAction parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        OilListResponse *response = [OilListResponse yy_modelWithDictionary:dic];
        self.stations = [NSMutableArray arrayWithArray:response.data.stations];
        [self layoutAnnotations];
    } failure:^(NSInteger code) {
        
    }];
}

- (void)layoutAnnotations {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.stations.count];
    for (OilStation *station in self.stations) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(station.coordinatey, station.coordinatex);
        annotation.title = station.name;
        annotation.subtitle = station.address;
        [arr addObject:annotation];
    }
    [self.mapView addAnnotations:arr];
    [self.mapView showAnnotations:arr edgePadding:UIEdgeInsetsMake(20 * WidthCoefficient, 20 * WidthCoefficient, 20 * WidthCoefficient, 20 * WidthCoefficient) animated:YES];
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
    self.currentStation = station;
    if (_infoView) {
        self.infoView = [[UIView alloc] init];
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
        [_infoFavoriteBtn.titleLabel setFont:[UIFont fontWithName:FontName size:12]];
        _infoFavoriteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [infoTop addSubview:_infoFavoriteBtn];
    }
    
    _nameLabel.text = station.name;
    
    _addressLabel.text = [NSString stringWithFormat:@"%ldkm 丨 %@",(long)station.distance,station.address];
    if (!station.address || [station.address isEqualToString:@""]) {
        _addressLabel.text = [NSString stringWithFormat:@"%ldkm",station.distance];
    }
    
    _infoFavoriteBtn.selected = YES;
}

- (void)hideInfo {
    if (self.infoView) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
    }
}

- (void)queryStationInfo:(OilStation *)station {
    [CUHTTPRequest POST:getStationDetailCooperateAction parameters:@{@"coordinatex":[NSString stringWithFormat:@"%f",station.coordinatex],@"coordinatey":[NSString stringWithFormat:@"%f",station.coordinatey],@"stationid":[NSString stringWithFormat:@"%ld",(long)station.stationid]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        StationDetailResponse *response = [StationDetailResponse yy_modelWithDictionary:dic];
        StationInfo *info = response.data.stationinfo;
        [self hideInfo];
        [self showDetailWithInfo:info];
    } failure:^(NSInteger code) {
        
    }];
}

- (void)showDetailWithInfo:(StationInfo *)info {
    [self createDataSourceWithInfo:info];
    if (_detailView) {
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
        [_detailTop addSubview:_detailFavoriteBtn];
        [_detailFavoriteBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_detailAddressLabel);
            make.top.equalTo(_detailAddressLabel.bottom).offset(10 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
            make.width.equalTo(57 * WidthCoefficient);
        }];
        
        self.detailSendBtn = [POISendBtn buttonWithType:UIButtonTypeCustom];
        _detailSendBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
        [_detailSendBtn setTitleColor:[UIColor colorWithHexString:@"#ac0042"] forState:UIControlStateNormal];
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
        [_shrinkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shrinkBtn.layer.cornerRadius = 1;
        [_shrinkBtn setTitle:NSLocalizedString(@"收起", nil) forState:UIControlStateNormal];
        _shrinkBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_shrinkBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
        [_detailView addSubview:_shrinkBtn];
        [_shrinkBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_detailView);
            make.height.equalTo(44 * WidthCoefficient);
        }];
    }
    _detailNameLabel.text = info.name;
    _detailAddressLabel.text = info.address;
    [self.tableView reloadData];
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
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"电话:%@",info.telephonenum] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
    }
    if (info.opentime) {
        [self.dataSource addObject:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"营业时间:%@",info.opentime] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}]];
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
        [self sendPOIWith:self.currentStation];
    }
}

- (void)sendPOIWith:(OilStation *)station {
    
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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
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
    if (self.currentAnnotaionView) {
        _currentAnnotaionView.image = [UIImage imageNamed:@"oilPin"];
        [self.mapView deselectAnnotation:_currentAnnotaionView.annotation animated:NO];
    }
    _currentAnnotaionView = view;
    view.image = [UIImage imageNamed:@"oilPin_selected"];
    [self showInfoWithStation:[self checkCorrespondingStation:view]];
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
