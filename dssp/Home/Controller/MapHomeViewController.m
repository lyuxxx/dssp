//
//  MapHomeViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapHomeViewController.h"
#import <MapManager/MapSearchManager.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LocationAnnotationView.h"
#import <YYCategoriesSub/YYCategories.h>
#import "MapSearchCell.h"
#import "LeftImgButton.h"
#import <MapManager/MapSearchManager.h>
#import "MapSearchHistory.h"
#import "POISendBtn.h"
#import <CUAlertController.h>
#import "SearchAroundViewController.h"

@interface MapHomeViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LocationAnnotationView *locationAnnotationView;

@property (nonatomic, strong) UIView *shade;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITextField *tmpField;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *topBackBtn;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *resultTable;
@property (nonatomic, strong) UIView *tableHeader;

@property (nonatomic, strong) UITextField *showField;
@property (nonatomic, strong) UIButton *showBackBtn;
@property (nonatomic, strong) UIButton *showClearBtn;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) LeftImgButton *infoFavoriteBtn;
@property (nonatomic, strong) LeftImgButton *infoAroundBtn;
@property (nonatomic, strong) LeftImgButton *infoFenceBtn;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) NSMutableArray<MapSearchObject *> *annotations;

@property (nonatomic, strong) UIView *tableFooter;
@property (nonatomic, strong) UIButton *clearHistoryBtn;

@property (nonatomic, strong) MapSearchObject *currentAnnotationInfo;

@end

@implementation MapHomeViewController

- (void)backToHome {
    [self hideInfoView];
    _tmpField.hidden = NO;
    [self clear];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self getHistory];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MapSearchManager sharedManager].searchFailBlock = ^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"", nil) message:[NSString stringWithFormat:@"请检查网络，%@",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
    };
}

- (void)setupUI {
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tmpField = [[UITextField alloc] init];
    _tmpField.leftView = _backBtn;
    _tmpField.leftViewMode = UITextFieldViewModeAlways;
    
    [_backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(53 * WidthCoefficient);
        make.height.equalTo(23 * WidthCoefficient);
    }];
    
    _tmpField.delegate = self;
    _tmpField.backgroundColor = [UIColor whiteColor];
    _tmpField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"你想要去哪儿?", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
    _tmpField.layer.cornerRadius = 2;
    _tmpField.layer.shadowOffset = CGSizeMake(0, 5);
    _tmpField.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    _tmpField.layer.shadowRadius = 15;
    _tmpField.layer.shadowOpacity = 0.5;
    [self.view addSubview:_tmpField];
    [_tmpField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(360 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
    }];
    
}

- (void)getHistory {
    NSLog(@"getAllHistory");
    self.annotations = [MapSearchHistory selectAllHistoryWithTimeStampDesc];
    if (self.annotations.count > 0) {
        self.resultTable.tableFooterView = self.tableFooter;
    } else {
        self.resultTable.tableFooterView = [UIView new];
    }
    [self.resultTable reloadData];
    [self.resultTable scrollToTopAnimated:NO];
}

