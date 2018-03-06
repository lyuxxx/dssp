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
#import "UpkeepdetailController.h"
@interface UpkeepViewController ()
@property (nonatomic ,strong) UIButton *operationBtn;
@property (nonatomic ,strong) UIButton *upkeepBtn;

@end

@implementation UpkeepViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"预约保养", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#040000"];

    
    [self requestData];
}


-(void)requestData
{

    NSDictionary *paras = @{
                            @"vin":kVin
                            };
    [CUHTTPRequest POST:queryMaintenRules parameters:paras success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            
          self.upkeep =[UpkeepModel yy_modelWithDictionary:dic[@"data"]];
         [self setupUI];
            NSLog(@"%@", self.upkeep.maintenanceMileage);

        } else {
            [self blankUI];
//            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [self blankUI];
//        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
    }];
}

-(void)blankUI{
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"空页面1"];
    [bgImgV setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top .equalTo(120 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.height.equalTo(77.5 * HeightCoefficient);
        make.width.equalTo(86.5 * WidthCoefficient);
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text =@"暂无数据";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgV.bottom).offset(15*WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.width.equalTo(100 *WidthCoefficient);
    }];
    
    
}


-(void)setupUI
{
   
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud_mine"];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(126*HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
//    UIView *whiteView = [UIView new];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    whiteView.layer.cornerRadius = 4;
//    whiteView.layer.shadowOpacity = 0.5;// 阴影透明度
//    whiteView.layer.shadowOffset = CGSizeMake(0,7.5);
//    whiteView.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteView.layer.shadowRadius = 20.5;//阴影半径，默认3
//    [self.view addSubview:whiteView];
//    [whiteView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(116 * HeightCoefficient);
//        make.height.equalTo(70 * HeightCoefficient);
//        make.width.equalTo(343 * WidthCoefficient);
//        make.left.equalTo(16 * WidthCoefficient);
//    }];
//
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(27.5 * HeightCoefficient);
        make.height.equalTo(60 * HeightCoefficient);
        make.width.equalTo(1 * HeightCoefficient);
    }];
    
    NSString *maintenanceDay = [[NSString stringWithFormat:@"%@",self.upkeep.maintenanceDay] stringByAppendingString:@"天"];
    UILabel *toplabel = [[UILabel alloc] init];
    toplabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    toplabel.textColor=[UIColor whiteColor];
    toplabel.text=NSLocalizedString(self.upkeep.maintenanceDay?maintenanceDay:@"0天", nil);
    toplabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:toplabel];
    [toplabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30*HeightCoefficient);
        make.height.equalTo(33.5 * HeightCoefficient);
        make.left.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    UILabel *centrelabel = [[UILabel alloc] init];
    centrelabel.font=[UIFont fontWithName:FontName size:12];
    centrelabel.textColor=[UIColor whiteColor];
    centrelabel.text=NSLocalizedString(@"距离下一次保养时间", nil);
    centrelabel.textAlignment = NSTextAlignmentCenter;
    [bgImgV addSubview:centrelabel];
    [centrelabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.left.equalTo(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    NSString *maintenanceMileage = [[NSString stringWithFormat:@"%@",self.upkeep.maintenanceMileage] stringByAppendingString:@"km"];
    UILabel *toplabel1 = [[UILabel alloc] init];
    toplabel1.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    toplabel1.textColor=[UIColor whiteColor];
    toplabel1.text=NSLocalizedString(self.upkeep.maintenanceMileage?maintenanceMileage:@"0km", nil);
    toplabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:toplabel1];
    [toplabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(30*HeightCoefficient);
        make.height.equalTo(33.5 * HeightCoefficient);
        make.left.equalTo(toplabel.right).offset(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
    UILabel *centrelabel1 = [[UILabel alloc] init];
    centrelabel1.font=[UIFont fontWithName:FontName size:12];
    centrelabel1.textColor=[UIColor whiteColor];
    centrelabel1.text=NSLocalizedString(@"距离下一次保养里程", nil);
    centrelabel1.textAlignment = NSTextAlignmentCenter;
    [bgImgV addSubview:centrelabel1];
    [centrelabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toplabel.bottom).offset(5*HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.left.equalTo(toplabel.right).offset(0);
        make.width.equalTo(375 *WidthCoefficient / 2);
    }];
    
    
//    UILabel *Lastlabel = [[UILabel alloc] init];
//    Lastlabel.font=[UIFont fontWithName:FontName size:13];
//    Lastlabel.backgroundColor = [UIColor colorWithHexString:@"#A18E79"];
//    Lastlabel.layer.cornerRadius = 20 * HeightCoefficient/2;
//    Lastlabel.clipsToBounds = YES;
//    Lastlabel.textColor=[UIColor whiteColor];
//    Lastlabel.text=NSLocalizedString(@"上一次保养时间 60天前", nil);
//    Lastlabel.textAlignment = NSTextAlignmentCenter;
//    [bgImgV addSubview:Lastlabel];
//    [Lastlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(centrelabel.bottom).offset(12*HeightCoefficient);
//        make.height.equalTo(20 * HeightCoefficient);
//        make.centerX.equalTo(bgImgV);
//        make.width.equalTo(240 * WidthCoefficient);
//    }];
    
    
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
//
//    [whiteView addSubview:lineView];
//    [lineView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(15 * HeightCoefficient);
//        make.height.equalTo(40 * HeightCoefficient);
//        make.width.equalTo(1 * WidthCoefficient);
//        make.left.equalTo(171 * WidthCoefficient);
//    }];
//
//
//    UILabel *employflowlabel = [[UILabel alloc] init];
//    employflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    employflowlabel.textColor=[UIColor blackColor];
//    employflowlabel.text=NSLocalizedString(@"100km", nil);
//    employflowlabel.textAlignment = NSTextAlignmentCenter;
//    [whiteView addSubview:employflowlabel];
//    [employflowlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(13*HeightCoefficient);
//        make.height.equalTo(25 * HeightCoefficient);
//        make.left.equalTo(0);
//        make.right.equalTo(lineView.left).offset(0);
//    }];
//
//
//    UILabel *employflow = [[UILabel alloc] init];
//    employflow.font=[UIFont fontWithName:FontName size:11];
//    employflow.textColor=[UIColor colorWithHexString:@"#A18E79"];
//    employflow.text=NSLocalizedString(@"行驶里程", nil);
//    employflow.textAlignment = NSTextAlignmentCenter;
//    [whiteView addSubview:employflow];
//    [employflow makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(employflowlabel.bottom).offset(5 * HeightCoefficient);
//        make.height.equalTo(15 * HeightCoefficient);
//        make.left.equalTo(0);
//        make.right.equalTo(lineView.left).offset(0);
//    }];
//
//
//    UILabel *totalflowlabel = [[UILabel alloc] init];
//    totalflowlabel.font=[UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    totalflowlabel.textColor=[UIColor blackColor];
//    totalflowlabel.text=NSLocalizedString(@"100km", nil);
//    totalflowlabel.textAlignment = NSTextAlignmentCenter;
//    [whiteView addSubview:totalflowlabel];
//    [totalflowlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(13*HeightCoefficient);
//        make.height.equalTo(25 * HeightCoefficient);
//        make.left.equalTo(lineView.left).offset(0);
//        make.right.equalTo(0);
//    }];
//
//
//    UILabel *totalflow = [[UILabel alloc] init];
//    totalflow.font=[UIFont fontWithName:FontName size:11];
//    totalflow.textColor=[UIColor colorWithHexString:@"#A18E79"];
//    totalflow.text=NSLocalizedString(@"总里程", nil);
//    totalflow.textAlignment = NSTextAlignmentCenter;
//    [whiteView addSubview:totalflow];
//    [totalflow makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(totalflowlabel.bottom).offset(5 * HeightCoefficient);
//        make.height.equalTo(15 * HeightCoefficient);
//        make.right.equalTo(0);
//        make.left.equalTo(lineView.left).offset(0);
//    }];
//
//
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 4;
    bottomView.layer.shadowOpacity = 0.5;// 阴影透明度
    bottomView.layer.shadowOffset = CGSizeMake(0,7.5);
    bottomView.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    bottomView.layer.shadowRadius = 20.5;//阴影半径，默认3
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(156 * HeightCoefficient);
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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [rightImg addGestureRecognizer:tapGesture];
    rightImg.userInteractionEnabled = YES;
    [bottomView addSubview:rightImg];
//    [bottomView addSubview:rightImg];
    [rightImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(100*HeightCoefficient);
        make.width.equalTo(123.5 *WidthCoefficient);
        make.right.equalTo(0);
    }];
    
    
    
    
    UIView *bottomView1 = [UIView new];
    bottomView1.backgroundColor = [UIColor whiteColor];
    bottomView1.layer.cornerRadius = 4;
    bottomView1.layer.shadowOpacity = 0.5;// 阴影透明度
    bottomView1.layer.shadowOffset = CGSizeMake(0,7.5);
    bottomView1.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    bottomView1.layer.shadowRadius = 20.5;//阴影半径，默认3
    [self.view addSubview:bottomView1];
    [bottomView1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(100 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    self.operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_operationBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _operationBtn.layer.cornerRadius = 2;
    _operationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_operationBtn setTitle:NSLocalizedString(@"保养登记", nil) forState:UIControlStateNormal];
    [_operationBtn setTitleColor:[UIColor colorWithHexString:@"#AC0042"] forState:UIControlStateNormal];
    _operationBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
//    [_operationBtn setBackgroundColor:[UIColor colorWithHexString:@"#A18E79"]];
    [bottomView1 addSubview:_operationBtn];
    [_operationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(140 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    UILabel *service1 = [[UILabel alloc] init];
    service1.font=[UIFont fontWithName:FontName size:13];
    service1.textColor=[UIColor colorWithHexString:@"#999999"];
    service1.text=NSLocalizedString(@"点击进入保养登记界面", nil);
    service1.textAlignment = NSTextAlignmentLeft;
    [bottomView1 addSubview:service1];
    [service1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operationBtn.bottom).offset(5 *HeightCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.width.equalTo(140 * WidthCoefficient);
    }];
    
    
    UIImageView *rightImg1 = [[UIImageView alloc] init];
    rightImg1.image = [UIImage imageNamed:@"手动预约bg"];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
//    [rightImg1 addGestureRecognizer:tapGesture];
//    rightImg1.userInteractionEnabled = YES;
    [bottomView1 addSubview:rightImg1];
    [rightImg1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(100*HeightCoefficient);
        make.width.equalTo(123.5 *WidthCoefficient);
        make.right.equalTo(0);
    }];
    
   
    UIImageView *bottomImg = [[UIImageView alloc] init];
    bottomImg.image = [UIImage imageNamed:@"问号_icon"];
    [self.view addSubview:bottomImg];
    [bottomImg makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.equalTo(-(kBottomHeight+10));
        make.height.equalTo(16 * WidthCoefficient);
        make.width.equalTo(16 * WidthCoefficient);
        make.left.equalTo(121 * WidthCoefficient);
    }];
    
   
    self.upkeepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_upkeepBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _upkeepBtn.layer.cornerRadius = 2;
    [_upkeepBtn setTitle:NSLocalizedString(@"查看DS预约保养规则", nil) forState:UIControlStateNormal];
    [_upkeepBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _upkeepBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
//    [_upkeepBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
    [self.view addSubview:_upkeepBtn];
    [_upkeepBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(113 * WidthCoefficient);
        make.height.equalTo(16 * HeightCoefficient);
        make.left.equalTo(bottomImg.right).offset(5 * WidthCoefficient);
        make.bottom.equalTo(-(kBottomHeight+10));
    }];
}

-(void)BtnClick:(UIButton *)btn
{
    if (btn == self.upkeepBtn) {
        UpkeepdetailController *upkeepdetail =[[UpkeepdetailController alloc] init];
        [self.navigationController pushViewController:upkeepdetail animated:YES];
        
    }
    
    
}

-(void)clickImage
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-400800888"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
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
