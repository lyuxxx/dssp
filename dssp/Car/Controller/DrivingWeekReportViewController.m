//
//  DrivingWeekReportViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingWeekReportViewController.h"
#import "DrivingReportObject.h"
#import "RankingObject.h"
#import "PNChart.h"
#import <YYText.h>
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>

#define JUDGE(_K) (_K ? _K : @"-")

@interface DrivingWeekReportViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIScrollViewDelegate>

//周报告入参
@property (nonatomic, copy) NSString *startTimeStamp;
@property (nonatomic, copy) NSString *endTimeStamp;

@property (nonatomic, strong) NSArray<DrivingReportWeek *> *reports;
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
//@property (nonatomic, strong) UILabel *brakeTimeLabel;
//@property (nonatomic, strong) UILabel *attentionTimesLabel;
//@property (nonatomic, strong) UILabel *accMileageLabel;
@property (nonatomic, strong) UILabel *harshBrakeLabel;
@property (nonatomic, strong) UILabel *harshAccelerateLabel;
//@property (nonatomic, strong) UILabel *harshTurnLabel;

@property (nonatomic, strong) RankingWeekRecordItem *mileageRanking;
@property (nonatomic, strong) RankingWeekRecordItem *fuelRanking;

@property (nonatomic, strong) PNLineChart *mileageChart;
@property (nonatomic, strong) PNLineChart *fuelChart;
@property (nonatomic, strong) UIImageView *mileageUserPoint;
@property (nonatomic, strong) UIImageView *fuelUserPoint;
@property (nonatomic, strong) YYLabel *mileageUserPercentLabel;
@property (nonatomic, strong) YYLabel *fuelUserPercentLabel;

///添加此属性的作用，根据差值，判断ScrollView是上滑还是下拉
@property (nonatomic, assign) NSInteger lastcontentOffset;
///用于记录空白占位图
@property (nonatomic, strong) UIView *emptyDataSetView;
///用于记录topScroll空白占位图
@property (nonatomic, strong) UIView *topEmptyView;

@end

