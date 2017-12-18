//
//  RemindViewController.m
//  dssp
//
//  Created by yxliu on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RemindViewController.h"
#import <YYCategories.h>

@interface RemindViewController ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *message;
@end

@implementation RemindViewController

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.image = image;
        self.intro = title;
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.intro;
    
    [self setupUI];
}

- (void)setupUI {
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.5;
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(359 * WidthCoefficient, 130 * HeightCoefficient));
        make.top.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = self.image;
    [self.view addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(48 * WidthCoefficient, 48 * WidthCoefficient));
        make.top.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    titleLabel.text = self.intro;
    [whiteV addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(34 * HeightCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.numberOfLines = 0;
    msgLabel.font = [UIFont fontWithName:FontName size:13];
    msgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    msgLabel.text = self.message;
    [whiteV addSubview:msgLabel];
    [msgLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(66.5 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(whiteV);
    }];
}

@end
