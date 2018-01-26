//
//  ActivationCodeListCell.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ActivationCodeListCell.h"

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
        make.height.equalTo(60 * HeightCoefficient);
        make.edges.equalTo(self.contentView).offset(UIEdgeInsetsMake(5 * HeightCoefficient, 16 * WidthCoefficient, 5 * HeightCoefficient, 16 * WidthCoefficient));
    }];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.font = [UIFont fontWithName:FontName size:16];
    codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [whiteV addSubview:codeLabel];
    [codeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteV);
        make.left.equalTo(10 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont fontWithName:FontName size:16];
    stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [whiteV addSubview:stateLabel];
    [stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteV);
        make.right.equalTo(-10 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
}

@end
