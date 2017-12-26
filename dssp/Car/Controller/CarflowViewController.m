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
@interface CarflowViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation CarflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    [self initTableView];
    [self setupUI];
}


-(void)requestData
{
    
    NSDictionary *paras = @{
                          
                            };
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:report parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            //            contract = [ContractModel yy_modelWithDictionary:dic[@"data"]];
            //            [_tableView reloadData];
            
            //响应事件
            
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
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
}

-(void)setupUI
{
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"流量", nil);
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,197*HeightCoefficient)];
    _headerView.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=_headerView;
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud_mine"];
    [_headerView addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(126*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.shadowOpacity = 0.5;// 阴影透明度
    whiteView.layer.shadowOffset = CGSizeMake(0,7.5);
    whiteView.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteView.layer.shadowRadius = 20.5;//阴影半径，默认3
    [_headerView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(106 * HeightCoefficient);
        make.height.equalTo(70 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *flowlabel = [[UILabel alloc] init];
    flowlabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:28];
    flowlabel.textColor=[UIColor whiteColor];
    flowlabel.text=NSLocalizedString(@"200M", nil);
    flowlabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:flowlabel];
    [flowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20*HeightCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.centerX.equalTo(_headerView);
        make.width.equalTo(76 * WidthCoefficient);
    }];
    
    
    UILabel *surpluslabel = [[UILabel alloc] init];
    surpluslabel.font=[UIFont fontWithName:FontName size:13];
    surpluslabel.textColor=[UIColor whiteColor];
    surpluslabel.text=NSLocalizedString(@"剩余流量", nil);
    surpluslabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:surpluslabel];
    [surpluslabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(flowlabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.centerX.equalTo(_headerView);
        make.width.equalTo(127 * WidthCoefficient);
    }];
    
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    [whiteView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15 * HeightCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.width.equalTo(1 * WidthCoefficient);
        make.centerX.equalTo(whiteView);
    }];
    
    
    UILabel *employflowlabel = [[UILabel alloc] init];
    employflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    employflowlabel.textColor=[UIColor blackColor];
    employflowlabel.text=NSLocalizedString(@"800M", nil);
    employflowlabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:employflowlabel];
    [employflowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(13*HeightCoefficient);
        make.height.equalTo(25 * HeightCoefficient);
        make.left.equalTo(0);
        make.right.equalTo(lineView.left).offset(0);
    }];
    
    
    UILabel *employflow = [[UILabel alloc] init];
    employflow.font=[UIFont fontWithName:FontName size:11];
    employflow.textColor=[UIColor colorWithHexString:@"#A18E79"];
    employflow.text=NSLocalizedString(@"已使用", nil);
    employflow.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:employflow];
    [employflow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(employflowlabel.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(0);
        make.right.equalTo(lineView.left).offset(0);
    }];
    
    
   
    UILabel *totalflowlabel = [[UILabel alloc] init];
    totalflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    totalflowlabel.textColor=[UIColor blackColor];
    totalflowlabel.text=NSLocalizedString(@"1000M", nil);
    totalflowlabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:totalflowlabel];
    [totalflowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(13*HeightCoefficient);
        make.height.equalTo(25 * HeightCoefficient);
        make.right.equalTo(0);
        make.left.equalTo(lineView.right).offset(0);
    }];
  
    
    
    UILabel *totalflow = [[UILabel alloc] init];
    totalflow.font=[UIFont fontWithName:FontName size:11];
    totalflow.textColor=[UIColor colorWithHexString:@"#A18E79"];
    totalflow.text=NSLocalizedString(@"总流量", nil);
    totalflow.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:totalflow];
    [totalflow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalflowlabel.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.right.equalTo(0);
        make.left.equalTo(lineView.right).offset(0);
    }];
    
    
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
    

     cell.toplab.text =@"在线音乐";
     cell.bottolab.text =@"最近使用:2017/12/31";
     cell.rightlab.text =@"45M";
   
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
