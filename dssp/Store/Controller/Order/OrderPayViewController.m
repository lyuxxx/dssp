//
//  OrderPayViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderPayViewController.h"
#import "OrderObject.h"
#import <CUPayTool.h>
#import <AFNetworking.h>
typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeWeChatPay,
    PayTypeAlipay,
};
@interface OrderPayViewController ()
@property (nonatomic, assign) PayType payType;
@property (nonatomic, strong) UIImageView *weChatState;
@property (nonatomic, strong) UIImageView *alipayState;
@property (nonatomic, strong) Order *order;
@end

@implementation OrderPayViewController

- (instancetype)initWithOrder:(Order *)order {
    self = [super init];
    if (self) {
        self.order = order;
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
    NSArray *subtitles = @[@"",@"微信安全支付",@"支付宝安全支付"];
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
    [payBtn setTitle:[NSString stringWithFormat:@"支付%.2f元",self.order.payment.floatValue] forState:UIControlStateNormal];
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
    if (self.payType == PayTypeAlipay) {
        [self aliPayFunc];
    }
}

- (void)wechatPayFunc
{
    //先获取微信支付参数
    //...
    
    CUPayTool *manager = [CUPayTool getInstance];
    [manager wechatPayWithAppId:@"" partnerId:@"" prepayId:@"" package:@"" nonceStr:@"" timeStamp:@"" sign:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)aliPayFunc
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    //先获取支付宝支付参数
    PayMessage *message = [[PayMessage alloc] init];
    message.orderNo = _order.orderNo;
    message.productId = [NSString stringWithFormat:@"%ld",_order.items[0].itemId];
    message.totalFee = [NSNumber numberWithFloat:_order.payment.floatValue];
    message.subject = [NSString stringWithFormat:@"capsa在线商城#%@#",_order.orderNo];
    message.body = _order.items[0].title;
    message.tradeType = @"APP";
    message.payType = @"ALIPAY";
    message.channel = @"APP";
    message.timeOut = @"90";
    message.vin = [[NSUserDefaults standardUserDefaults] objectForKey:@"vin"];
    
    PayRequest *request = [[PayRequest alloc] init];
    request.appId = @"dssp";
    request.userId = [NSString stringWithFormat:@"%ld",((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]).integerValue];
    request.protocolId = @"ALIPAY020504";
    request.thirdInfoId = @"7";
    request.t = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970]];
    
    NSDictionary *msgDic = [message yy_modelToJSONObject];
    
    NSString *msgStr = [self stringWithDict:msgDic];
    
    NSMutableString *info = [NSMutableString string];
    [info appendString:[NSString stringWithFormat:@"appId=%@",request.appId]];
    
    [info appendString:[NSString stringWithFormat:@"&message={\"message\":%@}",msgStr]];
    [info appendString:[NSString stringWithFormat:@"&protocolId=%@",request.protocolId]];
    [info appendString:[NSString stringWithFormat:@"&t=%@",request.t]];
    [info appendString:[NSString stringWithFormat:@"&thirdInfoId=%@",request.thirdInfoId]];
    [info appendString:[NSString stringWithFormat:@"&userId=%@",request.userId]];
    [info appendString:[NSString stringWithFormat:@"&appKey=ce54960341d675de1910d8f894216ae5"]];
    
    NSString *infoMD5 = [info md5String];
    
    request.h = infoMD5;
    request.message = [NSString stringWithFormat:@"{\"message\":%@}",msgStr];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appCreatePay] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"token"];
    
    [urlRequest setHTTPBody:[[NSString stringWithFormat:@"appId=%@&userId=%@&protocolId=%@&thirdInfoId=%@&t=%@&h=%@&message=%@",request.appId,request.userId,request.protocolId,request.thirdInfoId,request.t,request.h,request.message] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        NSString *returnCode = dic[@"message"][@"returnCode"];
        if ([returnCode isEqualToString:@"SUCCESS"]) {
            NSString *orderInfo = dic[@"message"][@"orderInfo"];
            CUPayTool *manager = [CUPayTool getInstance];
            [manager aliPayOrder:orderInfo scheme:@"dssp" respBlock:^(NSInteger respCode, NSString *respMsg) {
                
                //处理支付结果
                
                if (respCode == 0) {
                    hud.label.text = respMsg;
                    [hud hideAnimated:YES afterDelay:1];
                } else if (respCode == -1) {
                    hud.label.text = respMsg;
                    [hud hideAnimated:YES afterDelay:1];
                } else if (respCode == -2) {
                    hud.label.text = respMsg;
                    [hud hideAnimated:YES afterDelay:1];
                } else if (respCode == -99) {
                    hud.label.text = respMsg;
                    [hud hideAnimated:YES afterDelay:1];
                }

            }];
        } else if ([returnCode isEqualToString:@"FAIL"]) {
            hud.label.text = dic[@"message"][@"returnMsg"];
            [hud hideAnimated:YES afterDelay:1];
        } else {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSInteger statusCode = [res statusCode];
            hud.label.text = [NSString stringWithFormat:@"%ld",statusCode];
            [hud hideAnimated:YES afterDelay:1];
        }
    }] resume];
    
}

- (NSString *)stringWithDict:(NSDictionary *)dic{
    NSArray *allKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *jsonStr = [NSMutableString string];
    if (dic && dic.count > 0) {
        [jsonStr appendString:@"{"];
        for (NSString *key in allKeys) {
            [jsonStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",", key, dic[key]]];
        }
        [jsonStr replaceCharactersInRange:NSMakeRange(jsonStr.length - 1, 1) withString:@"}"];
    }else{
        [jsonStr appendString:@"{}"];
    }
    return jsonStr;
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
