//
//  CommodityNameCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityNameCell.h"
#import "NSString+Size.h"

NSString * const CommodityNameCellIdentifier = @"CommodityNameCellIdentifier";

@interface CommodityNameCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CommodityNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont fontWithName:FontName size:16];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView).offset(CGPointMake(0, -0.5));
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(10 * WidthCoefficient);
    }];
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    [self.contentView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_nameLabel).offset(UIEdgeInsetsMake(-10 * WidthCoefficient, -10 * WidthCoefficient, -11 * WidthCoefficient, -10 * WidthCoefficient));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(bg);
    }];
    
    [self.contentView insertSubview:bg atIndex:0];
}

- (void)configWithCommodityName:(NSString *)name {
    CGSize size = [name stringSizeWithContentSize:CGSizeMake(kScreenWidth - 52 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:16]];
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(ceil(size.height));
    }];
    self.nameLabel.text = name;
}

+ (CGFloat)cellHeightWithCommodityName:(NSString *)name {
    CGSize size = [name stringSizeWithContentSize:CGSizeMake(kScreenWidth - 52 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:16]];
    return ceil(size.height) + 21 * WidthCoefficient;
}

@end
