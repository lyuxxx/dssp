//
//  DrivingReportWeekCell.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingReportWeekCell.h"

@interface DrivingReportWeekCell ()
@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UIView *topDot;
@property (nonatomic, strong) UIView *botDot;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *botLabel;
@end

@implementation DrivingReportWeekCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bgV = [[UIView alloc] init];
    _bgV.layer.masksToBounds = YES;
    _bgV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    _bgV.layer.cornerRadius = 4;
    _bgV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _bgV.layer.shadowOffset = CGSizeMake(0, 6);
    _bgV.layer.shadowRadius = 7;
    _bgV.layer.shadowOpacity = 0.5;
    [self.contentView addSubview:_bgV];
    [_bgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(90 * WidthCoefficient);
        make.height.equalTo(80 * WidthCoefficient);
        make.edges.equalTo(UIEdgeInsetsMake(5 * WidthCoefficient, 5 * WidthCoefficient, 5 * WidthCoefficient, 5 * WidthCoefficient));
    }];
    
    self.topDot = [[UIView alloc] init];
    _topDot.backgroundColor = [UIColor colorWithHexString:@"999999"];
    _topDot.layer.cornerRadius = 3 * WidthCoefficient;
    [_bgV addSubview:_topDot];
    [_topDot makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(6 * WidthCoefficient);
        make.top.equalTo(17 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
    }];
    
    self.topLabel = [[UILabel alloc] init];
    _topLabel.font = [UIFont fontWithName:FontName size:12];
    _topLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [_bgV addSubview:_topLabel];
    [_topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topDot.right).offset(5 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.centerY.equalTo(_topDot);
    }];
    
    self.botDot = [[UIView alloc] init];
    _botDot.backgroundColor = [UIColor colorWithHexString:@"999999"];
    _botDot.layer.cornerRadius = 3 * WidthCoefficient;
    [_bgV addSubview:_botDot];
    [_botDot makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(6 * WidthCoefficient);
        make.top.equalTo(_topDot.bottom).offset(24 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
    }];
    
    self.botLabel = [[UILabel alloc] init];
    _botLabel.font = [UIFont fontWithName:FontName size:12];
    _botLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [_bgV addSubview:_botLabel];
    [_botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_botDot.right).offset(5 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.centerY.equalTo(_botDot);
    }];
}

- (void)configWithStart:(NSString *)start end:(NSString *)end isSelected:(BOOL)isSelected {
    if (isSelected) {
        self.topDot.backgroundColor = [UIColor colorWithHexString:@"#a18e79"];
        self.botDot.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
        
        _bgV.layer.borderColor = [UIColor colorWithHexString:@"#ac0042"].CGColor;
        _bgV.layer.borderWidth = 1;
        
    } else {
        self.topDot.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        self.botDot.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        
        _bgV.layer.borderColor = [UIColor clearColor].CGColor;
        _bgV.layer.borderWidth = 1;
    }
    
    self.topLabel.text = start;
    self.botLabel.text = end;
}

@end
