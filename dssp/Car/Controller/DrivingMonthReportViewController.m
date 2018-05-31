//
//  DrivingMonthReportViewController.m
//  dssp
//
//  Created by yxliu on 2018/5/31.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingMonthReportViewController.h"
#import "DrivingReportObject.h"

@interface DrivingMonthReportViewController ()

@property (nonatomic, copy) NSString *startTimeStamp;
@property (nonatomic, copy) NSString *endTimeStamp;

@property (nonatomic, strong) NSArray<DrivingReportMonth *> *reports;
@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) UIScrollView *topScroll;
@property (nonatomic, strong) UIScrollView *contentScroll;

@property (nonatomic, strong) UIView *statisticsView;
@property (nonatomic, strong) UIView *chartMileageContainer;
@property (nonatomic, strong) UIView *chartFuelContainer;

@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *fuelTotalLabel;
@property (nonatomic, strong) UILabel *fuelAverageLabel;
@property (nonatomic, strong) UILabel *brakeTimeLabel;
@property (nonatomic, strong) UILabel *attentionTimesLabel;
@property (nonatomic, strong) UILabel *accMileageLabel;
@property (nonatomic, strong) UILabel *harshBrakeLabel;
@property (nonatomic, strong) UILabel *harshDecelerateLabel;
@property (nonatomic, strong) UILabel *harshTurnLabel;

@end

@implementation DrivingMonthReportViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self clear];
    
    [self pullDefaultData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"DrivingMonthReportViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"DrivingMonthReportViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"DrivingMonthReportViewController"];
}

