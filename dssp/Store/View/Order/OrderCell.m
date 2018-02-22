//
//  OrderCell.m
//  dssp
//
//  Created by yxliu on 2018/2/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderCell.h"
#import <YYText.h>
#import <UIImageView+SDWebImage.h>
#import "OrderObject.h"

@interface OrderCell ()
@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *stateImgV;
@property (nonatomic, strong) YYLabel *descriptionLabel;
@property (nonatomic, strong) YYLabel *priceLabel;
@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, strong) Order *order;
@property (nonatomic, copy) OrderActionBlock orderActionBlock;
@end

@implementation OrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView action:(OrderActionBlock)block {
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
    cell.orderActionBlock = block;
    return cell;
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
    
    self.bgV = [[UIView alloc] init];
    _bgV.layer.masksToBounds = YES;
    _bgV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    [self.contentView addSubview:_bgV];
    [_bgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(5 * WidthCoefficient, 16 * WidthCoefficient, 5 * WidthCoefficient, 16 * WidthCoefficient));
        make.width.equalTo(343 * WidthCoefficient);
        make.top.equalTo(self.contentView).offset(5 * WidthCoefficient);
    }];
    
    self.avatar = [[UIImageView alloc] init];
    [_bgV addSubview:_avatar];
    [_avatar makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(80 * WidthCoefficient);
        make.left.top.equalTo(10 * WidthCoefficient);
    }];
    
    self.stateImgV = [[UIImageView alloc] init];
    [_bgV addSubview:_stateImgV];
    [_stateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_avatar);
    }];
    
    self.descriptionLabel = [[YYLabel alloc] init];
    _descriptionLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.font = [UIFont fontWithName:FontName size:15];
    _descriptionLabel.textColor = [UIColor whiteColor];
    [_bgV addSubview:_descriptionLabel];
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(233 * WidthCoefficient);
        make.top.bottom.equalTo(_avatar);
        make.left.equalTo(_avatar.right).offset(10 * WidthCoefficient);
    }];
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [_bgV addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgV);
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(_avatar.bottom).offset(10 * WidthCoefficient);
    }];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"总计价格:￥100.00"];
    text.yy_font = [UIFont fontWithName:FontName size:15];
    text.yy_color = [UIColor colorWithHexString:@"#999999"];
    NSRange range = [@"总计价格:￥100.00" rangeOfString:@"￥100.00"];
    [text yy_setColor:[UIColor colorWithHexString:@"#ac0042"] range:range];
    [text yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
    self.priceLabel = [[YYLabel alloc] init];
    _priceLabel.attributedText = text;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [_bgV addSubview:_priceLabel];
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20 * WidthCoefficient);
        make.top.equalTo(line0.bottom).offset(10 * WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.width.equalTo(kScreenWidth/2);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [_bgV addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgV);
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(_priceLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn1.titleLabel.font = [UIFont fontWithName:FontName size:12];
    _btn1.layer.cornerRadius = 14 * WidthCoefficient;
    _btn1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    _btn1.layer.borderWidth = 0.5;
    _btn1.layer.masksToBounds = YES;
    [_bgV addSubview:_btn1];
    [_btn1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(86 * WidthCoefficient);
        make.height.equalTo(28 * WidthCoefficient);
        make.top.equalTo(line1.bottom).offset(15 * WidthCoefficient);
        make.right.equalTo(line1);
    }];
    
    self.btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn0 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn0.titleLabel.font = [UIFont fontWithName:FontName size:12];
    _btn0.layer.cornerRadius = 14 * WidthCoefficient;
    _btn0.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    _btn0.layer.borderWidth = 0.5;
    _btn0.layer.masksToBounds = YES;
    [_bgV addSubview:_btn0];
    [_btn0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(_btn1);
        make.right.equalTo(_btn1.left).offset(-5 * WidthCoefficient);
    }];
    
    [_bgV makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceLabel.bottom).offset(69 * WidthCoefficient);
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (sender == _btn0) {//第一个按钮
        if (_order.status == 0) {//待付款
            self.orderActionBlock(OrderActionCancel);
        }
        if (_order.status == 2) {//待评价
            self.orderActionBlock(OrderActionEvaluate);
        }
    }
    if (sender == _btn1) {//第二个按钮
        if (_order.status == 0) {//待付款
            self.orderActionBlock(OrderActionPay);
        }
        if (_order.status == 2) {//待评价
            self.orderActionBlock(OrderActionInvoice);
        }
    }
}

- (void)configWithOrder:(Order *)order {
    self.order = order;
    [self.avatar downloadImage:order.items[0].picPath placeholder:[UIImage imageNamed:@""] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        
    } received:^(CGFloat progress) {
        
    }];
    
    self.descriptionLabel.text = order.items[0].title;
    
    if (order.status == 3) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"已取消", nil)];
        text.yy_font = [UIFont fontWithName:FontName size:15];
        text.yy_color = [UIColor colorWithHexString:@"#999999"];
        self.priceLabel.attributedText = text;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    } else {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计价格:￥%@",order.payment]];
        text.yy_font = [UIFont fontWithName:FontName size:15];
        text.yy_color = [UIColor colorWithHexString:@"#999999"];
        NSRange range = [[NSString stringWithFormat:@"总计价格:￥%@",order.payment] rangeOfString:order.payment];
        if (order.status == 1) {
            [text yy_setColor:[UIColor colorWithHexString:@"#999999"] range:range];
        } else {
            [text yy_setColor:[UIColor colorWithHexString:@"#ac0042"] range:range];
        }
        [text yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
        self.priceLabel.attributedText = text;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    
    if (order.status == 0) {
        [self.btn0 setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [self.btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn1 setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
        self.btn1.layer.borderColor = [UIColor colorWithHexString:GeneralColorString].CGColor;
    } else if (order.status == 2) {
        [self.btn0 setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        [self.btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn1 setTitle:NSLocalizedString(@"索要发票", nil) forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }
    
    if (order.status == 1 || order.status == 3) {
        [_bgV updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_priceLabel.bottom).offset(10 * WidthCoefficient);
        }];
    } else {
        [_bgV updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_priceLabel.bottom).offset(69 * WidthCoefficient);
        }];
    }
    
}

+ (CGFloat)cellHeightWithOrder:(Order *)order {
    if (order.status == 1 || order.status == 3) {
        return 151 * WidthCoefficient;
    }
    return 210 * WidthCoefficient;
}

@end
