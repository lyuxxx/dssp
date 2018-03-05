//
//  PayCompleteViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "PayCompleteViewController.h"
#import <UIViewController+RTRootNavigationController.h>
#import "OrderObject.h"

typedef NS_ENUM(NSUInteger, PayState) {
    PayStateOK,
    PayStateFail
};

@interface PayCompleteViewController ()

@property (nonatomic, strong) PayRequest *payRequest;
@property (nonatomic, assign) PayState payState;

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIImageView *stateImgV;

@property (nonatomic, strong) UIView *okMidV;
@property (nonatomic, strong) UIView *failMidV;

@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UILabel *paymentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *botBtn;
@end

@implementation PayCompleteViewController

- (instancetype)initWithPayRequest:(PayRequest *)payRequest {
    self = [super init];
    if (self) {
        _payRequest = payRequest;
    }
    return self;
}

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"交易状态", nil);
    self.rt_disableInteractivePop = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(24 * WidthCoefficient);
    }];
    self.navigationItem.leftBarButtonItem = left;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkOrderInfo];
}

//- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
//    return [[UIBarButtonItem alloc] initWithCustomView:btn];
//}

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
        make.height.equalTo(147.5 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UILabel *okLabel = [[UILabel alloc] init];
    self.stateLabel = okLabel;
    okLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    okLabel.textColor = [UIColor whiteColor];
    okLabel.textAlignment = NSTextAlignmentCenter;
    okLabel.text = NSLocalizedString(@"交易成功", nil);
    [topV addSubview:okLabel];
    [okLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(15 * WidthCoefficient);
        make.height.equalTo(22.5 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    self.stateImgV = imgV;
    imgV.image = [UIImage imageNamed:@"payOK"];
    [topV addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(80 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(okLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    UIView *midV = [[UIView alloc] init];
    self.okMidV = midV;
    midV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    midV.layer.cornerRadius = 4;
    midV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    midV.layer.shadowOffset = CGSizeMake(0, 6);
    midV.layer.shadowRadius = 7;
    midV.layer.shadowOpacity = 0.5;
    [self.view addSubview:midV];
    [midV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(100 * WidthCoefficient);
        make.top.equalTo(topV.bottom).offset(10 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    NSArray *midTitles = @[NSLocalizedString(@"订单编号:", nil),NSLocalizedString(@"支付金额:", nil),NSLocalizedString(@"交易时间:", nil)];
    for (NSInteger i = 0; i < midTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor whiteColor];
        label0.text = midTitles[i];
        [midV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(10 * WidthCoefficient);
            make.top.equalTo((10 + 30 * i) * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor whiteColor];
        [midV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
        
        if (i == 0) {
            self.orderNoLabel = label1;
        } else if (i == 1) {
            self.paymentLabel = label1;
        } else if (i == 2) {
            self.timeLabel = label1;
        }
    }
    
    UIView *midV1 = [[UIView alloc] init];
    midV1.hidden = YES;
    self.failMidV = midV1;
    midV1.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    midV1.layer.cornerRadius = 4;
    midV1.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    midV1.layer.shadowOffset = CGSizeMake(0, 6);
    midV1.layer.shadowRadius = 7;
    midV1.layer.shadowOpacity = 0.5;
    [self.view addSubview:midV1];
    [midV1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(70 * WidthCoefficient);
        make.top.equalTo(topV.bottom).offset(10 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UILabel *failLabel = [[UILabel alloc] init];
    failLabel.numberOfLines = 2;
    failLabel.font = [UIFont fontWithName:FontName size:14];
    failLabel.textColor = [UIColor whiteColor];
    failLabel.text = NSLocalizedString(@"请五分钟之后再次查询订单状态，如依然失败请联系客服咨询", nil);
    [midV1 addSubview:failLabel];
    [failLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(40 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UIButton *botBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.botBtn = botBtn;
    [botBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    botBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    botBtn.layer.cornerRadius = 4;
    botBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [botBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
    [botBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:botBtn];
    [botBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * WidthCoefficient);
        make.top.equalTo(self.okMidV.bottom).offset(24 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    self.payState = _payState;
}

- (void)setPayState:(PayState)payState {
    _payState = payState;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_payState == PayStateOK) {
            self.stateLabel.text = NSLocalizedString(@"交易成功", nil);
            self.stateImgV.image = [UIImage imageNamed:@"payOK"];
            self.okMidV.hidden = NO;
            self.failMidV.hidden = YES;
            _botBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
            [_botBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
            [_botBtn updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.okMidV.bottom).offset(24 * WidthCoefficient);
            }];
        } else {
            self.stateLabel.text = NSLocalizedString(@"交易失败", nil);
            self.stateImgV.image = [UIImage imageNamed:@"payFail"];
            self.okMidV.hidden = YES;
            self.failMidV.hidden = NO;
            _botBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
            [_botBtn setTitle:NSLocalizedString(@"返回首页", nil) forState:UIControlStateNormal];
            [_botBtn updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.failMidV.bottom).offset(24 * WidthCoefficient);
            }];
        }
    });
}

- (void)checkOrderInfo {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:payOrderQuery] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    [urlRequest setHTTPBody:[[NSString stringWithFormat:@"thirdInfoId=%@&message=%@&t=%@&h=%@",_payRequest.thirdInfoId,_payRequest.message,_payRequest.t,_payRequest.h] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *inerror;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&inerror];
        NSLog(@"%@",dic);
        if (dic[@"message"]) {
            if ([dic[@"message"][@"returnCode"] isEqualToString:@"SUCCESS"]) {
                NSString *tradeState = dic[@"message"][@"tradeState"];
                if ([tradeState isEqualToString:@"TRADE_SUCCESS"]) {
                    self.payState = PayStateOK;
                    NSString *orderNo = dic[@"message"][@"orderNo"];
                    NSString *totalFee = dic[@"message"][@"totalFee"];
                    NSString *tradeTime = dic[@"message"][@"tradeTime"];
                    
                    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
                    formatter0.dateFormat = @"yyyyMMddHHmmss";
                    formatter0.timeZone = [NSTimeZone localTimeZone];
                    
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    formatter1.dateFormat = @"yyyy/MM/dd HH:mm:ss";
                    formatter1.timeZone = [NSTimeZone localTimeZone];
                    NSDate *date = [formatter0 dateFromString:tradeTime];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.orderNoLabel.text = orderNo;
                        self.paymentLabel.text = [NSString stringWithFormat:@"¥%@",totalFee];
                        self.timeLabel.text = [formatter1 stringFromDate:date];
                    });
                    
                } else {
                    self.payState = PayStateFail;
                }
            } else if ([dic[@"message"][@"returnCode"] isEqualToString:@"FAIL"]) {
                self.payState = PayStateFail;
            }
        } else {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSInteger statusCode = [res statusCode];
        }
    }] resume];
}

//底下按钮
- (void)btnClick:(UIButton *)sender {
    [self backToHome];
}

- (void)backToHome {
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:NSClassFromString(@"StoreTabViewController")]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

@end
