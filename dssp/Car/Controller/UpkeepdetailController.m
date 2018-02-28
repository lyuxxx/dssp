//
//  UpkeepdetailController.m
//  dssp
//
//  Created by qinbo on 2018/2/5.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "UpkeepdetailController.h"

@interface UpkeepdetailController ()

@end

@implementation UpkeepdetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"DS预约保养规则", nil);
    
    [self setupUI];
}


-(void)setupUI
{
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"DS 保养规则"];
    [self.view addSubview:rightImg];
    [rightImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    
    
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