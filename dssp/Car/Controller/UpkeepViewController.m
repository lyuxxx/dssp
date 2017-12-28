//
//  UpkeepViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/22.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "UpkeepViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
@interface UpkeepViewController ()
@property (nonatomic ,strong) UIButton *operationBtn;
@end

@implementation UpkeepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self setupUI];
}


-(void)setupUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wifi密码"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = NSLocalizedString(@"预约保养", nil);
    

    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud_mine"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(126*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.shadowOpacity = 0.5;// 阴影透明度
    whiteView.layer.shadowOffset = CGSizeMake(0,7.5);
    whiteView.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteView.layer.shadowRadius = 20.5;//阴影半径，默认3
    [self.view addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(116 * HeightCoefficient);
        make.height.equalTo(70 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *toplabel = [[UILabel alloc] init];
    toplabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:28];
    toplabel.textColor=[UIColor whiteColor];
    toplabel.text=NSLocalizedString(@"7天", nil);
    toplabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:toplabel];
    [toplabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20*HeightCoefficient);
        make.height.equalTo(39 * HeightCoefficient);
        make.centerX.equalTo(bgImgV);
        make.width.equalTo(43.5 * WidthCoefficient);
    }];
    
    
    UILabel *centrelabel = [[UILabel alloc] init];
    centrelabel.font=[UIFont fontWithName:FontName size:13];
    centrelabel.textColor=[UIColor whiteColor];
    centrelabel.text=NSLocalizedString(@"距离下一次保养时间", nil);
    centrelabel.textAlignment = NSTextAlignmentCenter;
    [bgImgV addSubview:centrelabel];
    [centrelabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(bgImgV);
        make.width.equalTo(127 * WidthCoefficient);
    }];
    
    
    UILabel *Lastlabel = [[UILabel alloc] init];
    Lastlabel.font=[UIFont fontWithName:FontName size:13];
    Lastlabel.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
    Lastlabel.layer.cornerRadius = 20 * HeightCoefficient/2;
    Lastlabel.clipsToBounds = YES;
    Lastlabel.textColor=[UIColor whiteColor];
    Lastlabel.text=NSLocalizedString(@"上一次保养时间 60天前", nil);
    Lastlabel.textAlignment = NSTextAlignmentCenter;
    [bgImgV addSubview:Lastlabel];
    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centrelabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(bgImgV);
        make.width.equalTo(240 * WidthCoefficient);
    }];
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    
    [whiteView addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15 * HeightCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.width.equalTo(1 * WidthCoefficient);
        make.left.equalTo(171 * WidthCoefficient);
    }];
    
    
    UILabel *employflowlabel = [[UILabel alloc] init];
    employflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    employflowlabel.textColor=[UIColor blackColor];
    employflowlabel.text=NSLocalizedString(@"100km", nil);
    employflowlabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:employflowlabel];
    [employflowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(13*HeightCoefficient);
        make.height.equalTo(25 * HeightCoefficient);
        make.left.equalTo(0);
        make.right.equalTo(lineView.left).offset(0);
    }];
    
    
    UILabel *employflow = [[UILabel alloc] init];
    employflow.font=[UIFont fontWithName:FontName size:11];
    employflow.textColor=[UIColor colorWithHexString:@"#A18E79"];
    employflow.text=NSLocalizedString(@"行驶里程", nil);
    employflow.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:employflow];
    [employflow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(employflowlabel.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(0);
        make.right.equalTo(lineView.left).offset(0);
    }];
    
    
    UILabel *totalflowlabel = [[UILabel alloc] init];
    totalflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
    totalflowlabel.textColor=[UIColor blackColor];
    totalflowlabel.text=NSLocalizedString(@"100km", nil);
    totalflowlabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:totalflowlabel];
    [totalflowlabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(13*HeightCoefficient);
        make.height.equalTo(25 * HeightCoefficient);
        make.left.equalTo(lineView.left).offset(0);
        make.right.equalTo(0);
    }];
    
    
    UILabel *totalflow = [[UILabel alloc] init];
    totalflow.font=[UIFont fontWithName:FontName size:11];
    totalflow.textColor=[UIColor colorWithHexString:@"#A18E79"];
    totalflow.text=NSLocalizedString(@"总里程", nil);
    totalflow.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:totalflow];
    [totalflow makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalflowlabel.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.right.equalTo(0);
        make.left.equalTo(lineView.left).offset(0);
    }];
    
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 4;
    bottomView.layer.shadowOpacity = 0.5;// 阴影透明度
    bottomView.layer.shadowOffset = CGSizeMake(0,7.5);
    bottomView.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    bottomView.layer.shadowRadius = 20.5;//阴影半径，默认3
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(100 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *phone = [[UILabel alloc] init];
    phone.font=[UIFont fontWithName:FontName size:16];
    phone.textColor=[UIColor colorWithHexString:@"#AC0042"];
    phone.text=NSLocalizedString(@"400-800-888", nil);
    phone.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:phone];
    [phone makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * HeightCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.width.equalTo(140 * WidthCoefficient);
    }];
    
    
    UILabel *service = [[UILabel alloc] init];
    service.font=[UIFont fontWithName:FontName size:13];
    service.textColor=[UIColor colorWithHexString:@"#999999"];
    service.text=NSLocalizedString(@"拨打电话预约保养服务", nil);
    service.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:service];
    [service makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phone.bottom).offset(5 *HeightCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.width.equalTo(140 * WidthCoefficient);
    }];
    
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"电话bg"];
    [bottomView addSubview:rightImg];
    [rightImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(100*HeightCoefficient);
        make.width.equalTo(123.5 *WidthCoefficient);
        make.right.equalTo(0);
    }];
    
    self.operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_operationBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _operationBtn.layer.cornerRadius = 2;
    [_operationBtn setTitle:NSLocalizedString(@"手动预约", nil) forState:UIControlStateNormal];
    [_operationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _operationBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_operationBtn setBackgroundColor:[UIColor colorWithHexString:@"#A18E79"]];
    [self.view addSubview:_operationBtn];
    [_operationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(bottomView.bottom).offset(201 * HeightCoefficient);
    }];
    
    
}

-(void)BtnClick:(UIButton *)btn
{
    
    
    
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
