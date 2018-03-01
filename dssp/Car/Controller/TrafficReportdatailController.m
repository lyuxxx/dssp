//
//  TrafficReportdatailController.m
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrafficReportdatailController.h"
#import "TrafficReportdatailCell.h"
#import "TrafficReportModel.h"
#import "NSArray+Sudoku.h"

@interface TrafficReportdatailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger openSection;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellArray1;
@property (nonatomic, strong) NSMutableArray *cellArray2;
@property (nonatomic, strong) NSMutableArray *cellArray3;
@property (nonatomic, strong) NSMutableArray *imgArray;
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

@property (nonatomic, strong) NSMutableArray<RecordItems *> *dataSource;
//@property (nonatomic, strong) RecordItem *recordItem;
@property (nonatomic,strong) NSMutableDictionary *result;
@end

@implementation TrafficReportdatailController
static NSString *const cellID = @"cell";


- (BOOL)needGradientBg {
    return NO;
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


#pragma mark 懒加载
-(NSMutableArray *)titleArray{
    
    if (_titleArray == nil) {
        
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

#pragma mark 懒加载
-(NSMutableArray *)isExpland{
    
    if (_isExpland == nil) {
        
        _isExpland = [NSMutableArray array];
    }
    return _isExpland;
}


#pragma mark 懒加载
-(NSMutableArray *)cellArray1{
    
    if (_cellArray1 == nil) {
        
        _cellArray1 = [NSMutableArray array];
    }
    return _cellArray1;
}

#pragma mark 懒加载
-(NSMutableArray *)cellArray2{
    
    if (_cellArray2 == nil) {
        
        _cellArray2 = [NSMutableArray array];
    }
    return _cellArray2;
}

#pragma mark 懒加载
-(NSMutableArray *)cellArray3{
    
    if (_cellArray3 == nil) {
        
        _cellArray3 = [NSMutableArray array];
    }
    return _cellArray3;
}


-(void)requestData
{
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", queryTheVehicleHealthReportForLatestSevenDays,@"1"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:@{} success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            _trafficReporData =[TrafficReporData yy_modelWithDictionary:dic[@"data"]];
            
//            if (!self.dataArray) {
//                self.dataArray = [NSMutableArray array];
//            }
//            
//            if (!self.isExpland) {
//                self.isExpland = [NSMutableArray array];
//            }
//            self.titleArray = [NSMutableArray array];
//            self.cellArray1 = [NSMutableArray array];
//            self.cellArray2 = [NSMutableArray array];
//            self.cellArray3 = [NSMutableArray array];
            self.imgArray = [NSMutableArray array];
            self.result = [NSMutableDictionary new];
            NSMutableArray *vehicleSystem =[NSMutableArray array];
            
            for (NSDictionary *dic in _trafficReporData.healthAlerts) {
                HealthAlertsItem *healthAlerts = [HealthAlertsItem yy_modelWithDictionary:dic];
                //保存title数组
                [self.titleArray addObject:healthAlerts.vehicleSystemName];
                
                [vehicleSystem addObject:healthAlerts.vehicleSystem];
                
                [self.cellArray1 addObject:healthAlerts.record];
                
            }
            
           NSArray *titles = @[@"TPMS status",@"Steering system",@"Electronic system",@"engine system",@"Electronic lighting system",@"Gearbox system",@"Braking system",@"Airbag system"];
            
            NSArray *imgs = @[@"胎压_icon",@"转向系统_icon",@"电器系统_icon",@"发动机_icon",@"电器系统灯光_icon",@"变速箱_icon",@"制动系统_icon",@"气囊_icon"];
            
            
            for (int i = 0; i < self.titleArray.count; i++) {
                [self.isExpland addObject:@0];
  
             [_result setObject:imgs[i] forKey:titles[i]];
             [_imgArray addObject:[_result objectForKey:vehicleSystem[i]]];
           
            }
            
            [_tableView reloadData];
            [self initTableView];
        
//            [self loadData];
            [self setupUI];
            
            self.trafficReporData =_trafficReporData;
            
            
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
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.title = NSLocalizedString(@"车况报告", nil);
    
    self.bgImgV = [[UIImageView alloc] init];
    _bgImgV.image = [UIImage imageNamed:@"健康背景"];
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
    
    
    self.bgImgV1 = [[UIImageView alloc] init];
//    _bgImgV1.backgroundColor=[UIColor redColor];
    _bgImgV1.image = [UIImage imageNamed:@"健康车"];
    [_headerView addSubview:_bgImgV1];
    [_bgImgV1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(52.5 *HeightCoefficient);
        make.height.equalTo(201*HeightCoefficient);
        make.width.equalTo(375*WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    UILabel *Lastlabel = [[UILabel alloc] init];
    Lastlabel.font=[UIFont fontWithName:FontName size:12];
    Lastlabel.textColor = [UIColor colorWithHexString:@"#999999"];
    Lastlabel.text=NSLocalizedString(@"本数据为近一周统计数据", nil);
    Lastlabel.textAlignment = NSTextAlignmentCenter;
    [_bgImgV1 addSubview:Lastlabel];
    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0 *HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.centerX.equalTo(_bgImgV1);
        make.width.equalTo(240 * WidthCoefficient);
    }];
    

    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    bg.layer.cornerRadius = 4;
    [_headerView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(161 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_bgImgV1.bottom).offset(15*HeightCoefficient);
    }];
    
    
    UIView *line1= [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
    line1.layer.cornerRadius = 0;
    [bg addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.centerY.equalTo(0);
        make.left.equalTo(0*HeightCoefficient);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
    line2.layer.cornerRadius = 0;
    [bg addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(1 * WidthCoefficient);
        make.height.equalTo(161 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(0*HeightCoefficient);
    }];
    
    UILabel *Lastlabel1 = [[UILabel alloc] init];
    Lastlabel1.font=[UIFont fontWithName:FontName size:12];
    Lastlabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    Lastlabel1.text=NSLocalizedString(@"-以下为详细报告-", nil);
    Lastlabel1.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:Lastlabel1];
    [Lastlabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg.bottom).offset(30*HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.centerX.equalTo(_bgImgV1);
        make.width.equalTo(240 * WidthCoefficient);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"总里程", nil),NSLocalizedString(@"保养里程", nil),NSLocalizedString(@"机油剩余量", nil),NSLocalizedString(@"车辆油量", nil)];
    NSArray *imgs = @[NSLocalizedString(@"总里程_icon", nil),NSLocalizedString(@"保养里程_icon", nil),NSLocalizedString(@"机油剩余量_icon", nil),NSLocalizedString(@"车辆油量_icon", nil)];
    
    
    _DataArray = [NSMutableArray new];
    NSString *totalMileage = [[NSString stringWithFormat:@"%@",_trafficReporData.totalMileage] stringByAppendingString:@"km"];
    NSString *mileageBeforeMaintenance = [[NSString stringWithFormat:@"%@",_trafficReporData.mileageBeforeMaintenance] stringByAppendingString:@"km"];
    NSString *levelOil = [[NSString stringWithFormat:@"%@",_trafficReporData.levelOil] stringByAppendingString:@"L"];
    NSString *levelFuel = [[NSString stringWithFormat:@"%@",_trafficReporData.levelFuel] stringByAppendingString:@"%"];
    //
    [_DataArray addObject:_trafficReporData.totalMileage?totalMileage:@"0km"];
    [_DataArray addObject:_trafficReporData.mileageBeforeMaintenance?mileageBeforeMaintenance:@"0km"];
    [_DataArray addObject:_trafficReporData.levelOil?levelOil:@"0L"];
    [_DataArray addObject:_trafficReporData.levelFuel?levelFuel:@"0L"];
    
     NSMutableArray<UIView *> *viewArray = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (int i=0; i<titles.count; i++) {
        
        UIView *views = [[UIView alloc] init];
//        views.backgroundColor = [UIColor redColor];
        [bg addSubview:views];
        [viewArray addObject:views];
        
        
        UIImageView *ImgV = [[UIImageView alloc] init];
        ImgV.image = [UIImage imageNamed:imgs[i]];
        [views addSubview:ImgV];
        [ImgV makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(24*HeightCoefficient);
            make.width.equalTo(24*HeightCoefficient);
            make.left.equalTo(20 * WidthCoefficient);
            make.centerY.equalTo(0);
            
        }];
        
        
        UILabel *toplabel = [[UILabel alloc] init];
        toplabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:13];
        toplabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
        toplabel.text=NSLocalizedString(titles[i], nil);
        toplabel.textAlignment = NSTextAlignmentLeft;
        [views addSubview:toplabel];
        [toplabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20 *HeightCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(ImgV.right).offset(10*WidthCoefficient);
//            make.centerX.equalTo(_bgImgV1);
            make.width.equalTo(99 * WidthCoefficient);
        }];
        
        
        UILabel *bottomlabel = [[UILabel alloc] init];
        bottomlabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:15];
        bottomlabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        bottomlabel.text=NSLocalizedString(_DataArray[i], nil);
        bottomlabel.textAlignment = NSTextAlignmentLeft;
        [views addSubview:bottomlabel];
        [bottomlabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(toplabel.bottom).offset(0);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(ImgV.right).offset(10*WidthCoefficient);
            //            make.centerX.equalTo(_bgImgV1);
            make.width.equalTo(99 * WidthCoefficient);
        }];
        
        
    }

     [viewArray mas_distributeSudokuViewsWithFixedItemWidth:343 * WidthCoefficient/2-1 fixedItemHeight:161 * HeightCoefficient/2-1 warpCount:2 topSpacing:0 * WidthCoefficient bottomSpacing:0 * WidthCoefficient leadSpacing:0 * WidthCoefficient tailSpacing:0 * WidthCoefficient];

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
    
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,477*HeightCoefficient)];
    _headerView.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    _tableView.tableHeaderView=_headerView;
 
}


