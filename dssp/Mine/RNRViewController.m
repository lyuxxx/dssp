//
//  RNRViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RNRViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import "RNRPhotoViewController.h"

@interface RNRViewController ()

@end

@implementation RNRViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"实名制", nil);
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.height.equalTo(405 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20.5 * HeightCoefficient);
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
    
    NSArray<NSString *> *titles = @[NSLocalizedString(@"姓名", nil),NSLocalizedString(@"性别", nil),NSLocalizedString(@"证件类型", nil),NSLocalizedString(@"证件号码", nil),NSLocalizedString(@"电话码", nil),NSLocalizedString(@"证件地址", nil)];
    NSArray *placeHolders = @[NSLocalizedString(@"请填写姓名", nil),NSLocalizedString(@"未选择", nil),NSLocalizedString(@"请选择证件类型", nil),NSLocalizedString(@"请填写证件号码", nil),NSLocalizedString(@"请填写电话码", nil),NSLocalizedString(@"请填写证件地址", nil)];
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        label.textColor = [UIColor colorWithHexString:@"#040000"];
        label.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * HeightCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
            make.top.equalTo((66.5 + 49 * i) * HeightCoefficient);
        }];
        
        UITextField *field = [[UITextField alloc] init];
        field.textColor = [UIColor colorWithHexString:@"#040000"];
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolders[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont fontWithName:FontName size:15]}];
        field.font = [UIFont fontWithName:FontName size:15];
        [whiteV addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(label);
            make.left.equalTo(label.right).offset(30 * WidthCoefficient);
            make.width.equalTo(190 * WidthCoefficient);
        }];
        
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
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(24 * HeightCoefficient);
    }];
}

- (void)nextBtnClick:(UIButton *)sender {
    RNRPhotoViewController *vc = [[RNRPhotoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