@implementation DrivingWeekReportViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self clear];
    
    [self.contentScroll.mj_header beginRefreshing];
    
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
    
    self.topScroll = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.backgroundColor = [UIColor colorWithHexString:@"#040000"];
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
        scroll.delegate = self;
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
        
        UIView *shadowV0 = [[UIView alloc] init];
        shadowV0.layer.shadowOffset = CGSizeMake(0, 6);
        shadowV0.layer.shadowRadius = 7;
        shadowV0.layer.shadowOpacity = 0.5;
        shadowV0.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        [content addSubview:shadowV0];
        [shadowV0 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content).offset(7.5 * WidthCoefficient);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(229 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
        }];
        
        self.statisticsView = [[UIView alloc] init];
        _statisticsView.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        _statisticsView.layer.cornerRadius = 2;
        _statisticsView.layer.masksToBounds = YES;
        [shadowV0 addSubview:_statisticsView];
        [_statisticsView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(shadowV0);
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
        
//        NSArray<NSArray *> *stasTitles = @[
//                                @[NSLocalizedString(@"油耗", nil),
//                                  NSLocalizedString(@"平均油耗", nil)],
//                                @[NSLocalizedString(@"汽车制动时间", nil),
//                                  NSLocalizedString(@"疲劳驾驶提醒数", nil)],
//                                @[NSLocalizedString(@"ACC里程", nil),
//                                  NSLocalizedString(@"急刹车", nil)],
//                                @[NSLocalizedString(@"急加速", nil),
//                                  NSLocalizedString(@"急转弯", nil)]
//                                ];
//        NSArray<NSArray *> *imgNames = @[
//                                         @[@"油耗_icon",
//                                           @"平均油耗_icon"],
//                                         @[@"制动时间_icon",
//                                           @"注意次数_icon"],
//                                         @[@"acc里程_icon",
//                                           @"急刹车_icon"],
//                                         @[@"急加速_icon",
//                                           @"急转弯_icon"]
//                                         ];
        
        NSArray<NSArray *> *stasTitles = @[
                                           @[NSLocalizedString(@"油耗", nil),
                                             NSLocalizedString(@"平均油耗", nil)],
                                           @[NSLocalizedString(@"急刹车", nil),
                                             NSLocalizedString(@"急加速", nil)]
                                           ];
        NSArray<NSArray *> *imgNames = @[
                                         @[@"油耗_icon",
                                           @"平均油耗_icon"],
                                         @[@"急刹车_icon",
                                           @"急加速_icon"]
                                         ];
        
        for (NSInteger i = 0; i < 4; i++) {
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
                self.harshBrakeLabel = label1;
            } else {
                self.harshAccelerateLabel = label1;
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
        
        UIView *shadowV1 = [[UIView alloc] init];
        shadowV1.layer.shadowOffset = CGSizeMake(0, 6);
        shadowV1.layer.shadowRadius = 7;
        shadowV1.layer.shadowOpacity = 0.5;
        shadowV1.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        [content addSubview:shadowV1];
        [shadowV1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statisticsView.bottom).offset(10 * WidthCoefficient);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(281 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
        }];
        
        self.chartMileageContainer = [[UIView alloc] init];
        _chartMileageContainer.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        _chartMileageContainer.layer.cornerRadius = 2;
        _chartMileageContainer.layer.masksToBounds = YES;
        [shadowV1 addSubview:_chartMileageContainer];
        [_chartMileageContainer makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(shadowV1);
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
        title1.text = NSLocalizedString(@"周里程排名", nil);
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
        unitLabel1.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        unitLabel1.font = [UIFont fontWithName:FontName size:10];
        unitLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
        unitLabel1.text = NSLocalizedString(@"单位:km", nil);
        [self.chartMileageContainer addSubview:unitLabel1];
        [unitLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-17 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
            make.width.equalTo(41 * WidthCoefficient);
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
            make.top.equalTo(redV1.bottom).offset(76 * WidthCoefficient);
        }];
        
        UIView *shadowV2 = [[UIView alloc] init];
        shadowV2.layer.shadowOffset = CGSizeMake(0, 6);
        shadowV2.layer.shadowRadius = 7;
        shadowV2.layer.shadowOpacity = 0.5;
        shadowV2.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        [content addSubview:shadowV2];
        [shadowV2 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chartMileageContainer.bottom).offset(10 * WidthCoefficient);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(281 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.bottom.equalTo(content).offset(-10 * WidthCoefficient);
        }];
        
        self.chartFuelContainer = [[UIView alloc] init];
        _chartFuelContainer.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        _chartFuelContainer.layer.cornerRadius = 2;
        _chartFuelContainer.layer.masksToBounds = YES;
        [shadowV2 addSubview:_chartFuelContainer];
        [_chartFuelContainer makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(shadowV2);
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
        title2.text = NSLocalizedString(@"周平均油耗排名", nil);
        title2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        title2.textColor = [UIColor whiteColor];
        [self.chartFuelContainer addSubview:title2];
        [title2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(redV2.right).offset(5 * WidthCoefficient);
            make.height.equalTo(16 * WidthCoefficient);
            make.centerY.equalTo(redV2);
        }];
        
        UILabel *unitLabel2 = [[UILabel alloc] init];
        unitLabel2.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        unitLabel2.numberOfLines = 0;
        unitLabel2.font = [UIFont fontWithName:FontName size:10];
        unitLabel2.textColor = [UIColor colorWithHexString:@"#999999"];
        unitLabel2.text = NSLocalizedString(@"单位:\nL/百公里", nil);
        [self.chartFuelContainer addSubview:unitLabel2];
        [unitLabel2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-10 * WidthCoefficient);
            make.height.equalTo(28 * WidthCoefficient);
//            make.width.equalTo(50 * WidthCoefficient);
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
            make.top.equalTo(redV2.bottom).offset(76 * WidthCoefficient);
        }];
        
        scroll;
    });
    
    
    self.contentScroll.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDefaultData)];
}

- (void)pullDefaultData {
    NSDate *startDate = [[NSDate date] dateByAddingMonths:-6];
    
    self.startTimeStamp = [self convertDateToTimestamp:startDate isStart:YES];
    self.endTimeStamp = [self convertDateToTimestamp:[NSDate date] isStart:NO];
    
    [self pullData];
}