-(void)setTrafficReporData:(TrafficReporData *)trafficReporData
{
    if (trafficReporData.healthAlerts.count > 6 || trafficReporData.healthAlerts.count == 6) {
        
        _seeBtn.hidden = NO;
        _bgImgV.image = [UIImage imageNamed:@"需维修背景"];
        _bgImgV1.image = [UIImage imageNamed:@"需维修车"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#CE004F"];
        _titlelabel.text=NSLocalizedString(@"需维修", nil);
        
    }
    else if (trafficReporData.healthAlerts.count < 6 && trafficReporData.healthAlerts.count > 0) {
        _seeBtn.hidden = NO;
        _bgImgV.image = [UIImage imageNamed:@"需检查背景"];
        _bgImgV1.image = [UIImage imageNamed:@"需检查车"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#FFC3A5"];
        _titlelabel.text=NSLocalizedString(@"需检查", nil);
    }
    else
    {
        _seeBtn.hidden = YES;
        _bgImgV.image = [UIImage imageNamed:@"健康背景"];
        _bgImgV1.image = [UIImage imageNamed:@"健康车"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#A5FFD2"];
        _titlelabel.text=NSLocalizedString(@"健康", nil);
        
    }
    
}



-(void)blankUI{
    
    self.bgImgV = [[UIImageView alloc] init];
    _bgImgV.image = [UIImage imageNamed:@"空页面1"];
    [self.bgImgV setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top .equalTo(120 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.height.equalTo(77.5 * HeightCoefficient);
        make.width.equalTo(86.5 * WidthCoefficient);
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text =@"空空如也";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImgV.bottom).offset(15*WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(100 *WidthCoefficient);
    }];
    
    
}

- (void)loadData {
    
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }

    if (!self.isExpland) {
        self.isExpland = [NSMutableArray array];
    }
    
   

    //这里用一个二维数组来模拟数据。
//    self.dataArray = [NSArray arrayWithObjects:@[@"a",@"b",@"c",@"d"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n",@"a",@"b",@"c",@"d"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n"],@[@"h",@"i",@"j",@"m",@"n"],nil].mutableCopy;
    
    NSArray *titles = @[@"胎压状态",@"制动/转向系统",@"电器系统",@"发动机/变速箱系统",@"电器系统灯光部分",@"变速箱系统",@"制动/转向系统",@"安全气囊系统"];
    
    NSArray *imgs = @[@"胎压_icon",@"转向系统_icon",@"电器系统_icon",@"发动机_icon",@"电器系统灯光_icon",@"变速箱_icon",@"制动系统_icon",@"气囊_icon"];
    
   
 
    self.titleArray = [NSMutableArray array];
    self.cellArray1 = [NSMutableArray array];
    self.cellArray2 = [NSMutableArray array];
    self.cellArray3 = [NSMutableArray array];
    self.imgArray = [NSMutableArray array];
    self.result = [NSMutableDictionary new];
    for (NSDictionary *dic in _trafficReporData.healthAlerts) {
        HealthAlertsItem *healthAlerts = [HealthAlertsItem yy_modelWithDictionary:dic];
        //保存title数组
        [self.titleArray addObject:healthAlerts.vehicleSystemName];
        [self.cellArray1 addObject:healthAlerts.record];
        
        }
    
    
    //用0代表收起，非0（不一定是1）代表展开，默认都是收起的
    for (int i = 0; i < self.titleArray.count; i++) {
        [self.isExpland addObject:@0];
        
        [_result setObject:imgs[i] forKey:titles[i]];
//        [_imgArray addObject:[_result objectForKey:_titleArray[i]]];
        
//         [self.tableView reloadData];
    }
    
    
   //    根据title取图片
//    for (int i = 0; i < self.titleArray.count; i++) {
//       [_result setObject:imgs[i] forKey:titles[i]];
//       [_imgArray addObject:[_result objectForKey:_titleArray[i]]];
//    }


//    [self.tableView reloadData];

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
    NSArray *data1=self.cellArray1[indexPath.section];
    for (NSDictionary *dic in data1) {

         RecordItems *recordItem = [RecordItems yy_modelWithDictionary:dic];
//         [self setcellHight:recordItem.jdaName];

        recordItem.cellHeights = [self setcellHight:recordItem.jdaName];

        [self.cellArray3 addObject: [[NSString stringWithFormat:@"%@",recordItem.alertCount] stringByAppendingString:@"次"]];
        [self.dataSource addObject:recordItem];
    }

    NSLog(@"显示高度21:%f",self.dataSource[indexPath.row].cellHeights);
//
    return self.dataSource[indexPath.row].cellHeights;
 
}

-(CGFloat)setcellHight:(NSString *)cellModel
{
    CGRect tmpRect= [cellModel boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
   
    CGFloat contentH = tmpRect.size.height+11;
    NSLog(@"显示高度:%f",contentH);
    return contentH;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordItems *recordItem = self.dataSource[indexPath.row];
    TrafficReportdatailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TrafficReportdatailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
     cell.backgroundColor = [UIColor colorWithHexString:@"#040000"];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
     cell.recordItem = recordItem;
    
  
//       cell.leftlab.text = self.cellArray2[indexPath.row];
//      [self setcellHight:self.cellArray2[indexPath.row]];
//      NSLog(@"555%f",[self setcellHight:self.cellArray2[indexPath.row]]);
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
        make.height.equalTo(24*WidthCoefficient);
        make.width.equalTo(24*WidthCoefficient);
        make.left.equalTo(23.5 * WidthCoefficient);
        make.centerY.equalTo(view2).offset(0);
    }];
    
    self.rightimageView=[[UIImageView alloc] init];

    int intString = [[_isExpland objectAtIndex:section] intValue];
    NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
   
    if ([stringInt isEqualToString:@"1"]) {
        _rightimageView.image=[UIImage imageNamed:@"arrowup"];
    }else{
        _rightimageView.image=[UIImage imageNamed:@"arrowdown"];
    }
//    _rightimageView.image=[UIImage imageNamed:@"arrowdown"];
    [view1 addSubview:_rightimageView];
    [_rightimageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(16*WidthCoefficient);
        make.width.equalTo(16*WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
