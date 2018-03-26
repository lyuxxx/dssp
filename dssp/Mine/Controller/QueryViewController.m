//
//  查询 QueryViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "QueryViewController.h"
#import "MineViewController.h"
#import "QueryModel.h"
@interface QueryViewController ()
@property (nonatomic,strong)QueryModel *queryModel;
@end

@implementation QueryViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestData];
//    [self setupUI];
}

-(void)requestData
{
    NSDictionary *paras = @{
//                            @"vin": [kVin isEqualToString:@""]?_vin:kVin
                             @"vin": _vin
                            };
    [CUHTTPRequest POST:queryBindAndRNRStatus parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
           _queryModel =[QueryModel yy_modelWithDictionary:dic[@"data"]];
//            QueryViewController *queryVC =[[QueryViewController alloc] init];
//            queryVC.queryModel = queryModel;
//            [self.navigationController pushViewController:queryVC animated:YES];
//            NSString *str = [NSString stringWithFormat: @"%@", dic[@"data"]];
            NSLog(@"666%@",_queryModel.vhlStatus);
             [self setupUI];
        } else {
            [self setupUI];
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
            
        }
    } failure:^(NSInteger code) {
        [self setupUI];
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
    }];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"实名制结果查询", nil);
    NSArray *titles = @[
                        NSLocalizedString(@"实名制认证成功", nil),
                        NSLocalizedString(@"车辆激活成功", nil),
                        NSLocalizedString(@"T服务套餐开通成功", nil),
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
            lab.text = NSLocalizedString(@"人工审核中", nil);
            [view1 addSubview:lab];
            [lab makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(80 * WidthCoefficient);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(lab1.right).offset(0*WidthCoefficient);
                
            }];
            
            
             if ([_queryModel.certificationStatus isEqualToString:@"0"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            else if ([_queryModel.certificationStatus isEqualToString:@"1"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                logo.image = [UIImage imageNamed:@"失败_icon"];
                lab.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab.hidden = NO;
            }
            else if ([_queryModel.certificationStatus isEqualToString:@"2"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
            }
            
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==1) {
            
            if ([_queryModel.vhlActivate isEqualToString:@"0"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            else if ([_queryModel.vhlActivate isEqualToString:@"1"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==2) {
            
            if ([_queryModel.serviceStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            else if ([_queryModel.serviceStatus isEqualToString:@"1"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        
        }
        if (i==3) {
            
           if ([_queryModel.certificationStatus isEqualToString:@"2"]&&[_queryModel.vhlActivate isEqualToString:@"1"]&&[_queryModel.serviceStatus isEqualToString:@"1"])
            {
                
                
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                 logo.image = [UIImage imageNamed:@"认证成功_icon"];
                
                NSString *certificationStatus = @"1";
                NSUserDefaults *defaults3 = [NSUserDefaults standardUserDefaults];
                [defaults3 setObject:certificationStatus forKey:@"certificationStatus"];
                [defaults3 synchronize];
                
            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
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
    
    
   
    
    
    NSArray *title = @[
                        NSLocalizedString(@"审核成功", nil),
                        NSLocalizedString(@"审核失败", nil),
                        NSLocalizedString(@"待审核/审核中", nil),
                      
                        ];
    
    for (NSInteger i = 0 ; i < title.count; i++) {
        
        UIImageView *logoImg =[[UIImageView alloc] init];
        logoImg.image =[UIImage imageNamed:@"Rectangle"];
        [self.view addSubview:logoImg];
        [logoImg makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-(30*HeightCoefficient+kBottomHeight));
            make.width.equalTo (343*WidthCoefficient);
            make.height.equalTo (153*HeightCoefficient);
            make.centerX.equalTo(0);
        }];
        
        
        UILabel *lab = [[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor colorWithHexString:@"#A18E79"];
        lab.font = [UIFont fontWithName:FontName size:13];
        lab.text = NSLocalizedString(@"审核状态说明", nil);
        [logoImg addSubview:lab];
        [lab makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(180 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            
            make.left.equalTo(10*WidthCoefficient);
            make.top.equalTo(10*WidthCoefficient);
            
        }];
        
        
        
        
        UIView *view1 = [[UIView alloc] init];
        view1.backgroundColor = [UIColor clearColor];
        [logoImg addSubview:view1];
        
        UIImageView *logo = [[UIImageView alloc] init];
        //        logo.image = [UIImage imageNamed:@"selected"];
        [view1 addSubview:logo];
        [logo makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(18 * WidthCoefficient);
            make.height.equalTo(18 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(10 *WidthCoefficient);
        }];
        
        
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textAlignment = NSTextAlignmentLeft;
        //        lab1.textColor = [UIColor colorWithHexString:@"#666666"];
        lab1.font = [UIFont fontWithName:FontName size:13];
        lab1.text = titles[i];
        [view1 addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(150 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(logo.right).offset(10*WidthCoefficient);
            
        }];
        
        
        if (i==0) {
            
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(47 * HeightCoefficient);
            }];
            
        }
        else
        {
            [view1 makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(0 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(lastView.bottom).offset(12 * HeightCoefficient);
            }];
            
           
        }
        lastView = view1;
        
        if (i==0) {
            
            
            lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
            logo.image = [UIImage imageNamed:@"认证成功_icon"];
           
            
        }
        if (i==1) {
            
            
            lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
            logo.image = [UIImage imageNamed:@"失败_icon"];
            
           
        }
        if (i==2) {
            
            
            lab1.textColor = [UIColor colorWithHexString:@"#999999"];
            logo.image = [UIImage imageNamed:@"认证中_icon"];
           
        }
        
    }
     
 }

-(void)nextBtnClick
{
    UIViewController *viewCtl = self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:viewCtl animated:YES];
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
