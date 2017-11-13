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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
}

- (void)config {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self needGradientImg]) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, kScreenWidth, 126 * HeightCoefficient);
        gradient.colors = @[(id)[UIColor colorWithHexString:@"#2c2626"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor];
        gradient.startPoint = CGPointMake(0, 0.5);
        gradient.endPoint = CGPointMake(1, 0.5);
        UIImageView *gradientImgV = [[UIImageView alloc] initWithImage:[gradient snapshotImage]];
        [self.view addSubview:gradientImgV];
        [gradientImgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(kScreenWidth);
            make.height.equalTo((190 - kNaviHeight) * HeightCoefficient);
            make.top.equalTo(0);
            make.centerX.equalTo(self.view);
        }];
    }
}

@end