- (void)initSearchView {
    if (!_topBar) {
        [self.view addSubview:self.topBar];
        [_topBar makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(359 * WidthCoefficient);
            make.height.equalTo(44 * HeightCoefficient);
//            make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            make.top.equalTo(self.view).offset(-50 * HeightCoefficient);
            make.left.equalTo(8 * WidthCoefficient);
        }];
        
        self.topBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topBackBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        self.clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_clearBtn setImage:[UIImage imageNamed:@"delete text"] forState:UIControlStateNormal];
        
        self.searchField = [[UITextField alloc] init];
        [_searchField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        _searchField.delegate = self;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        _searchField.textColor = [UIColor colorWithHexString:@"#040000"];
        _searchField.font = [UIFont fontWithName:FontName size:16];
        [_topBar addSubview:_searchField];
        [_searchField makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(286 * WidthCoefficient);
            make.height.equalTo(_topBar);
            make.left.top.equalTo(_topBar);
        }];
        
        _searchField.leftView = self.topBackBtn;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        [_topBackBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(53 * WidthCoefficient);
            make.height.equalTo(23 * WidthCoefficient);
        }];
        
        _searchField.rightView = self.clearBtn;
        _searchField.rightViewMode = UITextFieldViewModeAlways;
        [_clearBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(36 * WidthCoefficient);
            make.height.equalTo(36 * WidthCoefficient);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [_topBar addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(1);
            make.height.equalTo(34 * HeightCoefficient);
            make.left.equalTo(_searchField.right);
            make.centerY.equalTo(_searchField);
        }];
        
        self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#040000"] forState:UIControlStateNormal];
        [_topBar addSubview:_searchBtn];
        [_searchBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.right);
            make.right.equalTo(_topBar.right);
            make.top.bottom.equalTo(_topBar);
        }];
        
        self.tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 359 * WidthCoefficient, 74 * WidthCoefficient)];
        self.tableHeader.backgroundColor = [UIColor clearColor];
        self.resultTable.tableHeaderView = self.tableHeader;
        
        [self.view addSubview:self.resultTable];
        [_resultTable makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(359 * WidthCoefficient);
            make.height.equalTo(kScreenHeight - kStatusBarHeight - 54 * HeightCoefficient);
            make.left.equalTo(8 * WidthCoefficient);
//            make.bottom.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(kScreenHeight - kStatusBarHeight - 54 * HeightCoefficient + 10 * HeightCoefficient);
        }];
        
        UIView *btnContainer = [[UIView alloc] init];
        btnContainer.backgroundColor = [UIColor whiteColor];
        [self.tableHeader addSubview:btnContainer];
        [btnContainer makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.tableHeader);
            make.height.equalTo(54 * WidthCoefficient);
            make.center.equalTo(self.tableHeader);
        }];
        
        NSArray *imgTitles = @[
                               @"park",
                               @"oil",
                               @"food",
                               @"life"
                               ];
        NSArray *titles = @[
                            NSLocalizedString(@"停车", nil),
                            NSLocalizedString(@"加油", nil),
                            NSLocalizedString(@"餐饮", nil),
                            NSLocalizedString(@"生活", nil)
                            ];
        
        NSMutableArray<LeftImgButton *> *btns = [NSMutableArray arrayWithCapacity:imgTitles.count];
        
        for (NSInteger i = 0; i < imgTitles.count; i++) {
            LeftImgButton *btn = [LeftImgButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:imgTitles[i]] forState:UIControlStateNormal];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#040000"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:FontName size:14];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btnContainer addSubview:btn];
            [btns addObject:btn];
        }
        [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:69 * WidthCoefficient leadSpacing:15 * WidthCoefficient tailSpacing:15 * WidthCoefficient];
        [btns makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btnContainer);
            make.height.equalTo(23.5 * WidthCoefficient);
        }];
        
        [self.view layoutIfNeeded];
    }
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag >= 1000) {//上方按钮
        _searchField.text = sender.titleLabel.text;
        [[MapSearchManager sharedManager] keyWordsAround:_searchField.text location:self.mapView.userLocation.coordinate returnBlock:^(NSArray<__kindof MapSearchPointAnnotation *> *pointAnnotations) {
            [self.annotations removeAllObjects];
            [self.annotations addObjectsFromArray:pointAnnotations];
            _resultTable.tableFooterView = [UIView new];
            [_resultTable reloadData];
        }];
    }
    if (sender == _backBtn) {
       [self.navigationController popViewControllerAnimated:YES];
        [MapView destroy];
    }
    
    if (sender == _topBackBtn) {
        [self hideSearchView];
    }
    if (sender == _clearBtn) {
        _searchField.text = @"";
        [self.annotations removeAllObjects];
        [self getHistory];
    }
    if (sender == _searchBtn) {
        [[MapSearchManager sharedManager] keyWordsSearch:_searchField.text city:self.city returnBlock:^(NSArray<__kindof MapSearchPointAnnotation *> *pointAnnotations) {
            [self.annotations removeAllObjects];
            [self.annotations addObjectsFromArray:pointAnnotations];
            _resultTable.tableFooterView = [UIView new];
            [_resultTable reloadData];
        }];
    }
    if (sender == _showBackBtn) {
        [self hideInfoView];
        [self showSearchViewFromLeft:YES animated:NO];
    }
    if (sender == _showClearBtn) {
        [self hideInfoView];
        _tmpField.hidden = NO;
        [self clear];
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
    }
    if (sender == _clearHistoryBtn) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示!", nil) message:NSLocalizedString(@"清空历史记录?", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"立即清空", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [MapSearchHistory dropAllHistory];
            [self getHistory];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (sender == _infoFavoriteBtn) {
        sender.selected = !sender.selected;
    }
    if (sender == _infoAroundBtn) {
        SearchAroundViewController *vc = [[SearchAroundViewController alloc] initWithAddress:self.currentAnnotationInfo];
        [self.navigationController pushViewController:vc animated:NO];
    }
    if (sender == _infoFenceBtn) {
        
    }
    if ([sender isKindOfClass:[POISendBtn class]]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"是否确定将\"光谷广场\"位置发送到车" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
        NSRange range = [@"是否确定将\"光谷广场\"位置发送到车" rangeOfString:@"光谷广场"];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:172.0/255.0 green:0 blue:66.0/255.0 alpha:1] range:range];
        CUAlertController *alert = [CUAlertController alertWithImage:[UIImage imageNamed:@"mobile-phone-2"] attributedMessage:message];
        [alert addButtonWithTitle:@"取消" type:CUButtonTypeCancel clicked:^{
            
        }];
        [alert addButtonWithTitle:@"发送" type:CUButtonTypeNormal clicked:^{
            
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)getUserLocation {
    [[MapSearchManager sharedManager] reGeoInfo:self.mapView.userLocation.coordinate returnBlock:^(MapReGeoInfo *regeoInfo) {
        self.city = regeoInfo.city;
    }];
}

- (void)clearAndAddAnnotationWithAnnotationInfo:(MapSearchObject *)annotationInfo {
    [self clear];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = annotationInfo.coordinate;
    annotation.title = annotationInfo.name;
    annotation.subtitle = annotationInfo.address;
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)clear {
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.mapView.annotations];
    for (NSInteger i = 0; i < tmp.count; i++) {
        id<MAAnnotation> obj = tmp[i];
        if ([obj isKindOfClass:[MAUserLocation class]]) {
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

- (void)showShade {
    if (!_shade) {
        _shade = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _shade.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        [self.view addSubview:_shade];
        [self.view insertSubview:_shade atIndex:4];
    }
}

- (void)hideShade {
    if (_shade) {
        [_shade removeFromSuperview];
        _shade = nil;
    }
}

- (void)showSearchViewFromLeft:(BOOL)fromLeft animated:(BOOL)animated {
    [self showShade];
    [self clear];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:NO];
    [self initSearchView];
    [self hideInfoView];
    _tmpField.hidden = YES;
    if (fromLeft) {
        [_topBar updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            make.left.equalTo(-kScreenWidth);
        }];
        [_resultTable updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(-kScreenWidth);
        }];
        [self.view layoutIfNeeded];
    } else {
        [_topBar updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-50 * HeightCoefficient);
            make.left.equalTo(8 * WidthCoefficient);
        }];
        [_resultTable updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(8 * WidthCoefficient);
            //            make.bottom.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(kScreenHeight - kStatusBarHeight - 54 * HeightCoefficient + 10 * HeightCoefficient);
        }];
        [self.view layoutIfNeeded];
    }
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            [_topBar updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
                make.left.equalTo(8 * WidthCoefficient);
            }];
            [_resultTable updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.left.equalTo(8 * WidthCoefficient);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if ([_searchField canBecomeFirstResponder]) {
                [_searchField becomeFirstResponder];
            }
        }];
    } else {
        [_topBar updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
            make.left.equalTo(8 * WidthCoefficient);
        }];
        [_resultTable updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(8 * WidthCoefficient);
        }];
        [self.view layoutIfNeeded];
        if ([_searchField canBecomeFirstResponder]) {
            [_searchField becomeFirstResponder];
        }
    }
    
    _searchField.text = @"";
    [self.annotations removeAllObjects];
    [self getHistory];
}

