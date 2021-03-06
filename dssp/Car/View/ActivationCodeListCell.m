//
//  ActivationCodeListCell.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ActivationCodeListCell.h"
#import "MapUpdateObject.h"

@interface ActivationCodeListCell ()
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation ActivationCodeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowOpacity = 0.5;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    [self.contentView addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(75 * WidthCoefficient);
        make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(5 * WidthCoefficient, 16 * WidthCoefficient, 5 * WidthCoefficient, 16 * WidthCoefficient));
    }];
    
    self.codeLabel = [[UILabel alloc] init];
    _codeLabel.font = [UIFont fontWithName:FontName size:16];
    _codeLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [whiteV addSubview:_codeLabel];
    [_codeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
    }];
    
    self.stateLabel = [[UILabel alloc] init];
    _stateLabel.textAlignment = NSTextAlignmentRight;
    _stateLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [whiteV addSubview:_stateLabel];
    [_stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeLabel);
        make.right.equalTo(-10 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont fontWithName:FontName size:13];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeLabel);
        make.top.equalTo(_codeLabel.bottom).offset(5 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
    }];
}

- (void)configWithActivationCode:(ActivationCode *)code {
    self.codeLabel.text = code.checkCode;
    if ([code.recordStatus isEqualToString:@"1"]) {
        _stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
        _stateLabel.text = NSLocalizedString(@"有效", nil);
    } else if ([code.recordStatus isEqualToString:@"0"]) {
        _stateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _stateLabel.text = NSLocalizedString(@"无效", nil);
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:1];
    [components setMonth:0];
    [components setDay:0];
    // laterDate为一年后的时间
    NSDate *laterDate = [calendar dateByAddingComponents:components toDate:code.getDate options:NSCalendarMatchStrictly];
    
    self.timeLabel.text = [NSString stringWithFormat:@"到期时间:%@",[formatter stringFromDate:laterDate]];
}

@end
