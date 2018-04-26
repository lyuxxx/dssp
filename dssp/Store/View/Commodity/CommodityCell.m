//
//  CommodityCell.m
//  dssp
//
//  Created by yxliu on 2018/2/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityCell.h"
#import <UIImageView+SDWebImage.h>
#import "StoreObject.h"

@interface CommodityCell ()
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UIImageView *promotion;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, copy) BuyBtnClick buyBtnClick;

@end

@implementation CommodityCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath buyBtnClick:(void (^)(UIButton *))buyBtnBlock {
    CommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CommodityCell class]) forIndexPath:indexPath];
    cell.buyBtnClick = buyBtnBlock;
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bg = [[UIView alloc] init];
    bg.clipsToBounds = YES;
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    bg.layer.cornerRadius = 4;
    bg.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    bg.layer.shadowOffset = CGSizeMake(0, 6);
    bg.layer.shadowRadius = 7;
    bg.layer.shadowOpacity = 0.5;
    [self.contentView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(5 * WidthCoefficient, 5 * WidthCoefficient, 5 * WidthCoefficient, 5 * WidthCoefficient));
        make.width.equalTo(166 * WidthCoefficient);
        make.height.equalTo(240 * WidthCoefficient);
    }];
    
    self.imgV = [[UIImageView alloc] init];
    _imgV.layer.masksToBounds = YES;
    [bg addSubview:_imgV];
    [_imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bg);
        make.height.equalTo(152 * WidthCoefficient);
        make.left.top.right.equalTo(bg);
    }];
    
    self.promotion = [[UIImageView alloc] init];
    _promotion.image = [UIImage imageNamed:@"promotion"];
    [_imgV addSubview:_promotion];
    [_promotion makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(29 * WidthCoefficient);
        make.right.top.equalTo(_imgV);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:FontName size:13];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.preferredMaxLayoutWidth = 104.5 * WidthCoefficient;
    [bg addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(146.5 * WidthCoefficient);
        make.height.equalTo(40 * WidthCoefficient);
        make.top.equalTo(_imgV.bottom).offset(10 * WidthCoefficient);
        make.centerX.equalTo(bg);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [bg addSubview:_priceLabel];
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(_titleLabel.bottom).offset(9 * WidthCoefficient);
        make.bottom.equalTo(-9 * WidthCoefficient);
    }];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBtn setTitle:NSLocalizedString(@"购买", nil) forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    _buyBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    _buyBtn.layer.cornerRadius = 9 * WidthCoefficient;
    _buyBtn.layer.masksToBounds = YES;
    [bg addSubview:_buyBtn];
    [_buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(18 * WidthCoefficient);
        make.centerY.equalTo(_priceLabel);
        make.right.equalTo(-10 * WidthCoefficient);
    }];
    
}

- (void)configWithCommodity:(StoreCommodity *)commodity {
    if (commodity.choosePriceType == 1) {
        _promotion.hidden = YES;
    } else {
        _promotion.hidden = NO;
    }
    [self.imgV downloadImage:[commodity.thumbnail isNotBlank] ? commodity.thumbnail:commodity.picImages[0] placeholder:[UIImage imageNamed:@"加载中小"] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        _imgV.image = [UIImage imageNamed:@"加载失败小"];
    } received:^(CGFloat progress) {
        
    }];
    self.titleLabel.text = commodity.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",commodity.salePrice];
}

- (void)btnClick:(UIButton *)sender {
    if (self.buyBtnClick) {
        self.buyBtnClick(sender);
    }
}

@end
