//
//  DrivingWeekReportViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingWeekReportViewController.h"

@interface DrivingWeekReportViewController ()

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) UIView *selectV;

@end

@implementation DrivingWeekReportViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    topV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    topV.layer.shadowOffset = CGSizeMake(0, 6);
    topV.layer.shadowRadius = 7;
    topV.layer.shadowOpacity = 0.5;
    [self.view addSubview:topV];
    [topV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * WidthCoefficient);
        make.left.right.equalTo(self.view);
        make.height.equalTo(70 * WidthCoefficient);
    }];
    
    UIImageView *calendarImgV = [[UIImageView alloc] init];
    calendarImgV.image = [UIImage imageNamed:@"日历_icon"];
    [topV addSubview:calendarImgV];
    [calendarImgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(36 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.centerY.equalTo(0);
    }];
    
    NSArray *topTitles = @[@"开始:",@"结束:"];
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = topTitles[i];
        [topV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(35 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(calendarImgV.right).offset(10 * WidthCoefficient);
            make.top.equalTo((10 + 30 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [topV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
    }
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"箭头_右"];
    [topV addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(15 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.centerY.equalTo(0);
    }];
    
    UIView *midV = [[UIView alloc] init];
    midV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:midV];
    [midV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topV.bottom);
        make.height.equalTo(337 * WidthCoefficient);
    }];
    
    NSArray *harshTitles = @[
                             @"急刹车",
                             @"急加速",
                             @"急转弯"
                             ];
    for (NSInteger i = 0; i < harshTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.textAlignment = NSTextAlignmentCenter;
        label0.font = [UIFont fontWithName:FontName size:13];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = harshTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(107.5 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.top.equalTo(20 * WidthCoefficient);
            make.left.equalTo((16 + 118 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(27.5 * WidthCoefficient);
            make.height.equalTo(25 * WidthCoefficient);
            make.top.equalTo(label0.bottom).offset(5 * WidthCoefficient);
            make.centerX.equalTo(label0);
        }];
    }
    
    UIView *line0 = [[UIView alloc] init];
    [midV addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(90 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    NSArray *reportImgs = @[
                            @"里程_icon",
                            @"油耗_icon",
                            @"平均油耗_icon",
                            @"制动时间_icon",
                            @"注意次数_icon",
                            @"acc里程_icon"
                            ];
    
    NSArray *reportTitles = @[
                              @"里程",
                              @"油耗",
                              @"平均油耗",
                              @"汽车制动时间",
                              @"开车注意次数",
                              @"ACC里程"
                              ];
    
    for (NSInteger i = 0; i < reportImgs.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:reportImgs[i]];
        [midV addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16 * WidthCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.top.equalTo(line0.bottom).offset((12 + 41 * i) * WidthCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:15];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.text = reportTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(imgV.right).offset(10 * WidthCoefficient);
            make.centerY.equalTo(imgV);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textAlignment = NSTextAlignmentRight;
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.right.equalTo(-16 * WidthCoefficient);
            make.centerY.equalTo(imgV);
        }];
        
        UIView *line = [[UIView alloc] init];
        [midV addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(317 * WidthCoefficient);
            make.height.equalTo(1 * WidthCoefficient);
            make.right.equalTo(label1);
            make.top.equalTo(label1.bottom).offset(10 * WidthCoefficient);
        }];
    }
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midV.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(120 * WidthCoefficient);
    }];
    
    UIView *content = [[UIView alloc] init];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.height.equalTo(scroll);
    }];
    
    UIView *lastV;
    
    for (NSInteger i = 0; i < 10; i++) {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
        v.layer.cornerRadius = 4;
        v.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
        v.layer.shadowOffset = CGSizeMake(0, 6);
        v.layer.shadowRadius = 7;
        v.layer.shadowOpacity = 0.5;
        [content addSubview:v];
        [v makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(90 * WidthCoefficient);
            make.height.equalTo(80 * HeightCoefficient);
            make.top.equalTo(content).offset(20 * WidthCoefficient);
            if (i == 0) {
                make.left.equalTo(16 * WidthCoefficient);
            } else {
                make.left.equalTo(lastV.right).offset(10 * WidthCoefficient);
            }
        }];
        lastV = v;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapWeek:)];
        [v addGestureRecognizer:tap];
    }
    [lastV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content).offset(-16 * WidthCoefficient);
    }];
}

- (void)didTapWeek:(UITapGestureRecognizer *)sender {
    
}

@end
