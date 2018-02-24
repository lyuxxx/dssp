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
@interface TrafficReportViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *employflowlabel;
@property (nonatomic, strong) UILabel *flowlabel;
@property (nonatomic, strong) UILabel *totalflowlabel;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) UIButton *seeBtn;
//@property (nonatomic,strong) CarflowModel *carflow;
@end

@implementation TrafficReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    [self initTableView];
    [self setupUI];
    [self requestData];
    //    [self initTableView];
    
}

-(void)requestData
{
  
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", queryTheVehicleHealthReportForLatestSevenDays,kVin];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:@{} success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
//            _carflow =[CarflowModel yy_modelWithDictionary:dic[@"data"]];
//            [_tableView reloadData];
            
//            self.carflow =_carflow;
        } else {
//            self.carflow =_carflow;
            [hud hideAnimated:YES];
//            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
//        self.carflow =_carflow;
        //      [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        //        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        //        [hud hideAnimated:YES afterDelay:1];
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

//-(void)setCarflow:(CarflowModel *)carflow
//{
//    NSInteger k = [_carflow.remainFlow integerValue];
//    if (k < 0) {
//        _flowlabel.text = @"0M";
//    }
//    else if([_carflow.remainFlow rangeOfString:@"."].length>0)
//    {
//        
//        double aNumber = [_carflow.remainFlow doubleValue];
//        NSString *remainFlow = [[NSString stringWithFormat:@"%.2f",aNumber] stringByAppendingString:@"M"];
//        _flowlabel.text = remainFlow;
//    }
//    else if(_carflow.remainFlow == nil)
//    {
//        _flowlabel.text = @"0M";
//        
//    }
//    else
//    {
//        NSString *remainFlow = [[NSString stringWithFormat:@"%@",_carflow.remainFlow] stringByAppendingString:@"M"];
//        _flowlabel.text = remainFlow;
//        
//    }
//    
//    NSString *totalFlow = [[NSString stringWithFormat:@"%@",_carflow.totalFlow] stringByAppendingString:@"M"];
//    _totalflowlabel.text =  _carflow.totalFlow == nil?@"0M":totalFlow;
//}

-(void)setupUI
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"车况报告", nil);
    //    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,197*HeightCoefficient)];
    //    _headerView.backgroundColor=[UIColor whiteColor];
    //    _tableView.tableHeaderView=_headerView;
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"健康背景"];
    [_headerView addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(260*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
    UIImageView *bgImgV1 = [[UIImageView alloc] init];
    bgImgV1.image = [UIImage imageNamed:@"健康"];
    [_headerView addSubview:bgImgV1];
    [bgImgV1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(24 *HeightCoefficient);
        make.height.equalTo(220*HeightCoefficient);
        make.width.equalTo(199*WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    UILabel *surpluslabel = [[UILabel alloc] init];
    surpluslabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    surpluslabel.textColor=[UIColor colorWithHexString:@"#A5FFD2"];
    surpluslabel.text=NSLocalizedString(@"健康", nil);
    surpluslabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:surpluslabel];
    [surpluslabel makeConstraints:^(MASConstraintMaker *make) {
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
    [_seeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _seeBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    //    [_upkeepBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
    [self.view addSubview:_seeBtn];
    [_seeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(76 * WidthCoefficient);
        make.height.equalTo(24 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(surpluslabel.bottom).offset(20 *HeightCoefficient);
    }];
    
    
  
    UILabel *Lastlabel = [[UILabel alloc] init];
    Lastlabel.font=[UIFont fontWithName:FontName size:12];
    Lastlabel.textColor = [UIColor colorWithHexString:@"#999999"];
    Lastlabel.text=NSLocalizedString(@"本数据为近一周统计数据", nil);
    Lastlabel.textAlignment = NSTextAlignmentCenter;
    [bgImgV addSubview:Lastlabel];
    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-12*HeightCoefficient);
        make.height.equalTo(16.5 * HeightCoefficient);
        make.centerX.equalTo(bgImgV);
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
    
//    NSString *music = [[NSString stringWithFormat:@"%@",_carflow.music] stringByAppendingString:@"M"];
//    NSString *fm = [[NSString stringWithFormat:@"%@",_carflow.fm] stringByAppendingString:@"M"];
//    NSString *ota = [[NSString stringWithFormat:@"%@",_carflow.ota] stringByAppendingString:@"M"];
//    NSString *wifi = [[NSString stringWithFormat:@"%@",_carflow.wifi] stringByAppendingString:@"M"];
//
//    [_DataArray addObject:_carflow.music?music:@"0M"];
//    [_DataArray addObject:_carflow.fm?fm:@"0M"];
//    [_DataArray addObject:_carflow.ota?ota:@"0M"];
//    [_DataArray addObject:_carflow.wifi?wifi:@"0M"];
//
    cell.img.image =[UIImage imageNamed:imgs[indexPath.row]];
    cell.leftlab.text =titles[indexPath.row];
    cell.rightlab.text =titles[indexPath.row];
//    //    cell.bottolab.text =@"最近使用:2017/12/31";
//    cell.rightlab.text =_DataArray[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)BtnClick
{
    UIViewController *vc = [[NSClassFromString(@"TrafficReportdatailController") alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
