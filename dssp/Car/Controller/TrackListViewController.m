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
#import <MGSwipeTableCell.h>

#define CalendarContainerHeight (kScreenHeight - kNaviHeight - 80 * WidthCoefficient)

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagCancel = 1000,
    ButtonTagOK,
};

@interface TrackListViewController () <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, MGSwipeTableCellDelegate>

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
@property (nonatomic, strong) NSMutableArray<TrackInfo *> *selectedDatas;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *filterStartLabel;
@property (nonatomic, strong) UILabel *filterEndLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

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
    [self setupFooter];
    [self createBtns];
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
    self.topView = topV;
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
    [self.view addSubview:self.tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(80 * WidthCoefficient, 0, 0, 0));
    }];
    
    [self setupFooter];
    
}

- (void)setupFooter {
    
    if (!self.tableView.mj_header) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullData)];
    }
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendListData)];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    if (!self.sections.count) {
        footer.hidden = YES;
    }
    if (@available(iOS 11.0, *)) {
        if (Is_Iphone_X && self.tableView.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
            footer.maskView = [[UIView alloc] init];
            footer.maskView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
        }
    }
    footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
    //    footer.stateLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = footer;
    }
    [self.KVOController unobserve:self.tableView];
    //处理iphoneX显示footer问题
    [self.KVOController observe:self.tableView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (@available(iOS 11.0, *)) {
            if (Is_Iphone_X && self.tableView.contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever) {
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

- (void)createBtns {
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [_editBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateSelected];
    [_editBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_editBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    [_editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
    }];
    _editBtn.enabled = NO;
    
    UIView *botView = [[UIView alloc] init];
    //    botView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    [self.view addSubview:botView];
    [botView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.bottom);
        make.height.equalTo(60 * WidthCoefficient + kBottomHeight);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#2f2726"];
    [botView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.equalTo(botView);
        //        make.bottom.equalTo(botView.top);
        make.top.left.right.equalTo(botView);
        make.height.equalTo(0.5 * WidthCoefficient);
    }];
    
    [botView addSubview:self.deleteBtn];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(botView);
        make.top.equalTo(line.bottom);
        make.right.equalTo(botView);
        make.width.equalTo(100 * WidthCoefficient);
        make.height.equalTo(59.5 * WidthCoefficient);
    }];
    
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _allBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_allBtn setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
    [_allBtn setTitle:NSLocalizedString(@"取消全选", nil) forState:UIControlStateSelected];
    [_allBtn setImage:[UIImage imageNamed:@"selected_empty"] forState:UIControlStateNormal];
    [_allBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_allBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [_allBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:self.allBtn];
    [self.allBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(botView).offset(18 * WidthCoefficient);
        make.height.equalTo(24 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.width.equalTo(130 * WidthCoefficient);
    }];
    _allBtn.titleEdgeInsets = UIEdgeInsetsMake(10 * WidthCoefficient, 10 * WidthCoefficient, 10 * WidthCoefficient, 0);
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

#pragma mark - 显示和隐藏 删除按钮
- (void)showDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-60 * WidthCoefficient - kBottomHeight);
    }];
    
    // 更新约束
    [self updateConstraints];
}

- (void)hideDeleteButton
{
    [self.deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
    }];
    
    // 更新约束
    [self updateConstraints];
}

// 更新布局
- (void)updateConstraints
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 删除功能相关事件 -
//删除相关按钮事件
- (void)btnsClick:(UIButton *)sender {
    if (sender == _editBtn) {
        sender.selected = !sender.selected;
        if (sender.isSelected) {//编辑
            
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
            self.topView.userInteractionEnabled = NO;
            
            // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
            [self.tableView reloadData];
            
            [self.tableView setEditing:YES animated:YES];
            
            _allBtn.selected = NO;
            
            [self showDeleteButton];
            
            if (Is_Iphone_X) {
                _tableView.contentInset = UIEdgeInsetsZero;
                _tableView.scrollIndicatorInsets = _tableView.contentInset;
            }
            
        } else {//完成
            self.topView.userInteractionEnabled = YES;
            
            if (Is_Iphone_X) {
                _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomHeight, 0);
                _tableView.scrollIndicatorInsets = _tableView.contentInset;
            }
            
            [self.selectedDatas removeAllObjects];
            
            [self.tableView setEditing:NO animated:YES];
            
            [self hideDeleteButton];
            
            [self setupFooter];
            
        }
    }
    if (sender == _allBtn) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            // 全选
            for (NSInteger i = 0 ; i < self.sections.count; i++)
            {
                TrackListSection *section = self.sections[i];
                for (NSInteger j = 0; j < section.list.count; j++) {
                    TrackInfo *item = section.list[j];
                    if (![self.selectedDatas containsObject:item]) {
                        [self.selectedDatas addObject:item];
                    }
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
            }
        } else {
            // 取消全选
            for (NSInteger i = 0 ; i < self.sections.count; i++)
            {
                TrackListSection *section = self.sections[i];
                for (NSInteger j = 0; j < section.list.count; j++) {
                    TrackInfo *item = section.list[j];
                    if ([self.selectedDatas containsObject:item]) {
                        [self.selectedDatas removeObject:item];
                    }
                    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:YES];
                }
            }
        }
        
        [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
    }
    if (sender == _deleteBtn) {
        [self deleteSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    }
}

