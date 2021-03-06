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
#import <UIScrollView+EmptyDataSet.h>
@interface ContractViewController ()
<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    ContractModel *contract;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *contractData;
@property (nonatomic, strong)NSMutableArray *latestNewsFrame;
@property (nonatomic, assign) int count;
@end


@implementation ContractViewController

- (BOOL)needGradientBg {
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
//    [self pullUpToLoadMoreNews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"ContractViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics staticsvisitTimesDataWithViewControllerType:@"ContractViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"ContractViewController"];
}


/**
 *  下拉加载最新数据
 */
//- (void)pullDownToRefreshLatestNews {
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    // 设置header
//    [_tableView.mj_header beginRefreshing];
//}

//- (void)pullDownToRefreshLatestNews {
//    //    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNoticeData)];
//    //    // 设置header
//    ////    _tableView.mj_header.lastUpdatedTimeLabel.hidden = YES;
//    //    [_tableView.mj_header beginRefreshing];
//
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    self.tableView.mj_header = header;
    // 隐藏时间
    //      header.lastUpdatedTimeLabel.hidden = YES;
    //      // 隐藏状态
    //      header.stateLabel.hidden = YES;
    
//}

/**
 *  上拉加载更多数据
 */
//- (void)pullUpToLoadMoreNews {
//    __weak __typeof(self) weakSelf = self;
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestMoreNews];
//    }];
//}



-(void)requestData
{
    _count = 1;
    NSString *string = [[NSString alloc] initWithFormat:@"%d",_count];
    self.tableView.mj_header.hidden =YES;
    NSDictionary *paras = @{
                            @"vin": kVin,
                            @"currentPage":string,
                            @"pageSize":@"5"
                            };
//    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [hud hideAnimated:YES];
            NSArray *dataArray =dic[@"data"][@"result"];
            NSMutableArray *contractData = [NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                contract = [ContractModel yy_modelWithDictionary:dic];
                [contractData addObject:contract];
            }
            self.latestNewsFrame = contractData;
            if (self.latestNewsFrame.count == 0) {
                _tableView.emptyDataSetSource = self;
                _tableView.emptyDataSetDelegate = self;
                [self.tableView.mj_header endRefreshing];
                [_tableView reloadData];
                self.tableView.mj_footer.hidden =YES;
               
            }

            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
          
            [_tableView reloadData];
            // 结束刷新状态
//            [_tableView.mj_header endRefreshing];
           
        } else {
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
//            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
//            self.tableView.mj_footer.hidden =YES;
          
//            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
//        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
//        self.tableView.mj_footer.hidden =YES;
        
//         [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
//        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
//        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"暂无内容"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - 30 * WidthCoefficient;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.contentOffset = CGPointZero;
    }];
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


-(void)requestMoreNews
{
    _count += 1;
    NSString *string = [[NSString alloc] initWithFormat:@"%d",_count];
    NSDictionary *paras = @{
                            @"vin": kVin,
                            @"currentPage":string,
                            @"pageSize":@"5"
                            };
    
//    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            [hud hideAnimated:YES];
            
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
        
         [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
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
    
    cell.contractModel = contract;
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