- (void)hideSearchView {
    [self hideShade];
    [_searchField resignFirstResponder];
    _tmpField.hidden = NO;
    [_topBar updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-50 * HeightCoefficient);
    }];
    [_resultTable updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(kScreenHeight - kStatusBarHeight - 54 * HeightCoefficient + 10 * HeightCoefficient);
    }];
    [self.view layoutIfNeeded];
}

- (void)showInfoWithAnnotationInfo:(MapSearchObject *)annotationInfo {
    self.currentAnnotationInfo = annotationInfo;
    _tmpField.hidden = YES;
    if (self.infoView) {
        [_infoView removeFromSuperview];
        _infoView = nil;
    }
    if (self.showField) {
        [_showField removeFromSuperview];
        _showField = nil;
    }
    
    self.showBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showBackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_showBackBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    self.showClearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showClearBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_showClearBtn setImage:[UIImage imageNamed:@"out"] forState:UIControlStateNormal];
    
    self.showField = [[UITextField alloc] init];
    _showField.backgroundColor = [UIColor whiteColor];
    _showField.delegate = self;
    _showField.text = annotationInfo.name;
    _showField.textColor = [UIColor colorWithHexString:@"#040000"];
    _showField.font = [UIFont fontWithName:FontName size:16];
    _showField.layer.cornerRadius = 2;
    _showField.layer.shadowOffset = CGSizeMake(0, 5);
    _showField.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    _showField.layer.shadowRadius = 15;
    _showField.layer.shadowOpacity = 0.5;
    [self.view addSubview:_showField];
    [_showField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient + kStatusBarHeight);
        make.centerX.equalTo(0);
    }];
    
    _showField.leftView = self.showBackBtn;
    _showField.leftViewMode = UITextFieldViewModeAlways;
    [_showBackBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(53 * WidthCoefficient);
        make.height.equalTo(23 * WidthCoefficient);
    }];
    
    _showField.rightView = self.showClearBtn;
    _showField.rightViewMode = UITextFieldViewModeAlways;
    [_showClearBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(42 * WidthCoefficient);
        make.height.equalTo(16 * WidthCoefficient);
    }];
    
    ///
    [self.view addSubview:self.infoView];
    [_infoView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(360 * WidthCoefficient);
        make.height.equalTo(159 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(- 15 * HeightCoefficient - kBottomHeight);
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
        make.height.equalTo(80 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(30 * WidthCoefficient);
    }];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    title.textColor = [UIColor colorWithHexString:@"#040000"];
    title.text = annotationInfo.name;
    [infoTop addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(15 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
        make.width.equalTo(infoTop).offset(-80 * WidthCoefficient);
    }];
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.font = [UIFont fontWithName:FontName size:13];
    subTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    subTitle.text = [NSString stringWithFormat:@"%@ 丨 %@",[self distanceFromUsr:annotationInfo.coordinate],annotationInfo.address];
    if (!annotationInfo.address || [annotationInfo.address isEqualToString:@""]) {
        subTitle.text = [NSString stringWithFormat:@"%@",[self distanceFromUsr:annotationInfo.coordinate]];
    }
    [infoTop addSubview:subTitle];
    [subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title);
        make.top.equalTo(title.bottom).offset(5 * WidthCoefficient);
        make.height.equalTo(16 * WidthCoefficient);
        make.width.equalTo(infoTop).offset(-20 * WidthCoefficient);
    }];
    
    POISendBtn *sendPOIBtn = [POISendBtn buttonWithType:UIButtonTypeCustom];
    [sendPOIBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendPOIBtn setBackgroundImage:[UIImage imageNamed:@"Group 4"] forState:UIControlStateNormal];
    [_infoView addSubview:sendPOIBtn];
    [sendPOIBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(60 * WidthCoefficient);
        make.top.equalTo(0);
        make.right.equalTo(-10 * WidthCoefficient);
    }];
    
    UIView *infoBot = [[UIView alloc] init];
    infoBot.backgroundColor = [UIColor whiteColor];
    infoBot.layer.cornerRadius = 1;
    infoBot.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    infoBot.layer.shadowOffset = CGSizeMake(0, 5);
    infoBot.layer.shadowOpacity = 0.5;
    infoBot.layer.shadowRadius = 15;
    [_infoView addSubview:infoBot];
    [infoBot makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_infoView);
        make.height.equalTo(44 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    NSMutableArray *botBtns = [[NSMutableArray alloc] init];
    
    NSArray *arr = @[
                     NSLocalizedString(@"收藏", nil),
                     NSLocalizedString(@"搜周边", nil),
                     NSLocalizedString(@"电子围栏", nil)
                     ];
    NSArray *imgTitles = @[
                           @"收藏 4",
                           @"周边",
                           @"电子围栏"
                           ];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        LeftImgButton *btn = [LeftImgButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgTitles[i]] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:FontName size:12]];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [infoBot addSubview:btn];
        [botBtns addObject:btn];
        if (i == 0) {
            self.infoFavoriteBtn = btn;
            [btn setTitle:NSLocalizedString(@"已收藏", nil) forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
        }
        if (i == 1) {
            self.infoAroundBtn = btn;
        }
        if (i == 2) {
            self.infoFenceBtn = btn;
        }
    }
    
    [botBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:36 * WidthCoefficient leadSpacing:20 * WidthCoefficient tailSpacing:20 * WidthCoefficient];
    [botBtns makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(13 * WidthCoefficient);
        make.bottom.equalTo(-13 * WidthCoefficient);
    }];
}

