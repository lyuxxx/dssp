//
//  StoreBaseViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"
#import <YYCategoriesSub/YYCategories.h>

@interface StoreBaseViewController ()

@end

@implementation StoreBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
    [self setNavBar];
    [self createGradientBg];
}

- (void)config {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    self.rt_navigationController.useSystemBackBarButtonItem = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)createGradientBg {
    if ([self needGradientBg]) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight);
        gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
        gradient.locations = @[@0,@0.8,@1];
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        [self.view.layer addSublayer:gradient];
        [self.view.layer insertSublayer:gradient atIndex:0];
    }
}

- (void)setNavBar {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kNaviHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    UIImage *gradientImg = [gradient snapshotImage];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:GeneralColorString]];
    [[UINavigationBar appearance] setBackgroundImage:gradientImg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[gradientImg imageByResizeToSize:CGSizeMake(kScreenWidth, 0.5)]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
}

@end
