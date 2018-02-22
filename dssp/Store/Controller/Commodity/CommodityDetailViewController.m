//
//  CommodityDetailViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityDetailViewController.h"
#import "CommodityDetailCellsConfigurator.h"

#import "CommodityBannerCell.h"
#import "CommodityNameCell.h"
#import "CommodityPriceCell.h"
#import "CommodityCommentHeaderCell.h"
#import "CommodityCommentCell.h"
#import "CommodityCommentFooterCell.h"
#import "CommodityCommentsViewController.h"
#import "OrderSubmitViewController.h"
#import "StoreObject.h"

@interface CommodityDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<CommodityComment *> *comments;//两个评论

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommodityDetailCellsConfigurator *cellConfigurator;

@property (nonatomic, strong) StoreCommodity *commodity;
@property (nonatomic, strong) StoreCommodityDetail *commodityDetail;

@end

@implementation CommodityDetailViewController

- (instancetype)initWithCommodity:(StoreCommodity *)commodity {
    self = [super init];
    if (self) {
        self.commodity = commodity;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self pullData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    self.navigationItem.title = NSLocalizedString(@"商品详细", nil);
    [self.view addSubview:self.tableView];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [buyBtn setTitle:NSLocalizedString(@"购买", nil) forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    buyBtn.frame = CGRectMake(0, kScreenHeight - kNaviHeight - kBottomHeight - 49 * WidthCoefficient, kScreenWidth, 49 * WidthCoefficient);
    if (Is_Iphone_X) {
        buyBtn.frame = CGRectMake(16 * WidthCoefficient, kScreenHeight - kNaviHeight - kBottomHeight - 49 * WidthCoefficient, 343 * WidthCoefficient, 49 * WidthCoefficient);
        buyBtn.layer.cornerRadius = 4;
        buyBtn.layer.shadowOffset = CGSizeMake(0, -5);
        buyBtn.layer.shadowColor = [UIColor colorWithHexString:@"#040000"].CGColor;
        buyBtn.layer.shadowRadius = 15;
        buyBtn.layer.shadowOpacity = 0.7;
    }
    [self.view addSubview:buyBtn];
}

- (void)pullData {
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //请求商品详细
        [CUHTTPRequest POST:[NSString stringWithFormat:@"%@/%ld",getCommodityDetail,self.commodity.itemId] parameters:@{} success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            StoreCommodityDetailResponse *response = [StoreCommodityDetailResponse yy_modelWithJSON:dic];
            self.commodityDetail = response.data;
            self.cellConfigurator = [[CommodityDetailCellsConfigurator alloc] initWithCommodityDetail:self.commodityDetail];
            
            dispatch_group_leave(group);
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSInteger code) {
            dispatch_group_leave(group);
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        //请求评论列表
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [CUHTTPRequest POST:findItemcommentList parameters:@{@"itemId":[NSString stringWithFormat:@"%ld",self.commodity.itemId]} success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            CommodityCommentResponse *response = [CommodityCommentResponse yy_modelWithJSON:dic];
            NSArray *tmpComments = response.data.result;
            if (tmpComments.count > 2) {
                self.comments = [response.data.result subarrayWithRange:NSMakeRange(0, 2)];
            } else {
                self.comments = tmpComments;
            }
            self.cellConfigurator.comments = self.comments;
            dispatch_group_leave(group);
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSInteger code) {
            dispatch_group_leave(group);
            dispatch_semaphore_signal(semaphore);
            
        }];
    });
    
    dispatch_group_notify(group, queue, ^{

        //两次请求完成
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

- (void)buyBtnClick:(UIButton *)sender {
    OrderSubmitViewController *vc = [[OrderSubmitViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - kBottomHeight - 49 * WidthCoefficient);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellConfigurator numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case CommodityDetailCellTypeBanner:
        {
            CommodityBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityBannerCellIdentifier];
            [cell configWithImages:self.cellConfigurator.bannerPics];
            return cell;
        }
            break;
        case CommodityDetailCellTypeName:
        {
            CommodityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityNameCellIdentifier];
            [cell configWithCommodityName:self.cellConfigurator.name];
            return cell;
        }
            break;
        case CommodityDetailCellTypePrice:
        {
            CommodityPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityPriceCellIdentifier];
            [cell configWithPrice:self.cellConfigurator.price];
            return cell;
        }
            break;
        case CommodityDetailCellTypeCommentHeader:
        {
            CommodityCommentHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityCommentHeaderCellIdentifier];
            return cell;
        }
            break;
        case CommodityDetailCellTypeComment:
        {
            CommodityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityCommentCellIdentifier];
            [cell configWithComment:self.cellConfigurator.comments[indexPath.row]];
            return cell;
        }
            break;
        case CommodityDetailCellTypeCommentFooter:
        {
            CommodityCommentFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityCommentFooterCellIdentifier];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case CommodityDetailCellTypeBanner:
        {
            return [CommodityBannerCell cellHeight];
        }
            break;
        case CommodityDetailCellTypeName:
        {
            return [CommodityNameCell cellHeightWithCommodityName:self.cellConfigurator.name];
        }
            break;
        case CommodityDetailCellTypePrice:
        {
            return [CommodityPriceCell cellHeight];
        }
            break;
        case CommodityDetailCellTypeCommentHeader:
        {
            return [CommodityCommentHeaderCell cellHeight];
        }
            break;
        case CommodityDetailCellTypeComment:
        {
            return [CommodityCommentCell cellHeightWithComment:self.cellConfigurator.comments[indexPath.row]];
        }
            break;
        case CommodityDetailCellTypeCommentFooter:
        {
            return [CommodityCommentFooterCell cellHeight];
        }
            break;
            
        default:
            break;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == CommodityDetailCellTypeCommentFooter) {
        CommodityCommentsViewController *vc = [[CommodityCommentsViewController alloc] initWithCommodityId:self.commodity.itemId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        
        [_tableView registerClass:[CommodityBannerCell class] forCellReuseIdentifier:CommodityBannerCellIdentifier];
        [_tableView registerClass:[CommodityNameCell class] forCellReuseIdentifier:CommodityNameCellIdentifier];
        [_tableView registerClass:[CommodityPriceCell class] forCellReuseIdentifier:CommodityPriceCellIdentifier];
        [_tableView registerClass:[CommodityCommentHeaderCell class] forCellReuseIdentifier:CommodityCommentHeaderCellIdentifier];
        [_tableView registerClass:[CommodityCommentCell class] forCellReuseIdentifier:CommodityCommentCellIdentifier];
        [_tableView registerClass:[CommodityCommentFooterCell class] forCellReuseIdentifier:CommodityCommentFooterCellIdentifier];
    }
    return _tableView;
}

- (CommodityDetailCellsConfigurator *)cellConfigurator {
    if (!_cellConfigurator) {
        _cellConfigurator = [[CommodityDetailCellsConfigurator alloc] init];
    }
    return _cellConfigurator;
}

@end
