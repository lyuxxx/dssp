//
//  OrderDetailViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderObject.h"
#import <YYText.h>
#import <UIImageView+SDWebImage.h>
#import "OrderPayViewController.h"
#import "InvoicePageController.h"
#import "EvaluateViewController.h"
#import "InputAlertView.h"

@interface OrderDetailViewController ()
@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) Order *orderDetail;

@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *stateImgV;
@property (nonatomic, strong) YYLabel *descriptionLabel;
@property (nonatomic, strong) YYLabel *priceLabel;

@property (nonatomic, strong) UIView *botV;
@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;
@end

@implementation OrderDetailViewController

- (BOOL)needGradientBg {
    if (Is_Iphone_X) {
        return NO;
    }
    return YES;
}

- (instancetype)initWithOrder:(Order *)order {
    self = [super init];
    if (self) {
        self.order = order;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)setupUI {
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    topV.layer.cornerRadius = 4;
    topV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    topV.layer.shadowOffset = CGSizeMake(0, 6);
    topV.layer.shadowRadius = 7;
    topV.layer.shadowOpacity = 0.5;
    [self.view addSubview:topV];
    [topV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(70 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    NSArray *topTitles = @[NSLocalizedString(@"订单编号:", nil),NSLocalizedString(@"创建时间:", nil)];
    for (NSInteger i = 0; i < topTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor whiteColor];
        label0.text = topTitles[i];
        [topV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo((10 + 30 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor whiteColor];
        [topV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
        
        if (i == 0) {
            self.orderNoLabel = label1;
        } else if (i == 1) {
            self.createTimeLabel = label1;
        }
    }
    
    self.stateLabel = [[UILabel alloc] init];
    _stateLabel.font = [UIFont fontWithName:FontName size:14];
    _stateLabel.textAlignment = NSTextAlignmentRight;
    [topV addSubview:_stateLabel];
    [_stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20 * WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    UIView *midV = [[UIView alloc] init];
    midV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    midV.layer.cornerRadius = 4;
    midV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    midV.layer.shadowOffset = CGSizeMake(0, 6);
    midV.layer.shadowRadius = 7;
    midV.layer.shadowOpacity = 0.5;
    [self.view addSubview:midV];
    [midV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(142 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(topV.bottom).offset(5 * WidthCoefficient);
    }];
    
    self.avatar = [[UIImageView alloc] init];
    _avatar.layer.cornerRadius = 4;
    _avatar.layer.masksToBounds = YES;
    [midV addSubview:_avatar];
    [_avatar makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(80 * WidthCoefficient);
        make.left.top.equalTo(10 * WidthCoefficient);
    }];
    
    self.stateImgV = [[UIImageView alloc] init];
    [_avatar addSubview:_stateImgV];
    [_stateImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_avatar);
    }];
    
    self.descriptionLabel = [[YYLabel alloc] init];
    _descriptionLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.font = [UIFont fontWithName:FontName size:15];
    _descriptionLabel.textColor = [UIColor whiteColor];
    [midV addSubview:_descriptionLabel];
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(233 * WidthCoefficient);
        make.top.bottom.equalTo(_avatar);
        make.left.equalTo(_avatar.right).offset(10 * WidthCoefficient);
    }];
    
    UIView *line0 = [[UIView alloc] init];
    line0.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [midV addSubview:line0];
    [line0 makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(midV);
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(_avatar.bottom).offset(10 * WidthCoefficient);
    }];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"总计价格:¥100.00"];
    text.yy_font = [UIFont fontWithName:FontName size:15];
    text.yy_color = [UIColor colorWithHexString:@"#999999"];
    NSRange range = [@"总计价格:¥100.00" rangeOfString:@"¥100.00"];
    [text yy_setColor:[UIColor colorWithHexString:@"#ac0042"] range:range];
    [text yy_setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] range:range];
    self.priceLabel = [[YYLabel alloc] init];
    _priceLabel.attributedText = text;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [midV addSubview:_priceLabel];
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20 * WidthCoefficient);
        make.top.equalTo(line0.bottom).offset(10 * WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.width.equalTo(kScreenWidth/2);
    }];
    
    UIView *botV = [[UIView alloc] init];
    self.botV = botV;
    botV.layer.masksToBounds = YES;
    botV.backgroundColor = [UIColor colorWithHexString:@"0e0c0c"];
    if (Is_Iphone_X) {
        botV.layer.cornerRadius = 4;
        botV.layer.shadowOffset = CGSizeMake(0, -5);
        botV.layer.shadowColor = [UIColor colorWithHexString:@"#040000"].CGColor;
        botV.layer.shadowRadius = 15;
        botV.layer.shadowOpacity = 0.7;
    }
    [self.view addSubview:botV];
    [botV makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(49 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(-kBottomHeight);
        if (Is_Iphone_X) {
            make.width.equalTo(343 * WidthCoefficient);
        } else {
            make.width.equalTo(kScreenWidth);
        }
    }];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn1.titleLabel.font = [UIFont fontWithName:FontName size:12];
    _btn1.layer.cornerRadius = 14 * WidthCoefficient;
    _btn1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    _btn1.layer.borderWidth = 0.5;
    _btn1.layer.masksToBounds = YES;
    [botV addSubview:_btn1];
    [_btn1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(86 * WidthCoefficient);
        make.height.equalTo(28 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.centerY.equalTo(botV);
    }];
    
    self.btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn0 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _btn0.titleLabel.font = [UIFont fontWithName:FontName size:12];
    _btn0.layer.cornerRadius = 14 * WidthCoefficient;
    _btn0.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    _btn0.layer.borderWidth = 0.5;
    _btn0.layer.masksToBounds = YES;
    [botV addSubview:_btn0];
    [_btn0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(_btn1);
        make.right.equalTo(_btn1.left).offset(-10 * WidthCoefficient);
    }];
    
}

