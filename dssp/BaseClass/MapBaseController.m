//
//  MapBaseController.m
//  dssp
//
//  Created by yxliu on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapBaseController.h"
#import "FavoritesViewController.h"

@interface MapBaseController ()
@property (nonatomic, strong) UIButton *favoriteBtn;
@property (nonatomic, strong) UIButton *carLocationBtn;
@property (nonatomic, strong) UIButton *locationBtn;
@end

@implementation MapBaseController

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

- (void)click:(UIButton *)sender {
    if (sender == _favoriteBtn) {//收藏夹按钮
        FavoritesViewController *vc = [[FavoritesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender == _locationBtn) {//定位按钮
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
    if (sender == _carLocationBtn) {//车定位按钮
        
    }
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
}

@end
