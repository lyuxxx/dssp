//
//  CommodityPriceCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityPriceCell.h"
#import <YYLabel.h>
#import "NSString+Size.h"
#import "CommodityDetailCellsConfigurator.h"

NSString * const CommodityPriceCellIdentifier = @"CommodityPriceCellIdentifier";

@interface CommodityPriceCell ()
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UILabel *salePriceLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *promotionLabel;
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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bg = [[UIView alloc] init];
    _bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    _bg.layer.cornerRadius = 4;
    _bg.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _bg.layer.shadowOffset = CGSizeMake(0, 6);
    _bg.layer.shadowRadius = 7;
    _bg.layer.shadowOpacity = 0.5;
    [self.contentView addSubview:_bg];
    [_bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 16 * WidthCoefficient, 5 * WidthCoefficient, 16 * WidthCoefficient));
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(45 * WidthCoefficient);
    }];
    
    self.salePriceLabel = [[UILabel alloc] init];
    _salePriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    _salePriceLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    _salePriceLabel.textAlignment = NSTextAlignmentLeft;
    [_bg addSubview:_salePriceLabel];
    [_salePriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(10 * WidthCoefficient);
        make.height.equalTo(25 * WidthCoefficient);
        make.width.equalTo(75 * WidthCoefficient);
    }];
    
    self.originalPriceLabel = [[UILabel alloc] init];
    _originalPriceLabel.font = [UIFont fontWithName:FontName size:12];
    _originalPriceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _originalPriceLabel.textAlignment = NSTextAlignmentLeft;
    [_bg addSubview:_originalPriceLabel];
    [_originalPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_salePriceLabel.right).offset(5 * WidthCoefficient);
        make.top.equalTo(_salePriceLabel.top).offset(7 * WidthCoefficient);
        make.height.equalTo(18 * WidthCoefficient);
        make.width.equalTo(100 * WidthCoefficient);
    }];
    
    self.promotionLabel = [[UILabel alloc] init];
    _promotionLabel.layer.masksToBounds = YES;
    _promotionLabel.layer.cornerRadius = 3;
    _promotionLabel.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    _promotionLabel.layer.borderWidth = 0.5;
    _promotionLabel.font = [UIFont fontWithName:FontName size:12];
    _promotionLabel.textColor = [UIColor colorWithHexString:@"#a18e79"];
    _promotionLabel.textAlignment = NSTextAlignmentCenter;
    [_bg addSubview:_promotionLabel];
    [_promotionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_salePriceLabel);
        make.right.equalTo(-10 * WidthCoefficient);
        make.width.equalTo(70 * WidthCoefficient);
    }];
    
}

- (void)configWithConfig:(CommodityDetailCellsConfigurator *)config {
    if (!config.promotionStr.length) {
        _originalPriceLabel.hidden = YES;
        _promotionLabel.hidden = YES;
    } else {
        _originalPriceLabel.hidden = NO;
        _promotionLabel.hidden = NO;
    }
    _salePriceLabel.text = config.salePriceStr;
    _originalPriceLabel.attributedText = config.originalPriceStr;
    _promotionLabel.text = config.promotionStr;

    CGSize size = [config.salePriceStr stringSizeWithContentSize:CGSizeMake(MAXFLOAT, 25 * WidthCoefficient) font:[UIFont fontWithName:@"PingFangSC-Medium" size:20]];
    [_salePriceLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ceil(size.width));
    }];
    
    if (config.promotionStr.length) {
        CGSize size1 = [config.promotionStr stringSizeWithContentSize:CGSizeMake(MAXFLOAT, 22 * WidthCoefficient) font:_promotionLabel.font];
        [_promotionLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(ceil(size1.width) + 18 * WidthCoefficient);
        }];
    }
    
}

+ (CGFloat)cellHeight {
    return 50 * WidthCoefficient;
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
