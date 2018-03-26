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
#import <FSCalendar.h>
#import "RangePickerCell.h"
#import <FSCalendarExtensions.h>

#define CalendarContainerHeight (kScreenHeight - kNaviHeight - 80 * WidthCoefficient)

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagCancel = 1000,
    ButtonTagOK,
};

@interface DrivingWeekReportViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (weak, nonatomic) UIView *calendarContainer;
@property (weak, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;

@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, weak) UIButton *okBtn;

///

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

@property (nonatomic, copy) NSString *startTimeStamp;
@property (nonatomic, copy) NSString *endTimeStamp;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation DrivingWeekReportViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNaviHeight, kScreenWidth, CalendarContainerHeight)];
    calendarContainer.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:calendarContainer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = calendarContainer.bounds;
    maskLayer.path = maskPath.CGPath;
    calendarContainer.layer.mask = maskLayer;
    calendarContainer.layer.masksToBounds = YES;
    [view addSubview:calendarContainer];
    self.calendarContainer = calendarContainer;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont fontWithName:FontName size:15];
    cancelBtn.tag = ButtonTagCancel;
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [calendarContainer addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, 0, 50 * WidthCoefficient, 40 * WidthCoefficient);
    self.cancelBtn = cancelBtn;
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.titleLabel.font = [UIFont fontWithName:FontName size:15];
    okBtn.tag = ButtonTagOK;
    [okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [calendarContainer addSubview:okBtn];
    okBtn.frame = CGRectMake(kScreenWidth - 50 * WidthCoefficient, 0, 50 * WidthCoefficient, 40 * WidthCoefficient);
    self.okBtn = okBtn;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = NSLocalizedString(@"选择日期", nil);
    [calendarContainer addSubview:tipLabel];
    tipLabel.frame = CGRectMake(kScreenWidth / 2 - 50 * WidthCoefficient, 0, 100 * WidthCoefficient, 40 * WidthCoefficient);
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 40 * WidthCoefficient, kScreenWidth, CalendarContainerHeight - 40 * WidthCoefficient)];
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO;
    calendar.allowsMultipleSelection = YES;
    calendar.rowHeight = 60 * WidthCoefficient;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [calendarContainer addSubview:calendar];
    self.calendar = calendar;
    
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase | FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.weekdayTextColor = [UIColor colorWithHexString:@"#666666"];
    calendar.appearance.titleWeekendColor = [UIColor colorWithHexString:@"#ff6600"];
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = [UIColor blackColor];
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.headerHeight = 40 * WidthCoefficient;
    calendar.weekdayHeight = 40 * WidthCoefficient;
    
    calendar.swipeToChooseGesture.enabled = NO;
    
    calendar.today = nil; // Hide the today circle
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"驾驶行为报告", nil);
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    // Uncomment this to perform an 'initial-week-scope'
    self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
    [self setupUI];
    
    self.harshBrakeLabel.text = @"-";
    self.harshAccLabel.text = @"-";
    self.harshTurnLabel.text = @"-";
    self.mileageLabel.text = @"-";
    self.fuelTotalLabel.text = @"-";
    self.fuelAverageLabel.text = @"-";
    self.brakeTimeLabel.text = @"-";
    self.attentionTimesLabel.text = @"-";
    self.accMileageLabel.text = @"-";
    
    [self pullDefaultData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.calendarContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"DrivingWeekReportViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"DrivingWeekReportViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"DrivingWeekReportViewController"];
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
    
    UILabel *chooseLabel = [[UILabel alloc] init];
    chooseLabel.textAlignment = NSTextAlignmentRight;
    chooseLabel.font = [UIFont fontWithName:FontName size:12];
    chooseLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    chooseLabel.text = NSLocalizedString(@"请选择查看日期", nil);
    [topV addSubview:chooseLabel];
    [chooseLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrow.left);
        make.centerY.equalTo(arrow);
        make.height.equalTo(20 * WidthCoefficient);
    }];
    
    UITapGestureRecognizer *showCalendarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCalendar)];
    [topV addGestureRecognizer:showCalendarTap];
    
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
                              @"疲劳驾驶提醒次数",
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

