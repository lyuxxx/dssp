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
- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"实名制认证", nil);
//    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[
                        NSLocalizedString(@"实名制与T服务激活 | 入口", nil),
                        NSLocalizedString(@"实名制与T服务结果 | 查询", nil),
                        NSLocalizedString(@"实名制与T服务解绑 | 入口", nil)
                        ];
    
    NSArray *imgArray= @[
                         NSLocalizedString(@"实名制_icon", nil),
                         NSLocalizedString(@"实名制结果_icon", nil),
                         NSLocalizedString(@"解绑实名制_icon", nil)
                         ];
    
    NSArray *imgArray1= @[
                         NSLocalizedString(@"实名制入口认证背景", nil),
                         NSLocalizedString(@"实名制结果", nil),
                         NSLocalizedString(@"解绑实名制", nil)
                         ];

    
    UIView *lastView = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UIView *whiteV = [[UIView alloc] init];
//        whiteV.layer.cornerRadius = 4;
//        whiteV.layer.shadowOffset = CGSizeMake(0, 7);
//        whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//        whiteV.layer.shadowOpacity = 0.2;
//        whiteV.layer.shadowRadius = 7;
        whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
        [self.view addSubview:whiteV];
        
        
    
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.tag = 100+i;
        [nextBtn setBackgroundColor:[UIColor clearColor]];
        [whiteV addSubview:nextBtn];
        
        UIImageView *arrownext = [[UIImageView alloc] init];
        arrownext.image = [UIImage imageNamed:@"arrownext"];
        [nextBtn addSubview:arrownext];
       
        
        UIImageView *BtnImg = [[UIImageView alloc] init];
        BtnImg.image = [UIImage imageNamed:imgArray1[i]];
        [nextBtn addSubview:BtnImg];
        
        UIImageView *rightImg = [[UIImageView alloc] init];
        rightImg.image = [UIImage imageNamed:imgArray[i]];
        [BtnImg addSubview:rightImg];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithHexString:@"#ffffff"];
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label.text = titles[i];
        CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Medium" size:16],NSFontAttributeName,nil]];
        // 名字的H
        //    CGFloat nameH = size.height;
        // 名字的W
        CGFloat nameW = size.width;
        
        
        [BtnImg addSubview:label];
        
       
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
                make.width.equalTo(nameW+1);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.left.equalTo(20*WidthCoefficient);
            }];
            
            [arrownext makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(14.5 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(label.right).offset(15 * WidthCoefficient);
            }];
            
            
            [BtnImg makeConstraints:^(MASConstraintMaker *make) {
               make.edges.equalTo(nextBtn);
            }];
            
            
            [rightImg makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(32 * HeightCoefficient);
                make.height.equalTo(32 * HeightCoefficient);
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
                make.width.equalTo(nameW+1);
                make.height.equalTo(22.5 * HeightCoefficient);
                make.left.equalTo(20*WidthCoefficient);
            }];
            
            [arrownext makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(14.5 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.left.equalTo(label.right).offset(15 * WidthCoefficient);
            }];
            
            
            [BtnImg makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(nextBtn);
            }];
            
            [rightImg makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(32 * HeightCoefficient);
                make.height.equalTo(32 * HeightCoefficient);
                make.centerY.equalTo(0);
                make.right.equalTo(-20 * WidthCoefficient);
            }];
          
        }
        lastView =whiteV;
        
    
    }

}

- (void)nextBtnClick:(UIButton *)sender {
   
    if (sender.tag==100) {
        
        if ([KuserName isEqualToString:@"18911568274"]) {
            InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [popupView initWithTitle:@"当前您为游客账户，不能做此操作" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: popupView];
            
            popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                
                if(btn.tag ==100)
                {
                    
                    
                }
                
            };
            
            
        }
        else
        {
        
        RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    if (sender.tag==101) {
    
        if ([KuserName isEqualToString:@"18911568274"]) {
            InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [popupView initWithTitle:@"当前您为游客账户，不能做此操作" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: popupView];
            
            popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                
                if(btn.tag ==100)
                {
                    
                    
                }
                
            };
            
            
        }
        else
        {
        SearchresultViewController *vc=[[SearchresultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender.tag==102) {
        if ([KuserName isEqualToString:@"18911568274"]) {
            InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [popupView initWithTitle:@"当前您为游客账户，不能做此操作" img:@"未绑定汽车_icon" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: popupView];
            
            popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                
                if(btn.tag ==100)
                {
                    
                    
                }
                
            };
            
            
        }
        else
        {
        RnunbindViewController *vc=[[RnunbindViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        }
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
