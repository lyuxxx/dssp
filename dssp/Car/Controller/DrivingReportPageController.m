//
//  DrivingReportPageController.m
//  dssp
//
//  Created by yxliu on 2018/5/31.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingReportPageController.h"
#import "DrivingWeekReportViewController.h"
#import "DrivingMonthReportViewController.h"

@interface DrivingReportPageController ()

@end

@implementation DrivingReportPageController

- (BOOL)needGradientBg {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"驾驶行为报告", nil);
    
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
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    self.progressHeight = 3 * WidthCoefficient;
    self.progressViewCornerRadius = 1.5;
    self.menuViewStyle = WMMenuViewStyleLine;
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    self.scrollView.backgroundColor = [UIColor clearColor];
    if (index == 0) {
        return [[DrivingWeekReportViewController alloc] init];
    } else {
        return [[DrivingMonthReportViewController alloc] init];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15.5;
    self.titleColorNormal = [UIColor colorWithHexString:@"#999999"];
    self.titleColorSelected = [UIColor colorWithHexString:GeneralColorString];
    
    if (index == 0) {
        return NSLocalizedString(@"周报告", nil);
    } else {
        return NSLocalizedString(@"月报告", nil);
    }
}

//- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
//    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
//    return width +20;
//}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    self.scrollEnable = YES;
    return CGRectMake(0, 0, kScreenWidth, 44 * WidthCoefficient);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 44 * WidthCoefficient, kScreenWidth, kScreenHeight - kNaviHeight - 44 * WidthCoefficient);
}

@end
