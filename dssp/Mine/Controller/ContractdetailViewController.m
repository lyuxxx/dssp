//
//  ContractdetailViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractdetailViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
#import "TopImgButton.h"
#import "NSArray+Sudoku.h"
#import "ContractdetailCell.h"
#import "ContractDetailed.h"
@interface ContractdetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *vipLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *describeLabel;
@property (nonatomic,strong) ContractData *contractData;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIView * headerView;
@end

@implementation ContractdetailViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self tableViews];
   [self setupUI];
}

-(void)requestData
{
    
    NSDictionary *paras = @{
//                            @"contractCode": _contractCode?_contractCode:@"VF7CAPSA000000002"
                            };
    
    NSString *findServiceVin = [NSString stringWithFormat:@"%@/%@",findServiceByVin,_contractCode];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:findServiceVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
           _contractData = [ContractData yy_modelWithDictionary:dic[@"data"]];
           _dataArray =_contractData.serviceItemProfiles;
            [_tableView reloadData];
            [self setupUI];
            //响应事件
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}

-(void)tableViews
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
    _tableView.backgroundColor=[UIColor clearColor];
    //    隐藏线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,265*HeightCoefficient)];
    _headerView.backgroundColor=[UIColor clearColor];
    _tableView.tableHeaderView=_headerView;
    
}


-(void)setupUI
{

    self.navigationItem.title = NSLocalizedString(@"合同详细", nil);

    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [_headerView addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(190 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    
    UIView *V = [[UIView alloc] init];
    V.layer.cornerRadius = 2;
    V.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
    [_headerView addSubview:V];
    [V makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 *WidthCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
    make.top.equalTo(whiteV.bottom).offset(22.5*HeightCoefficient);
    }];
    
    
    UILabel *service = [[UILabel alloc] init];
    service.textAlignment = NSTextAlignmentLeft;
    service.textColor=[UIColor colorWithHexString:@"#ffffff"];
    service.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    service.text = NSLocalizedString(@"可用服务", nil);
    [_headerView addSubview:service];
    [service makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100 * WidthCoefficient);
        make.left.equalTo(24 * WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
    make.top.equalTo(whiteV.bottom).offset(22.5*HeightCoefficient);
    }];

    
    
    self.vipLabel = [[UILabel alloc] init];
    _vipLabel.textAlignment = NSTextAlignmentLeft;
    _vipLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _vipLabel.text = NSLocalizedString(_contractData.name, nil);
    _vipLabel.textColor=[UIColor colorWithHexString:@"#A18E79"];
    [whiteV addSubview:_vipLabel];
    [_vipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    self.typeLabel = [[UILabel alloc] init];
    _typeLabel.textAlignment = NSTextAlignmentLeft;
    _typeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    NSString *packType = [NSString stringWithFormat:@"类型：%@",_contractData.packType];
//                         stringByAppendingString:@"条新消息通知"]
    _typeLabel.text = NSLocalizedString(packType, nil);
    _typeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:_typeLabel];
    [_typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(_vipLabel.bottom).offset(10 * HeightCoefficient);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    NSString *a = _contractData.createTime?_contractData.createTime:@"";
//    NSString *b = [a substringWithRange:NSMakeRange(0,10)];
    NSString *a1 = _contractData.lastUpdateTime?_contractData.lastUpdateTime:@"";
//    NSString *b1= [a1 substringWithRange:NSMakeRange(0,10)];
    NSString *time = [[NSString stringWithFormat:@"有效时间：%@至",a] stringByAppendingString:a1];
//    NSString *createTime = [NSString stringWithFormat:@"有效时间:%@",b];
    _timeLabel.numberOfLines = 0;
    _timeLabel.text = NSLocalizedString(time, nil);
    _timeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(170 * WidthCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.right.equalTo(-10 * HeightCoefficient);
        make.top.equalTo(_typeLabel.bottom).offset(10 * HeightCoefficient);
    }];
    
    self.describeLabel = [[UILabel alloc] init];
    _describeLabel.textAlignment = NSTextAlignmentLeft;
    _describeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    NSString *descript = [NSString stringWithFormat:@"描述：%@",_contractData.descript];
    _describeLabel.text = NSLocalizedString(descript, nil);
    _describeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:_describeLabel];
    [_describeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(41.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.right.equalTo(-10 * HeightCoefficient);
        make.top.equalTo(_timeLabel.bottom).offset(10 * HeightCoefficient);
    }];
    
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*HeightCoefficient;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContractdetailCellName";
    ContractdetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ContractdetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.toplab.text = _dataArray[indexPath.row][@"deviceType"];
    cell.backgroundColor =[UIColor clearColor];
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
