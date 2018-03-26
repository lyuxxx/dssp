//
//  StoreSingleViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/6.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreSingleViewController.h"
#import "CommodityCell.h"
#import "CommodityHeaderView.h"
#import "CommodityDetailViewController.h"
#import "StoreObject.h"
#import "OrderSubmitViewController.h"
#import <MJRefresh.h>
#import <UIScrollView+EmptyDataSet.h>

@interface StoreSingleViewController () <UICollectionViewDelegate, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray<StoreCategory *> *categories;
@property (nonatomic, strong) NSMutableArray<StoreCommodity *> *commodities;
@property (nonatomic, strong) StoreCategory *selectedCategory;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *leftScroll;

@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger categoryId;

@end

@implementation StoreSingleViewController

- (instancetype)initWithCategoryId:(NSInteger)categoryId {
    self = [super init];
    if (self) {
        self.categoryId = categoryId;
    }
    return self;
}

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.clipsToBounds = YES;
    
    self.currentPage = 1;
    [self.commodities removeAllObjects];
    
//    [self setupLeftBg];
    
    [self createCollectionView];
    [self pullCommodities];
}

//- (void)setupLeftBg {
//    UIView *leftBg = [[UIView alloc] init];
//    leftBg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
//    [self.view addSubview:leftBg];
//    [leftBg makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(100 * WidthCoefficient);
//        make.height.equalTo(kScreenHeight - kNaviHeight - kTabbarHeight - 1);
//        make.left.top.equalTo(self.view);
//    }];
//
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = [UIColor colorWithHexString:@"#2f2726"];
//    [self.view addSubview:line];
//    [line makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(1);
//        make.height.equalTo(kScreenHeight - kNaviHeight - kTabbarHeight - 1);
//        make.top.equalTo(self.view);
//        make.left.equalTo(leftBg.right);
//    }];
//}

//- (void)createLeftScroll {
//    if (self.leftScroll) {
//        [self.leftScroll removeFromSuperview];
//        self.leftScroll = nil;
//    }
//    self.leftScroll = [[UIScrollView alloc] init];
//    [self.view addSubview:_leftScroll];
//    NSInteger height = 50 * WidthCoefficient * self.categories.count;
//    if (height > kScreenHeight - kNaviHeight - kTabbarHeight - 1) {
//        height = kScreenHeight - kNaviHeight - kTabbarHeight - 1;
//    }
//    [_leftScroll makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.view);
//        make.width.equalTo(100 * WidthCoefficient);
//        make.height.equalTo(height);
//    }];
//
//    UIView *content = [[UIView alloc] init];
//    [_leftScroll addSubview:content];
//    [content makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_leftScroll);
//        make.width.equalTo(100 * WidthCoefficient);
//    }];
//
//    UIView *lastView;
//    for (NSInteger i = 0; i < self.categories.count; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag = 100 + i;
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.titleLabel.font = [UIFont fontWithName:FontName size:15];
//        [btn setTitle:self.categories[i].name forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"category_normal"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"category_selected"] forState:UIControlStateSelected];
//        [content addSubview:btn];
//        [btn makeConstraints:^(MASConstraintMaker *make) {
//            make.right.left.equalTo(content);
//            make.width.equalTo(100 * WidthCoefficient);
//            make.height.equalTo(50 * WidthCoefficient);
//            if (i == 0) {
//                make.top.equalTo(content);
//            } else {
//                make.top.equalTo(lastView.bottom);
//            }
//        }];
//        lastView = btn;
//        if (i == 0) {
//            _lastBtn = btn;
//            btn.selected = YES;
//        }
//    }
//    [lastView makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(content);
//    }];
//}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0 * WidthCoefficient;
    flowLayout.minimumLineSpacing = 0 * WidthCoefficient;
    flowLayout.sectionInset = UIEdgeInsetsMake(15 * WidthCoefficient, 11 * WidthCoefficient, 10 * WidthCoefficient, 11 * WidthCoefficient);
    flowLayout.itemSize = CGSizeMake(176 * WidthCoefficient, 250 * WidthCoefficient);
//    flowLayout.headerReferenceSize = CGSizeMake(275 * WidthCoefficient, 45 * WidthCoefficient);
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_collectionView registerClass:[CommodityCell class] forCellWithReuseIdentifier:NSStringFromClass([CommodityCell class])];
    [_collectionView registerClass:[CommodityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CommodityHeaderView class])];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshLatestNews)];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCommoditiesWithCategoryId)];
    //    footer.refreshingTitleHidden = YES;
    footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
    self.collectionView.mj_footer = footer;
}

- (void)pullDownToRefreshLatestNews {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StorePageControllerRefresh" object:nil userInfo:nil];
}

- (void)pullCommodities {
    
    self.currentPage = 1;
    
    NSDictionary *paras = @{@"cid":[NSNumber numberWithInteger:self.categoryId],@"currentPage":[NSNumber numberWithInteger:self.currentPage]};
    [CUHTTPRequest POST:getCategoryCommodities parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            StoreCommodityResponse *response = [StoreCommodityResponse yy_modelWithJSON:dic];
            [self.commodities removeAllObjects];
            [self.commodities addObjectsFromArray:response.data.result];
            if (response.data.result) {
                self.currentPage++;
            }
            
            _collectionView.emptyDataSetSource = self;
            _collectionView.emptyDataSetDelegate = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            });
        } else {
            _collectionView.emptyDataSetSource = self;
            _collectionView.emptyDataSetDelegate = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            });
        }
    } failure:^(NSInteger code) {
        
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        });
    }];
}

- (void)getCommoditiesWithCategoryId {
    NSDictionary *paras = @{@"cid":[NSNumber numberWithInteger:self.categoryId],@"currentPage":[NSNumber numberWithInteger:self.currentPage]};
    [CUHTTPRequest POST:getCategoryCommodities parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        StoreCommodityResponse *response = [StoreCommodityResponse yy_modelWithJSON:dic];
        [self.commodities addObjectsFromArray:response.data.result];
        if (response.data.result) {
            self.currentPage++;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        });
    } failure:^(NSInteger code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
}


//- (void)btnClick:(UIButton *)sender {
////    if (sender != _lastBtn) {
//        //清空
//        self.currentPage = 1;
//        [self.commodities removeAllObjects];
//        [self.collectionView reloadData];
//
//        _lastBtn.selected = NO;
//        sender.selected = YES;
//        _lastBtn = sender;
//        self.selectedCategory = self.categories[sender.tag - 100];
//        [self.collectionView.mj_footer beginRefreshing];
////    }
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.commodities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CommodityCell *cell = [CommodityCell cellWithCollectionView:collectionView forIndexPath:indexPath buyBtnClick:^(UIButton *sender) {
        OrderSubmitViewController *vc = [[OrderSubmitViewController alloc] initWithCommodity:self.commodities[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [cell configWithCommodity:self.commodities[indexPath.row]];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    CommodityHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CommodityHeaderView class]) forIndexPath:indexPath];
//    headerView.title = self.selectedCategory.name;
//    return headerView;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CommodityDetailViewController *vc = [[CommodityDetailViewController alloc] initWithCommodity:self.commodities[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource -

//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = NSLocalizedString(@"暂无商品", nil);
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

- (NSMutableArray<StoreCommodity *> *)commodities {
    if (!_commodities) {
        _commodities = [NSMutableArray array];
    }
    return _commodities;
}

@end