- (void)pullData {
    
    self.reports = nil;
    
    NSDictionary *paras = @{
                            @"vin":kVin,
                            @"startTime":self.startTimeStamp,
                            @"endTime":self.endTimeStamp
                            };
    [CUHTTPRequest POST:getDrivingReportWeekURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            DrivingReportWeekResponse *response = [DrivingReportWeekResponse yy_modelWithJSON:dic];
            self.reports = response.data.record;
            
            if (self.reports.count) {
                [self hideEmptyDataSet];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self configTopScrollWithReports:self.reports];
                });
            } else {
                [self.contentScroll.mj_header endRefreshing];
                [self showEmptyDataSet];
            }
            
        } else {
            [self.contentScroll.mj_header endRefreshing];
            [self showEmptyDataSet];
        }
    } failure:^(NSInteger code) {
        [self.contentScroll.mj_header endRefreshing];
        [self showEmptyDataSet];
    }];
}

- (void)pullRankingWithReport:(DrivingReportWeek *)report {
    
    [MBProgressHUD showMessage:@""];
    
    self.mileageRanking = nil;
    self.fuelRanking = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSString *startStr = report.startDate;
    NSString *endStr = report.endDate;
    NSString *startPara = [self convertDateToTimestamp:[dateFormatter dateFromString:startStr] isStart:YES];
    NSString *endPara = [self convertDateToTimestamp:[dateFormatter dateFromString:endStr] isStart:NO];
    
    
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_queue_create("ranking", NULL);
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        [CUHTTPRequest GET:[NSString stringWithFormat:@"%@/%@/%@/%@/brand",getRankingMileageWeekURL,kVin,startPara,endPara] parameters:nil success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] isEqualToString:@"200"]) {
                RankingWeekResponse *response = [RankingWeekResponse yy_modelWithJSON:dic];
                self.mileageRanking = response.data.record[0];
                
                dispatch_semaphore_signal(sem);
            } else {
                dispatch_semaphore_signal(sem);
            }
        } failure:^(NSInteger code) {
            dispatch_semaphore_signal(sem);
        }];
    });
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        [CUHTTPRequest GET:[NSString stringWithFormat:@"%@/%@/%@/%@/brand",getRankingFuelWeekURL,kVin,startPara,endPara] parameters:nil success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] isEqualToString:@"200"]) {
                RankingWeekResponse *response = [RankingWeekResponse yy_modelWithJSON:dic];
                self.fuelRanking = response.data.record[0];
                
                dispatch_semaphore_signal(sem);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateChart];
                });
                
            } else {
                dispatch_semaphore_signal(sem);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateChart];
                });
                
            }
        } failure:^(NSInteger code) {
            dispatch_semaphore_signal(sem);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateChart];
            });
            
        }];
    });

}

- (void)updateChart {
    
    [self updateMileageChart];
    
    [self updateFuelChart];
    
    [MBProgressHUD hideHUD];
    
    [self.contentScroll.mj_header endRefreshing];
}

