//
//  StoreHomeViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/6.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreHomeViewController.h"
#import "CommodityCell.h"
#import "CommodityHeaderView.h"
#import "CommodityDetailViewController.h"
#import "StoreObject.h"
#import "OrderSubmitViewController.h"

@interface StoreHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<StoreCategory *> *categories;
@property (nonatomic, strong) NSArray<StoreCommodity *> *commodities;
@property (nonatomic, strong) StoreCategory *selectedCategory;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *leftScroll;
@property (nonatomic, strong) UIButton *lastBtn;
@end

@implementation StoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createGradientBg];
    [self createCollectionView];
    [self getStoreCategoriesList];
}

- (void)createGradientBg {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - kTabbarHeight - 1);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)getStoreCategoriesList {
    [CUHTTPRequest POST:getStoreCategories parameters:@{} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        StoreCategoryResponse *response = [StoreCategoryResponse yy_modelWithJSON:dic];
        self.categories = response.data;
        self.selectedCategory = self.categories[0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createLeftScroll];
        });
        [self getCommoditiesWithCategoryId:self.categories[0].contentCategoryId];
    } failure:^(NSInteger code) {
        
    }];
}

- (void)getCommoditiesWithCategoryId:(NSInteger)categoryId {
    NSDictionary *paras = @{@"contentCategoryId":[NSNumber numberWithInteger:categoryId]};
    [CUHTTPRequest POST:getCategoryCommodities parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        StoreCommodityResponse *resposne = [StoreCommodityResponse yy_modelWithJSON:dic];
        self.commodities = resposne.data;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } failure:^(NSInteger code) {
        
    }];
}

- (void)createLeftScroll {
    if (self.leftScroll) {
        [self.leftScroll removeFromSuperview];
        self.leftScroll = nil;
    }
    self.leftScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_leftScroll];
    [_leftScroll makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.equalTo(100 * WidthCoefficient);
        make.height.equalTo(50 * WidthCoefficient * self.categories.count);
    }];
    
    UIView *content = [[UIView alloc] init];
    [_leftScroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_leftScroll);
        make.width.equalTo(100 * WidthCoefficient);
    }];
    
    UIView *lastView;
    for (NSInteger i = 0; i < self.categories.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont fontWithName:FontName size:15];
        [btn setTitle:self.categories[i].name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"category_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"category_selected"] forState:UIControlStateSelected];
        [content addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(content);
            make.width.equalTo(100 * WidthCoefficient);
            make.height.equalTo(50 * WidthCoefficient);
            if (i == 0) {
                make.top.equalTo(content);
            } else {
                make.top.equalTo(lastView.bottom);
            }
        }];
        lastView = btn;
        if (i == 0) {
            _lastBtn = btn;
            btn.selected = YES;
        }
    }
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content);
    }];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10 * WidthCoefficient;
    flowLayout.minimumLineSpacing = 10 * WidthCoefficient;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20 * WidthCoefficient, 0, 16 * WidthCoefficient);
    flowLayout.itemSize = CGSizeMake(114.5 * WidthCoefficient, 195 * WidthCoefficient);
    flowLayout.headerReferenceSize = CGSizeMake(275 * WidthCoefficient, 50 * WidthCoefficient);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.width.equalTo(275 * WidthCoefficient);
    }];
    
    [_collectionView registerClass:[CommodityCell class] forCellWithReuseIdentifier:NSStringFromClass([CommodityCell class])];
    [_collectionView registerClass:[CommodityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CommodityHeaderView class])];
}

- (void)btnClick:(UIButton *)sender {
    if (sender != _lastBtn) {
        _lastBtn.selected = NO;
        sender.selected = YES;
        _lastBtn = sender;
        NSInteger categoryId = self.categories[sender.tag - 100].contentCategoryId;
        self.selectedCategory = self.categories[sender.tag - 100];
        [self getCommoditiesWithCategoryId:categoryId];
    }
}

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CommodityHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CommodityHeaderView class]) forIndexPath:indexPath];
    headerView.title = self.selectedCategory.name;
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CommodityDetailViewController *vc = [[CommodityDetailViewController alloc] initWithCommodity:self.commodities[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
