//
//  CommodityHeaderView.m
//  dssp
//
//  Created by yxliu on 2018/2/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityHeaderView.h"
#import "NSString+Size.h"

@interface CommodityHeaderView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@end

@implementation CommodityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont fontWithName:FontName size:15];
    [self addSubview:_label];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(45 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.top.equalTo(15 * WidthCoefficient);
        make.bottom.equalTo(-15 * WidthCoefficient);
    }];
    
    self.leftLine = [[UIView alloc] init];
    _leftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_leftLine];
    [_leftLine makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(15 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.centerY.equalTo(_label);
        make.right.equalTo(_label.left).offset(-7.5 * WidthCoefficient);
    }];
    
    self.rightLine = [[UIView alloc] init];
    _rightLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_rightLine];
    [_rightLine makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(15 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.centerY.equalTo(_label);
        make.left.equalTo(_label.right).offset(7.5 * WidthCoefficient);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    CGSize size = [title stringSizeWithContentSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
    [_label updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ceil(size.width));
    }];
    _label.text = title;
}

@end
