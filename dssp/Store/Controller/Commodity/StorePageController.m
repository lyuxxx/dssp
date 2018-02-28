//
//  StorePageController.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StorePageController.h"
#import "StoreSingleViewController.h"
#import "StoreObject.h"

@interface StorePageController ()

@property (nonatomic, strong) NSArray<StoreCategory *> *categories;

@end

@implementation StorePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyCalculatesItemWidths = YES;
    
    self.view.clipsToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [self getStoreCategoriesList];
}

- (void)getStoreCategoriesList {
    [CUHTTPRequest POST:getStoreCategories parameters:@{@"parentId":[NSNumber numberWithInteger:-1]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            StoreCategoryResponse *response = [StoreCategoryResponse yy_modelWithJSON:dic];
            self.categories = response.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }
    } failure:^(NSInteger code) {
        
    }];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    self.menuViewStyle = WMMenuViewStyleLine;
    return self.categories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    self.scrollView.backgroundColor = [UIColor clearColor];
    return [[StoreSingleViewController alloc] initWithCategoryId:self.categories[index].itemcatId];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15.5;
    self.titleColorNormal = [UIColor colorWithHexString:@"#999999"];
    self.titleColorSelected = [UIColor colorWithHexString:GeneralColorString];
    return self.categories[index].name;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    self.scrollEnable = NO;
    self.progressHeight = 3 * WidthCoefficient;
    self.progressViewCornerRadius = 1.5;
    return CGRectMake(0, 0, kScreenWidth, 44 * WidthCoefficient);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 44 * WidthCoefficient, kScreenWidth, kScreenHeight - kNaviHeight - kTabbarHeight -1 - 44 * WidthCoefficient);
}


- (NSArray<StoreCategory *> *)categories {
    if (!_categories) {
        _categories = [NSArray array];
    }
    return _categories;
}

@end
