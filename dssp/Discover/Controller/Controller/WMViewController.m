//
//  WMViewController.m
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMViewController.h"
#import "SubscriCell.h"
#import <YYCategoriesSub/YYCategories.h>
#import "WMPageController.h"
#import "SubscribeModel.h"
#import "SubscribedatailController.h"
#import <MJRefresh.h>
@interface WMViewController ()<UITableViewDataSource,UITableViewDelegate,WMPageControllerDelegate,WMPageControllerDataSource>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, strong) NSMutableArray  *channelArray;
@end

@implementation WMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor colorWithHexString:@"#F9F8F8"];
    
  
    [self initTableView];

    [self pullDownToRefreshLatestNews];
   
    [self.tableView.mj_header beginRefreshing];


}

- (void)pullDownToRefreshLatestNews {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    // 设置header
    //    _tableView.mj_header.lastUpdatedTimeLabel.hidden = YES;
    [_tableView.mj_header beginRefreshing];
}





-(void)requestData
{
    
    
//    NSInteger channel = _indexs;
//    NSString *channelId = [[NSString alloc] initWithFormat:@"%ld",channel];
    NSDictionary *paras = @{
                                @"channelId":_indexs,
                                @"currentPage":@"0",
                                @"pageSize":@"10",
                                @"vin":kVin
                            };
    [CUHTTPRequest POST:findAppPushContentAppViewByAll parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
            NSArray *dataArray = dic[@"data"][@"result"];
//            NSMutableArray *array=[NSMutableArray array];
            self.channelArray =[NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                ChannelModel *channel = [ChannelModel yy_modelWithDictionary:dic];
                [self.channelArray addObject:channel];
            }
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
            //响应事件
            
        } else {
//            [self initTableView];
             [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
//        [self initTableView];
         [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        
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
//    if (self.channelArray.count ==0 ) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    adjustsScrollViewInsets_NO(tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
    //    _tableView.bounces=NO;
    //滚动条隐藏
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
//         make.edges.equalTo(self.view);
       
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(10 *HeightCoefficient, 0, 0, 0));
       
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCellName";
    SubscriCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SubscriCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //    cell.img.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row][0]];
    //    cell.lab.text =_dataArray[indexPath.section][indexPath.row][1];
    //    cell.arrowImg.image=[UIImage imageNamed:@"arrownext"];
    
    cell.channelModel = _channelArray[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _channelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110*HeightCoefficient;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscribedatailController *vc = [[SubscribedatailController alloc] init];
    ChannelModel *channel  = _channelArray[indexPath.row];
    vc.channels = channel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    NSLog(@"%@ destroyed",[self class]);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
