//
//  ContractViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
@interface ContractViewController ()

@end


@implementation ContractViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
}

-(void)setupUI
{
    
    self.navigationItem.title = NSLocalizedString(@"合同服务", nil);
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(200 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    
    UIButton *testdriveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    testdriveBtn.layer.cornerRadius = 10;
    [testdriveBtn setTitle:NSLocalizedString(@"试驾", nil) forState:UIControlStateNormal];
    [testdriveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testdriveBtn.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [testdriveBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [whiteV addSubview:testdriveBtn];
    [testdriveBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
        make.right.equalTo(whiteV.right).offset(-10 * HeightCoefficient);
    }];
    
    
    UILabel *serialNumber = [[UILabel alloc] init];
    serialNumber.textAlignment = NSTextAlignmentLeft;
    serialNumber.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    serialNumber.text = NSLocalizedString(@"合同编号001", nil);
    [whiteV addSubview:serialNumber];
    [serialNumber makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    NSArray<NSString *> *titles = @[
                                    NSLocalizedString(@"开始时间:", nil),
                                    NSLocalizedString(@"结束时间:", nil),
                                    NSLocalizedString(@"支付方式:", nil),
                                    NSLocalizedString(@"支付时间:", nil),
                                    NSLocalizedString(@"支付金额:", nil)
                                   ];
    
    
    UILabel *lastLabel = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont fontWithName:FontName size:14];
        [whiteV addSubview:label];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.text = titles[i];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.textColor = [UIColor colorWithHexString:@"##2A2A2A"];
        rightLabel.font = [UIFont fontWithName:FontName size:14];
        [whiteV  addSubview:rightLabel];
        
        if (i == 0) {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(85 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(10*WidthCoefficient);
                make.top.equalTo(serialNumber.bottom).offset(10*HeightCoefficient);
                
            }];
            [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(150 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(label.right).offset(10*WidthCoefficient);
//                make.top.equalTo(10);
                 make.top.equalTo(serialNumber.bottom).offset(10*HeightCoefficient);
                
            }];
            
        } else {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(85 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(10 * WidthCoefficient);
                make.top.equalTo(lastLabel.bottom).offset(10 * HeightCoefficient);
            }];
            
            [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(150 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(label.right).offset(10*WidthCoefficient);
                make.top.equalTo(lastLabel.bottom).offset(10);
            }];
            
        }
        lastLabel = label;
      }
    
    
    
    UIView *whiteV1 = [[UIView alloc] init];
    whiteV1.layer.cornerRadius = 4;
    whiteV1.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV1.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV1.layer.shadowOpacity = 0.2;
    whiteV1.layer.shadowRadius = 7;
    whiteV1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV1];
    [whiteV1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(200 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(15*HeightCoefficient);
    }];
    
    
    UIButton *testdriveBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    testdriveBtn1.layer.cornerRadius = 10;
    [testdriveBtn1 setTitle:NSLocalizedString(@"试驾", nil) forState:UIControlStateNormal];
    [testdriveBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testdriveBtn1.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [testdriveBtn1 setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [whiteV1 addSubview:testdriveBtn1];
    [testdriveBtn1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
        make.right.equalTo(whiteV1.right).offset(-10 * HeightCoefficient);
    }];
    
    UILabel *serialNumber1 = [[UILabel alloc] init];
    serialNumber1.textAlignment = NSTextAlignmentLeft;
    serialNumber1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    serialNumber1.text = NSLocalizedString(@"合同编号002", nil);
    [whiteV1 addSubview:serialNumber1];
    [serialNumber1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    
    UILabel *lastLabels = nil;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont fontWithName:FontName size:14];
        [whiteV1 addSubview:label];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.text = titles[i];
        rightLabel.textColor = [UIColor colorWithHexString:@"#2A2A2A"];
        rightLabel.font = [UIFont fontWithName:FontName size:14];
        [whiteV1  addSubview:rightLabel];
        if (i == 0) {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(85 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(10*WidthCoefficient);
                make.top.equalTo(serialNumber1.bottom).offset(10*HeightCoefficient);
                
            }];
            [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(150 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(label.right).offset(10*WidthCoefficient);
                //                make.top.equalTo(10);
                make.top.equalTo(serialNumber1.bottom).offset(10*HeightCoefficient);
                
            }];
            
        } else {
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(85 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(10*WidthCoefficient);
                make.top.equalTo(lastLabels.bottom).offset(10);
            }];
            
            [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(150 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.left.equalTo(label.right).offset(10*WidthCoefficient);
                make.top.equalTo(lastLabels.bottom).offset(10);
            }];
            
        }
        lastLabels = label;
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
