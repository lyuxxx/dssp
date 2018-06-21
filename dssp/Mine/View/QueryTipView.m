//
//  QueryTipView.m
//  dssp
//
//  Created by season on 2018/6/20.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "QueryTipView.h"

//  第一步提示按钮的tag
#define kStepOne 100
//  第二步提示按钮的tag
#define kStepTwo 101

@interface QueryTipView()

/** 说明的label*/
@property (nonatomic, strong) UILabel *explainLabel;

/** 步骤的label*/
@property (nonatomic, strong) UILabel *stepLabel;

/** 拨打电话的button*/
@property (nonatomic, strong) UIButton *callButton;

@end

@implementation QueryTipView

#pragma mark- 初始化
- (instancetype)initWithTag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.tag = tag;
        [self setUpUI];
    }
    return self;
}

#pragma mark- 搭建界面
- (void)setUpUI {
    self.image = [UIImage imageNamed:@"Rectangle"];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.explainLabel];
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20 * HeightCoefficient);
        make.leading.mas_equalTo(self).offset(10 * WidthCoefficient);
        make.trailing.mas_equalTo(self).offset(-10 * WidthCoefficient);
        make.height.mas_equalTo(14 * HeightCoefficient);
    }];
    
    [self addSubview:self.stepLabel];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(self.explainLabel.bottom).offset(7 * HeightCoefficient);
        make.top.mas_equalTo(self).offset(20 * HeightCoefficient);
        make.leading.trailing.mas_equalTo(self.explainLabel);
    }];
    
    [self addSubview:self.callButton];
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.stepLabel);
        make.top.mas_equalTo(self.stepLabel.bottom).offset(10 * HeightCoefficient);
        make.height.mas_equalTo(24 * HeightCoefficient);
        make.width.mas_equalTo(190 * WidthCoefficient);
        make.bottom.mas_equalTo(self).offset(-20 * HeightCoefficient);
    }];
}

#pragma mark- 按钮的点击事件
- (void)callButtonAction:(UIButton *)button {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(queryTipView:callButtonAction:)]) {
        [self.delegate queryTipView:self callButtonAction:button];
    }
}

#pragma mark- 懒加载
- (UILabel *)explainLabel {
    if (!_explainLabel) {
        _explainLabel = [UILabel new];
        _explainLabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
        _explainLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _explainLabel.text = @"";//NSLocalizedString(@"如果车辆激活超过2个小时未成功,请尝试以下操作:", nil);
        _explainLabel.numberOfLines = 0;
    }
    return _explainLabel;
}

- (UILabel *)stepLabel {
    if (!_stepLabel) {
        _stepLabel = [UILabel new];
        _stepLabel.textColor = [UIColor whiteColor];
        _stepLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _stepLabel.numberOfLines = 0;
        
        NSString *text = @"";
        if (self.tag == kStepOne) {
            text = @"a. 如果您提交的实名认证信息存在上传照片不清晰的问题、会进入人工审核，人工审核存在一定延时，需等待\nb. 人工审核已驳回，则需要再次提交实名认证信息";
        }else if (self.tag == kStepTwo) {
            text = @"a. 请将车开至移动信号好的地方，并启动车辆10分钟，以完成激活\nb. 如果车辆仍未激活，请拨打400电话";
        }
        
        _stepLabel.text = text;
    }
    return _stepLabel;
}

- (UIButton *)callButton {
    if (!_callButton) {
        NSString *buttonTitle = [NSString stringWithFormat:@"点击拨打%@",kphonenumber];
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callButton setImage:[UIImage imageNamed:@"call_service"] forState:UIControlStateNormal];
        [_callButton setImage:[UIImage imageNamed:@"call_service"] forState:UIControlStateHighlighted];
        [_callButton setTitle:buttonTitle forState:UIControlStateNormal];
        [_callButton setTitle:buttonTitle forState:UIControlStateHighlighted];
        [_callButton addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _callButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _callButton.layer.borderWidth = 1 / [UIScreen.mainScreen scale];
        _callButton.layer.borderColor = [[UIColor colorWithHexString:@"#AC0042"] CGColor];
        _callButton.layer.cornerRadius = 24 * HeightCoefficient / 2;
        _callButton.layer.masksToBounds = YES;
        _callButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        _callButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    }
    return _callButton;
}

@end

