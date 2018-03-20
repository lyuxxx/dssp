//
//  LllegalViewController.m
//  dssp
//
//  Created by qinbo on 2018/1/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "LllegalViewController.h"
#import "LllegaCell.h"
#import "LllegadetailController.h"
#import "LllegaModel.h"
@interface LllegalViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *employflowlabel;
@property (nonatomic, strong) UILabel *flowlabel;
@property (nonatomic, strong) UILabel *totalflowlabel;
@property (nonatomic, strong) NSMutableArray *DataArray;
//@property (nonatomic,strong) CarflowModel *carflow;
@end

@implementation LllegalViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//     self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
     self.navigationItem.title = NSLocalizedString(@"违章查询", nil);
    
   
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"LllegalViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics staticsvisitTimesDataWithViewControllerType:@"LllegalViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"LllegalViewController"];
}

-(void)requestData
{

    NSDictionary *paras = @{
                            
                            };
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", violationsForApp,kVin];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:paras success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
            NSArray *array = dic[@"data"][@"viloationInfo"];

            if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0){
                
                self.DataArray = [NSMutableArray new];
                for(int i= 0; i<array.count;i++) {
                    NSDictionary *dic1 = array[i];
                    LllegaModel *lllegaModel = [LllegaModel yy_modelWithDictionary:dic1];
                    
                    [self.DataArray addObject:lllegaModel];
                }
    
                
                [_tableView reloadData];
                [self initTableView];
            }
            else
            {
                 [self blankUI];
                
            }
        } else {
             [self blankUI];
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
           [self blankUI];
        [hud hideAnimated:YES];
      
        //    self.carflow =_carflow;
//        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        //        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        //        [hud hideAnimated:YES afterDelay:1];
    }];
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
    _tableView.backgroundColor=[UIColor clearColor];
    //    隐藏线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,126*HeightCoefficient)];
//    _headerView.backgroundColor=[UIColor whiteColor];
//    _tableView.tableHeaderView=_headerView;
    
    
//    [self setupUI];
}

-(void)setupUI
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"违章查询", nil);
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
    //
    
    
    //    NSString *remainFlow = [[NSString stringWithFormat:@"%@",_carflow.remainFlow] stringByAppendingString:@"M"];
//    double aNumber = [_carflow.remainFlow doubleValue];
//    NSString *remainFlow = [[NSString stringWithFormat:@"%.2f",aNumber] stringByAppendingString:@"M"];
    self.flowlabel = [[UILabel alloc] init];
    _flowlabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:28];
    _flowlabel.textColor=[UIColor whiteColor];
    _flowlabel.text = @"1起";

    //    _flowlabel.text = _carflow.remainFlow?remainFlow:@"0M";
    _flowlabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_flowlabel];
    [_flowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30*HeightCoefficient);
        make.height.equalTo(33.5 * HeightCoefficient);
        make.left.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    UILabel *surpluslabel = [[UILabel alloc] init];
    surpluslabel.font=[UIFont fontWithName:FontName size:13];
    surpluslabel.textColor=[UIColor whiteColor];
    surpluslabel.text=NSLocalizedString(@"未处理", nil);
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
        make.top.equalTo(24.5 * HeightCoefficient);
        make.height.equalTo(60 * HeightCoefficient);
        make.width.equalTo(1 * HeightCoefficient);
        
        
    }];
    
    
    self.totalflowlabel = [[UILabel alloc] init];
    _totalflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:28];
    _totalflowlabel.textColor=[UIColor whiteColor];
    _totalflowlabel.text = @"2起";
    _totalflowlabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_totalflowlabel];
    [_totalflowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30*HeightCoefficient);
        make.height.equalTo(33.5 * HeightCoefficient);
        make.right.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    UILabel *totalflow = [[UILabel alloc] init];
    totalflow.font=[UIFont fontWithName:FontName size:13];
    totalflow.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
    totalflow.text=NSLocalizedString(@"已处理", nil);
    totalflow.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:totalflow];
    [totalflow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalflowlabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.right.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    
//    UILabel *Lastlabel = [[UILabel alloc] init];
//    Lastlabel.font=[UIFont fontWithName:FontName size:13];
//    Lastlabel.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
//    Lastlabel.layer.cornerRadius = 20 * HeightCoefficient/2;
//    Lastlabel.clipsToBounds = YES;
//    Lastlabel.textColor=[UIColor whiteColor];
//    Lastlabel.text=NSLocalizedString(@"本数据均为前一天统计数", nil);
//    Lastlabel.textAlignment = NSTextAlignmentCenter;
//    [bgImgV addSubview:Lastlabel];
//    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(totalflow.bottom).offset(12*HeightCoefficient);
//        make.height.equalTo(20 * HeightCoefficient);
//        make.centerX.equalTo(bgImgV);
//        make.width.equalTo(240 * WidthCoefficient);
//    }];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*HeightCoefficient;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LllegaCellName";
    LllegaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LllegaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }


    LllegaModel *lllegaModel=self.DataArray[indexPath.row];
    cell.lllegaModel = lllegaModel;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

//点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LllegaModel *lllegaModel=self.DataArray[indexPath.row];
    LllegadetailController *lllegadetail =[[LllegadetailController alloc] init];
    
    lllegadetail.lllegaModel = lllegaModel;
//    //    remindView.vin= notice.vin;
//    //    remindView.title=notice.title;
//    //    remindView.businType= notice.businType;
//    //    remindView.noticeId = notice.noticeId;
//    remindView.noticeModel = notice;
//    remindView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lllegadetail animated:YES];
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
