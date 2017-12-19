//
//  CarUnbindViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarUnbindViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "CarInfoModel.h"

@interface CarUnbindViewController ()
@property (nonatomic, strong) UIScrollView *sc;
@property (nonatomic, strong) UIButton *unbindBtn;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@end

@implementation CarUnbindViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}


- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"解绑车辆", nil);

    self.rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(BtnClick:)];
    [_rightBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = _rightBarItem;
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.5;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 *WidthCoefficient);
        make.height.equalTo(405 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(20.5 * HeightCoefficient);
        make.bottom.equalTo(self.view.bottom).offset(-77 * HeightCoefficient - kBottomHeight);
        
    }];
    
    UILabel *query = [[UILabel alloc] init];
    query.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    query.textAlignment = NSTextAlignmentCenter;
    query.text = NSLocalizedString(@"您的车辆信息", nil);
    [whiteV addSubview:query];
    [query makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteV);
        make.width.equalTo(170 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.top.equalTo(20 * HeightCoefficient);
    }];
    
    NSArray<NSString *> *titles = @[
                                    
                                    NSLocalizedString(@"车架号", nil),
                                    NSLocalizedString(@"发动机号", nil),
                                    NSLocalizedString(@"车牌号", nil),
                                    NSLocalizedString(@"颜色", nil),
                                    NSLocalizedString(@"车辆状态", nil),
                                    NSLocalizedString(@"车辆类型", nil),
                                    NSLocalizedString(@"品牌", nil),
                                    NSLocalizedString(@"车辆T状态", nil),
                                    NSLocalizedString(@"车系名", nil),
                                    NSLocalizedString(@"车型名", nil)
                                    
                                    ];
    
    self.sc = ({
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [whiteV addSubview:scroll];
        [scroll makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(whiteV).offset(UIEdgeInsetsMake(66 * HeightCoefficient, 0, 50 * HeightCoefficient, 0));
        }];
        
        UIView *contentView = [[UIView alloc] init];
        [scroll addSubview:contentView];
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scroll);
            make.width.equalTo(whiteV.width);
        }];
        
        UILabel *lastLabel = nil;
        UIView *lastView = nil;
        
        for (NSInteger i = 0 ; i < titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = titles[i];
            label.textColor = [UIColor colorWithHexString:@"#040000"];
            label.font = [UIFont fontWithName:FontName size:15];
            [contentView addSubview:label];
            
            UILabel *rightLabel = [[UILabel alloc] init];
            rightLabel.text = titles[i];
            rightLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            rightLabel.font = [UIFont fontWithName:FontName size:15];
            [contentView  addSubview:rightLabel];
            
            UIView *whiteView = [[UIView alloc] init];
            whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
            [contentView addSubview:whiteView];
            
            
            
            if (i == 0) {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(150 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(27*WidthCoefficient);
                    make.top.equalTo(0);
                    
                }];
                
                [whiteView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(34 * HeightCoefficient);
                    
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            } else {
                [label makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(85 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(15*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(29 * HeightCoefficient);
                }];
                
                [rightLabel makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(150 * WidthCoefficient);
                    make.height.equalTo(20 * HeightCoefficient);
                    make.left.equalTo(label.right).offset(27*WidthCoefficient);
                    make.top.equalTo(lastLabel.bottom).offset(29 * HeightCoefficient);
                }];
                
                [whiteView makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.bottom).offset(48 * HeightCoefficient);
                    make.height.equalTo(1);
                    make.left.equalTo(15 * WidthCoefficient);
                    make.right.equalTo(-15 * WidthCoefficient);
                    
                }];
                
            }
            lastLabel = label;
            lastView =whiteView;
            
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastLabel.bottom).offset(0);
            
        }];
        
        scroll;
    });
    
    
    self.unbindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_unbindBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _unbindBtn.layer.cornerRadius = 2;
    [_unbindBtn setTitle:NSLocalizedString(@"解绑车辆", nil) forState:UIControlStateNormal];
    [_unbindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _unbindBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_unbindBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
    [self.view addSubview:_unbindBtn];
    [_unbindBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(whiteV.bottom).offset(25 * HeightCoefficient);
    }];
    
}

-(void)BtnClick:(UIButton *)btn
{
    if (self.rightBarItem == btn) {
        
    }
    if (self.unbindBtn == btn) {
        
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
