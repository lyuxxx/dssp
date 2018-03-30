//
//  BaseViewController.m
//  dssp
//
//  Created by yxliu on 2017/10/31.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"
#import <YYCategoriesSub/YYCategories.h>

@interface BaseViewController ()
@property (nonatomic, assign) BOOL needGradientImg;
@end

@implementation BaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
    [self setNavBar];
}

- (void)config {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
    if ([self needGradientImg]) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, kScreenWidth, 96 * HeightCoefficient);
        gradient.colors = @[(id)[UIColor colorWithHexString:@"#2c2626"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        UIImageView *gradientImgV = [[UIImageView alloc] initWithImage:[gradient snapshotImage]];
        [self.view addSubview:gradientImgV];
        [gradientImgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kScreenWidth);
            make.height.equalTo((160 - kNaviHeight) * HeightCoefficient);
            make.top.equalTo(0);
            make.centerX.equalTo(self.view);
        }];
    }
    self.rt_navigationController.useSystemBackBarButtonItem = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)setNavBar {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kNaviHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#2c2626"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    UIImage *gradientImg = [gradient snapshotImage];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:GeneralColorString]];
    [[UINavigationBar appearance] setBackgroundImage:gradientImg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[gradientImg imageByResizeToSize:CGSizeMake(kScreenWidth, 0.5)]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:GeneralColorString]}];
}

//- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
//    return [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
//}

@end
