//
//  RealnameViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/22.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RealnameViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "RealVinViewcontroller.h"
#import "SearchresultViewController.h"
#import "RnunbindViewController.h"
@interface RealnameViewController ()

@end

@implementation RealnameViewController
//- (BOOL)needGradientImg {
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"实名制认证", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
 
    
    NSArray *titles = @[
                        NSLocalizedString(@"实名制认证 | 入口", nil),
                        NSLocalizedString(@"实名制结果 | 查询", nil),
                        NSLocalizedString(@"解绑实名制 | 入口", nil)
                        ];
    
    NSArray *imgArray= @[
                         NSLocalizedString(@"business", nil),
                         NSLocalizedString(@"len", nil),
                         NSLocalizedString(@"解绑", nil)
                         ];
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"wifi密码"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(96*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    

    UIView *lastView = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UIView *whiteV = [[UIView alloc] init];
        whiteV.layer.cornerRadius = 4;
        whiteV.layer.shadowOffset = CGSizeMake(0, 7);
        whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
        whiteV.layer.shadowOpacity = 0.2;
        whiteV.layer.shadowRadius = 7;
        whiteV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:whiteV];
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.tag = 100+i;
        [nextBtn setBackgroundColor:[UIColor clearColor]];
        [whiteV addSubview:nextBtn];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label.text = titles[i];
        [nextBtn addSubview:label];
        
        UIImageView *arrownext = [[UIImageView alloc] init];
        arrownext.image = [UIImage imageNamed:@"arrownext"];
        [nextBtn addSubview:arrownext];
       
        
        UIImageView *rightImg = [[UIImageView alloc] init];
        rightImg.image = [UIImage imageNamed:imgArray[i]];
        [nextBtn addSubview:rightImg];
        
       
        if (i == 0) {
            [whiteV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(343 * WidthCoefficient);
                make.height.equalTo(100 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(20 * HeightCoefficient);
            }];
            
            [nextBtn makeConstraints:^(MASConstraintMaker *make) {
              make.edges.equalTo(whiteV);
            }];
            
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(0);
                make.width.equalTo(127 * WidthCoefficient);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.left.equalTo(20*WidthCoefficient);
            }];
            
            [arrownext makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(14.5 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(label.right).offset(10 * WidthCoefficient);
            }];
            
            
            [rightImg makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(64 * HeightCoefficient);
                make.height.equalTo(62 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.right.equalTo(-20 * WidthCoefficient);
            }];
            
        } else{
            [whiteV makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(343 * WidthCoefficient);
                make.height.equalTo(100 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(lastView.bottom).offset(20 * HeightCoefficient);
            }];
            
         
            [nextBtn makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(whiteV);
            }];
            
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(0);
                make.width.equalTo(127 * WidthCoefficient);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.left.equalTo(20*WidthCoefficient);
            }];
            
            [arrownext makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(14.5 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(label.right).offset(10 * WidthCoefficient);
            }];
            
            [rightImg makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(64 * HeightCoefficient);
                make.height.equalTo(62 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.right.equalTo(-20 * WidthCoefficient);
            }];
          
        }
        lastView =whiteV;
        
    
    }

}

- (void)nextBtnClick:(UIButton *)sender {
   
    if (sender.tag==100) {
        
        RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (sender.tag==101) {
    
        SearchresultViewController *vc=[[SearchresultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==102) {
        
        RnunbindViewController *vc=[[RnunbindViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
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
