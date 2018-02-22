//
//  OrderPageController.m
//  dssp
//
//  Created by yxliu on 2018/2/6.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderPageController.h"
#import "OrderViewController.h"

@interface OrderPageController ()

@end

@implementation OrderPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyCalculatesItemWidths = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    self.menuViewStyle = WMMenuViewStyleLine;
    return 4;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSNumber *type = nil;
    if (index > 0) {
        type = [NSNumber numberWithInteger:(index - 1)];
    }
    return [[OrderViewController alloc] initWithType:type];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15.5;
    self.titleColorNormal = [UIColor colorWithHexString:@"#999999"];
    self.titleColorSelected = [UIColor colorWithHexString:GeneralColorString];
    NSArray *titles = @[@"全部",@"待付款",@"已付款",@"待评价"];
    return titles[index];
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

@end
