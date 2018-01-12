//
//  查询 QueryViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "QueryViewController.h"
#import "MineViewController.h"
@interface QueryViewController ()

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}




- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"实名制结果查询", nil);
    NSArray *titles = @[
                        NSLocalizedString(@"实名制认证", nil),
                        NSLocalizedString(@"车辆激活", nil),
                        NSLocalizedString(@"T服务套餐开通", nil),
                        NSLocalizedString(@"完成", nil)
                        ];
    
    UIView *lastView = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UIView *view1 = [[UIView alloc] init];
        view1.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view1];
        
        UIImageView *logo = [[UIImageView alloc] init];
//        logo.image = [UIImage imageNamed:@"selected"];
        [view1 addSubview:logo];
        [logo makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(18 * WidthCoefficient);
            make.height.equalTo(18 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(0);
        }];
        
    
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textAlignment = NSTextAlignmentLeft;
//        lab1.textColor = [UIColor colorWithHexString:@"#666666"];
        lab1.font = [UIFont fontWithName:FontName size:16];
        lab1.text = titles[i];
        [view1 addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(150 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(logo.right).offset(18*WidthCoefficient);
            
        }];
        
        UIView *lineview = [[UIView alloc] init];
        lineview.backgroundColor = [UIColor colorWithHexString:@"#D1D1D6"];
        [self.view addSubview:lineview];

        if (i==0) {
            
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(19 * WidthCoefficient);
                make.height.equalTo(22 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(41 * HeightCoefficient);
            }];
            
            
            [lineview makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(1 * WidthCoefficient);
                make.height.equalTo(49 * HeightCoefficient);
                make.left.equalTo(28 * WidthCoefficient);
                make.top.equalTo(logo.bottom).offset(0);
            }];
            
        }
        else
        {
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(19 * WidthCoefficient);
                make.height.equalTo(22 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(lastView.bottom).offset(42.5 * HeightCoefficient);
            }];
            
            [lineview makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(1 * WidthCoefficient);
                make.height.equalTo(49 * HeightCoefficient);
                make.left.equalTo(28 * WidthCoefficient);
                make.top.equalTo(logo.bottom).offset(0 * HeightCoefficient);
            }];
        }
        lastView = view1;
        
        
        if (i==0) {
            
//            lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.textColor = [UIColor colorWithHexString:@"#666666"];
            lab.font = [UIFont fontWithName:FontName size:16];
            lab.hidden = YES;
            lab.text = NSLocalizedString(@"人工审核", nil);
            [view1 addSubview:lab];
            [lab makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(80 * WidthCoefficient);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(lab1.right).offset(0*WidthCoefficient);
                
            }];
            
            
            if ([_queryModel.certificationStatus isEqualToString:@"0"] && [_queryModel.certificationStatus isEqualToString:@"6"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                logo.image = [UIImage imageNamed:@"selected"];
                 lab.hidden = NO;
            }
            else if ([_queryModel.certificationStatus isEqualToString:@"0"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#666666"];
                logo.image = [UIImage imageNamed:@"check grey"];
            }
            else if ([_queryModel.certificationStatus isEqualToString:@"1"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                logo.image = [UIImage imageNamed:@"selected"];
            }
            
    
        }
        if (i==1) {
            
            if ([_queryModel.vhlFlowStatus isEqualToString:@"7"]) {
                 lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                 logo.image = [UIImage imageNamed:@"selected"];
                

            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#666666"];
                logo.image = [UIImage imageNamed:@"check grey"];
            }
            
          
        }
        if (i==2) {
            
            if ([_queryModel.serviceStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#666666"];
                logo.image = [UIImage imageNamed:@"check grey"];
            }
            else if ([_queryModel.serviceStatus isEqualToString:@"1"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                logo.image = [UIImage imageNamed:@"selected"];
            }
            
        
        }
        if (i==3) {
            
            if ([_queryModel.serviceStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#666666"];
                logo.image = [UIImage imageNamed:@"check grey"];
            }
            else if ([_queryModel.serviceStatus isEqualToString:@"1"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                 logo.image = [UIImage imageNamed:@"selected"];
            }
            lineview.hidden = YES;
        }
       }
    
            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
            nextBtn.layer.cornerRadius = 2;
            [nextBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
            [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
            [self.view addSubview:nextBtn];
            [nextBtn makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(271 * WidthCoefficient);
                make.height.equalTo(44 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(297 * HeightCoefficient);
            }];
    
 }

-(void)nextBtnClick
{
    
    UIViewController *viewCtl = self.navigationController.viewControllers[0];
    
    [self.navigationController popToViewController:viewCtl animated:YES];
    
//    MineViewController 
    
    
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
