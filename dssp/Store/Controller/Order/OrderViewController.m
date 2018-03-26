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
#import "OrderDetailViewController.h"
#import "InputAlertView.h"
#import <UIScrollView+EmptyDataSet.h>

@interface OrderViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSNumber *type;// 0、未付款，1、已付款，2、交易成功，3、交易取消,不传查所有
@property (nonatomic, strong) NSMutableArray<Order *> *orders;

@property (nonatomic, assign) NSInteger currentPage;

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
    self.currentPage = 1;
    [self.orders removeAllObjects];
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
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendListData)];
    footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
    self.tableView.mj_footer = footer;
}

- (void)pullOrderListData {
    
    self.currentPage = 1;
    
    [CUHTTPRequest POST:getOrderList parameters:@{@"status":self.type,@"currentPage":[NSNumber numberWithInteger:self.currentPage]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            [self.orders removeAllObjects];
            OrderResponse *response = [OrderResponse yy_modelWithJSON:dic];
            self.orders = [NSMutableArray arrayWithArray:response.data.result];
            
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            if (response.data.result) {
                self.currentPage++;
            }
        } else {
            _tableView.emptyDataSetSource = self;
            _tableView.emptyDataSetDelegate = self;
            
           [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    } failure:^(NSInteger code) {
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)appendListData {
    [CUHTTPRequest POST:getOrderList parameters:@{@"status":self.type,@"currentPage":[NSNumber numberWithInteger:self.currentPage]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            OrderResponse *response = [OrderResponse yy_modelWithJSON:dic];
            if (response.data.result.count) {
                self.currentPage++;
            }
            [self.orders addObjectsFromArray:response.data.result];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSInteger code) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)cancelOrderWithOrderNo:(NSString *)orderNo {
    [Statistics staticsstayTimeDataWithType:@"3" WithController:@"ClickEventCancel"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:cancelOrderURL parameters:@{@"orderNo":orderNo} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            hud.label.text = NSLocalizedString(@"取消成功", nil);
            [hud hideAnimated:YES afterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header beginRefreshing];
            });
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
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
            InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [InputalertView initWithTitle:@"是否确定取消订单" img:@"cancelOrder" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: InputalertView];
            
            InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                if (btn.tag == 100) {//左边按钮
                    [self cancelOrderWithOrderNo:order.orderNo];
                }
                if(btn.tag ==101)
                {
                    //右边按钮
                    
                }
                
            };
        } else if (action == OrderActionPay) {
            OrderPayViewController *vc = [[OrderPayViewController alloc] initWithOrder:order];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (action == OrderActionEvaluate) {
            EvaluateViewController *vc = [[EvaluateViewController alloc] initWithOrder:order];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (action == OrderActionInvoice) {
            InvoicePageController *vc = [[InvoicePageController alloc] initWithOrderId:[NSString stringWithFormat:@"%ld",order.orderId]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    [cell configWithOrder:order];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *order = self.orders[indexPath.row];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] initWithOrder:order];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource -

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = NSLocalizedString(@"暂无订单", nil);
//    UIFont *font = [UIFont fontWithName:FontName size:16];
//    UIColor *textColor = [UIColor colorWithHexString:@"999999"];
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"暂无内容"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - 30 * WidthCoefficient;
}

#pragma mark - DZNEmptyDataSetDelegate -

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointZero;
}

#pragma mark - lazy load -

- (NSMutableArray<Order *> *)orders {
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

@end
