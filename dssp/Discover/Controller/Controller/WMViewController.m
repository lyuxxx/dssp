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
#import <UIScrollView+EmptyDataSet.h>
@interface WMViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
//@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray  *channelArray;
@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, assign) BOOL didAppear;
@end

@implementation WMViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor clearColor];
    [self initTableView];
    [self requestData];

}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (self.didAppear) {
//        self.didAppear = NO;
////        [self pullDownToRefreshLatestNews];
//          [self requestData];
//    }
//    else
//    {
//        [self requestData];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)pullDownToRefreshLatestNews {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubscribeVCneedRefresh" object:nil userInfo:nil];
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
            
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
            for (NSDictionary *dic in dataArray) {
                ChannelModel *channel = [ChannelModel yy_modelWithDictionary:dic];
                [self.channelArray addObject:channel];
            }
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
            if (self.channelArray.count == 0) {
//                [self blankUI];
                _tableView.emptyDataSetSource = self;
                _tableView.emptyDataSetDelegate = self;
                [self.tableView.mj_header endRefreshing];
                [_tableView reloadData];
            }
            //响应事件
         
        } else {
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
            [self.tableView.mj_header endRefreshing];
            [_tableView reloadData];
//            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
//        [self blankUI];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [self.tableView.mj_header endRefreshing];
        [_tableView reloadData];
//        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
        
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

-(void)initTableView
{

    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
     _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
   
    //取消cell的线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    adjustsScrollViewInsets_NO(tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
    //    _tableView.bounces=NO;
    //滚动条隐藏
    //    _tableView.showsVerticalScrollIndicator = NO;
   

    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
//         make.edges.equalTo(self.view);
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(10 *HeightCoefficient, 0, kNaviHeight+kTabbarHeight, 0));
       
    }];
    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshLatestNews)];
//
//    self.tableView.mj_header = header;
//         //     隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//        // 隐藏状态
//    header.stateLabel.hidden = YES;
    
     _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshLatestNews)];
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
