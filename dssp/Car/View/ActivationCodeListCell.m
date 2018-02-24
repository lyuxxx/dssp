//
//  ActivationCodeListCell.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ActivationCodeListCell.h"

@interface ActivationCodeListCell ()
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation ActivationCodeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowOpacity = 0.5;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(85 * HeightCoefficient);
        make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(5 * HeightCoefficient, 16 * WidthCoefficient, 5 * HeightCoefficient, 16 * WidthCoefficient));
    }];
    
    self.codeLabel = [[UILabel alloc] init];
    _codeLabel.font = [UIFont fontWithName:FontName size:16];
    _codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [whiteV addSubview:_codeLabel];
    [_codeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.stateLabel = [[UILabel alloc] init];
    _stateLabel.textAlignment = NSTextAlignmentRight;
    _stateLabel.font = [UIFont fontWithName:FontName size:16];
    _stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [whiteV addSubview:_stateLabel];
    [_stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeLabel);
        make.right.equalTo(-10 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont fontWithName:FontName size:13];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [whiteV addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_codeLabel);
        make.top.equalTo(_codeLabel.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
}

@end
