//
//  CommodityCommentFooterCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityCommentFooterCell.h"

NSString * const CommodityCommentFooterCellIdentifier = @"CommodityCommentFooterCellIdentifier";

@interface CommodityCommentFooterCell ()
@property (nonatomic, strong) UIView *bg;
@end

@implementation CommodityCommentFooterCell

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
    _bg.layer.cornerRadius = 4;
    _bg.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _bg.layer.shadowOffset = CGSizeMake(0, 6);
    _bg.layer.shadowRadius = 7;
    _bg.layer.shadowOpacity = 0.5;
    _bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    [self.contentView addSubview:_bg];
    [_bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 16 * WidthCoefficient, 10 * WidthCoefficient, 16 * WidthCoefficient));
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(50 * WidthCoefficient);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:FontName size:15];
    label.text = NSLocalizedString(@"查看全部评论", nil);
    label.textColor = [UIColor colorWithHexString:GeneralColorString];
    [_bg addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(300 * WidthCoefficient);
        make.height.equalTo(40 * WidthCoefficient);
        make.center.equalTo(_bg);
    }];
}

+ (CGFloat)cellHeight {
    return 60 * WidthCoefficient;
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