- (void)setupUI {
    
    self.topScroll = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        [self.view addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(54.5 * WidthCoefficient);
        }];
        
        scroll;
    });
    
    
    self.contentScroll = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topScroll.bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        UIView *content = [[UIView alloc] init];
        [scroll addSubview:content];
        [content makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.width.equalTo(scroll);
        }];
        
        self.statisticsView = [[UIView alloc] init];
        _statisticsView.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        _statisticsView.layer.cornerRadius = 2;
        _statisticsView.layer.masksToBounds = YES;
        _statisticsView.layer.shadowOffset = CGSizeMake(0, 6);
        _statisticsView.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _statisticsView.layer.shadowRadius = 7;
        _statisticsView.layer.shadowOpacity = 0.5;
        [content addSubview:_statisticsView];
        [_statisticsView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content).offset(7.5 * WidthCoefficient);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(355 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
        }];
        
        UIImageView *imgV0 = [[UIImageView alloc] init];
        imgV0.image = [UIImage imageNamed:@"里程_icon"];
        [self.statisticsView addSubview:imgV0];
        [imgV0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16 * WidthCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.top.equalTo(19 * WidthCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:15];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = NSLocalizedString(@"里程", nil);
        [self.statisticsView addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(30 * WidthCoefficient);
            make.height.equalTo(15 * WidthCoefficient);
            make.left.equalTo(imgV0.right).offset(5 * WidthCoefficient);
            make.centerY.equalTo(imgV0);
        }];
        
        self.mileageLabel = [[UILabel alloc] init];
        _mileageLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:38];
        _mileageLabel.textColor = [UIColor whiteColor];
        [self.statisticsView addSubview:_mileageLabel];
        [_mileageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgV0.bottom).offset(10 * WidthCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.height.equalTo(38 * WidthCoefficient);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:FontName size:15];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.statisticsView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(15 * WidthCoefficient);
            make.top.equalTo(20 * WidthCoefficient);
            make.right.equalTo(-20 * WidthCoefficient);
        }];
        
        NSArray<NSArray *> *stasTitles = @[
                                           @[NSLocalizedString(@"油耗", nil),
                                             NSLocalizedString(@"平均油耗", nil)],
                                           @[NSLocalizedString(@"汽车制动时间", nil),
                                             NSLocalizedString(@"疲劳驾驶提醒数", nil)],
                                           @[NSLocalizedString(@"ACC里程", nil),
                                             NSLocalizedString(@"急刹车", nil)],
                                           @[NSLocalizedString(@"急减速", nil),
                                             NSLocalizedString(@"急转弯", nil)]
                                           ];
        NSArray<NSArray *> *imgNames = @[
                                         @[@"油耗_icon",
                                           @"平均油耗_icon"],
                                         @[@"制动时间_icon",
                                           @"注意次数_icon"],
                                         @[@"acc里程_icon",
                                           @"急刹车_icon"],
                                         @[@"急减速_icon",
                                           @"急转弯_icon"]
                                         ];
        
        for (NSInteger i = 0; i < 8; i++) {
            NSInteger row = i / 2;
            NSInteger col = i % 2;
            
            //图标
            UIImageView *imgV = [[UIImageView alloc] init];
            imgV.image = [UIImage imageNamed:imgNames[row][col]];
            [self.statisticsView addSubview:imgV];
            [imgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(16 * WidthCoefficient);
                make.top.equalTo(self.mileageLabel.bottom).offset((31 + 63 * row) * WidthCoefficient);
                make.left.equalTo((20 + 172 * col) * WidthCoefficient);
            }];
            
            //条目名称
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentRight;
            label.text = stasTitles[row][col];
            label.font = [UIFont fontWithName:FontName size:15];
            label.textColor = [UIColor colorWithHexString:@"#999999"];
            [self.statisticsView addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(105 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.left.equalTo(imgV.right).offset(10 * WidthCoefficient);
                make.centerY.equalTo(imgV);
            }];
            
            //条目内容
            UILabel *label1 = [[UILabel alloc] init];
            label1.textAlignment = NSTextAlignmentRight;
            label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
            label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
            [self.statisticsView addSubview:label1];
            [label1 makeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(60 * WidthCoefficient);
                make.height.equalTo(16 * WidthCoefficient);
                make.top.equalTo(label.bottom).offset(10 * WidthCoefficient);
                make.right.equalTo(label);
            }];
            
            if (i == 0) {
                self.fuelTotalLabel = label1;
            } else if (i == 1) {
                self.fuelAverageLabel = label1;
            } else if (i == 2) {
                self.brakeTimeLabel = label1;
            } else if (i == 3) {
                self.attentionTimesLabel = label1;
            } else if (i == 4) {
                self.accMileageLabel = label1;
            } else if (i == 5) {
                self.harshBrakeLabel = label1;
            } else if (i == 6) {
                self.harshDecelerateLabel = label1;
            } else if (i == 7) {
                self.harshTurnLabel = label1;
            }
            
            //横向分割线
            if (col == 0) {
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
                [self.statisticsView addSubview:line];
                [line makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imgV);
                    make.bottom.equalTo(imgV.top).offset(-10 * WidthCoefficient);
                    make.width.equalTo(303 * WidthCoefficient);
                    make.height.equalTo(1 * WidthCoefficient);
                }];
                
                if (row == 0) {
                    //竖向分割线
                    UIView *verticalLine = [[UIView alloc] init];
                    verticalLine.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
                    [self.statisticsView addSubview:verticalLine];
                    [verticalLine makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(imgV.right).offset(135 * WidthCoefficient);
                        make.top.equalTo(line.bottom);
                        make.width.equalTo(1 * WidthCoefficient);
                        make.bottom.equalTo(0);
                    }];
                }
            }
            
        }
        
        self.chartMileageContainer = [[UIView alloc] init];
        _chartMileageContainer.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        _chartMileageContainer.layer.cornerRadius = 2;
        _chartMileageContainer.layer.masksToBounds = YES;
        _chartMileageContainer.layer.shadowOffset = CGSizeMake(0, 6);
        _chartMileageContainer.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _chartMileageContainer.layer.shadowRadius = 7;
        _chartMileageContainer.layer.shadowOpacity = 0.5;
        [content addSubview:_chartMileageContainer];
        [_chartMileageContainer makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statisticsView.bottom).offset(10 * WidthCoefficient);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(281 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
        }];
        
        UIView *redV1 = [[UIView alloc] init];
        redV1.layer.cornerRadius = 1.5;
        redV1.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
        [self.chartMileageContainer addSubview:redV1];
        [redV1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(3 * WidthCoefficient);
            make.height.equalTo(15 * WidthCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.top.equalTo(20.5 * WidthCoefficient);
        }];
        
        UILabel *title1 = [[UILabel alloc] init];
        title1.text = NSLocalizedString(@"月里程排名", nil);
        title1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        title1.textColor = [UIColor whiteColor];
        [self.chartMileageContainer addSubview:title1];
        [title1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redV1.right).offset(5 * WidthCoefficient);
            make.width.equalTo(96 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
            make.centerY.equalTo(redV1);
        }];
        
        UILabel *unitLabel1 = [[UILabel alloc] init];
        unitLabel1.font = [UIFont fontWithName:FontName size:13];
        unitLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
        unitLabel1.text = NSLocalizedString(@"单位:km", nil);
        [self.chartMileageContainer addSubview:unitLabel1];
        [unitLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20 * WidthCoefficient);
            make.top.equalTo(21.5 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
        }];
        
        UILabel *yTitleLabel1 = [[UILabel alloc] init];
        yTitleLabel1.font = [UIFont fontWithName:FontName size:10];
        yTitleLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
        yTitleLabel1.numberOfLines = 0;
        yTitleLabel1.lineBreakMode = NSLineBreakByWordWrapping;
        yTitleLabel1.text = NSLocalizedString(@"用户占比", nil);
        [self.chartMileageContainer addSubview:yTitleLabel1];
        [yTitleLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(10 * WidthCoefficient);
            make.height.equalTo(60 * WidthCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.top.equalTo(redV1.bottom).offset(15.5 * WidthCoefficient);
        }];
        
        self.chartFuelContainer = [[UIView alloc] init];
        _chartFuelContainer.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        _chartFuelContainer.layer.cornerRadius = 2;
        _chartFuelContainer.layer.masksToBounds = YES;
        _chartFuelContainer.layer.shadowOffset = CGSizeMake(0, 6);
        _chartFuelContainer.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
        _chartFuelContainer.layer.shadowRadius = 7;
        _chartFuelContainer.layer.shadowOpacity = 0.5;
        [content addSubview:_chartFuelContainer];
        [_chartFuelContainer makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chartMileageContainer.bottom).offset(10 * WidthCoefficient);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(281 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.bottom.equalTo(content).offset(-10 * WidthCoefficient);
        }];
        
        UIView *redV2 = [[UIView alloc] init];
        redV2.layer.cornerRadius = 1.5;
        redV2.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
        [self.chartFuelContainer addSubview:redV2];
        [redV2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(3 * WidthCoefficient);
            make.height.equalTo(15 * WidthCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.top.equalTo(20.5 * WidthCoefficient);
        }];
        
        UILabel *title2 = [[UILabel alloc] init];
        title2.text = NSLocalizedString(@"月油耗排名", nil);
        title2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        title2.textColor = [UIColor whiteColor];
        [self.chartFuelContainer addSubview:title2];
        [title2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redV2.right).offset(5 * WidthCoefficient);
            make.width.equalTo(96 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
            make.centerY.equalTo(redV2);
        }];
        
        UILabel *unitLabel2 = [[UILabel alloc] init];
        unitLabel2.font = [UIFont fontWithName:FontName size:13];
        unitLabel2.textColor = [UIColor colorWithHexString:@"#999999"];
        unitLabel2.text = NSLocalizedString(@"单位:L", nil);
        [self.chartFuelContainer addSubview:unitLabel2];
        [unitLabel2 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20 * WidthCoefficient);
            make.top.equalTo(21.5 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
        }];
        
        UILabel *yTitleLabel2 = [[UILabel alloc] init];
        yTitleLabel2.font = [UIFont fontWithName:FontName size:10];
        yTitleLabel2.textColor = [UIColor colorWithHexString:@"#999999"];
        yTitleLabel2.numberOfLines = 0;
        yTitleLabel2.lineBreakMode = NSLineBreakByWordWrapping;
        yTitleLabel2.text = NSLocalizedString(@"用户占比", nil);
        [self.chartFuelContainer addSubview:yTitleLabel2];
        [yTitleLabel2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(10 * WidthCoefficient);
            make.height.equalTo(60 * WidthCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.top.equalTo(redV2.bottom).offset(15.5 * WidthCoefficient);
        }];
        
        scroll;
    });
    
}


