//
//  ContractViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
#import "ContractCell.h"
#import "ContractModel.h"
#import "ContractdetailViewController.h"
#import "MJRefresh.h"
@interface ContractViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    ContractModel *contract;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *contractData;
@property (nonatomic, strong)NSMutableArray *latestNewsFrame;
@property (nonatomic, assign) int count;
@end


@implementation ContractViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navigationItem.title = NSLocalizedString(@"合同服务", nil);
    [self requestData];
    [self initTableView];
    
    [self.tableView.mj_footer beginRefreshing];
    // 下拉加载最新数据
//    [self pullDownToRefreshLatestNews];
    // 上拉加载更多数据
    [self pullUpToLoadMoreNews];
}


/**
 *  下拉加载最新数据
 */
//- (void)pullDownToRefreshLatestNews {
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    // 设置header
//    [_tableView.mj_header beginRefreshing];
//}

/**
 *  上拉加载更多数据
 */
- (void)pullUpToLoadMoreNews {
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMoreNews];
    }];
}



-(void)requestData
{
    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    NSString *vin = [defaults1 objectForKey:@"vin"];
    
    NSDictionary *paras = @{
                            @"vin": kVin,
                            @"currentPage":@"1",
                            @"pageSize":@"5"
                            };

    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
            NSArray *dataArray =dic[@"data"][@"result"];
            NSMutableArray *contractData = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                contract = [ContractModel yy_modelWithDictionary:dic];
                
                [contractData addObject:contract];
            }
            self.latestNewsFrame = contractData;
            NSLog(@"333%@",contract.contractBeginTime);

            [_tableView reloadData];
            // 结束刷新状态
            [_tableView.mj_header endRefreshing];
           
        } else {
             [_tableView.mj_header endRefreshing];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
         [_tableView.mj_header endRefreshing];
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}


-(void)requestMoreNews
{

    _count += 1;
    NSString *string = [[NSString alloc] initWithFormat:@"%d",_count];
    NSDictionary *paras = @{
                            @"vin": @"VF7CAPSA000020942",
                            @"currentPage":string,
                            @"pageSize":@"5"
                            };
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
            NSArray *dataArray =dic[@"data"][@"result"];
            NSMutableArray *contractData = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                contract = [ContractModel yy_modelWithDictionary:dic];
                
                [contractData addObject:contract];
            }
             [self.latestNewsFrame addObjectsFromArray:contractData];
            
            NSLog(@"333%@",contract.contractBeginTime);
            
            [_tableView reloadData];
            // 结束刷新状态
            [_tableView.mj_footer endRefreshing];
            
        } else {
            [_tableView.mj_footer endRefreshing];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [_tableView.mj_footer endRefreshing];
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
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
     //取消cell的线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
//    _tableView.bounces=NO;
    //滚动条隐藏
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(20 *HeightCoefficient, 0, 0, 0));
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCellName";
    ContractCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ContractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
//    ContractModel *contract =[ContractModel new];
     cell.contractModel = contract;
//    cell.img.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row][0]];
//    cell.moneyLabel.text = contract.userId;
//    cell.arrowImg.image=[UIImage imageNamed:@"arrownext"];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.latestNewsFrame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157.5*HeightCoefficient;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractdetailViewController *Contractdetail = [ContractdetailViewController new];
    Contractdetail.contractCode = contract.contractCode;
    [self.navigationController pushViewController: Contractdetail animated:YES];
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
