//
//  TrackListHeaderView.m
//  dssp
//
//  Created by yxliu on 2018/3/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrackListHeaderView.h"

@interface TrackListHeaderView ()
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation TrackListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor colorWithHexString:@"040000"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"040000"];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"ac0042"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(15 * WidthCoefficient);
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont fontWithName:FontName size:14];
    _dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.right).offset(5 * WidthCoefficient);
        make.centerY.equalTo(line);
        make.height.equalTo(20 * WidthCoefficient);
    }];
}

- (void)configWithDate:(NSString *)date {
    self.dateLabel.text = [self transformDate:date];
}

- (NSString *)transformDate:(NSString *)inputDate {
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    formatter0.dateFormat = @"yyyy-MM-dd";
    formatter0.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy/MM/dd";
    formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate *date = [formatter0 dateFromString:inputDate];
    return [formatter1 stringFromDate:date];
}

@end
