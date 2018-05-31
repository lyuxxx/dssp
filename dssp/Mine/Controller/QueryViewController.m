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
#import "ContractModel.h"
#import "NSArray+Sudoku.h"
@interface QueryViewController ()

@property (nonatomic,strong)QueryModel *queryModel;
@property (nonatomic,strong)ContractModel *contract;
@end

@implementation QueryViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"实名制结果查询", nil);
    // 下滑手势
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:recognizer];
    
    
    self.rt_disableInteractivePop = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToHome1) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    self.navigationItem.leftBarButtonItem = left;
    
    [self requestData];
  
}

- (void)backToHome1 {
   
    if ([self.types isEqualToString:@"2"]) {
//        for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
//            UIViewController *vc = self.navigationController.viewControllers[i];
//            if ([vc isKindOfClass:NSClassFromString(@"StoreTabViewController")]) {
//                //            StoreTabViewController *tabVC = (StoreTabViewController *)vc;
//                //            OrderPageController *pageController = [tabVC gotoOrderPageController];
//                //            if (pageController.selectIndex != 0) {
//                //                [pageController.menuView selectItemAtIndex:0];
//                //            }
//
//
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//        }
        
         //从实名制与T服务结果查询进来的，就返回第二个界面
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
        
      
    }
    else
    {
        //从实名制与T服务结果查询进来的，就直接返回
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
     [self requestData];
}

-(void)requestData
{
    NSDictionary *paras = @{
                             @"vin": _vin
                           };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryBindAndRNRStatus parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
              [hud hideAnimated:YES];
           _queryModel =[QueryModel yy_modelWithDictionary:dic[@"data"]];

            NSLog(@"666%@",_queryModel.vhlStatus);
             [self setupUI];
        } else {
           [hud hideAnimated:YES];
            [self setupUI];
            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
            
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [self setupUI];
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
    }];
}