- (void)updateMileageChart {
    //里程排名表
    [self.mileageChart removeFromSuperview];
    self.mileageChart = nil;
    [self.mileageUserPercentLabel removeFromSuperview];
    self.mileageUserPercentLabel = nil;
    
    self.mileageChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 51 * WidthCoefficient, 343 * WidthCoefficient, 210 * WidthCoefficient)];
    [self.chartMileageContainer addSubview:self.mileageChart];
    self.mileageChart.userInteractionEnabled = NO;
    self.mileageChart.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    self.mileageChart.axisColor = [UIColor colorWithHexString:@"#2f2726"];
    self.mileageChart.xLabelColor = [UIColor colorWithHexString:@"#999999"];
    self.mileageChart.showCoordinateAxis = YES;
    //    self.mileageChart.yLabelFormat = @"%1.1f";
    self.mileageChart.xLabelFont = [UIFont fontWithName:FontName size:10];
    [self.mileageChart setXLabels:self.mileageRanking.xLabels];
    self.mileageChart.showGenYLabels = NO;
    self.mileageChart.showYGridLines = NO;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.mileageChart.yFixedValueMax = 100;
    self.mileageChart.yFixedValueMin = 0.0;
    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = [UIColor colorWithHexString:@"#2687ee"];
    data01.lineWidth = 3;
    data01.alpha = 0.3f;
    data01.showPointLabel = NO;
    data01.itemCount = self.mileageRanking.yData.count;
    data01.inflexionPointStyle = PNLineChartPointStyleNone;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [self.mileageRanking.yData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.mileageChart.chartData = @[data01];
    //    [self.mileageChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
    //        obj.pointLabelColor = [UIColor blackColor];
    //    }];
    self.mileageChart.displayAnimated = NO;
    self.mileageChart.showSmoothLines = YES;
    
    [self.mileageChart strokeChart];
    
    if (self.mileageRanking) {
        CGPoint p = [((NSArray *)self.mileageChart.pathPoints[0])[self.mileageRanking.userIndex] CGPointValue];
        self.mileageUserPoint.frame = CGRectMake(p.x - 8, p.y - 8, 16, 16);
        //        [self.lineChart strokeChart];
        [self.mileageChart addSubview:self.mileageUserPoint];
        [self.mileageChart bringSubviewToFront:self.mileageUserPoint];
    }
    
    [self.chartMileageContainer addSubview:self.mileageChart];
    [self.chartMileageContainer insertSubview:self.mileageChart atIndex:0];
    
    self.mileageUserPercentLabel = [[YYLabel alloc] init];
    _mileageUserPercentLabel.backgroundColor = [UIColor colorWithRed:47.0/255.0 green:39.0/255.0 blue:38.0/255.0 alpha:0.5];
    NSString *oriStr = [NSString stringWithFormat:@"您本周里程超过了%.0f%%的用户",self.mileageRanking.mileagePercent];
    NSRange range = [oriStr rangeOfString:[NSString stringWithFormat:@"%.0f%%",self.mileageRanking.mileagePercent]];
    NSMutableAttributedString *userPercent = [[NSMutableAttributedString alloc] initWithString:oriStr];
    userPercent.yy_alignment = NSTextAlignmentCenter;
    userPercent.yy_font = [UIFont fontWithName:FontName size:13];
    userPercent.yy_color = [UIColor colorWithHexString:@"#999999"];
    [userPercent yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
    [userPercent yy_setColor:[UIColor colorWithHexString:@"#e2cd8d"] range:range];
    _mileageUserPercentLabel.attributedText = userPercent;
    if (!_mileageRanking) {
        _mileageUserPercentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"暂无数据", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:FontName size:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
        _mileageUserPercentLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self.chartMileageContainer addSubview:_mileageUserPercentLabel];
    [_mileageUserPercentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(201.5 * WidthCoefficient);
        make.height.equalTo(36 * WidthCoefficient);
        make.right.equalTo(-20 * WidthCoefficient);
        make.top.equalTo(51 * WidthCoefficient);
    }];
}

