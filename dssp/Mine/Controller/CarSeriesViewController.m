//
//  CarSeriesViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarSeriesViewController.h"
#import <YYCategoriesSub/YYCategories.h>

#define selectedColor [UIColor colorWithHexString:@"#ac0042"]
#define normalColor [UIColor colorWithHexString:@"#999999"]

@interface CarSeriesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *seriesBtn;
@property (nonatomic, strong) UIView *seriesBot;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) UIView *typeBot;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, strong) NSArray<NSString *> *series;
@property (nonatomic, strong) NSArray<NSString *> *types;

@property (nonatomic, copy) NSString *carSeries;

@end

@implementation CarSeriesViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self initData];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"车系选择", nil);
    
    self.seriesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seriesBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_seriesBtn setTitle:NSLocalizedString(@"车系", nil) forState:UIControlStateNormal];
    [_seriesBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    _seriesBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.view addSubview:_seriesBtn];
    [_seriesBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(163 * WidthCoefficient);
        make.height.equalTo(21 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(22 * HeightCoefficient);
    }];
    
    self.seriesBot = [[UIView alloc] init];
    _seriesBot.backgroundColor = selectedColor;
    _seriesBot.layer.cornerRadius = 4;
    [self.view addSubview:_seriesBot];
    [_seriesBot makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(2 * HeightCoefficient);
        make.centerX.equalTo(_seriesBtn);
        make.top.equalTo(_seriesBtn.bottom).offset(5 * HeightCoefficient);
    }];
    
    self.typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_typeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_typeBtn setTitle:NSLocalizedString(@"车型", nil) forState:UIControlStateNormal];
    [_typeBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [self.view addSubview:_typeBtn];
    [_typeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(_seriesBtn);
        make.right.equalTo(-16 * WidthCoefficient);
    }];
    
    self.typeBot = [[UIView alloc] init];
    _typeBot.backgroundColor = normalColor;
    _typeBot.layer.cornerRadius = 4;
    [self.view addSubview:_typeBot];
    [_typeBot makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(2 * HeightCoefficient);
        make.centerX.equalTo(_typeBtn);
        make.top.equalTo(_typeBtn.bottom).offset(5 * HeightCoefficient);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [self.view addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_seriesBtn);
        make.width.height.equalTo(14.15 * WidthCoefficient);
        make.centerX.equalTo(self.view);
    }];
    
    self.table = [[UITableView alloc] init];
    _table.estimatedRowHeight = 0;
    _table.estimatedSectionFooterHeight = 0;
    _table.estimatedSectionHeaderHeight = 0;
    _table.tableFooterView = [UIView new];
    _table.layer.cornerRadius = 4;
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    [_table makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(300 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_seriesBot.bottom).offset(11.5 * HeightCoefficient);
    }];
    
    UIView *shadow = [[UIView alloc] init];
    shadow.backgroundColor = [UIColor whiteColor];
    shadow.layer.cornerRadius = 4;
    shadow.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    shadow.layer.shadowOffset = CGSizeMake(0, 4);
    shadow.layer.shadowRadius = 7;
    shadow.layer.shadowOpacity = 0.5;
    [self.view addSubview:shadow];
    [shadow makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_table);
    }];
    
    [self.view insertSubview:shadow belowSubview:_table];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 2;
    [confirmBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:confirmBtn];
    [confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(self.view.bottom).offset(-8 * HeightCoefficient - kBottomHeight);
    }];
}

- (void)initData {
    self.dataSource = self.series;
    [self.table reloadData];
}

- (void)btnClick:(UIButton *)sender {
    if (sender == _seriesBtn) {
        _seriesBot.backgroundColor = selectedColor;
        _typeBot.backgroundColor = normalColor;
        self.dataSource = self.series;
        [self.table reloadData];
    }
    if (sender == _typeBtn) {
        _seriesBot.backgroundColor = normalColor;
        _typeBot.backgroundColor = selectedColor;
        self.dataSource = self.types;
        [self.table reloadData];
    }
}

- (void)confirmBtnClick:(UIButton *)sender {
    self.carSeriesSelct(_carSeries);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _carSeries = self.dataSource[indexPath.row];
}

- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (NSArray<NSString *> *)series {
    if (!_series) {
        _series = @[
                    @"车系一",
                    @"车系二"
                    ];
    }
    return _series;
}

- (NSArray<NSString *> *)types {
    if (!_types) {
        _types = @[
                   @"车型一",
                   @"车型二"
                   ];
    }
    return _types;
}

@end
