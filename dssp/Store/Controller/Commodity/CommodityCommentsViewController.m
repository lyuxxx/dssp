//
//  CommodityCommentsViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityCommentsViewController.h"
#import "CommodityCommentsListCell.h"
#import "StoreObject.h"

@interface CommodityCommentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger commodityId;
@property (nonatomic, strong) NSMutableArray<CommodityComment *> *comments;
@end

@implementation CommodityCommentsViewController

- (instancetype)initWithCommodityId:(NSInteger)commodityId {
    self = [super init];
    if (self) {
        self.commodityId = commodityId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"评论", nil);
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getCommentsList];
}

- (void)getCommentsList {
    [CUHTTPRequest POST:findItemcommentList parameters:@{@"itemId":[NSString stringWithFormat:@"%ld",self.commodityId]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        CommodityCommentResponse *response = [CommodityCommentResponse yy_modelWithJSON:dic];
        self.comments = [NSMutableArray arrayWithArray:response.data.result];
        [self.tableView reloadData];
    } failure:^(NSInteger code) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CommodityCommentsListCell cellHeightWithComment:self.comments[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityCommentsListCell *cell = [CommodityCommentsListCell cellWithTableView:tableView];
    [cell configWithComment:self.comments[indexPath.row]];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        [_tableView registerClass:[CommodityCommentsListCell class] forCellReuseIdentifier:@"CommodityCommentsListCell"];
        
    }
    return _tableView;
}

- (NSMutableArray<CommodityComment *> *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

@end