- (void)showCalendar {
    [UIView animateWithDuration:0.25 animations:^{
        _calendarContainer.frame = CGRectMake(0, 80 * WidthCoefficient, kScreenWidth, CalendarContainerHeight);
    }];
}

- (void)hideCalendarWithCompletion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.25 animations:^{
        _calendarContainer.frame = CGRectMake(0, kScreenHeight - kNaviHeight, kScreenWidth, CalendarContainerHeight);
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

- (void)btnClick:(UIButton *)sender {
    
    [self hideCalendarWithCompletion:^(BOOL finished) {
        if (finished) {
            if (sender.tag == ButtonTagOK) {
                if (self.date1 && self.date2) {//
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy/MM/dd";
                    formatter.timeZone = [NSTimeZone localTimeZone];
                    self.filterStartLabel.text = [formatter stringFromDate:self.date1];
                    self.filterEndLabel.text = [formatter stringFromDate:self.date2];
                    
                    self.startTimeStamp = [self convertDateToTimestamp:self.date1 isStart:YES];
                    self.endTimeStamp = [self convertDateToTimestamp:self.date2 isStart:NO];
                    [self pullData];
                }
            }
            //还原
            if (self.date1) {
                [self.calendar deselectDate:self.date1];
                self.date1 = nil;
            }
            if (self.date2) {
                [self.calendar deselectDate:self.date2];
                self.date2 = nil;
            }
            [self configureVisibleCells];
        }
    }];;
}

- (void)pullDefaultData {
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate *startDate = [self.gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    formatter.timeZone = [NSTimeZone localTimeZone];
    self.filterStartLabel.text = [formatter stringFromDate:startDate];
    self.filterEndLabel.text = [formatter stringFromDate:[NSDate date]];
    
    self.startTimeStamp = [self convertDateToTimestamp:startDate isStart:YES];
    self.endTimeStamp = [self convertDateToTimestamp:[NSDate date] isStart:NO];
    
    [self pullData];
}

- (void)pullData {
    
    self.harshBrakeLabel.text = @"-";
    self.harshAccLabel.text = @"-";
    self.harshTurnLabel.text = @"-";
    self.mileageLabel.text = @"-";
    self.fuelTotalLabel.text = @"-";
    self.fuelAverageLabel.text = @"-";
    self.brakeTimeLabel.text = @"-";
    self.attentionTimesLabel.text = @"-";
    self.accMileageLabel.text = @"-";
    
    self.reports = nil;
    [self.collectionView reloadData];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    
    NSDictionary *paras = @{
                            @"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"],
//                            @"vin":@"VF7CAPSA000020154",
                            @"startTime":self.startTimeStamp,
                            @"endTime":self.endTimeStamp
                            };
    [CUHTTPRequest POST:getDrivingReportWeekURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            DrivingReportWeekResponse *response = [DrivingReportWeekResponse yy_modelWithJSON:dic];
            self.reports = response.data.record;
            self.selectIndex = 0;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self.collectionView reloadData];
                if (self.reports.count) {
                    [self configWithReport:self.reports[self.selectIndex]];
                }
            });
            
        } else {
//            hud.label.text = dic[@"msg"];
//            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

///用于选择日期后转化为接口入参
- (NSString *)convertDateToTimestamp:(NSDate *)date isStart:(BOOL)isStart {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone localTimeZone];
    
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    dateComps.timeZone = [NSTimeZone localTimeZone];
    
    if (isStart) {
        dateComps.hour = 0;
        dateComps.minute = 0;
        dateComps.second = 0;
    } else {
        dateComps.hour = 23;
        dateComps.minute = 59;
        dateComps.second = 59;
    }
    
    NSDate *newDate = [cal dateFromComponents:dateComps];
    
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",interval * 1000];
    return timeStamp;
}

#pragma mark - UICollectionViewDelegate -

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

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-6];
    return [self.gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
        if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = date;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = date;
        } else {//有date1
            //            self.date2 = date;
            if ([date timeIntervalSinceDate:self.date1] > 0) {
                self.date2 = date;
            } else {
                [calendar deselectDate:self.date1];
                self.date1 = date;
            }
        }
    }
    
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.date1 && self.date2) {
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
    } else {
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
}

- (NSArray<DrivingReportWeek *> *)reports {
    if (!_reports) {
        _reports = [NSArray array];
    }
    return _reports;
}

@end
