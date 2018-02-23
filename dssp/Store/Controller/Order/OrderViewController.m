//
//  OrderViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderCell.h"
#import "OrderPayViewController.h"
#import "EvaluateViewController.h"
#import "InvoicePageController.h"
#import <MJRefresh.h>
#import "OrderObject.h"

@interface OrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSNumber *type;// 0、未付款，1、已付款，2、交易成功，3、交易取消,不传查所有
@property (nonatomic, strong) NSMutableArray<Order *> *orders;
@end

@implementation OrderViewController

- (BOOL)needGradientBg {
    return NO;
}

- (instancetype)initWithType:(NSNumber *)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:NSStringFromClass([OrderCell class])];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullOrderListData)];
}

- (void)pullOrderListData {
    [CUHTTPRequest POST:getOrderList parameters:@{@"status":self.type} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            OrderResponse *response = [OrderResponse yy_modelWithJSON:dic];
            [self.orders removeAllObjects];
            self.orders = [NSMutableArray arrayWithArray:response.data.result];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } else {
           [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSInteger code) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)cancelOrderWithOrderNo:(NSString *)orderNo {
    [CUHTTPRequest POST:cancelOrderURL parameters:@{@"orderNo":orderNo} success:^(id responseData) {
        
    } failure:^(NSInteger code) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OrderCell cellHeightWithOrder:self.orders[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = self.orders[indexPath.row];
    OrderCell *cell = [OrderCell cellWithTableView:tableView action:^(OrderAction action) {//订单操作
        if (action == OrderActionCancel) {
            [self cancelOrderWithOrderNo:order.orderNo];
        } else if (action == OrderActionPay) {
            OrderPayViewController *vc = [[OrderPayViewController alloc] initWithOrder:order];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (action == OrderActionEvaluate) {
            EvaluateViewController *vc = [[EvaluateViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (action == OrderActionInvoice) {
            InvoicePageController *vc = [[InvoicePageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [cell configWithOrder:order];
    return cell;
}

- (NSMutableArray<Order *> *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

@end
