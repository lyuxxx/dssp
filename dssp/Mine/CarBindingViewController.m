//
//  CarBindingViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarBindingViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "CarSeriesViewController.h"

@interface CarBindingViewController ()
@property (nonatomic, strong) UILabel *carSeries;
@end

@implementation CarBindingViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"车辆绑定", nil);
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.cornerRadius = 4;
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(313.5 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20 * HeightCoefficient + kNaviHeight);
    }];
    
    UILabel *intro = [[UILabel alloc] init];
    intro.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    intro.text = NSLocalizedString(@"填写车辆信息完成车辆绑定", nil);
    [whiteV addSubview:intro];
    [intro makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(214.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    NSArray<NSString *> *titles = @[NSLocalizedString(@"车主姓名", nil),NSLocalizedString(@"VIN", nil),NSLocalizedString(@"发动机号", nil),NSLocalizedString(@"车系", nil),NSLocalizedString(@"车牌号", nil)];
    NSArray<NSString *> *placeHolders = @[NSLocalizedString(@"", nil),NSLocalizedString(@"请填写VIN号", nil),NSLocalizedString(@"请填写发动机号", nil),NSLocalizedString(@"", nil),NSLocalizedString(@"请填写车牌号", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:FontName size:15];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.text = titles[i];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
            make.top.equalTo((66.5 + 49 * i) * HeightCoefficient);
        }];
        
        if (i != 3) {
            UITextField *field = [[UITextField alloc] init];
            field.font = [UIFont fontWithName:FontName size:15];
            field.textColor = [UIColor colorWithHexString:@"333333"];
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
            [whiteV addSubview:field];
            [field makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
                make.centerY.equalTo(label);
                make.height.equalTo(label);
                make.width.equalTo(150 * WidthCoefficient);
            }];
            
            if (i == 0) {
                field.text = @"张三";
                field.userInteractionEnabled = NO;
            }
            
        } else {
            self.carSeries = [[UILabel alloc] init];
            _carSeries.userInteractionEnabled = YES;
            _carSeries.text = NSLocalizedString(@"请选择车系", nil);
            _carSeries.font = [UIFont fontWithName:FontName size:15];
            _carSeries.textColor = [UIColor colorWithHexString:@"#040000"];
            [whiteV addSubview:_carSeries];
            [_carSeries makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.right).offset(30 * WidthCoefficient);
                make.centerY.equalTo(label);
                make.height.equalTo(label);
                make.width.equalTo(150 * WidthCoefficient);
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seriesLabelTap:)];
            [_carSeries addGestureRecognizer:tap];
        }
        
        if (i < titles.count - 1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
            [whiteV addSubview:line];
            [line makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(313 * WidthCoefficient);
                make.height.equalTo(1 * HeightCoefficient);
                make.centerX.equalTo(0);
                make.top.equalTo(label.bottom).offset(14 * HeightCoefficient);
            }];
        }
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 2;
    [confirmBtn setTitle:NSLocalizedString(@"确认并绑定", nil) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:confirmBtn];
    [confirmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
}

- (void)confirmBtnClick:(UIButton *)sender {
    
}

- (void)seriesLabelTap:(UITapGestureRecognizer *)sender {
    CarSeriesViewController *vc = [[CarSeriesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