- (void)pullDefaultData {
    NSDate *startDate = [[NSDate date] dateByAddingMonths:-3];
    
    self.startTimeStamp = [self convertDateToTimestamp:startDate isStart:YES];
    self.endTimeStamp = [self convertDateToTimestamp:[NSDate date] isStart:NO];
    
    [self pullData];
}

- (void)pullData {
    
    self.reports = nil;
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    
    NSDictionary *paras = @{
                            @"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"],
                            //                            @"vin":@"LPAA4CDC4H2Z91859",
                            @"startTime":self.startTimeStamp,
                            @"endTime":self.endTimeStamp
                            };
    [CUHTTPRequest POST:getDrivingReportWeekURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            DrivingReportMonthResponse *response = [DrivingReportMonthResponse yy_modelWithJSON:dic];
            self.reports = response.data.record;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self configTopScrollWithReports:self.reports];
            });
            
        } else {
            [hud hideAnimated:YES];
            //            hud.label.text = dic[@"msg"];
            //            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)clear {
    self.mileageLabel.text = @"-";
    self.timeLabel.text = @"-";
    self.fuelTotalLabel.text = @"-";
    self.fuelAverageLabel.text = @"-";
    self.brakeTimeLabel.text = @"-";
    self.attentionTimesLabel.text = @"-";
    self.accMileageLabel.text = @"-";
    self.harshBrakeLabel.text = @"-";
    self.harshDecelerateLabel.text = @"-";
    self.harshTurnLabel.text = @"-";
}

