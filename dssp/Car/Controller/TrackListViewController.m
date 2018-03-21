//
//  TrackListViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrackListViewController.h"
#import "TrackDetailViewController.h"
#import <FSCalendar.h>
#import "RangePickerCell.h"
#import <FSCalendarExtensions.h>
#import "TrackObject.h"
#import "TrackListHeaderView.h"
#import "TrackSingleCell.h"
#import <MJRefresh.h>
#import <NSObject+FBKVOController.h>
#import <UIScrollView+EmptyDataSet.h>

#define CalendarContainerHeight (kScreenHeight - kNaviHeight - 80 * WidthCoefficient)

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagCancel = 1000,
    ButtonTagOK,
};

@interface TrackListViewController () <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

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

@property (nonatomic, strong) NSMutableArray<TrackListSection *> *sections;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UILabel *filterStartLabel;
@property (nonatomic, strong) UILabel *filterEndLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *startTimeStamp;
@property (nonatomic, copy) NSString *endTimeStamp;

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation TrackListViewController

- (BOOL)needGradientBg {
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
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
    self.navigationItem.title = NSLocalizedString(@"行车日志", nil);
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    // Uncomment this to perform an 'initial-week-scope'
    self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    
    [self createTop];
    [self createTableView];
    [self pullDefaultData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.calendarContainer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"TrackListViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Statistics  staticsvisitTimesDataWithViewControllerType:@"TrackListViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"TrackListViewController"];
}

- (void)createTop {
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
    for (NSInteger i = 0; i < topTitles.count; i++) {
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
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(80 * WidthCoefficient, 0, 0, 0));
    }];
    
    [_tableView registerClass:[TrackSingleCell class] forCellReuseIdentifier:@"TrackSingleCell"];
    [_tableView registerClass:[TrackListHeaderView class] forHeaderFooterViewReuseIdentifier:@"TrackListHeaderView"];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDefaultData)];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendListData)];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    footer.hidden = YES;
    if (@available(iOS 11.0, *)) {
        if (Is_Iphone_X && self.tableView.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentAutomatic) {
            footer.maskView = [[UIView alloc] init];
            footer.maskView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
        }
    }
    footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
//    footer.stateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.tableView.mj_footer = footer;
    
    //处理iphoneX显示footer问题
    [self.KVOController observe:self.tableView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (@available(iOS 11.0, *)) {
            if (Is_Iphone_X && self.tableView.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentAutomatic) {
                CGFloat distanceToSafeBottom = (self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame) - self.view.safeAreaInsets.bottom) - self.tableView.contentSize.height;
                if (distanceToSafeBottom < 0) {
                    self.tableView.mj_footer.maskView.frame = CGRectZero;
                } else {
                    CGFloat showFooterHeight = distanceToSafeBottom;
                    if (showFooterHeight > CGRectGetHeight(self.tableView.mj_footer.bounds)) {
                        showFooterHeight = CGRectGetHeight(self.tableView.mj_footer.bounds);
                    }
                    if (self.tableView.mj_footer.state != MJRefreshStateRefreshing) {
                        self.tableView.mj_footer.maskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.mj_footer.bounds), showFooterHeight);
                    }
                }
            }
        }
    }];
    
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
    //默认拉取3个月数据
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-3];
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
    //清空
    self.currentPage = 1;
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    
    NSDictionary *paras = @{
//                            @"vin":@"VF7CAPSA000020154",
//                            @"startTime":@"1519367046000",
//                                         //1519888479.927832
//                            @"endTime":@"1519723342000",
                            @"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"],
                            @"startTime":self.startTimeStamp,
                            @"endTime":self.endTimeStamp,
                            @"pageNo":[NSString stringWithFormat:@"%ld",self.currentPage],
                            @"pageSize":@"10"
                            };
    [CUHTTPRequest POST:getTrackListURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            TrackListResponse *response = [TrackListResponse yy_modelWithJSON:dic];
            if (response.data.result.count) {
                self.currentPage++;
            }
            
            _tableView.emptyDataSetDelegate = self;
            _tableView.emptyDataSetSource = self;
            
            [self appendSections:response.data.result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"请求失败:%ld",code];
        [hud hideAnimated:YES afterDelay:1];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)appendListData {
    NSDictionary *paras = @{
//                            @"vin":@"VF7CAPSA000020154",
//                            @"startTime":@"1519367046000",
//                                         //1519888479.927832
//                            @"endTime":@"1519723342000",
                            @"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"],
                            @"startTime":self.startTimeStamp,
                            @"endTime":self.endTimeStamp,
                            @"pageNo":[NSString stringWithFormat:@"%ld",self.currentPage],
                            @"pageSize":@"10"
                            };
    [CUHTTPRequest POST:getTrackListURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            if (dic[@"data"] && ![dic[@"data"] isKindOfClass:[NSNull class]]) {
                TrackListResponse *response = [TrackListResponse yy_modelWithJSON:dic];
                if (response.data.result.count) {
                    [self appendSections:response.data.result];
                    self.currentPage++;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer endRefreshing];
                    [MBProgressHUD showText:NSLocalizedString(@"没有更多数据", nil)];
                });
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
                [MBProgressHUD showText:NSLocalizedString(@"获取数据出错", nil)];
            });
        }
    } failure:^(NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)appendSections:(NSArray<TrackListSection *> *)appendSections {
    if (self.sections.count) {
        NSString *lastDate = self.sections.lastObject.date;
        NSString *appendDate = appendSections[0].date;
        if (![lastDate isEqualToString:appendDate]) {
            [self.sections addObjectsFromArray:appendSections];
        } else {//需要拼接
            TrackListSection *lastSection = self.sections.lastObject;
            TrackListSection *appendFirstSection = appendSections[0];
            [lastSection.list addObjectsFromArray:appendFirstSection.list];
            [self.sections addObjectsFromArray:[appendSections subarrayWithRange:NSMakeRange(1, appendSections.count - 1)]];
        }
    } else {
        [self.sections addObjectsFromArray:appendSections];
    }
    
    if (self.sections.count) {
        self.tableView.mj_footer.hidden = NO;
    } else {
        self.tableView.mj_footer.hidden = YES;
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections[section].list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121 * WidthCoefficient;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackSingleCell *cell = (TrackSingleCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackSingleCell"];
    [cell configWithTrackInfo:self.sections[indexPath.section].list[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40 * WidthCoefficient;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TrackListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TrackListHeaderView"];
    [view configWithDate:self.sections[section].date];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackInfo *info = self.sections[indexPath.section].list[indexPath.row];
    TrackDetailViewController *vc = [[TrackDetailViewController alloc] initWithTrackInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    view.tintColor = [UIColor colorWithHexString:@"040000"];
//}

#pragma mark - DZNEmptyDataSetSource -

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = NSLocalizedString(@"暂无数据", nil);
//    UIFont *font = [UIFont fontWithName:FontName size:16];
//    UIColor *textColor = [UIColor colorWithHexString:@"999999"];
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"暂无内容"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - 30 * WidthCoefficient;
}

#pragma mark - DZNEmptyDataSetDelegate -

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointZero;
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-3];
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

- (NSMutableArray<TrackListSection *> *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

@end