- (void)updateFuelChart {
    //油耗排名表
    [self.fuelChart removeFromSuperview];
    self.fuelChart = nil;
    [self.fuelUserPercentLabel removeFromSuperview];
    self.fuelUserPercentLabel = nil;
    
    self.fuelChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 51 * WidthCoefficient, 343 * WidthCoefficient, 210 * WidthCoefficient)];
    [self.chartFuelContainer addSubview:self.fuelChart];
    self.fuelChart.userInteractionEnabled = NO;
    self.fuelChart.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    self.fuelChart.axisColor = [UIColor colorWithHexString:@"#2f2726"];
    self.fuelChart.xLabelColor = [UIColor colorWithHexString:@"#999999"];
    self.fuelChart.showCoordinateAxis = YES;
    //    self.mileageChart.yLabelFormat = @"%1.1f";
    self.fuelChart.xLabelFont = [UIFont fontWithName:FontName size:10];
    [self.fuelChart setXLabels:self.fuelRanking.xLabels];
    self.fuelChart.showGenYLabels = NO;
    self.fuelChart.showYGridLines = NO;
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    self.fuelChart.yFixedValueMax = 100;
    self.fuelChart.yFixedValueMin = 0.0;
    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = [UIColor colorWithHexString:@"ea764d"];
    data01.lineWidth = 3;
    data01.alpha = 0.3f;
    data01.showPointLabel = NO;
    data01.itemCount = self.fuelRanking.yData.count;
    data01.inflexionPointStyle = PNLineChartPointStyleNone;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [self.fuelRanking.yData[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.fuelChart.chartData = @[data01];
    //    [self.fuelChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
    //        obj.pointLabelColor = [UIColor blackColor];
    //    }];
    self.fuelChart.displayAnimated = NO;
    self.fuelChart.showSmoothLines = YES;
    
    [self.fuelChart strokeChart];
    
    if (self.fuelRanking) {
        CGPoint p = [((NSArray *)self.fuelChart.pathPoints[0])[self.fuelRanking.userIndex] CGPointValue];
        self.fuelUserPoint.frame = CGRectMake(p.x - 8, p.y - 8, 16, 16);
        //        [self.lineChart strokeChart];
        [self.fuelChart addSubview:self.fuelUserPoint];
        [self.fuelChart bringSubviewToFront:self.fuelUserPoint];
    }
    
    [self.chartFuelContainer addSubview:self.fuelChart];
    [self.chartFuelContainer insertSubview:self.fuelChart atIndex:0];
    
    self.fuelUserPercentLabel = [[YYLabel alloc] init];
    _fuelUserPercentLabel.backgroundColor = [UIColor colorWithRed:47.0/255.0 green:39.0/255.0 blue:38.0/255.0 alpha:0.5];
    NSString *oriStr = [NSString stringWithFormat:@"您本周油耗超过了%.0f%%的用户",self.fuelRanking.fuelPercent];
    NSRange range = [oriStr rangeOfString:[NSString stringWithFormat:@"%.0f%%",self.fuelRanking.fuelPercent]];
    NSMutableAttributedString *userPercent = [[NSMutableAttributedString alloc] initWithString:oriStr];
    userPercent.yy_alignment = NSTextAlignmentCenter;
    userPercent.yy_font = [UIFont fontWithName:FontName size:13];
    userPercent.yy_color = [UIColor colorWithHexString:@"#999999"];
    [userPercent yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
    [userPercent yy_setColor:[UIColor colorWithHexString:@"#e2cd8d"] range:range];
    _fuelUserPercentLabel.attributedText = userPercent;
    if (!_fuelRanking) {
        _fuelUserPercentLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"暂无数据", nil) attributes:@{NSFontAttributeName:[UIFont fontWithName:FontName size:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
        _fuelUserPercentLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self.chartFuelContainer addSubview:_fuelUserPercentLabel];
    [_fuelUserPercentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(201.5 * WidthCoefficient);
        make.height.equalTo(36 * WidthCoefficient);
        make.right.equalTo(-20 * WidthCoefficient);
        make.top.equalTo(51 * WidthCoefficient);
    }];
}

- (void)clear {
    self.mileageLabel.text = @"-";
    self.timeLabel.text = @"-";
    self.fuelTotalLabel.text = @"-";
    self.fuelAverageLabel.text = @"-";
//    self.brakeTimeLabel.text = @"-";
//    self.attentionTimesLabel.text = @"-";
//    self.accMileageLabel.text = @"-";
    self.harshBrakeLabel.text = @"-";
    self.harshAccelerateLabel.text = @"-";
//    self.harshTurnLabel.text = @"-";
}

- (void)configTopScrollWithReports:(NSArray<DrivingReportWeek *> *)reports {
    [self.topScroll removeAllSubviews];
    
    UIView *content = [[UIView alloc] init];
    [self.topScroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topScroll);
        make.height.equalTo(self.topScroll);
    }];
    
    UIButton *lastBtn;
    for (NSInteger i = 0; i < reports.count; i++) {
        DrivingReportWeek *report = reports[i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        formatter.timeZone = [NSTimeZone localTimeZone];
        NSDate *startDate = [formatter dateFromString:report.startDate];
        NSInteger weekOfYear = startDate.weekOfYear;
        
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
        [btn setTitle:[NSString stringWithFormat:@"第%ld周",(long)weekOfYear] forState:UIControlStateNormal];
        [content addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            [self configWithReport:self.reports[0]];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(content).offset(16 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.width.equalTo(82 * WidthCoefficient);
                make.height.equalTo(32 * WidthCoefficient);
            }];
        } else {
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.right).offset(5 * WidthCoefficient);
                make.top.equalTo(15 * WidthCoefficient);
                make.width.equalTo(82 * WidthCoefficient);
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

- (void)configWithReport:(DrivingReportWeek *)report {
    
    [self clear];
    
    self.mileageLabel.text = [NSString stringWithFormat:@"%@km",JUDGE(report.mileage)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",report.startDate ? report.startDate : @"",report.endDate ? report.endDate : @""];
    self.fuelTotalLabel.text = [NSString stringWithFormat:@"%@ L",JUDGE(report.totalFuelConsumed)];
    self.fuelAverageLabel.text = [NSString stringWithFormat:@"%@ L/百公里",JUDGE(report.averageFuelConsumed)];
//    self.brakeTimeLabel.text = [NSString stringWithFormat:@"%@ h",report.autoBrakeTimes];
//    self.attentionTimesLabel.text = [NSString stringWithFormat:@"%@ 次",report.driverAttentionTimes];
//    self.accMileageLabel.text = [NSString stringWithFormat:@"%@ km",report.accMileage];
    self.harshBrakeLabel.text = [NSString stringWithFormat:@"%@ 次",JUDGE(report.harshDecelerationTimes)];
    self.harshAccelerateLabel.text = [NSString stringWithFormat:@"%@ 次",JUDGE(report.harshAccelerationTimes)];
//    self.harshTurnLabel.text = [NSString stringWithFormat:@"%@ 次",report.harshTurnTimes];
    
    [self pullRankingWithReport:report];
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
    
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",interval * 1000];
    return timeStamp;
}

- (void)showEmptyDataSet {
    
    if (self.topEmptyView) {
        [self.topEmptyView removeFromSuperview];
        self.topEmptyView = nil;
    }
    self.topEmptyView = [[UIView alloc] init];
    self.topEmptyView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    [self.topScroll addSubview:self.topEmptyView];
    [self.topEmptyView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topScroll);
    }];
    
    self.contentScroll.emptyDataSetSource = self;
    self.contentScroll.emptyDataSetDelegate = self;
    [self.contentScroll reloadEmptyDataSet];
    for (UIView *view in self.contentScroll.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"DZNEmptyDataSetView")]) {
            self.emptyDataSetView = view;
            self.emptyDataSetView.hidden = NO;
            self.emptyDataSetView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
            break;
        }
    }
}

