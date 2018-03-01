//
//  DrivingWeekReportViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingWeekReportViewController.h"
#import "DrivingReportObject.h"
#import "DrivingReportWeekCell.h"

@interface DrivingWeekReportViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<DrivingReportWeek *> *reports;

@property (nonatomic, strong) UIView *midV;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UILabel *filterStartLabel;
@property (nonatomic, strong) UILabel *filterEndLabel;

@property (nonatomic, strong) UILabel *harshBrakeLabel;
@property (nonatomic, strong) UILabel *harshAccLabel;
@property (nonatomic, strong) UILabel *harshTurnLabel;

@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *fuelTotalLabel;
@property (nonatomic, strong) UILabel *fuelAverageLabel;
@property (nonatomic, strong) UILabel *brakeTimeLabel;
@property (nonatomic, strong) UILabel *attentionTimesLabel;
@property (nonatomic, strong) UILabel *accMileageLabel;

@end

@implementation DrivingWeekReportViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self pullData];
}

- (void)setupUI {
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    topV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    topV.layer.shadowOffset = CGSizeMake(0, 6);
    topV.layer.shadowRadius = 7;
    topV.layer.shadowOpacity = 0.5;
    [self.view addSubview:topV];
    [topV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * WidthCoefficient);
        make.left.right.equalTo(self.view);
        make.height.equalTo(70 * WidthCoefficient);
    }];
    
    UIImageView *calendarImgV = [[UIImageView alloc] init];
    calendarImgV.image = [UIImage imageNamed:@"日历_icon"];
    [topV addSubview:calendarImgV];
    [calendarImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(36 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.centerY.equalTo(0);
    }];
    
    NSArray *topTitles = @[@"开始:",@"结束:"];
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = topTitles[i];
        [topV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(35 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(calendarImgV.right).offset(10 * WidthCoefficient);
            make.top.equalTo((10 + 30 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [topV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
        
        if (i == 0) {
            self.filterStartLabel = label1;
        } else if (i == 1) {
            self.filterEndLabel = label1;
        }
    }
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"箭头_右"];
    [topV addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(15 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.centerY.equalTo(0);
    }];
    
    UIView *midV = [[UIView alloc] init];
    self.midV = midV;
    midV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:midV];
    [midV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topV.bottom);
        make.height.equalTo(397 * WidthCoefficient);
    }];
    
    NSArray *harshTitles = @[
                             @"急刹车",
                             @"急加速",
                             @"急转弯"
                             ];
    for (NSInteger i = 0; i < harshTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.textAlignment = NSTextAlignmentCenter;
        label0.font = [UIFont fontWithName:FontName size:13];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = harshTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(107.5 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.top.equalTo(20 * WidthCoefficient);
            make.left.equalTo((16 + 118 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(27.5 * WidthCoefficient);
            make.height.equalTo(25 * WidthCoefficient);
            make.top.equalTo(label0.bottom).offset(5 * WidthCoefficient);
            make.centerX.equalTo(label0);
        }];
        
        if (i == 0) {
            self.harshBrakeLabel = label1;
        } else if (i == 1) {
            self.harshAccLabel = label1;
        } else if (i == 2) {
            self.harshTurnLabel = label1;
        }
    }
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:@"1e1918"];
    [midV addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(90 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    NSArray *reportImgs = @[
                            @"里程_icon",
                            @"油耗_icon",
                            @"平均油耗_icon",
                            @"制动时间_icon",
                            @"注意次数_icon",
                            @"acc里程_icon"
                            ];
    
    NSArray *reportTitles = @[
                              @"里程",
                              @"油耗",
                              @"平均油耗",
                              @"汽车制动时间",
                              @"开车注意次数",
                              @"ACC里程"
                              ];
    
    for (NSInteger i = 0; i < reportImgs.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:reportImgs[i]];
        [midV addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.top.equalTo(line0.bottom).offset((17 + 51 * i) * WidthCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:15];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = reportTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(imgV.right).offset(10 * WidthCoefficient);
            make.centerY.equalTo(imgV);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textAlignment = NSTextAlignmentRight;
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.right.equalTo(-16 * WidthCoefficient);
            make.centerY.equalTo(imgV);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"1e1918"];
        [midV addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(317 * WidthCoefficient);
            make.height.equalTo(1 * WidthCoefficient);
            make.right.equalTo(label1);
            make.top.equalTo(label1.bottom).offset(15 * WidthCoefficient);
        }];
        
        if (i == 0) {
            self.mileageLabel = label1;
        } else if (i == 1) {
            self.fuelTotalLabel = label1;
        } else if (i == 2) {
            self.fuelAverageLabel = label1;
        } else if (i == 3) {
            self.brakeTimeLabel = label1;
        } else if (i == 4) {
            self.attentionTimesLabel = label1;
        } else if (i == 5) {
            self.accMileageLabel = label1;
        }
    }
    
    [self createCollectionView];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0 * WidthCoefficient;
    flowLayout.minimumLineSpacing = 0 * WidthCoefficient;
    flowLayout.sectionInset = UIEdgeInsetsMake(15 * WidthCoefficient, 11 * WidthCoefficient, 15 * WidthCoefficient, 11 * WidthCoefficient);
    flowLayout.itemSize = CGSizeMake(100 * WidthCoefficient, 90 * WidthCoefficient);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_midV.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(120 * WidthCoefficient);
    }];

    [_collectionView registerClass:[DrivingReportWeekCell class] forCellWithReuseIdentifier:@"DrivingReportWeekCell"];
    
}

- (void)configWithReport:(DrivingReportWeek *)report {
    self.harshBrakeLabel.text = report.harshDecelerationTimes;
    self.harshAccLabel.text = report.harshAccelerationTimes;
    self.harshTurnLabel.text = report.harshTurnTimes;
    
    self.mileageLabel.text = [NSString stringWithFormat:@"%@km",report.mileage];
    self.fuelTotalLabel.text = [NSString stringWithFormat:@"%@L",report.totalFuelConsumed];
    self.fuelAverageLabel.text = [NSString stringWithFormat:@"%@L",report.averageFuelConsumed];
    self.brakeTimeLabel.text = [NSString stringWithFormat:@"%@h",report.autoBrakeTimes];
    self.attentionTimesLabel.text = [NSString stringWithFormat:@"%@次",report.driverAttentionTimes];
    self.accMileageLabel.text = [NSString stringWithFormat:@"%@km",report.accMileage];
}

- (void)pullData {
    NSDictionary *paras = @{
//                            @"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"],
                            @"vin":@"1",
                            @"startTime":@"1",
                            @"endTime":@"1"
                            };
    [CUHTTPRequest POST:getDrivingReportWeekURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            DrivingReportWeekResponse *response = [DrivingReportWeekResponse yy_modelWithJSON:dic];
            self.reports = response.data.record;
            self.selectIndex = 0;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self configWithReport:self.reports[self.selectIndex]];
            });
            
        }
    } failure:^(NSInteger code) {
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.reports.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DrivingReportWeekCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DrivingReportWeekCell" forIndexPath:indexPath];
    DrivingReportWeek *report = self.reports[indexPath.row];
    [cell configWithStart:report.startDate end:report.endDate isSelected:indexPath.row == self.selectIndex];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DrivingReportWeek *report = self.reports[indexPath.row];
    self.selectIndex = indexPath.row;
    [self configWithReport:report];
    [collectionView reloadData];
}

- (NSArray<DrivingReportWeek *> *)reports {
    if (!_reports) {
        _reports = [NSArray array];
    }
    return _reports;
}

@end
