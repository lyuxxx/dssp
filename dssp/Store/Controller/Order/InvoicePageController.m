//
//  InvoicePageController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InvoicePageController.h"
#import "InvoiceIndividualViewController.h"
#import "InvoiceEnterpriseViewController.h"

@interface InvoicePageController ()

@end

@implementation InvoicePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyCalculatesItemWidths = YES;
    self.navigationItem.title = NSLocalizedString(@"发票信息", nil);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    self.menuViewStyle = WMMenuViewStyleLine;
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return [[InvoiceEnterpriseViewController alloc] init];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15.5;
    self.titleColorNormal = [UIColor colorWithHexString:@"#999999"];
    self.titleColorSelected = [UIColor colorWithHexString:GeneralColorString];
    NSArray *titles = @[@"个人",@"企业"];
    return titles[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    self.scrollEnable = NO;
    self.progressHeight = 3 * WidthCoefficient;
    self.progressViewCornerRadius = 1.5;
    return CGRectMake(0, 0, kScreenWidth, 44 * WidthCoefficient);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 44 * WidthCoefficient, kScreenWidth, kScreenHeight - kNaviHeight - 44 * WidthCoefficient);
}

@end
