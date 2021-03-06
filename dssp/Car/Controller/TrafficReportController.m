//
//  TrafficReportdatailController.m
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrafficReportController.h"
#import "TrafficReportdatailCell.h"
#import "TrafficReportModel.h"
#import "NSArray+Sudoku.h"

@interface TrafficReportController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger openSection;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellArray1;
@property (nonatomic, strong) NSMutableArray *cellArray2;
@property (nonatomic, strong) NSMutableArray *cellArray3;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *imgArrays;
@property (nonatomic, strong) NSMutableArray *imgArray1;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *isExpland;
@property (nonatomic, strong) NSMutableArray *cArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImageView *rightimageView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *employflowlabel;
@property (nonatomic, strong) UILabel *flowlabel;
@property (nonatomic, strong) UILabel *totalflowlabel;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) UIButton *seeBtn;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIImageView *bgImgV1;
@property (nonatomic,strong) TrafficReporData  *trafficReporData;
@property (nonatomic, assign) BOOL isDo;

@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) NSMutableArray<RecordItems *> *dataSource;
//@property (nonatomic, strong) RecordItem *recordItem;
@property (nonatomic,strong) NSMutableDictionary *result;
@end

@implementation TrafficReportController
static NSString *const cellID = @"cell";


- (BOOL)needGradientBg {
    return YES;
}

- (NSMutableArray<RecordItems *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车况报告";
    _isDo = NO;
    openSection = -1;
//
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
////     [self.view addSubview:self.tableView];
     [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"TrafficReportController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics staticsvisitTimesDataWithViewControllerType:@"TrafficReportController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"TrafficReportController"];
}

-(void)requestData
{
    
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", queryTheVehicleHealthReportForLatestSevenDays,kVin];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:@{} success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            _trafficReporData =[TrafficReporData yy_modelWithDictionary:dic[@"data"]];
            if (!_trafficReporData) {
                [self blankUI];
            } else {
                self.imgArray = [NSMutableArray array];
                self.imgArray1 = [NSMutableArray array];
                self.result = [NSMutableDictionary new];
                NSMutableArray *vehicleSystem =[NSMutableArray array];
                NSMutableArray *alertPriority =[NSMutableArray array];
                
                if ( _trafficReporData.healthAlerts != nil && ![ _trafficReporData.healthAlerts isKindOfClass:[NSNull class]] &&  _trafficReporData.healthAlerts.count != 0){
                    
                    for (NSDictionary *dic in _trafficReporData.healthAlerts) {
                        HealthAlertsItem *healthAlerts = [HealthAlertsItem yy_modelWithDictionary:dic];
                        //保存title数组
                        [self.titleArray addObject:healthAlerts.vehicleSystemName];
                        
                        [vehicleSystem addObject:healthAlerts.vehicleSystem];
                        [alertPriority addObject:healthAlerts.alertPriority];
                        [self.cellArray1 addObject:healthAlerts.record];
                    }
                }
                else
                {
                    [self blankUI];
                }
                
                NSDictionary * dic2 = @{ @"TPMS status":@"胎压_icon",
                                         @"Steering system":@"转向系统_icon",
                                         @"Electronic system":@"电器系统_icon",
                                         @"engine system":@"发动机_icon",
                                         @"Electronic lighting system":@"电器系统灯光_icon",
                                         @"Gearbox system":@"变速箱_icon",
                                         @"Airbag system":@"气囊_icon",
                                         @"Braking system":@"制动系统_icon"
                                         };
                
                
                NSDictionary * dic3 = @{
                                        @"low":@"低风险",
                                        @"high":@"高风险",
                                        @"health":@"健康"
                                        };
                
                for (int i = 0; i < self.titleArray.count; i++) {
                    [self.isExpland addObject:@1];
                    //             [_result setObject:imgs[i] forKey:titles[i]];
                    [_imgArray addObject:[dic2 objectForKey:vehicleSystem[i]]?[dic2 objectForKey:vehicleSystem[i]]:@""];
                    [_imgArray1 addObject:[dic3 objectForKey:alertPriority[i]]?[dic3 objectForKey:alertPriority[i]]:@""];
                }
                
                [_tableView reloadData];
                [self initTableView];
                [self setupUI];
                self.trafficReporData =_trafficReporData;
            }
        } else {
            [self blankUI];
            [hud hideAnimated:YES];
            //[MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [self blankUI];
        
    }];
}