- (void)hideInfoView {
    if (self.infoView) {
        [self.infoView removeFromSuperview];
        _infoView = nil;
    }
    if (self.showField) {
        [self.showField removeFromSuperview];
        _showField = nil;
    }
}

#pragma mark = UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _tmpField) {
        [self showSearchViewFromLeft:NO animated:NO];
        return NO;
    }
    if (textField == _showField) {
        [self showSearchViewFromLeft:NO animated:NO];
    }
    if (textField == _searchField) {
        [self getHistory];
    }
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField {
    [[MapSearchManager sharedManager] inputTipsSearch:textField.text city:self.city returnBlock:^(NSArray<__kindof MapSearchTip *> *tips) {
        [self.annotations removeAllObjects];
        for (MapSearchTip *tip in tips) {
            if (tip.uid && tip.coordinate.longitude > 0 && tip.coordinate.latitude) {
                [self.annotations addObject:tip];
            }
        }
        _resultTable.tableFooterView = [UIView new];
        [_resultTable reloadData];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _searchField) {
        [[MapSearchManager sharedManager] keyWordsSearch:_searchField.text city:self.city returnBlock:^(NSArray<__kindof MapSearchPointAnnotation *> *pointAnnotations) {
            [self.annotations removeAllObjects];
            [self.annotations addObjectsFromArray:pointAnnotations];
            _resultTable.tableFooterView = [UIView new];
            [_resultTable reloadData];
        }];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchField resignFirstResponder];
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MapSearchObject * annotation = self.annotations[indexPath.row];
    [self hideSearchView];
    [self clearAndAddAnnotationWithAnnotationInfo:annotation];
    MapSearchHistory *history = [[MapSearchHistory alloc] initWithName:annotation.name address:annotation.address coordinate:annotation.coordinate timeStamp:[[NSDate date] timeIntervalSince1970]];
    [MapSearchHistory updateWithHistory:history];
    [self getHistory];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 * WidthCoefficient;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.annotations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"MapCellId";
    MapSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MapSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    id<MapAnnotation> annotation = self.annotations[indexPath.row];
    cell.titleLabel.text = annotation.name;
    cell.subTitleLabel.text = annotation.address;
    return cell;
}

#pragma mark - MAMapViewDelegate-

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!self.city) {
        [self getUserLocation];
    }
    if (!updatingLocation && _locationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            _locationAnnotationView.rotateDegree = userLocation.heading.trueHeading - mapView.rotationDegree;
        }];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        return nil;
