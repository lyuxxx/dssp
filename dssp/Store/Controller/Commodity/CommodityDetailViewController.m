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
#import "CommodityDescriptionTitleCell.h"
#import "CommodityDescriptionCell.h"
#import "CommodityCommentHeaderCell.h"
#import "CommodityCommentCell.h"
#import "CommodityCommentFooterCell.h"
#import "CommodityCommentsViewController.h"
#import "OrderSubmitViewController.h"
#import "StoreObject.h"

@interface CommodityDetailViewController () <UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (nonatomic, strong) NSArray<CommodityComment *> *comments;//两个评论

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommodityDetailCellsConfigurator *cellConfigurator;

@property (nonatomic, strong) StoreCommodity *commodity;
@property (nonatomic, strong) StoreCommodityDetail *commodityDetail;

@property (nonatomic, strong) CommodityDescriptionCell *descCell;

@property (nonatomic, assign) CGFloat webViewHeight;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation CommodityDetailViewController

- (instancetype)initWithCommodity:(StoreCommodity *)commodity {
    self = [super init];
    if (self) {
        self.commodity = commodity;
    }
    return self;
}

- (BOOL)needGradientBg {
    if (Is_Iphone_X) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self pullData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    self.navigationItem.title = NSLocalizedString(@"商品详情", nil);
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
    
    self.hud = [MBProgressHUD showMessage:@""];
    
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
            if ([dic[@"code"] isEqualToString:@"200"]) {
                CommodityCommentResponse *response = [CommodityCommentResponse yy_modelWithJSON:dic];
                NSArray *tmpComments = response.data.result;
                if (tmpComments.count > 2) {
                    self.comments = [response.data.result subarrayWithRange:NSMakeRange(0, 2)];
                } else {
                    self.comments = tmpComments;
                }
                self.cellConfigurator.comments = self.comments;
            }
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
            if (self.cellConfigurator.desc && self.cellConfigurator.desc.length) {//有商品描述
                
            } else {
                [_hud hideAnimated:YES];
            }
            
            [self.tableView reloadData];
        });
    });
    
}

- (void)buyBtnClick:(UIButton *)sender {
    OrderSubmitViewController *vc = [[OrderSubmitViewController alloc] initWithCommodity:self.commodity];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - kBottomHeight - 49 * WidthCoefficient);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *js = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white';document.getElementsByTagName('body')[0].style.background='#120f0e';document.getElementsByTagName('body')[0].color='#ffffff';";
    //    NSString *js = @"document.body.style.backgroundColor='#120f0e'; document.body.style.color='#ffffff';document.body.style.webkitTextFillColor='#ffffff'";
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES afterDelay:0.3];
        });
        
        if (error) {
            
        }
    }];
    if (self.webViewHeight) {
        return;
    }
    self.webViewHeight = webView.scrollView.contentSize.height;
    [self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:webView.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CommodityDescriptionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:CommodityDetailCellTypeDescription]];
    if (cell) {
        [cell.webView setNeedsLayout];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellConfigurator.elementsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellConfigurator numberOfRowsInSection:section];
}

/**
 * 返回每一行的估计高度
 * 只要返回了估计高度，那么就会先调用tableView:cellForRowAtIndexPath:方法创建cell，再调   用tableView:heightForRowAtIndexPath:方法获取cell的真实高度
 */
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 300 * WidthCoefficient;
//}

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
            [cell configWithConfig:self.cellConfigurator];
            return cell;
        }
            break;
        case CommodityDetailCellTypeDescriptionTitle:
        {
            CommodityDescriptionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityDescriptionTitleCellIdentifier];
            
            return cell;
        }
            break;
        case CommodityDetailCellTypeDescription:
        {
            CommodityDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CommodityDescriptionCellIdentifier];
//            cell.myIndexPath = indexPath;
//            cell.tableView = self.tableView;
//            [cell configWithCommodityDescription:self.cellConfigurator.desc];
//            self.descCell = cell;
            cell.webView.tag = indexPath.section;
            cell.webView.navigationDelegate = self;
            
            NSString *htmlStr = [NSString stringWithFormat:@"<html><head><style type='text/css'>p{background: #120f0e !important;color: #FFFFFF;}p span{background: #120f0e !important;color: #FFFFFF !important;}</style></head><body>%@</body></html>",self.cellConfigurator.desc];
            
            [cell.webView loadHTMLString:htmlStr baseURL:nil];
            [cell.webView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self.webViewHeight);
            }];
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
        case CommodityDetailCellTypeDescriptionTitle:
        {
            return [CommodityDescriptionTitleCell cellHeight];
        }
            break;
        case CommodityDetailCellTypeDescription:
        {
//            return [self.descCell cellHeightWithCommodityDescription:self.cellConfigurator.desc];
            return self.webViewHeight + 25 * WidthCoefficient;
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
        [_tableView registerClass:[CommodityDescriptionTitleCell class] forCellReuseIdentifier:CommodityDescriptionTitleCellIdentifier];
        [_tableView registerClass:[CommodityDescriptionCell class] forCellReuseIdentifier:CommodityDescriptionCellIdentifier];
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