- (void)configTopScrollWithReports:(NSArray<DrivingReportMonth *> *)reports {
    [self.topScroll removeAllSubviews];
    
    UIView *content = [[UIView alloc] init];
    [self.topScroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topScroll);
        make.height.equalTo(self.topScroll);
    }];
    
    UIButton *lastBtn;
    for (NSInteger i = 0; i < reports.count; i++) {
        DrivingReportMonth *report = reports[i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMM";
        formatter.timeZone = [NSTimeZone localTimeZone];
        NSDate *startDate = [formatter dateFromString:report.periodMonth];
        NSInteger month = startDate.month;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        btn.layer.cornerRadius = 2;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#120f0e"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ac0042"]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ac0042"]] forState:UIControlStateSelected | UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont fontWithName:FontName size:14];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"%ld月",(long)month] forState:UIControlStateNormal];
        [content addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            [self configWithReport:self.reports[0]];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(content).offset(16 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.width.equalTo(111 * WidthCoefficient);
                make.height.equalTo(32 * WidthCoefficient);
            }];
        } else {
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.right).offset(5 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.width.equalTo(111 * WidthCoefficient);
                make.height.equalTo(32 * WidthCoefficient);
            }];
        }
        
        UIView *shadowV = [[UIView alloc] init];
        shadowV.backgroundColor = [UIColor colorWithHexString:@"#040000"];
        shadowV.layer.shadowOffset = CGSizeMake(0, 6);
        shadowV.layer.shadowRadius = 7;
        shadowV.layer.shadowOpacity = 0.5;
        shadowV.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        [content addSubview:shadowV];
        [content insertSubview:shadowV belowSubview:btn];
        [shadowV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(btn);
        }];
        
        
        lastBtn = btn;
    }
    
    [lastBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content).offset(-16 * WidthCoefficient).with.priorityMedium;
    }];
}

- (void)configWithReport:(DrivingReportMonth *)report {
    
    [self clear];
    
    self.mileageLabel.text = [NSString stringWithFormat:@"%@km",report.mileage];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",report.periodMonth];
    self.fuelTotalLabel.text = [NSString stringWithFormat:@"%@ L",report.totalFuelConsumed];
    self.fuelAverageLabel.text = [NSString stringWithFormat:@"%@ L",report.averageFuelConsumed];
    self.brakeTimeLabel.text = [NSString stringWithFormat:@"%@ h",report.autoBrakeTimes];
    self.attentionTimesLabel.text = [NSString stringWithFormat:@"%@ 次",report.driverAttentionTimes];
    self.accMileageLabel.text = [NSString stringWithFormat:@"%@ km",report.accMileage];
    self.harshBrakeLabel.text = [NSString stringWithFormat:@"%@ 次",report.harshDecelerationTimes];
    self.harshDecelerateLabel.text = [NSString stringWithFormat:@"%@ 次",report.harshAccelerationTimes];
    self.harshTurnLabel.text = [NSString stringWithFormat:@"%@ 次",report.harshTurnTimes];
}

- (void)btnClick:(UIButton *)sender {
    if (sender != self.selectedBtn) {
        self.selectedBtn.selected = NO;
        sender.selected = !sender.selected;
        self.selectedBtn = sender;
        
        [self configWithReport:self.reports[sender.tag - 1000]];
    } else {
        
    }
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
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld%2ld",newDate.year,newDate.month];
    return timeStamp;
}


- (NSArray<DrivingReportMonth *> *)reports {
    if (!_reports) {
        _reports = [NSArray array];
    }
    return _reports;
}

@end
