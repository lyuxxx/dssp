//
//  CUAlertView.m
//  CUAlertController
//
//  Created by yxliu on 2017/12/14.
//
#define WidthCoefficient ([[UIScreen mainScreen] bounds].size.width / 375.0)
#define HeightCoefficient ([[UIScreen mainScreen] bounds].size.height / 667.0)
#import "CUAlertView.h"

@implementation CUAlertButtonItem

@end

@interface CUAlertView ()

@end

@implementation CUAlertView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.frame = CGRectMake(0, 0, 270 * WidthCoefficient, 190 * WidthCoefficient);
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(103 * WidthCoefficient, 20 * WidthCoefficient, 64 * WidthCoefficient, 48 * WidthCoefficient)];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.image = self.image;
    [self addSubview:imgV];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(35 * WidthCoefficient, 78 * WidthCoefficient, 200 * WidthCoefficient, 45 * WidthCoefficient)];
    message.textAlignment = NSTextAlignmentCenter;
    message.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    message.numberOfLines = 0;
    if (self.attributedMessage) {
        message.attributedText = self.attributedMessage;
    } else {
        message.text = self.message;
    }
    [self addSubview:message];
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 140.5 * WidthCoefficient, 270 * WidthCoefficient, 1.5 * WidthCoefficient)];
    line0.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    [self addSubview:line0];
    
    if (self.buttonItems.count == 1) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        leftBtn.tag = 100;
        leftBtn.frame = CGRectMake(0, 142 * WidthCoefficient, 270 * WidthCoefficient, 48 * WidthCoefficient);
        [leftBtn setTitle:self.buttonItems[0].title forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.buttonItems.count == 2) {
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(135.25 * WidthCoefficient, 141.5 * WidthCoefficient, 1.25 * WidthCoefficient, 48.25 * WidthCoefficient)];
        line1.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
        [self addSubview:line1];
        for (CUAlertButtonItem *item in self.buttonItems) {
            if (item.type == CUButtonTypeCancel) {
                UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [leftBtn setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
                [leftBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
                leftBtn.tag = 100;
                leftBtn.frame = CGRectMake(0, 142 * WidthCoefficient, 135.5 * WidthCoefficient, 48 * WidthCoefficient);
                [leftBtn setTitle:item.title forState:UIControlStateNormal];
                [self addSubview:leftBtn];
                [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightBtn setTitleColor:[UIColor colorWithRed:172.0/255.0 green:0.0/255.0 blue:66.0/255.0 alpha:1] forState:UIControlStateNormal];
                [rightBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16]];
                rightBtn.tag = 101;
                rightBtn.frame = CGRectMake(135.5 * WidthCoefficient, 142 * WidthCoefficient, 134.5 * WidthCoefficient, 48 * WidthCoefficient);
                [rightBtn setTitle:item.title forState:UIControlStateNormal];
                [self addSubview:rightBtn];
                [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }
}

- (void)btnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        self.buttonItems[0].clicked();
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertButtonClicked:)]) {
            [self.delegate alertButtonClicked:self.buttonItems[0].clicked];
        }
    } else {
        self.buttonItems[1].clicked();
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertButtonClicked:)]) {
            [self.delegate alertButtonClicked:self.buttonItems[1].clicked];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
