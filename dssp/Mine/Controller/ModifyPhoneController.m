//
//  modifyPhoneController.m
//  dssp
//
//  Created by qinbo on 2017/12/26.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ModifyPhoneController.h"
#import "ModifyPhonesController.h"
@interface ModifyPhoneController ()

@end

@implementation ModifyPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
      [self setupUI];
}

- (void)setupUI {
    
    
    self.navigationItem.title = @"手机号";
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(180 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(44 * HeightCoefficient);
    }];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"更换手机_icon"];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
//    logo.backgroundColor = [UIColor redColor];
    logo.clipsToBounds=YES;
    logo.layer.cornerRadius=48 * WidthCoefficient/2;
    [self.view addSubview:logo];
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(48 * WidthCoefficient);
        make.height.equalTo(48 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"当前手机号为 15871707603" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
    NSRange range = [@"当前手机号为 15871707603" rangeOfString:@"15871707603"];
    [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:172.0/255.0 green:0 blue:66.0/255.0 alpha:1] range:range];
    UILabel *phone = [[UILabel alloc] init];
    phone.textAlignment = NSTextAlignmentCenter;
    phone.textColor = [UIColor colorWithHexString:@"#000000"];
    phone.font = [UIFont fontWithName:FontName size:13];
//    phone.text = NSLocalizedString(@"当前手机号为", nil);
    phone.attributedText =message;
    [whiteV addSubview:phone];
    [phone makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.top.equalTo(logo.bottom).offset(10 * HeightCoefficient);
    }];
    
    
    UILabel *lab1 = [[UILabel alloc] init];
//    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.textColor = [UIColor colorWithHexString:@"#999999"];
    lab1.font = [UIFont fontWithName:FontName size:12];
    lab1.text = NSLocalizedString(@"* 更换手机号后,当前的账户信息及享有的权益均保持不变", nil);
//    lab1.numberOfLines = 0;//根据最大行数需求来设置
    [whiteV addSubview:lab1];
    [lab1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.equalTo(20 * WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.top.equalTo(phone.bottom).offset(15 * HeightCoefficient);
    }];
    
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.textColor = [UIColor colorWithHexString:@"#999999"];
    lab2.font = [UIFont fontWithName:FontName size:12];
    lab2.text = NSLocalizedString(@"* 更换成功后请使用新手机号登录", nil);
    [whiteV addSubview:lab2];
    [lab2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.equalTo(20 * WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.top.equalTo(lab1.bottom).offset(0 * HeightCoefficient);
    }];
    
    
    UILabel *lab3 = [[UILabel alloc] init];
    lab3.textColor = [UIColor colorWithHexString:@"#999999"];
    lab3.font = [UIFont fontWithName:FontName size:12];
    lab3.text = NSLocalizedString(@"* 30天内只能修改一次手机号", nil);
    [whiteV addSubview:lab3];
    [lab3 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.left.equalTo(20 * WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.top.equalTo(lab2.bottom).offset(0 * HeightCoefficient);
    }];
    
    
     UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        modifyBtn.layer.cornerRadius = 2;
        [modifyBtn setTitle:NSLocalizedString(@"知道了,我要更换", nil) forState:UIControlStateNormal];
        [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        modifyBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
        [modifyBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
        [self.view addSubview:modifyBtn];
        [modifyBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(271 * WidthCoefficient);
            make.height.equalTo(44 * HeightCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(whiteV.bottom).offset(25 * HeightCoefficient);
        }];
}

-(void)BtnClick:(UIButton *)btn
{
    ModifyPhonesController *ModifyPhones = [ModifyPhonesController new];
    [self.navigationController pushViewController:ModifyPhones animated:YES];
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
