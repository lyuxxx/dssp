//
//  MapSearchCell.m
//  dssp
//
//  Created by yxliu on 2017/11/23.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapSearchCell.h"
#import <YYCategories.h>

@interface MapSearchCell ()

@end

@implementation MapSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:FontName size:16];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(263.75 * WidthCoefficient);
        make.height.equalTo(22.5 * WidthCoefficient);
        make.left.equalTo(14.35 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.font = [UIFont fontWithName:FontName size:12];
    _subTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(239.35 * WidthCoefficient);
        make.height.equalTo(16.5 * WidthCoefficient);
        make.left.equalTo(14.35 * WidthCoefficient);
        make.top.equalTo(_titleLabel.bottom).offset(2.5 * WidthCoefficient);;
        make.bottom.equalTo(-8.5 * WidthCoefficient);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.left.equalTo(_subTitleLabel.left);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