// delete
- (void)deleteSelectIndexPaths:(NSArray *)indexPaths
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //修改message的内容，字号，颜色。使用的key值是“attributedMessage"
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"是否要删除这些轨迹记录?"];
    [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [[message string] length])];
    [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#040000"] range:NSMakeRange(0, [[message string] length])];
    [alertController setValue:message forKey:@"attributedMessage"];
    
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *idStr = @"";
        NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:self.selectedDatas.count];
        for (TrackInfo *item in self.selectedDatas) {
            [idArr addObject:item.properties.tripId];
        }
        idStr = [idArr componentsJoinedByString:@","];
        
        [CUHTTPRequest POST:deletePoiFavoritesService parameters:@{@"id":idStr} success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"200"]) {
                // 删除数据源
                for (NSInteger i = 0; i < self.sections.count; i++) {
                    TrackListSection *section = self.sections[i];
                    [section.list removeObjectsInArray:self.selectedDatas];
                }
                [self.selectedDatas removeAllObjects];
                
                //    [UIView setAnimationsEnabled:NO];
                // 删除选中项
                //    [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                //    [self.tableView endUpdates];
                //    [UIView setAnimationsEnabled:YES];
                
                // 验证数据源
                [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
                
                // 验证
                // 没有
                if ([self trackInfoAllCount] == 0)
                {
                    //没有收藏数据
                    
                    if(self.editBtn.selected)
                    {
                        // 编辑状态 -- 取消编辑状态
                        [self btnsClick:self.editBtn];
                    }
                    
                    self.editBtn.enabled = NO;
                    
                }
                
                [self setupFooter];
            }
        } failure:^(NSInteger code) {
            
        }];
    }];
    [defaultAction setValue:[UIColor colorWithHexString:@"#ac0042"] forKey:@"titleTextColor"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [cancelAction setValue:[UIColor colorWithHexString:@"#040000"] forKey:@"titleTextColor"];
    
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction];
    
    //修改背景色
    UIView *subview = alertController.view.subviews.firstObject;
    UIView *alertContentView = subview.subviews.firstObject;
    alertContentView.backgroundColor = [UIColor whiteColor];
    alertContentView.layer.cornerRadius = 15;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//更新删除按钮
- (void)indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = [self trackInfoAllCount];
    self.allBtn.selected = (currentCount == allCount);
    NSString *title = (currentCount > 0) ? [NSString stringWithFormat:@"删除(%zd)",currentCount] : @"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount > 0;
}

- (NSInteger)trackInfoAllCount {
    NSInteger count = 0;
    for (NSInteger i = 0; i < self.sections.count; i++) {
        TrackListSection *section = self.sections[i];
        count += section.list.count;
    }
    return count;
}

#pragma mark - 非删除功能相关事件 -

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
    //默认拉取1个月数据
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
    //清空
    self.currentPage = 1;
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    
    NSDictionary *paras = @{
//                            @"vin":@"LPAA5CJC4H2Z91846",
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
            
            [self.sections removeAllObjects];
            [self appendSections:response.data.result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            });
            
            if (self.sections.count) {
                self.editBtn.enabled = YES;
            } else {
                self.editBtn.enabled = NO;
            }
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)appendListData {
    NSDictionary *paras = @{
//                            @"vin":@"LPAA5CJC4H2Z91846",
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
    cell.delegate = self;
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
    if (tableView.isEditing) {
        TrackInfo *item = self.sections[indexPath.section].list[indexPath.row];
        if (![self.selectedDatas containsObject:item]) {
            [self.selectedDatas addObject:item];
        }
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    } else {
        TrackInfo *info = self.sections[indexPath.section].list[indexPath.row];
        TrackDetailViewController *vc = [[TrackDetailViewController alloc] initWithTrackInfo:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    {
        if (tableView.isEditing) {
            TrackInfo *item = self.sections[indexPath.section].list[indexPath.row];
            if ([self.selectedDatas containsObject:item]) {
                [self.selectedDatas removeObject:item];
            }
            
            [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        }
        
    }
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    view.tintColor = [UIColor colorWithHexString:@"040000"];
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        // 删除
        return UITableViewCellEditingStyleNone;
    }
}
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        TrackInfo *item = self.sections[indexPath.section].list[indexPath.row];
        if (![self.selectedDatas containsObject:item]) {
            [self.selectedDatas addObject:item];
        }
        [self deleteSelectIndexPaths:@[indexPath]];
    }
}

#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *tmp = [self.tableView indexPathForCell:cell];
    TrackInfo *item = self.sections[tmp.section].list[tmp.row];
    if (![self.selectedDatas containsObject:item]) {
        [self.selectedDatas addObject:item];
    }
    [self deleteSelectIndexPaths:@[[self.tableView indexPathForCell:cell]]];
    return YES;
}

- (NSArray<UIView *> *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionClipCenter;
        //            expansionSettings.buttonIndex = 0;
        //            expansionSettings.fillOnTrigger = YES;
        return @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"delete_icon"] backgroundColor:[UIColor clearColor] insets:UIEdgeInsetsMake(0, 16 * WidthCoefficient, 0, 25 * WidthCoefficient)]];
    } else {
        return nil;
    }
}

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
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.contentOffset = CGPointZero;
    }];
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

#pragma mark - lazy load -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            if (Is_Iphone_X) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomHeight, 0);
                _tableView.scrollIndicatorInsets = _tableView.contentInset;
            }
        } else {
            // Fallback on earlier versions
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        //        _tableView.allowsMultipleSelection = YES;
        //        _tableView.allowsSelectionDuringEditing = YES;
        //        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[TrackSingleCell class] forCellReuseIdentifier:@"TrackSingleCell"];
        [_tableView registerClass:[TrackListHeaderView class] forHeaderFooterViewReuseIdentifier:@"TrackListHeaderView"];
    }
    return _tableView;
}

- (NSMutableArray<TrackListSection *> *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (NSMutableArray<TrackInfo *> *)selectedDatas {
    if (!_selectedDatas) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ac0042"]] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_deleteBtn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.enabled = NO;
        
    }
    return _deleteBtn;
}

@end
