//
//  ParkingViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/12.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ParkingViewController.h"

@interface ParkingViewController ()

@end

@implementation ParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    self.navigationItem.title = NSLocalizedString(@"智慧停车", nil);
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
