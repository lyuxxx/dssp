//
//  NavigationController.m
//  dssp
//
//  Created by yxliu on 2017/10/31.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
}

- (void)config {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

@end
