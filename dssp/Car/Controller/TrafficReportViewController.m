//
//  TrafficReportViewController.m
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrafficReportViewController.h"
#import "TrafficReportModel.h"
#import "TrafficReportCell.h"
#import "TrafficReportdatailController.h"
@interface TrafficReportViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
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
@end

@implementation TrafficReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"车况报告", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    
    [self requestData];
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
            
           
            [_tableView reloadData];
            
            [self initTableView];
            [self setupUI];
          
            self.trafficReporData =_trafficReporData;
//            dispatch_async(dispatch_get_main_queue(), ^{
            
     
       
//            });
          
        } else {
            [self blankUI];
//            [_tableView reloadData];
//            self.trafficReporData =_trafficReporData;
            [hud hideAnimated:YES];
//            [MBProgressHUD showText:dic[@"msg"]];
          
            
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [self blankUI];
//        [_tableView reloadData];
//        self.trafficReporData =_trafficReporData;
//        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
//        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
//        [hud hideAnimated:YES afterDelay:1];
    }];
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

-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    //    _tableView.tableFooterView = [UIView new];
    //    _tableView.tableHeaderView = [UIView new];
    
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
    _tableView.bounces=NO;
    //滚动条隐藏
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    //    隐藏线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,260*HeightCoefficient)];
    _headerView.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=_headerView;
}

-(void)setTrafficReporData:(TrafficReporData *)trafficReporData
{
    if (trafficReporData.healthAlerts.count > 6 || trafficReporData.healthAlerts.count == 6) {
      
         _seeBtn.hidden = NO;
        _bgImgV.image = [UIImage imageNamed:@"危险背景"];
        _bgImgV1.image = [UIImage imageNamed:@"危险"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#CE004F"];
        _titlelabel.text=NSLocalizedString(@"危险", nil);
        
    }
    else if (trafficReporData.healthAlerts.count < 6 && trafficReporData.healthAlerts.count > 0) {
         _seeBtn.hidden = NO;
        _bgImgV.image = [UIImage imageNamed:@"亚健康背景"];
        _bgImgV1.image = [UIImage imageNamed:@"亚健康"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#FFC3A5"];
        _titlelabel.text=NSLocalizedString(@"亚健康", nil);
    }
    else
    {
         _seeBtn.hidden = YES;
        _bgImgV.image = [UIImage imageNamed:@"健康背景"];
        _bgImgV1.image = [UIImage imageNamed:@"健康"];
        _titlelabel.textColor=[UIColor colorWithHexString:@"#A5FFD2"];
        _titlelabel.text=NSLocalizedString(@"健康", nil);
        
    }
  
}

-(void)setupUI
{
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"车况报告", nil);
  
    self.bgImgV = [[UIImageView alloc] init];
    _bgImgV.image = [UIImage imageNamed:@"健康背景"];
    [_headerView addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(260*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
   self.bgImgV1 = [[UIImageView alloc] init];
    _bgImgV1.image = [UIImage imageNamed:@"健康"];
    [_headerView addSubview:_bgImgV1];
    [_bgImgV1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24 *HeightCoefficient);
        make.height.equalTo(218*HeightCoefficient);
        make.width.equalTo(199*WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    self.titlelabel = [[UILabel alloc] init];
    _titlelabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    _titlelabel.textColor=[UIColor colorWithHexString:@"#A5FFD2"];
//    _titlelabel.text=NSLocalizedString(@"健康", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_titlelabel];
    [_titlelabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(100*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(70 *WidthCoefficient);
    }];
    
    self.seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeBtn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    _upkeepBtn.layer.cornerRadius = 2;
    _seeBtn.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    _seeBtn.layer.borderWidth = 0.75;
    _seeBtn.layer.cornerRadius = 2;
    [_seeBtn setTitle:NSLocalizedString(@"点击查看", nil) forState:UIControlStateNormal];
    _seeBtn.hidden = YES;
    [_seeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _seeBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    //    [_upkeepBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
    [self.view addSubview:_seeBtn];
    [_seeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(76 * WidthCoefficient);
        make.height.equalTo(24 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_titlelabel.bottom).offset(20 *HeightCoefficient);
    }];
    
    
    UILabel *Lastlabel = [[UILabel alloc] init];
    Lastlabel.font=[UIFont fontWithName:FontName size:12];
    Lastlabel.textColor = [UIColor colorWithHexString:@"#999999"];
    Lastlabel.text=NSLocalizedString(@"本数据为近一周统计数据", nil);
    Lastlabel.textAlignment = NSTextAlignmentCenter;
    [_bgImgV addSubview:Lastlabel];
    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-10 *HeightCoefficient);
        make.height.equalTo(16.5 * HeightCoefficient);
        make.centerX.equalTo(_bgImgV);
        make.width.equalTo(240 * WidthCoefficient);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*HeightCoefficient;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TrafficReportCellName";
    TrafficReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[TrafficReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *titles = @[NSLocalizedString(@"总里程", nil),NSLocalizedString(@"保养里程", nil),NSLocalizedString(@"机油剩余量", nil),NSLocalizedString(@"车辆油量", nil)];
    NSArray *imgs = @[NSLocalizedString(@"总里程_icon", nil),NSLocalizedString(@"保养里程_icon", nil),NSLocalizedString(@"机油剩余量_icon", nil),NSLocalizedString(@"车辆油量_icon", nil)];
    
    _DataArray = [NSMutableArray new];
    
    NSString *totalMileage = [[NSString stringWithFormat:@"%@",_trafficReporData.totalMileage] stringByAppendingString:@"km"];
    NSString *mileageBeforeMaintenance = [[NSString stringWithFormat:@"%@",_trafficReporData.mileageBeforeMaintenance] stringByAppendingString:@"km"];
    NSString *levelOil = [[NSString stringWithFormat:@"%@",_trafficReporData.levelOil] stringByAppendingString:@"L"];
    NSString *levelFuel = [[NSString stringWithFormat:@"%@",_trafficReporData.levelFuel] stringByAppendingString:@"L"];
//
    [_DataArray addObject:_trafficReporData.totalMileage?totalMileage:@"0km"];
    [_DataArray addObject:_trafficReporData.mileageBeforeMaintenance?mileageBeforeMaintenance:@"0km"];
    [_DataArray addObject:_trafficReporData.levelOil?levelOil:@"0L"];
    [_DataArray addObject:_trafficReporData.levelFuel?levelFuel:@"0L"];
//
    cell.img.image =[UIImage imageNamed:imgs[indexPath.row]];
    cell.leftlab.text =titles[indexPath.row];
    cell.rightlab.text =_DataArray[indexPath.row];
//    //    cell.bottolab.text =@"最近使用:2017/12/31";
//    cell.rightlab.text =_DataArray[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)BtnClick
{
//    UIViewController *vc = [[NSClassFromString(@"TrafficReportdatailController") alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    TrafficReportdatailController *vc = [[TrafficReportdatailController alloc] init];
    vc.dataArray1 = _trafficReporData.healthAlerts;
    [self.navigationController pushViewController:vc animated:YES];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
