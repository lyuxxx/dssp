//
//  QueryAlertView.m
//  dssp
//
//  Created by season on 2018/6/15.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "QueryAlertView.h"

//  实名制查询第一步提示按钮的tag 需要根据其重新布局其高度
#define kStepOne 100
//  实名制查询第二步提示按钮的tag 需要根据其重新布局其高度
#define kStepTwo 101

@interface QueryAlertView()

/** 弹窗的显示*/
@property (nonatomic, strong) UIImageView *alertView;

/** 知道了按钮 透明的*/
@property (nonatomic, strong) UIButton *knownButton;

/** 取消按钮 透明*/
@property (nonatomic, strong) UIButton *cancelButton;

@end


@implementation QueryAlertView

#pragma mark- 初始化
- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag; {
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.tag = tag;
        [self setUpUI];
        
    }
    return self;
}

#pragma mark- 搭建界面
- (void)setUpUI {
    
    //  alertView
    [self addSubview:self.alertView];
    if (self.tag == kStepOne) {
        self.alertView.image = [UIImage imageNamed:@"query_alert_stepOne"];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(270);
            make.height.mas_equalTo(243);
        }];
    }else if (self.tag == kStepTwo) {
        self.alertView.image = [UIImage imageNamed:@"query_alert_stepTwo"];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(270);
            make.height.mas_equalTo(283);
        }];
    }else {
        
    }
    [self exChangeOut:self.alertView dur:0.6];
    
    //  knownButton
    [self.alertView addSubview:self.knownButton];
    [self.knownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.alertView);
        make.height.mas_equalTo(44);
    }];
    
    //  cancelButton
    [self.alertView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.top.mas_equalTo(self.alertView).offset(5);
        make.trailing.mas_equalTo(self.alertView).offset(-5);
    }];
}

#pragma mark- 按钮的点击事件
- (void)dismissAction {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertView = nil;
    }];
}

#pragma mark- 动画效果
-(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [changeOutView.layer addAnimation:animation forKey:nil];
}

#pragma mark- 懒加载
- (UIImageView *)alertView {
    if (!_alertView) {
        _alertView = [[UIImageView alloc] init];
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

- (UIButton *)knownButton {
    if (!_knownButton) {
        _knownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knownButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knownButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark- 对外方法
- (void)show {
    UIView *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: self];
}

@end