- (void)pullData {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:getOrderDetail parameters:@{@"orderNo":self.order.orderNo} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            OrderDetailResponse *response = [OrderDetailResponse yy_modelWithJSON:dic];
            self.orderDetail = response.data;
            [hud hideAnimated:YES];
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (sender == _btn0) {//第一个按钮
        if (_order.status == 0) {//待付款
            InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [InputalertView initWithTitle:@"是否确定取消订单" img:@"cancelOrder" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否",nil] ];
            //            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: InputalertView];
            
            InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                if (btn.tag == 100) {//左边按钮
                    [self cancelOrderWithOrderNo:_orderDetail.orderNo];
                }
                if(btn.tag ==101)
                {
                    //右边按钮
                    
                }
                
            };
        }
        if (_order.status == 2) {//待评价
            InvoicePageController *vc = [[InvoicePageController alloc] initWithOrderId:[NSString stringWithFormat:@"%ld",self.orderDetail.orderId]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender == _btn1) {//第二个按钮
        if (_order.status == 0) {//待付款
            OrderPayViewController *vc = [[OrderPayViewController alloc] initWithOrder:_orderDetail];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (_order.status == 2) {//待评价
            EvaluateViewController *vc = [[EvaluateViewController alloc] initWithOrder:self.orderDetail];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)cancelOrderWithOrderNo:(NSString *)orderNo {
    [Statistics staticsstayTimeDataWithType:@"3" WithController:@"ClickEventCancel"];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:cancelOrderURL parameters:@{@"orderNo":orderNo} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            hud.label.text = NSLocalizedString(@"取消成功", nil);
            [hud hideAnimated:YES afterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pullData];
            });
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)setOrderDetail:(Order *)order {
    _orderDetail = order;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    self.orderNoLabel.text = order.orderNo;
    self.createTimeLabel.text = [formatter stringFromDate:order.createTime];
    if (order.status == 0) {
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
        self.stateLabel.text = NSLocalizedString(@"待付款", nil);
    } else if (order.status == 1) {
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        self.stateLabel.text = NSLocalizedString(@"已付款", nil);
    } else if (order.status == 2) {
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        self.stateLabel.text = NSLocalizedString(@"已完成", nil);
    } else if (order.status == 3) {
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        self.stateLabel.text = NSLocalizedString(@"已取消", nil);
    }
    
    [self.avatar downloadImage:order.items[0].thumbnail?order.items[0].thumbnail:order.items[0].picImages[0] placeholder:[UIImage imageNamed:@"加载中小"] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        _avatar.image = [UIImage imageNamed:@"加载失败小"];
    } received:^(CGFloat progress) {
        
    }];
    
    if (order.status == 2) {
        self.stateImgV.image = [UIImage imageNamed:@"OrderComplete"];
    } else if (order.status == 3) {
        self.stateImgV.image = [UIImage imageNamed:@"OrderCancel"];
    } else {
        self.stateImgV.image = nil;
    }
    
    self.descriptionLabel.text = order.items[0].title;
    
    if (order.status == 3) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"", nil)];
        text.yy_font = [UIFont fontWithName:FontName size:15];
        text.yy_color = [UIColor colorWithHexString:@"#999999"];
        self.priceLabel.attributedText = text;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    } else {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计价格:¥%@",order.payment]];
        text.yy_font = [UIFont fontWithName:FontName size:15];
        text.yy_color = [UIColor colorWithHexString:@"#999999"];
        NSRange range = [[NSString stringWithFormat:@"总计价格:¥%@",order.payment] rangeOfString:order.payment];
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
        [self.btn0 setTitle:NSLocalizedString(@"索要发票", nil) forState:UIControlStateNormal];
        [self.btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn1 setTitle:NSLocalizedString(@"去评价", nil) forState:UIControlStateNormal];
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    }
    
    if (order.status == 2 && order.haveInvoice) {
        self.btn0.hidden = YES;
    } else {
        self.btn0.hidden = NO;
    }
    
    if (order.status == 1 || order.status == 3) {
        self.botV.hidden = YES;
    } else {
        self.botV.hidden = NO;
    }
}

@end
