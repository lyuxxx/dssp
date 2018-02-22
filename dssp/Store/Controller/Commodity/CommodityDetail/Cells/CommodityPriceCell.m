//
//  CommodityPriceCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityPriceCell.h"

NSString * const CommodityPriceCellIdentifier = @"CommodityPriceCellIdentifier";

@interface CommodityPriceCell ()
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation CommodityPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#040000"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bg = [[UIView alloc] init];
    _bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    [self.contentView addSubview:_bg];
    [_bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 16 * WidthCoefficient, 0, 16 * WidthCoefficient));
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(45 * WidthCoefficient);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    [_bg addSubview:_priceLabel];
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10 * WidthCoefficient, 10 * WidthCoefficient, 10 * WidthCoefficient, 10 * WidthCoefficient));
        make.height.equalTo(25 * WidthCoefficient);
    }];
}

- (void)configWithPrice:(NSString *)price {
    self.priceLabel.text = price;
}

+ (CGFloat)cellHeight {
    return 45 * WidthCoefficient;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bg.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bg.bounds;
    maskLayer.path = maskPath.CGPath;
    _bg.layer.mask = maskLayer;
    _bg.layer.masksToBounds = YES;
}

@end
