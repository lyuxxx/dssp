//
//  SendPoiProgressView.m
//  dssp
//
//  Created by yxliu on 2018/1/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "SendPoiProgressView.h"
#import <FLAnimatedImage.h>

typedef void(^CancelBlock)(void);

@interface SendPoiProgressView ()
@property (nonatomic, copy) CancelBlock cancelBlock;
@end

@implementation SendPoiProgressView

+ (instancetype)showWithCancelBlock:(void (^)(void))block {
    SendPoiProgressView *view = [[self alloc] init];
    view.cancelBlock = block;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return view;
}

+ (void)dismiss {
    for (UIView *view in [[UIApplication sharedApplication].keyWindow.subviews reverseObjectEnumerator]) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:5/255.0 green:0 blue:10/255.0 alpha:0.3];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(270 * WidthCoefficient);
        make.height.equalTo(150 * WidthCoefficient);
    }];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"waiting" ofType:@"gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    [whiteV addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(130 * WidthCoefficient);
        make.height.equalTo(130 * WidthCoefficient * 23.0 / 180.0);
        make.top.equalTo(20 * WidthCoefficient);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:FontName size:16];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.text = @"正在发送,请等待...";
    [whiteV addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(20 * WidthCoefficient);
        make.top.equalTo(imageView.bottom).offset(20 * WidthCoefficient);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [whiteV addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(48 * WidthCoefficient);
        make.width.equalTo(whiteV);
        make.centerX.equalTo(whiteV);
        make.bottom.equalTo(whiteV);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [whiteV addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(whiteV);
        make.height.equalTo(1.5 * WidthCoefficient);
        make.centerX.equalTo(whiteV);
        make.bottom.equalTo(btn.top);
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