-(void)setupUI
{
    self.bgImgV = [[UIImageView alloc] init];
    _bgImgV.image = [UIImage imageNamed:@"健康背景"];
//    _bgImgV.backgroundColor =[UIColor redColor];
    [_headerView addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(260*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
    self.titlelabel = [[UILabel alloc] init];
    _titlelabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _titlelabel.textColor=[UIColor colorWithHexString:@"#A5FFD2"];
    _titlelabel.text=NSLocalizedString(@"健康", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_titlelabel];
    [_titlelabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(25.5*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(70 *WidthCoefficient);
    }];
    

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:currentDate];
    
    
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate* theDate = [currentDate initWithTimeIntervalSinceNow:-oneDay*6];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:theDate];
    NSLog(@"系统时间为%@",currentDateStr1);
    
    NSDate *endDate = [[NSDate date] dateByAddingDays:-1];
    NSDate *startDate = [[NSDate date] dateByAddingDays:-7];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd";
    
    NSString *str=[NSString stringWithFormat:@"本报告为%@-%@数据",[formatter stringFromDate:startDate],[formatter stringFromDate:endDate]];
    
    
    UILabel *Lastlabel = [[UILabel alloc] init];
    Lastlabel.font=[UIFont fontWithName:FontName size:12];
    Lastlabel.textColor = [UIColor colorWithHexString:@"#999999"];
    Lastlabel.text=NSLocalizedString(str, nil);
    Lastlabel.textAlignment = NSTextAlignmentCenter;
    [_bgImgV addSubview:Lastlabel];
    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(215 *HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(240 * WidthCoefficient);
    }];
    

    UIView *bg = [[UIView alloc] init];

//     bg.backgroundColor = [UIColor grayColor];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    bg.layer.cornerRadius = 4;

    [_headerView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
//        make.height.equalTo(126 * HeightCoefficient/2);
        make.height.equalTo(0);
        make.centerX.equalTo(0);
        make.top.equalTo(Lastlabel.bottom).offset(20*HeightCoefficient);
    }];
    

    UILabel *Lastlabel1 = [[UILabel alloc] init];
    Lastlabel1.hidden = YES;
    Lastlabel1.font=[UIFont fontWithName:FontName size:12];
    Lastlabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    Lastlabel1.text=NSLocalizedString(@"-以下为详细报告-", nil);
    Lastlabel1.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:Lastlabel1];
    [Lastlabel1 makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bg.bottom).offset(30*HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(240 * WidthCoefficient);
        make.top.equalTo(bg.bottom).offset(24*HeightCoefficient);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"总里程", nil),NSLocalizedString(@"保养里程", nil),NSLocalizedString(@"车辆油量", nil)];
    NSArray *imgs = @[NSLocalizedString(@"总里程_icon", nil),NSLocalizedString(@"保养里程_icon", nil),NSLocalizedString(@"车辆油量_icon", nil)];
    
    
    _DataArray = [NSMutableArray new];
    NSString *totalMileage = [[NSString stringWithFormat:@"%@",_trafficReporData.totalMileage] stringByAppendingString:@"km"];
    NSString *mileageBeforeMaintenance = [[NSString stringWithFormat:@"%@",_trafficReporData.mileageBeforeMaintenance] stringByAppendingString:@"km"];
