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
@property (nonatomic, copy) NSString *orderID;
@end

@implementation InvoicePageController

- (instancetype)initWithOrderId:(NSString *)orderId {
    self = [super init];
    if (self) {
        self.orderID = orderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyCalculatesItemWidths = YES;
    self.navigationItem.title = NSLocalizedString(@"发票信息", nil);
    
    [self createGradientBg];
}

- (void)createGradientBg {
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
    self.menuViewStyle = WMMenuViewStyleLine;
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {

    if (index == 0) {
        
        InvoiceEnterpriseViewController *vc = [[InvoiceEnterpriseViewController alloc] init];
        vc.personalID = _orderID;
        return vc;

    }else {
        
        InvoiceIndividualViewController *vc = [[InvoiceIndividualViewController alloc] init];
        vc.companyID = _orderID;
        return vc;
        
    }

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