//        static NSString *userLocationStyleReuseIdetifier = @"userLocationStyleReuseIndetifier";
//        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIdetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[LocationAnnotationView alloc] initWithAnnotation:annotation
//                                                                reuseIdentifier:userLocationStyleReuseIdetifier];
//
//            annotationView.canShowCallout = YES;
//        }
//
//        _locationAnnotationView = (LocationAnnotationView *)annotationView;
//        [_locationAnnotationView updateImage:[UIImage imageNamed:@"gps_icon"]];
//
//        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *tipId = @"tipId";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:tipId];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipId];
        }
        annotationView.image = [UIImage imageNamed:@"Dropped Pin"];
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois {
    if (pois.count == 0) {
        return;
    }
    MATouchPoi *touchPOI = pois[0];
    if (touchPOI) {
        
        [[MapSearchManager sharedManager] idSearch:touchPOI.uid returnBlock:^(MapSearchPointAnnotation *pointAnnotation) {
            [self clear];
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = touchPOI.coordinate;
            annotation.title = touchPOI.name;
            annotation.subtitle = pointAnnotation.address;
            [self.mapView addAnnotation:annotation];
            [self.mapView selectAnnotation:annotation animated:YES];
        }];
    }
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    [self.mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    MapSearchObject *annotation = [[MapSearchObject alloc] init];
    annotation.coordinate = view.annotation.coordinate;
    annotation.name = view.annotation.title;
    annotation.address = view.annotation.subtitle;
    [self showInfoWithAnnotationInfo:annotation];
}

#pragma mark - lazy load -

- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [UIColor whiteColor];
        _topBar.layer.cornerRadius = 2;
        _topBar.layer.shadowColor = [UIColor colorWithHexString:@"#e7e7e7"].CGColor;
        _topBar.layer.shadowOffset = CGSizeMake(0, -1.5);
        _topBar.layer.shadowRadius = 15;
        _topBar.layer.shadowOpacity = 0.5;
    }
    return _topBar;
}