//    NSString *levelFuel = [[NSString stringWithFormat:@"%@",_trafficReporData.levelFuel] stringByAppendingString:@"%"];
    
    [_DataArray addObject:_trafficReporData.totalMileage?totalMileage:@"-"];
    [_DataArray addObject:_trafficReporData.mileageBeforeMaintenance?mileageBeforeMaintenance:@"-"];
    [_DataArray addObject:_trafficReporData.levelFuel?_trafficReporData.levelFuel:@"12"];
    
    return;
     NSMutableArray<UIView *> *viewArray = [NSMutableArray arrayWithCapacity:titles.count];
    
   
    for (int i = 0; i < titles.count; i++) {
        
        UIView *views = [[UIView alloc] init];
        views.layer.cornerRadius = 4;
//        views.backgroundColor = [UIColor redColor];
        views.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
        [bg addSubview:views];
        [viewArray addObject:views];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
        [bg addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20 *HeightCoefficient);
            make.bottom.equalTo(-20 *HeightCoefficient);
            make.width.equalTo(1 * WidthCoefficient);
            make.left.equalTo(343 * WidthCoefficient/3-1);
        }];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
        [bg addSubview:lineView1];
        [lineView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20 *HeightCoefficient);
            make.bottom.equalTo(-20 *HeightCoefficient);
            make.width.equalTo(1 * WidthCoefficient);
            make.left.equalTo(lineView.right).offset(343 * WidthCoefficient/3-1);
        }];
     
        
        UIImageView *ImgV = [[UIImageView alloc] init];
        ImgV.image = [UIImage imageNamed:imgs[i]];
        [views addSubview:ImgV];
        [ImgV makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(24*HeightCoefficient);
            make.width.equalTo(24*HeightCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.centerY.equalTo(0);
        }];
        
        
        UILabel *toplabel = [[UILabel alloc] init];
        toplabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:13];
        toplabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
        toplabel.text=NSLocalizedString(titles[i], nil);
        toplabel.textAlignment = NSTextAlignmentLeft;
        [views addSubview:toplabel];
        [toplabel makeConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(20 *HeightCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(ImgV.right).offset(10*WidthCoefficient);
//            make.centerX.equalTo(_bgImgV1);
            make.width.equalTo(99 * WidthCoefficient);
            make.bottom.equalTo(ImgV.centerY);
        }];
        
        
        UILabel *bottomlabel = [[UILabel alloc] init];
        bottomlabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:13];
        bottomlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];

        if (i==0) {
            
          bottomlabel.text=NSLocalizedString(_DataArray[0], nil);
            
        }else if (i==1)
        {
          bottomlabel.text=NSLocalizedString(_DataArray[1], nil);
        }
        else
        {
            
            if(![NSString isBlankString:_trafficReporData.levelFuel])
            {
                
                NSString *stringInt = _trafficReporData.levelFuel;
                NSInteger ivalue = [stringInt integerValue];
                NSString *levelFuel = [[NSString stringWithFormat:@"%@",_trafficReporData.levelFuel] stringByAppendingString:@"%"];
                if (ivalue<10 || ivalue==10) {
                    
                    bottomlabel.text=NSLocalizedString(levelFuel, nil);
                    bottomlabel.textColor = [UIColor redColor];
                }
                else
                {
                    bottomlabel.text=NSLocalizedString(levelFuel, nil);
                    bottomlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                    
                }
            }
            else
            {
                bottomlabel.text= @"-";
                bottomlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                
            }
      
            
            
//            NSString *stringInt = _DataArray[2];
//            NSInteger ivalue = [stringInt intValue];
//            NSString *levelFuel = [[NSString stringWithFormat:@"%@",_DataArray[2]] stringByAppendingString:@"%"];
//            
//            if (ivalue<10 || ivalue==10) {
//                bottomlabel.text=NSLocalizedString(levelFuel, nil);
//                bottomlabel.textColor = [UIColor redColor];
//            }
//            else
//            {
//                bottomlabel.text=NSLocalizedString(@"-", nil);
//                bottomlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//                
//            }
            
        }
       
        bottomlabel.textAlignment = NSTextAlignmentLeft;
        [views addSubview:bottomlabel];
        [bottomlabel makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(toplabel.bottom).offset(0);
            make.top.equalTo(ImgV.centerY);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(ImgV.right).offset(10*WidthCoefficient);
            //            make.centerX.equalTo(_bgImgV1);
            make.width.equalTo(99 * WidthCoefficient);
        }];
    }

     [viewArray mas_distributeSudokuViewsWithFixedItemWidth:343 * WidthCoefficient/3-1 fixedItemHeight:126 * HeightCoefficient/2-1 warpCount:3 topSpacing:0 * WidthCoefficient bottomSpacing:0 * WidthCoefficient leadSpacing:0 * WidthCoefficient tailSpacing:0 * WidthCoefficient];
    
}


