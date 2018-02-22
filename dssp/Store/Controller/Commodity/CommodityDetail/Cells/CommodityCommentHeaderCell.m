//
//  CommodityCommentHeaderCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityCommentHeaderCell.h"

NSString * const CommodityCommentHeaderCellIdentifier = @"CommodityCommentHeaderCellIdentifier";

@interface CommodityCommentHeaderCell ()
@property (nonatomic, strong) UIView *bg;
@end

@implementation CommodityCommentHeaderCell

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
        make.edges.equalTo(UIEdgeInsetsMake(10 * WidthCoefficient, 16 * WidthCoefficient, 0, 16 * WidthCoefficient));
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(41 * WidthCoefficient);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    [_bg addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.centerY.equalTo(_bg);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithHexString:GeneralColorString];
    label.text = NSLocalizedString(@"评论", nil);
    [_bg addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(line.right).offset(5 * WidthCoefficient);
        make.centerY.equalTo(_bg);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [_bg addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.bottom.equalTo(_bg);
        make.centerX.equalTo(_bg);
    }];
}

+ (CGFloat)cellHeight {
    return 51 * WidthCoefficient;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bg.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bg.bounds;
    maskLayer.path = maskPath.CGPath;
    _bg.layer.mask = maskLayer;
    _bg.layer.masksToBounds = YES;
}

@end
