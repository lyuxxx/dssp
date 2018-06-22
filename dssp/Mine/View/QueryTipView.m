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
    
/** 第一个竖线*/
@property (nonatomic, strong) UIView *firstLine;

/** 横线*/
@property (nonatomic, strong) UIView *line;

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
    self.image = [UIImage imageNamed:@"query_tip_bg"];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.firstLine];
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3 * WidthCoefficient);
        make.height.mas_equalTo(15 * HeightCoefficient);
        make.top.mas_equalTo(self).offset(20 * HeightCoefficient);
        make.leading.mas_equalTo(self).offset(10 * WidthCoefficient);
    }];
    
    [self addSubview:self.callButton];
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16 * HeightCoefficient);
        make.top.mas_equalTo(self.firstLine);
        make.trailing.mas_equalTo(self).offset(-10 * WidthCoefficient);
    }];
    
    [self addSubview:self.explainLabel];
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstLine);
        make.leading.mas_equalTo(self.firstLine.trailing).offset(5 * WidthCoefficient);
        make.trailing.mas_equalTo(self.callButton.leading).offset(-5 * WidthCoefficient);
        make.height.mas_equalTo(15 * HeightCoefficient);
    }];
    
    [self addSubview:self.line];
    [self.line makeConstraints:^(MASConstraintMaker *make) {
         make.leading.mas_equalTo(self.firstLine);
         make.trailing.mas_equalTo(self.callButton);
         make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.explainLabel.bottom).offset(10 * HeightCoefficient);
     }];
    
    [self addSubview:self.stepLabel];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line.bottom).offset(10 * HeightCoefficient);
        make.leading.trailing.mas_equalTo(self.line);
        make.bottom.mas_equalTo(self).offset(-20 * HeightCoefficient);
    }];
    
    /*
    [self addSubview:self.callButton];
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.stepLabel);
        make.top.mas_equalTo(self.stepLabel.bottom).offset(10 * HeightCoefficient);
        make.height.mas_equalTo(24 * HeightCoefficient);
        make.width.mas_equalTo(190 * WidthCoefficient);
        make.bottom.mas_equalTo(self).offset(-20 * HeightCoefficient);
    }];
    */
}

#pragma mark- 按钮的点击事件
- (void)callButtonAction:(UIButton *)button {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(queryTipView:callButtonAction:)]) {
        [self.delegate queryTipView:self callButtonAction:button];
    }
}

#pragma mark- 通过正则改变文字的颜色
- (NSMutableAttributedString *)changText:(NSString *)text regex:(NSString *)regex color:(UIColor *)color {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRegularExpression *regexExpression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *result = [regexExpression matchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    for (NSTextCheckingResult* item in result) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[item range]];
    }
    return attributedString;
}
    
#pragma mark- 懒加载
    
- (UIView *)firstLine {
    if (!_firstLine) {
        _firstLine = [UIView new];
        _firstLine.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
        _firstLine.layer.cornerRadius = 1.5;
        _firstLine.layer.masksToBounds = YES;
    }
    return _firstLine;
}
    
- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithHexString:@"#1E1918"];
    }
    return _line;
}
    
- (UILabel *)explainLabel {
    if (!_explainLabel) {
        _explainLabel = [UILabel new];
        _explainLabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
        _explainLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        
        NSString *text = @"";
        if (self.tag == kStepOne) {
            text = @"实名认证信息审核温馨提示：";
        }else if (self.tag == kStepTwo) {
            text = @"车辆激活温馨提示：";
        }
        _explainLabel.text = text;
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
            text = @"1. 如果您提交的实名认证信息未实时通过，进入人工审核，请等待\n2. 若实名认证审核被驳回，则需要您再次提交\n3. 如有疑问清拨打客服电话 400-626-6998";
        }else if (self.tag == kStepTwo) {
            text = @"1. 请将车开至信号良好的地方\n2. 启动车辆10分钟以上\n3. 如果车辆激活超过半小时未完成，可拨打客服电话 400-626-6998";
        }
        NSMutableAttributedString* attributedString = [self changText:text regex:@"400-626-6998" color:[UIColor colorWithHexString:@"#AC0042"]];
        _stepLabel.attributedText = attributedString;
    }
    return _stepLabel;
}

- (UIButton *)callButton {
    if (!_callButton) {
        NSString *buttonTitle = [NSString stringWithFormat:@"点击拨打%@",kphonenumber];
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callButton setImage:[UIImage imageNamed:@"call_service"] forState:UIControlStateNormal];
        [_callButton setImage:[UIImage imageNamed:@"call_service"] forState:UIControlStateHighlighted];
        //[_callButton setTitle:buttonTitle forState:UIControlStateNormal];
        //[_callButton setTitle:buttonTitle forState:UIControlStateHighlighted];
        [_callButton addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //_callButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        //_callButton.layer.borderWidth = 1 / [UIScreen.mainScreen scale];
        //_callButton.layer.borderColor = [[UIColor colorWithHexString:@"#AC0042"] CGColor];
        //_callButton.layer.cornerRadius = 24 * HeightCoefficient / 2;
        //_callButton.layer.masksToBounds = YES;
        //_callButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        //_callButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    }
    return _callButton;
}

@end

