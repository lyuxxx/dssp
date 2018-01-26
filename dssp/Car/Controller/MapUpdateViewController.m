//
//  MapUpdateViewController.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "MapUpdateViewController.h"
#import "GetActivationCodeViewController.h"

@interface MapUpdateViewController ()

@end

@implementation MapUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"地图升级", nil);
    
    UIButton *rtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rtBtn addTarget:self action:@selector(helpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rtBtn setTitle:NSLocalizedString(@"帮助", nil) forState:UIControlStateNormal];
    [rtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtBtn];
    [rtBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
    }];
    
    [self setupUI];
}

- (void)setupUI {
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"update_backgroud"];
    [self.view addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(95 * WidthCoefficient);
    }];
    
    UIView *topWV = [[UIView alloc] init];
    topWV.layer.cornerRadius = 4;
    topWV.layer.masksToBounds = YES;
    topWV.layer.shadowOffset = CGSizeMake(0, 4);
    topWV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    topWV.layer.shadowOpacity = 0.5;
    topWV.layer.shadowRadius = 7;
    topWV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topWV];
    [topWV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(70 * WidthCoefficient);
        make.top.equalTo(86 * WidthCoefficient);
    }];
    
    UIView *line = [[UIView alloc] init];
    [topWV addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topWV);
        make.width.equalTo(1 * WidthCoefficient);
        make.height.equalTo(40 * WidthCoefficient);
    }];
    
    UIView *leftV = [[UIView alloc] init];
    [topWV addSubview:leftV];
    [leftV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(171.5 * WidthCoefficient);
        make.height.equalTo(topWV);
        make.left.equalTo(topWV);
        make.centerY.equalTo(topWV);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"1次";
    timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [leftV addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftV);
        make.height.equalTo(25 * WidthCoefficient);
        make.top.equalTo(13 * WidthCoefficient);
    }];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = NSLocalizedString(@"已购买升级权限", nil);
    leftLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    leftLabel.font = [UIFont fontWithName:FontName size:11];
    [leftV addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftV);
        make.height.equalTo(15 * WidthCoefficient);
        make.top.equalTo(timeLabel.bottom).offset(5 * WidthCoefficient);
    }];
    
    UIView *rtV = [[UIView alloc] init];
    [topWV addSubview:rtV];
    [rtV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(171.5 * WidthCoefficient);
        make.height.equalTo(topWV);
        make.right.equalTo(topWV);
        make.centerY.equalTo(topWV);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"1个";
    numLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [rtV addSubview:numLabel];
    [numLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rtV);
        make.height.equalTo(25 * WidthCoefficient);
        make.top.equalTo(13 * WidthCoefficient);
    }];
    
    UILabel *rtLabel = [[UILabel alloc] init];
    rtLabel.text = NSLocalizedString(@"已购买升级权限", nil);
    rtLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    rtLabel.font = [UIFont fontWithName:FontName size:11];
    [rtV addSubview:rtLabel];
    [rtLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rtV);
        make.height.equalTo(15 * WidthCoefficient);
        make.top.equalTo(numLabel.bottom).offset(5 * WidthCoefficient);
    }];
    
    UIView *botV = [[UIView alloc] init];
    botV.backgroundColor = [UIColor whiteColor];
    botV.layer.cornerRadius = 4;
    botV.layer.masksToBounds = YES;
    botV.layer.shadowOffset = CGSizeMake(0, 4);
    botV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    botV.layer.shadowOpacity = 0.5;
    botV.layer.shadowRadius = 7;
    [self.view addSubview:botV];
    [botV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(100 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(topWV.bottom).offset(20 * WidthCoefficient);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.userInteractionEnabled = YES;
    imgV.image = [UIImage imageNamed:@"激活bg"];
    [botV addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(botV);
        make.width.equalTo(123.5 * WidthCoefficient);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"点击获取激活码", nil);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [botV addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
        make.height.equalTo(22.5 * WidthCoefficient);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = NSLocalizedString(@"您还可以获取激活一次", nil);
    label1.font = [UIFont fontWithName:FontName size:13];
    label1.textColor = [UIColor colorWithHexString:@"#999999"];
    [botV addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(label.bottom).offset(5 * WidthCoefficient);
        make.height.equalTo(18.5 * WidthCoefficient);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate:)];
    [botV addGestureRecognizer:tap];
}

- (void)helpBtnClick:(UIButton *)sender {
    
}

- (void)activate:(UITapGestureRecognizer *)sender {
    GetActivationCodeViewController *vc = [[GetActivationCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