- (void)hideEmptyDataSet {
    
    if (self.topEmptyView) {
        [self.topEmptyView removeFromSuperview];
        self.topEmptyView = nil;
    }
    
    if (self.emptyDataSetView) {
        self.emptyDataSetView.hidden = YES;
    }
}

#pragma mark - DZNEmptyDataSetSource -

//- (NSAttributedString *)titleF                                                                                    orEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = NSLocalizedString(@"暂无订单", nil);
//    UIFont *font = [UIFont fontWithName:FontName size:16];
//    UIColor *textColor = [UIColor colorWithHexString:@"999999"];
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"暂无数据"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - 30 * WidthCoefficient;
}

#pragma mark - DZNEmptyDataSetDelegate -

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.contentOffset = CGPointZero;
    }];
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hight = scrollView.frame.size.height;
    CGFloat contentOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - self.lastcontentOffset;
    self.lastcontentOffset = contentOffset;
    
    if (offset > 0 && contentOffset > 0) {
        NSLog(@"上拉行为");
        if (scrollView.emptyDataSetVisible) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
    if (offset < 0 && distanceFromBottom > hight) {
        NSLog(@"下拉行为");
    }
    if (contentOffset == 0) {
        NSLog(@"滑动到顶部");
    }
    if (distanceFromBottom < hight) {
        NSLog(@"滑动到底部");
    }
}

- (NSArray<DrivingReportWeek *> *)reports {
    if (!_reports) {
        _reports = [NSArray array];
    }
    return _reports;
}

- (UIImageView *)mileageUserPoint {
    if (!_mileageUserPoint) {
        _mileageUserPoint = [[UIImageView alloc] init];
        _mileageUserPoint.image = [UIImage imageNamed:@"用户排名位置"];
    }
    return _mileageUserPoint;
}

- (UIImageView *)fuelUserPoint {
    if (!_fuelUserPoint) {
        _fuelUserPoint = [[UIImageView alloc] init];
        _fuelUserPoint.image = [UIImage imageNamed:@"用户排名位置"];
    }
    return _fuelUserPoint;
}

@end