-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    //    _tableView.tableFooterView = [UIView new];
    //    _tableView.tableHeaderView = [UIView new];
    
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
//    _tableView.bounces=NO;
    //滚动条隐藏
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    //    隐藏线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[TrafficReportdatailCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,368*HeightCoefficient)];
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,260*HeightCoefficient)];

//     _headerView.backgroundColor=[UIColor redColor];
    _headerView.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    _tableView.tableHeaderView=_headerView;
 
}


-(void)setTrafficReporData:(TrafficReporData *)trafficReporData
{

    if([trafficReporData.alertPriority isEqualToString:@"high"]) {
      
        _bgImgV.image = [UIImage imageNamed:@"需维修"];
//        _bgImgV1.image = [UIImage imageNamed:@"需维修车"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#CE004F"];
        _titlelabel.text=NSLocalizedString(@"需维修", nil);
        
    }
    else if([trafficReporData.alertPriority isEqualToString:@"low"]) {
      
        _bgImgV.image = [UIImage imageNamed:@"需检查"];
//        _bgImgV1.image = [UIImage imageNamed:@"需检查车"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#FFC3A5"];
        _titlelabel.text=NSLocalizedString(@"需检查", nil);
    }
    else if([trafficReporData.alertPriority isEqualToString:@"health"])
    {
        
        _bgImgV.image = [UIImage imageNamed:@"健康车"];
//        _bgImgV1.image = [UIImage imageNamed:@"健康"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#A5FFD2"];
        _titlelabel.text=NSLocalizedString(@"正常", nil);
    }
    else
    {
       
        _bgImgV.image = [UIImage imageNamed:@"健康车"];
//        _bgImgV1.image = [UIImage imageNamed:@"健康车"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#ffffff"];
        _titlelabel.text=NSLocalizedString(@"-", nil);
    }
    
}



-(void)blankUI{
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"暂无内容"];
    [bgImgV setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top .equalTo(50 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.height.equalTo(175 * HeightCoefficient);
        make.width.equalTo(278 * WidthCoefficient);
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //有多少组
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这里是关键，如果选中
    NSArray *array = self.cellArray1[section];
    if ([self.isExpland[section] boolValue]) {
        return array.count;
    }
    else {
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSource removeAllObjects];
    [self.cellArray2 removeAllObjects];
    [self.cellArray3 removeAllObjects];
    
    NSArray *data1=self.cellArray1[indexPath.section];
    for (NSDictionary *dic in data1) {

        RecordItems *recordItem = [RecordItems yy_modelWithDictionary:dic];
//         [self setcellHight:recordItem.jdaName];
        recordItem.cellHeights = [self setcellHight:recordItem.jdaName];

        [self.cellArray2 addObject:recordItem.jdaName];
//        [self.cellArray3 addObject: [[NSString stringWithFormat:@"%@",recordItem.alertCount] stringByAppendingString:@"次"]];
        [self.dataSource addObject:recordItem];
    }

    return self.dataSource[indexPath.row].cellHeights;
}

-(CGFloat)setcellHight:(NSString *)cellModel
{
    CGRect tmpRect= [cellModel boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
   
    CGFloat contentH = tmpRect.size.height+28 *HeightCoefficient;
    return contentH;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    RecordItems *recordItem = self.dataSource[indexPath.row];
//
    TrafficReportdatailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TrafficReportdatailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
   
     cell.backgroundColor = [UIColor colorWithHexString:@"#040000"];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
  
     cell.recordItem = self.dataSource[indexPath.row];
    
  
//      cell.leftlab.text = self.cellArray2[indexPath.row];
//      cell.rightlab.text = self.cellArray3[indexPath.row];
      return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
   
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(62*WidthCoefficient, 10*HeightCoefficient, 297*WidthCoefficient, 40*HeightCoefficient)];
    view1.backgroundColor=[UIColor colorWithHexString:@"#120F0E"];
//     view1.backgroundColor=[UIColor grayColor];
    [view addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 10*HeightCoefficient, 62*WidthCoefficient, 40*HeightCoefficient)];
    view2.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    //     view1.backgroundColor=[UIColor grayColor];
    [view addSubview:view2];
    
    self.view3=[[UIView alloc]initWithFrame:CGRectMake(0, 39*HeightCoefficient,297*WidthCoefficient, 1*HeightCoefficient)];
    _view3.hidden = YES;
    _view3.backgroundColor=[UIColor colorWithHexString:@"#1E1918"];
//    view3.backgroundColor=[UIColor grayColor];
    [view1 addSubview:_view3];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*WidthCoefficient, 10*HeightCoefficient, 180*WidthCoefficient, 20*HeightCoefficient)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = [self.titleArray objectAtIndex:section];
    titleLabel.textColor =[UIColor colorWithHexString:@"#999999"];
