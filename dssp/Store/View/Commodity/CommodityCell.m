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
    
    self.imgV = [[UIImageView alloc] init];
    _imgV.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_imgV];
    [_imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(114.5 * WidthCoefficient);
        make.height.equalTo(115 * WidthCoefficient);
        make.left.top.right.equalTo(self.contentView);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"基础流量包基础流量包";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:FontName size:13];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.preferredMaxLayoutWidth = 104.5 * WidthCoefficient;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(104.5 * WidthCoefficient);
        make.height.equalTo(40 * WidthCoefficient);
        make.top.equalTo(_imgV.bottom).offset(5 * WidthCoefficient);
        make.centerX.equalTo(self.contentView);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    _priceLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
    _priceLabel.text = @"￥200";
    [self.contentView addSubview:_priceLabel];
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(5 * WidthCoefficient);
        make.top.equalTo(_titleLabel.bottom).offset(10 * WidthCoefficient);
        make.bottom.equalTo(-5 * WidthCoefficient);
    }];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBtn setTitle:NSLocalizedString(@"购买", nil) forState:UIControlStateNormal];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    _buyBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    _buyBtn.layer.cornerRadius = 9 * WidthCoefficient;
    _buyBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_buyBtn];
    [_buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(45 * WidthCoefficient);
        make.height.equalTo(18 * WidthCoefficient);
        make.centerY.equalTo(_priceLabel);
        make.right.equalTo(-5 * WidthCoefficient);
    }];
    
}

- (void)configWithCommodity:(StoreCommodity *)commodity {
    [self.imgV downloadImage:commodity.image placeholder:[UIImage imageNamed:@""] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        
    } received:^(CGFloat progress) {
        
    }];
    self.titleLabel.text = commodity.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",commodity.price];
}

- (void)btnClick:(UIButton *)sender {
    if (self.buyBtnClick) {
        self.buyBtnClick(sender);
    }
}

@end
