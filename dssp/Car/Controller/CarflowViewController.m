//
//  CarflowViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/22.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarflowViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "CarflowCell.h"
#import "CarflowModel.h"
#import "NSObject+YYModel.h"
@interface CarflowViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *employflowlabel;
@property (nonatomic, strong) UILabel *flowlabel;
@property (nonatomic, strong) UILabel *totalflowlabel;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic,strong) CarflowModel *carflow;
@end

@implementation CarflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self setupUI];
    [self requestData];
//    [self initTableView];

}


-(void)requestData
{
    NSDictionary *paras = @{
                          
                         };
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", findSimRealTimeFlowByIccid,kVin];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:paras success:^(id responseData) {
       NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            _carflow =[CarflowModel yy_modelWithDictionary:dic[@"data"]];
            [_tableView reloadData];
          
            self.carflow =_carflow;
        } else {
            self.carflow =_carflow;
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
      [hud hideAnimated:YES];
      self.carflow =_carflow;
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
    _tableView.backgroundColor=[UIColor whiteColor];
//    隐藏线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,126*HeightCoefficient)];
    _headerView.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=_headerView;
    
}

-(void)setCarflow:(CarflowModel *)carflow
{
    NSInteger k = [_carflow.remainFlow integerValue];
    if (k < 0) {
        _flowlabel.text = @"0M";
    }
    else if([_carflow.remainFlow rangeOfString:@"."].length>0)
    {
        
        double aNumber = [_carflow.remainFlow doubleValue];
        NSString *remainFlow = [[NSString stringWithFormat:@"%.2f",aNumber] stringByAppendingString:@"M"];
        _flowlabel.text = remainFlow;
    }
    else if(_carflow.remainFlow == nil)
    {
         _flowlabel.text = @"0M";

    }
    else
    {
        NSString *remainFlow = [[NSString stringWithFormat:@"%@",_carflow.remainFlow] stringByAppendingString:@"M"];
        _flowlabel.text = remainFlow;
        
    }
    
     NSString *totalFlow = [[NSString stringWithFormat:@"%@",_carflow.totalFlow] stringByAppendingString:@"M"];
    _totalflowlabel.text =  _carflow.totalFlow == nil?@"0M":totalFlow;
}

-(void)setupUI
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"流量", nil);
//    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,197*HeightCoefficient)];
//    _headerView.backgroundColor=[UIColor whiteColor];
//    _tableView.tableHeaderView=_headerView;
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud_mine"];
    [_headerView addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(126*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];

   
//    NSString *remainFlow = [[NSString stringWithFormat:@"%@",_carflow.remainFlow] stringByAppendingString:@"M"];
   
    self.flowlabel = [[UILabel alloc] init];
    _flowlabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:28];
    _flowlabel.textColor=[UIColor whiteColor];
    _flowlabel.text = @"0M";
  
//    _flowlabel.text = @"0M";
    _flowlabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_flowlabel];
    [_flowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20*HeightCoefficient);
        make.height.equalTo(33.5 * HeightCoefficient);
        make.left.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    UILabel *surpluslabel = [[UILabel alloc] init];
    surpluslabel.font=[UIFont fontWithName:FontName size:13];
    surpluslabel.textColor=[UIColor whiteColor];
    surpluslabel.text=NSLocalizedString(@"剩余流量", nil);
    surpluslabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:surpluslabel];
    [surpluslabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_flowlabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.left.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(14.5 * HeightCoefficient);
        make.height.equalTo(60 * HeightCoefficient);
        make.width.equalTo(1 * HeightCoefficient);
        
        
    }];
    


//     NSString *totalFlow = [[NSString stringWithFormat:@"%@",_carflow.totalFlow] stringByAppendingString:@"M"];
    self.totalflowlabel = [[UILabel alloc] init];
    _totalflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:28];
    _totalflowlabel.textColor=[UIColor whiteColor];
    _totalflowlabel.text = @"0M";
    _totalflowlabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_totalflowlabel];
    [_totalflowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20*HeightCoefficient);
        make.height.equalTo(33.5 * HeightCoefficient);
        make.right.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];


    UILabel *totalflow = [[UILabel alloc] init];
    totalflow.font=[UIFont fontWithName:FontName size:13];
    totalflow.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
    totalflow.text=NSLocalizedString(@"总流量", nil);
    totalflow.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:totalflow];
    [totalflow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalflowlabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.right.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];

    
    
    UILabel *Lastlabel = [[UILabel alloc] init];
    Lastlabel.font=[UIFont fontWithName:FontName size:13];
    Lastlabel.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
    Lastlabel.layer.cornerRadius = 20 * HeightCoefficient/2;
    Lastlabel.clipsToBounds = YES;
    Lastlabel.textColor=[UIColor whiteColor];
    Lastlabel.text=NSLocalizedString(@"本数据均为前一天统计数", nil);
    Lastlabel.textAlignment = NSTextAlignmentCenter;
    [bgImgV addSubview:Lastlabel];
    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalflow.bottom).offset(12*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(bgImgV);
        make.width.equalTo(240 * WidthCoefficient);
    }];
    
//    UILabel *msgLabel1 = [[UILabel alloc] init];
//    msgLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
//    msgLabel1.textAlignment = NSTextAlignmentCenter;
//    msgLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
//    msgLabel1.text = NSLocalizedString(@"本数据均为前一天统计数",nil);
//    [self.view addSubview:msgLabel1];
//    [msgLabel1 makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(-(kBottomHeight+15));
//        make.height.equalTo(16.5 * HeightCoefficient);
//        make.right.equalTo(-16 * WidthCoefficient);
//        make.left.equalTo(16 * WidthCoefficient);
//    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HeightCoefficient;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CarflowCellName";
    CarflowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CarflowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSArray *titles = @[NSLocalizedString(@"在线音乐", nil),NSLocalizedString(@"在线电台", nil),NSLocalizedString(@"OTA升级", nil),NSLocalizedString(@"WIFI", nil)];
    
    _DataArray = [NSMutableArray new];
    
    NSString *music = [[NSString stringWithFormat:@"%@",_carflow.music] stringByAppendingString:@"M"];
    NSString *fm = [[NSString stringWithFormat:@"%@",_carflow.fm] stringByAppendingString:@"M"];
    NSString *ota = [[NSString stringWithFormat:@"%@",_carflow.ota] stringByAppendingString:@"M"];
    NSString *wifi = [[NSString stringWithFormat:@"%@",_carflow.wifi] stringByAppendingString:@"M"];
    
    [_DataArray addObject:_carflow.music?music:@"0M"];
    [_DataArray addObject:_carflow.fm?fm:@"0M"];
    [_DataArray addObject:_carflow.ota?ota:@"0M"];
    [_DataArray addObject:_carflow.wifi?wifi:@"0M"];

    cell.toplab.text =titles[indexPath.row];
//    cell.bottolab.text =@"最近使用:2017/12/31";
    cell.rightlab.text =_DataArray[indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
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
