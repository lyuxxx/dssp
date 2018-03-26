//
//  AboutmeViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "AboutmeViewController.h"

@interface AboutmeViewController ()

@end

@implementation AboutmeViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navigationItem.title = NSLocalizedString(@"关于我们", nil);
    [self setupUI];
}

-(void)setupUI
{
    UIView *bgV = [[UIView alloc] init];
    bgV.layer.cornerRadius = 4;
    bgV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:bgV];
    [bgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20*HeightCoefficient);
        make.height.equalTo(229 * HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.right.equalTo(-16*WidthCoefficient);
    }];
    
    
    UIImageView *logoImg =[[UIImageView alloc] init];
    logoImg.image =[UIImage imageNamed:@"logo"];
    [bgV addSubview:logoImg];
    [logoImg makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo (30*HeightCoefficient);
         make.width.equalTo (130);
         make.height.equalTo (99);
         make.centerX.equalTo(0);
    }];
    
    
    NSString *string = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLbael = [[UILabel alloc] init];
    versionLbael.text = [NSString stringWithFormat:@"版本号 %@",NSLocalizedString(string, nil)];
    versionLbael.textColor = [UIColor colorWithHexString:@"#ffffff"];
    versionLbael.font =[UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [bgV addSubview:versionLbael];
    [versionLbael makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (0);
        make.top.equalTo(logoImg.bottom).offset(30*HeightCoefficient);
        make.height.equalTo(18.5*HeightCoefficient);
        
    }];
    
    
    
    UILabel *bottomLbael = [[UILabel alloc] init];
    bottomLbael.text = NSLocalizedString(@"COPYRIGHT © 2018 DS. ALL RIGHTS RESERVED", nil);
    bottomLbael.textColor = [UIColor colorWithHexString:@"#A18E79"];
    bottomLbael.font =[UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [self.view addSubview:bottomLbael];
    [bottomLbael makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (0);
        make.bottom.equalTo(-(21.5+kBottomHeight));
        make.height.equalTo(18.5*HeightCoefficient);
        
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