- (UITableView *)resultTable {
    if (!_resultTable) {
        _resultTable = [[UITableView alloc] init];
        if (@available(iOS 11.0, *)) {
            _resultTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _resultTable.delegate = self;
        _resultTable.dataSource = self;
        _resultTable.tableFooterView = [UIView new];
        _resultTable.backgroundColor = [UIColor clearColor];
        _resultTable.showsVerticalScrollIndicator = NO;
        _resultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _resultTable;
}

- (NSMutableArray<MapSearchObject *> *)annotations {
    if (!_annotations) {
        _annotations = [[NSMutableArray alloc] init];
    }
    return _annotations;
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
    }
    return _infoView;
}

- (UIView *)tableFooter {
    if (!_tableFooter) {
        _tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 359 * WidthCoefficient, 52 * WidthCoefficient)];
        _tableFooter.backgroundColor = [UIColor whiteColor];
        self.clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearHistoryBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_clearHistoryBtn setTitle:NSLocalizedString(@"清空历史记录", nil) forState:UIControlStateNormal];
        [_clearHistoryBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _clearHistoryBtn.titleLabel.font = [UIFont fontWithName:FontName size:15];
        [_tableFooter addSubview:_clearHistoryBtn];
        [_clearHistoryBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(222 * WidthCoefficient);
            make.height.equalTo(21 * WidthCoefficient);
            make.center.equalTo(_tableFooter);
        }];
    }
    return _tableFooter;
}

@end