- (void)setupUI {
   
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
         lab1.text = titles[i];
        CGSize size = [lab1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:FontName size:16],NSFontAttributeName,nil]];
        // 名字的H
        //    CGFloat nameH = size.height;
        // 名字的W
        CGFloat nameW = size.width;
        lab1.font = [UIFont fontWithName:FontName size:16];
       
        [view1 addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(nameW+1);
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
    
            UIView *lineview1 = [[UIView alloc] init];
            lineview1.backgroundColor = [UIColor colorWithHexString:@"#E2CD8D"];
            lineview1.hidden = YES;
            [view1 addSubview:lineview1];
            [lineview1 makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(49 * WidthCoefficient);
                make.height.equalTo(1 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(lab1.right).offset(10 * WidthCoefficient);
            }];
            
            
            
            UILabel *lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.textColor = [UIColor colorWithHexString:@"#666666"];
            lab.hidden = YES;
            lab.text = NSLocalizedString(@"人工审核中", nil);
            CGSize size = [lab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:FontName size:16],NSFontAttributeName,nil]];
            // 名字的H
            //    CGFloat nameH = size.height;
            // 名字的W
            CGFloat nameW1 = size.width;
            lab.font = [UIFont fontWithName:FontName size:16];
        
            [view1 addSubview:lab];
            [lab makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(nameW1+1);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.centerY.equalTo(0);
           make.left.equalTo(lineview1.right).offset(10*WidthCoefficient);
                
            }];
            
            
             if ([_queryModel.rnrStatus isEqualToString:@"0"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                lab1.text = @"未提交实名认证";
                logo.image = [UIImage imageNamed:@"认证中_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
                }];
            }
            else if ([_queryModel.rnrStatus isEqualToString:@"1"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
                logo.image = [UIImage imageNamed:@"审核中_icon"];
                lab.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
                lab.hidden = NO;
                lineview1.hidden = NO;
            }
            else if ([_queryModel.rnrStatus isEqualToString:@"2"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                lab1.text = @"实名制认证成功";
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
                    
                    
                }];
            }
            else if ([_queryModel.rnrStatus isEqualToString:@"3"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                lab1.text = @"未提交实名认证";
                logo.image = [UIImage imageNamed:@"认证中_icon"];
                
            }
            else if ([_queryModel.rnrStatus isEqualToString:@"4"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab1.text = @"实名制认证失败,请重新提交";
                logo.image = [UIImage imageNamed:@"失败_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(280*WidthCoefficient);
                    
                    
                }];
            }
            else
            {
            

                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==1) {
            
            if ([_queryModel.rcStatus isEqualToString:@"0"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            else if ([_queryModel.rcStatus isEqualToString:@"1"])
            {
                
                lab1.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
                lab1.text = @"车辆配置中";
                logo.image = [UIImage imageNamed:@"审核中_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
   
                }];
               
            }
            else if ([_queryModel.rcStatus isEqualToString:@"2"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                lab1.text = @"车辆激活成功";
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
                   
                    
                }];
            }
            else if ([_queryModel.rcStatus isEqualToString:@"3"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab1.text = @"车辆激活失败";
                logo.image = [UIImage imageNamed:@"失败_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
                    
                }];
            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==2) {
            
            if ([_queryModel.simStatus isEqualToString:@"0"]) {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            else if ([_queryModel.simStatus isEqualToString:@"1"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                lab1.text = @"T服务开通成功";
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
                }];
            }
            else if ([_queryModel.simStatus isEqualToString:@"2"])
            {
                lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
                lab1.text = @"T服务开通失败";
                logo.image = [UIImage imageNamed:@"失败_icon"];
                [lab1 updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(180*WidthCoefficient);
                    
                    
                }];
            }
            else
            {
                lab1.textColor = [UIColor colorWithHexString:@"#999999"];
                logo.image = [UIImage imageNamed:@"认证中_icon"];
            }
            
        }
        if (i==3) {
            
           if ([_queryModel.rnrStatus isEqualToString:@"2"]&&[_queryModel.rcStatus isEqualToString:@"2"]&&[_queryModel.simStatus isEqualToString:@"1"])
            {
                
                lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
                logo.image = [UIImage imageNamed:@"认证成功_icon"];
                
                NSDictionary *paras = @{
                                        @"vin": kVin,
                                        @"currentPage":@"1",
                                        @"pageSize":@"5"
                                        };
                [CUHTTPRequest POST:queryContractForApp parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        NSArray *dataArray =dic[@"data"][@"result"];
                        
                        for (NSDictionary *dic in dataArray) {
                            _contract = [ContractModel yy_modelWithDictionary:dic];
                        }
                        
                        if ([_contract.contractStatus isEqualToString:@"1"]) {
                            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                            [defaults1 setObject:_contract.contractStatus forKey:@"contractStatus"];
                            [defaults1 synchronize];
                        }
                        else
                        {
                            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
                            [defaults1 setObject:@"" forKey:@"contractStatus"];
                            [defaults1 synchronize];
                            
                        }
                        
                        NSLog(@"5543%@",_contract.contractStatus);
                        
                    } else {
                        
                        
                    }
                } failure:^(NSInteger code) {
                    
                }];
                
                
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
    
    
    UIImageView *logoImg =[[UIImageView alloc] init];
    logoImg.image =[UIImage imageNamed:@"Rectangle"];
    [self.view addSubview:logoImg];
    [logoImg makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-(60*HeightCoefficient+kBottomHeight));
        make.width.equalTo (343*WidthCoefficient);
        make.height.equalTo (111*HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    NSArray *title = @[
                        NSLocalizedString(@"审核成功", nil),
                        NSLocalizedString(@"审核中", nil),
                        NSLocalizedString(@"审核失败", nil),
                        NSLocalizedString(@"未执行", nil)
                      
                        ];
    
    NSMutableArray<UIView *> *viewArray = [NSMutableArray arrayWithCapacity:title.count];
    
    for (NSInteger i = 0 ; i < title.count; i++) {
        
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
        
        
        UIView *views = [[UIView alloc] init];
        [logoImg addSubview:views];
        [viewArray addObject:views];
        

        UIImageView *logo = [[UIImageView alloc] init];

        [views addSubview:logo];
        [logo makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(18 * WidthCoefficient);
            make.height.equalTo(18 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(0 *WidthCoefficient);
        }];


        UILabel *lab1 = [[UILabel alloc] init];
        lab1.textAlignment = NSTextAlignmentLeft;
     
        lab1.font = [UIFont fontWithName:FontName size:13];
        lab1.text = title[i];
        [views addSubview:lab1];
        [lab1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(150 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(logo.right).offset(10*WidthCoefficient);

        }];

        if (i==0) {
            lab1.textColor = [UIColor colorWithHexString:@"#00FFB4"];
            logo.image = [UIImage imageNamed:@"认证成功_icon"];
        }
        if (i==1) {

            lab1.textColor = [UIColor colorWithHexString:@"#E2CD8D"];
            logo.image = [UIImage imageNamed:@"审核中_icon"];
        }
        if (i==2) {
            lab1.textColor = [UIColor colorWithHexString:@"#AC0042"];
            logo.image = [UIImage imageNamed:@"失败_icon"];
        }
        if (i==3) {
            lab1.textColor = [UIColor colorWithHexString:@"#999999"];
            logo.image = [UIImage imageNamed:@"认证中_icon"];
        }
        
    }
     [viewArray mas_distributeSudokuViewsWithFixedItemWidth:100*WidthCoefficient fixedItemHeight:20* HeightCoefficient warpCount:2 topSpacing:47 * HeightCoefficient bottomSpacing:12 * HeightCoefficient leadSpacing:10 * WidthCoefficient tailSpacing:100 * WidthCoefficient];
    
    
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.textAlignment = NSTextAlignmentLeft;
    [lab2 setNumberOfLines:0];
    lab2.textColor = [UIColor colorWithHexString:@"#ffffff"];
    lab2.text = @"*如果车辆激活超过两个小时未成功，请联系人工客服处理";
    CGRect tmpRect= [lab2.text boundingRectWithSize:CGSizeMake(343*WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:FontName size:13]} context:nil];
  
    CGFloat contentH = tmpRect.size.height;
    lab2.font = [UIFont fontWithName:FontName size:13];
    [self.view addSubview:lab2];
    [lab2 makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(contentH+1);
        make.top.equalTo(logoImg.bottom).offset(10*HeightCoefficient);
        make.left.equalTo(16*WidthCoefficient);
        make.right.equalTo(-16*WidthCoefficient);
    }];
     
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
