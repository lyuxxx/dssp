//
//  OrderPayViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderPayViewController.h"
#import <CUPayTool.h>
typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeWeChatPay,
    PayTypeAlipay,
};
@interface OrderPayViewController ()
@property (nonatomic, assign) PayType payType;
@property (nonatomic, strong) UIImageView *weChatState;
@property (nonatomic, strong) UIImageView *alipayState;
@property (nonatomic, assign) float price;
@end

@implementation OrderPayViewController

- (instancetype)initWithPrice:(float)price {
    self = [super init];
    if (self) {
        self.price = price;
    }
    return self;
}

- (BOOL)needGradientBg {
    if (Is_Iphone_X) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"订单支付", nil);
    
    UIView *bg = [[UIView alloc] init];
    bg.layer.cornerRadius = 4;
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    [self.view addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(200 * HeightCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    NSArray *ys = @[@0,@(60 * HeightCoefficient),@(130 * HeightCoefficient)];
    NSArray *hs = @[@(60 * HeightCoefficient),@(70 * HeightCoefficient),@(70 * HeightCoefficient)];
    NSArray *categories = @[@"",@"WeChatPay_icon",@"Alipay_icon"];
    NSArray *titles = @[@"",@"微信支付",@"支付宝支付"];
    NSArray *subtitles = @[@"",@"支付宝支付",@"支付宝安全支付"];
    NSArray *imgs = @[@"",@"pay_selected",@"pay_normal"];
    
    for (NSInteger i = 0; i < 3 ; i++) {
        UIView *view = [[UIView alloc] init];
        view.tag = 100 + i;
        [bg addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(bg);
            make.height.equalTo(hs[i]);
            make.centerX.equalTo(bg);
            make.top.equalTo(ys[i]);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
        [bg addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(323 * WidthCoefficient);
            make.height.equalTo(1 * WidthCoefficient);
            make.centerX.equalTo(bg);
            make.bottom.equalTo(view);
        }];
        if (i == 0) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithHexString:GeneralColorString];
            label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = NSLocalizedString(@"请选择支付方式", nil);
            [view addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        } else {
            UIImageView *imgV = [[UIImageView alloc] init];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            imgV.image = [UIImage imageNamed:categories[i]];
            [view addSubview:imgV];
            [imgV makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(32 * WidthCoefficient);
                make.centerY.equalTo(view);
                make.left.equalTo(10 * WidthCoefficient);
            }];
            
            UILabel *title = [[UILabel alloc] init];
            title.text = titles[i];
            title.textColor = [UIColor whiteColor];
            title.font = [UIFont fontWithName:FontName size:15];
            [view addSubview:title];
            [title makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(100 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.top.equalTo(15 * HeightCoefficient);
                make.left.equalTo(imgV.right).offset(15 * WidthCoefficient);
            }];
            
            UILabel *subtitle = [[UILabel alloc] init];
            subtitle.text = subtitles[i];
            subtitle.textColor = [UIColor colorWithHexString:@"#999999"];
            subtitle.font = [UIFont fontWithName:FontName size:13];
            [view addSubview:subtitle];
            [subtitle makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(100 * WidthCoefficient);
                make.height.equalTo(20 * HeightCoefficient);
                make.top.equalTo(title.bottom);
                make.left.equalTo(title);
            }];
            
            UIImageView *state = [[UIImageView alloc] init];
            state.image = [UIImage imageNamed:imgs[i]];
            [view addSubview:state];
            [state makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(22 * WidthCoefficient);
                make.centerY.equalTo(view);
                make.right.equalTo(view).offset(-10 * WidthCoefficient);
            }];
            if (i == 1) {
                self.weChatState = state;
            } else if (i == 2) {
                self.alipayState = state;
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapWithSender:)];
            [view addGestureRecognizer:tap];
            
        }
    }
    self.payType = PayTypeWeChatPay;
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [payBtn setTitle:[NSString stringWithFormat:@"支付%.2f元",self.price] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    payBtn.frame = CGRectMake(0, kScreenHeight - kNaviHeight - kBottomHeight - 49 * WidthCoefficient, kScreenWidth, 49 * WidthCoefficient);
    payBtn.frame = CGRectMake(16 * WidthCoefficient, kScreenHeight - kNaviHeight - kBottomHeight - 49 * WidthCoefficient, 343 * WidthCoefficient, 49 * WidthCoefficient);
    if (Is_Iphone_X) {
        payBtn.layer.cornerRadius = 4;
        payBtn.layer.shadowOffset = CGSizeMake(0, -5);
        payBtn.layer.shadowColor = [UIColor colorWithHexString:@"#040000"].CGColor;
        payBtn.layer.shadowRadius = 15;
        payBtn.layer.shadowOpacity = 0.7;
    }
    [self.view addSubview:payBtn];
    [payBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(49 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(-kBottomHeight);
        if (Is_Iphone_X) {
            make.width.equalTo(343 * WidthCoefficient);
        } else {
            make.width.equalTo(kScreenWidth);
        }
    }];
}

- (void)payBtnClick:(UIButton *)sender {
    
}

- (void)didTapWithSender:(UITapGestureRecognizer *)sender {
    if (sender.view.tag == 101) {//WeChatPay
        self.payType = PayTypeWeChatPay;
    }
    if (sender.view.tag == 102) {//Alipay
        self.payType = PayTypeAlipay;
    }
}

- (void)setPayType:(PayType)payType {
    _payType = payType;
    if (_payType == PayTypeWeChatPay) {
        self.weChatState.image = [UIImage imageNamed:@"pay_selected"];
        self.alipayState.image = [UIImage imageNamed:@"pay_normal"];
    }
    if (_payType == PayTypeAlipay) {
        self.weChatState.image = [UIImage imageNamed:@"pay_normal"];
        self.alipayState.image = [UIImage imageNamed:@"pay_selected"];
    }
}

@end
