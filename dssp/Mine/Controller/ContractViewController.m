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
@interface ContractViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    ContractModel *contract;
    
}

@property (nonatomic, strong) UITableView *tableView;

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
}

-(void)requestData
{
    
    NSDictionary *paras = @{
                            @"vin": @"V2017122700000001",
                            @"currentPage":@"1",
                            @"pageSize":@"20"
                            };

    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
          
            NSArray *dataArray =dic[@"data"][@"result"];
            for (NSDictionary *dic in dataArray) {
                contract = [ContractModel yy_modelWithDictionary:dic];
            }
            
        
            NSLog(@"333%@",contract.contractBeginTime);

            [_tableView reloadData];
           
           
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215*HeightCoefficient;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractdetailViewController *Contractdetail = [ContractdetailViewController new];
    Contractdetail.contractCode = contract.vin;
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