//    titleLabel.text=@"发动机系统";
    [view1 addSubview:titleLabel];
    

    UIImageView *leftimageView=[[UIImageView alloc] init];
    leftimageView.image=[UIImage imageNamed:[self.imgArray objectAtIndex:section]];
    [view2 addSubview:leftimageView];
    [leftimageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(36*WidthCoefficient);
        make.width.equalTo(36*WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.centerY.equalTo(view2).offset(0);
    }];
    
    self.rightimageView=[[UIImageView alloc] init];

    int intString = [[_isExpland objectAtIndex:section] intValue];
    NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
   
    if ([stringInt isEqualToString:@"1"]) {
         _view3.hidden = NO;
        _rightimageView.image=[UIImage imageNamed:@"arrowup"];
    }else{
        _view3.hidden = YES;
        _rightimageView.image=[UIImage imageNamed:@"arrowdown"];
    }

    [view1 addSubview:_rightimageView];
    [_rightimageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(16*WidthCoefficient);
        make.width.equalTo(16*WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.centerY.equalTo(view1).offset(0);
        
    }];
    
    UIImageView *rightimageView1=[[UIImageView alloc] init];
    rightimageView1.image=[UIImage imageNamed:[self.imgArray1 objectAtIndex:section]];
    [view1 addSubview:rightimageView1];
    [rightimageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(15*HeightCoefficient);
        make.width.equalTo(42*WidthCoefficient);
        make.right.equalTo(_rightimageView.left).offset(-10*WidthCoefficient);
        make.centerY.equalTo(view1).offset(0);
    }];
    
    

    //添加一个button 用来监听点击分组，实现分组的展开关闭。
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor=[UIColor redColor];
    btn.frame=CGRectMake(62*WidthCoefficient, 0, 297*HeightCoefficient, 40*HeightCoefficient);
    btn.tag=666+section;
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 *HeightCoefficient;
}

- (void)buttonAction:(UIButton *)button {
    
    NSInteger section = button.tag - 666;

    self.isExpland[section] = [self.isExpland[section] isEqual:@0]?@1:@0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -lazy load-
-(NSMutableArray *)titleArray{
    
    if (_titleArray == nil) {
        
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

-(NSMutableArray *)isExpland{
    
    if (_isExpland == nil) {
        
        _isExpland = [NSMutableArray array];
    }
    return _isExpland;
}


-(NSMutableArray *)cellArray1{
    
    if (_cellArray1 == nil) {
        
        _cellArray1 = [NSMutableArray array];
    }
    return _cellArray1;
}

-(NSMutableArray *)cellArray2{
    
    if (_cellArray2 == nil) {
        
        _cellArray2 = [NSMutableArray array];
    }
    return _cellArray2;
}

-(NSMutableArray *)cellArray3{
    
    if (_cellArray3 == nil) {
        
        _cellArray3 = [NSMutableArray array];
    }
    return _cellArray3;
}

@end
