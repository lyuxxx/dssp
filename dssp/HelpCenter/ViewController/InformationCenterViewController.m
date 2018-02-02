//
//  InformationCenterViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InformationCenterViewController.h"
#import "InfoMessageHelpCenterCell.h"
#import "InfoMessageUserCell.h"

@interface InformationCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<InfoMessage *> *dataSource;
@end

@implementation InformationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"咨询中心", nil);
    
    [self createTableView];
    [self pullData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[InfoMessageHelpCenterCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageHelpCenterCell class])];
    [self.tableView registerClass:[InfoMessageUserCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageUserCell class])];
}

- (void)pullData {
    
    [CUHTTPRequest POST:[NSString stringWithFormat:@"%@/0",sendToServiceKnowledgeProfileValue] parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
    } failure:^(NSInteger code) {
        
    }];
    
    [self.dataSource removeAllObjects];
    for (NSInteger i = 0 ; i < 10 ; i++) {
        InfoMessage *message = [[InfoMessage alloc] init];
        if (i % 2 == 0) {
            message = [[InfoMessage alloc] initWithTime:[NSDate date] text:@"亲,请问您遇到了什么问题?点击下方的常见问题可以快速得到解答哦~" choices:@[@"订单状态",@"取消订单",@"商城购物",@"客服电话",@"订单状态",@"取消订单",@"商城购物",@"客服电话",@"商城购物",@"客服电话",@"订单状态",@"取消订单",@"商城购物"] type:InfoMessageTypeOther];
            if (i == 0) {
                message.showTime = YES;
            }
        } else {
            message = [[InfoMessage alloc] initWithTime:[NSDate date] text:@"如何取消订单" choices:nil type:InfoMessageTypeMe];
        }
        [self.dataSource addObject:message];
    }
    [self.tableView reloadData];
}

- (void)sendMessage:(InfoMessage *)message {
    NSDate *lastDate = self.dataSource.lastObject.time;
    message.time = [NSDate date];
    NSTimeInterval interval = [message.time timeIntervalSinceDate:lastDate];
    if (interval > 5 * 60) {//5分钟后显示时间
        message.showTime = YES;
    }
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    [self.tableView scrollToBottomAnimated:NO];
}

/**
 * 返回每一行的估计高度
 * 只要返回了估计高度，那么就会先调用tableView:cellForRowAtIndexPath:方法创建cell，再调   用tableView:heightForRowAtIndexPath:方法获取cell的真实高度
*/
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380 * WidthCoefficient;//不要设置的太小
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoMessage *message = self.dataSource[indexPath.row];
    if (message.type == InfoMessageTypeOther) {
        InfoMessageHelpCenterCell *cell = [InfoMessageHelpCenterCell cellWithTableView:tableView serviceBlock:^(UIButton *sender) {
            NSLog(@"click:%@",sender.titleLabel.text);
        }];
        cell.message = message;
        return cell;
    }
    if (message.type == InfoMessageTypeMe) {
        InfoMessageUserCell *cell = [InfoMessageUserCell cellWithTableView:tableView];
        cell.message = message;
        return cell;
    }
    return nil;
}

- (NSMutableArray<InfoMessage *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
