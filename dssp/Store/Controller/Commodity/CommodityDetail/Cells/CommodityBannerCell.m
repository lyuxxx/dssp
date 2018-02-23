//
//  CommodityBannerCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityBannerCell.h"
#import <UIImageView+SDWebImage.h>

NSString * const CommodityBannerCellIdentifier = @"CommodityBannerCellIdentifier";

@interface CommodityBannerCell ()

@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *content;

@end

@implementation CommodityBannerCell

+ (CGFloat)cellHeight {
    return 260 * WidthCoefficient;
}

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
    [self.contentView addSubview:_bg];
    [_bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10 * WidthCoefficient, 16 * WidthCoefficient, 0, 16 * WidthCoefficient));
    }];
    
    self.scroll = [[UIScrollView alloc] init];
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.bounces = NO;
    [_bg addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bg);
    }];
    
    self.content = [[UIView alloc] init];
    [self.scroll addSubview:_content];
    [_content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.height.equalTo(self.scroll);
    }];
    
}

- (void)configWithImages:(NSArray *)images {
    
    [self.content removeAllSubviews];
    
    UIImageView *lastView;
    for (NSInteger i = 0 ; i < 3; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        [imgV downloadImage:images[i] placeholder:[UIImage imageNamed:@""] success:^(CUImageCacheType cacheType, UIImage *image) {
            
        } failure:^(NSError *error) {
            
        } received:^(CGFloat progress) {
            
        }];
        [_content addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(250 * WidthCoefficient);
            make.top.equalTo(_content);
            if (i == 0) {
                make.left.equalTo(_content);
            } else {
                make.left.equalTo(lastView.right);
            }
        }];
        lastView = imgV;
    }
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_content);
    }];
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
