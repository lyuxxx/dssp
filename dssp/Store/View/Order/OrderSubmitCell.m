//
//  OrderSubmitCell.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderSubmitCell.h"
#import <YYLabel.h>
#import <UIImageView+SDWebImage.h>
#import "StoreObject.h"

@interface OrderSubmitCell ()
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) YYLabel *name;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *count;
@end

@implementation OrderSubmitCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    OrderSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderSubmitCell"];
    return cell;
}

+ (CGFloat)cellHeight {
    return 110 * WidthCoefficient;
}

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
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    bg.layer.cornerRadius = 4;
    [self.contentView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(100 * WidthCoefficient);
        make.edges.equalTo(UIEdgeInsetsMake(5 * WidthCoefficient, 16 * WidthCoefficient, 5 * WidthCoefficient, 16 * WidthCoefficient));
    }];
    
    self.imgV = [[UIImageView alloc] init];
    [bg addSubview:_imgV];
    [_imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(80 * WidthCoefficient);
        make.centerY.equalTo(bg);
        make.left.equalTo(10 * WidthCoefficient);
    }];
    
    self.name = [[YYLabel alloc] init];
    _name.numberOfLines = 0;
    _name.font = [UIFont fontWithName:FontName size:15];
    _name.textColor = [UIColor whiteColor];
    _name.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _name.textAlignment = NSTextAlignmentLeft;
    [bg addSubview:_name];
    [_name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.right).offset(10 * WidthCoefficient);
        make.width.equalTo(233 * WidthCoefficient);
        make.height.equalTo(45 * WidthCoefficient);
        make.top.equalTo(_imgV);
    }];
    
    self.price = [[UILabel alloc] init];
    _price.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    _price.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [bg addSubview:_price];
    [_price makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(150 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(_name);
        make.bottom.equalTo(_imgV);
    }];
    
    self.count = [[UILabel alloc] init];
    _count.textAlignment = NSTextAlignmentRight;
    _count.font = [UIFont fontWithName:FontName size:13];
    _count.textColor = [UIColor colorWithHexString:@"#999999"];
    [bg addSubview:_count];
    [_count makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(65 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.bottom.equalTo(_imgV);
        make.right.equalTo(-10 * WidthCoefficient);
    }];
}

- (void)configWithCommodity:(StoreCommodity *)commodity {
    [self.imgV downloadImage:commodity.image placeholder:[UIImage imageNamed:@"加载中小"] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        _imgV.image = [UIImage imageNamed:@"加载失败小"];
    } received:^(CGFloat progress) {
        
    }];
    
    self.name.text = commodity.title;
    self.price.text = [NSString stringWithFormat:@"￥%@",commodity.salePrice];
//    self.count.text = [NSString stringWithFormat:@"×%ld",commodity.num];
    self.count.text = @"×1";
}

@end
