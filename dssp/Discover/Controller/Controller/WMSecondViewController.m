//
//  WMSecondViewController.m
//  WMPageController
//
//  Created by Mark on 16/2/27.
//  Copyright © 2016年 yq. All rights reserved.
//

#import "WMSecondViewController.h"
#import "WMPageController.h"


@interface WMSecondViewController ()

@end

@implementation WMSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.pageController isKindOfClass:[WMPageController class]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(reloadPageController)];
        self.title = @"刷新";
    } else {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2, 100, 100, 100)];
        redView.backgroundColor = [UIColor redColor];
        [self.view addSubview:redView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)reloadPageController {
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
