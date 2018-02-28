//
//  EvaluateViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "EvaluateViewController.h"
#import "YYStarView.h"
#import <YYLabel.h>
#import "UITextView+Placeholder.h"
#import "OrderObject.h"
#import <UIImageView+SDWebImage.h>

@interface EvaluateViewController () <YYStarViewDelegate>
@property (nonatomic, strong) YYStarView *starView;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) Order *order;
@end

@implementation EvaluateViewController

- (instancetype)initWithOrder:(Order *)order {
    self = [super init];
    if (self) {
        self.order = order;
    }
    return self;
}

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    
    self.navigationItem.title = NSLocalizedString(@"评价", nil);
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 343 * WidthCoefficient, 146 * WidthCoefficient)];
    top.center = CGPointMake(kScreenWidth / 2, 83 * WidthCoefficient);
    top.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    top.layer.cornerRadius = 2;
    [self.view addSubview:top];
    
    self.starView = [[YYStarView alloc] initWithFrame:CGRectMake(92 * WidthCoefficient, 20 * WidthCoefficient, 160 * WidthCoefficient, 24.75 * WidthCoefficient) numberOfStars:5];
    _starView.scorePercent = 1;
    _starView.allowIncompleteStar = NO;;
    _starView.hasAnimation = NO;
    [top addSubview:_starView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 323 * WidthCoefficient, 1 * WidthCoefficient)];
    line.center = CGPointMake(kScreenWidth / 2, 75.5 * WidthCoefficient);
    line.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [top addSubview:line];
    
    self.imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WidthCoefficient, 86 * WidthCoefficient, 40 * WidthCoefficient, 40 * WidthCoefficient)];
    [top addSubview:_imgV];
    [_imgV downloadImage:self.order.items[0].picPath placeholder:[UIImage imageNamed:@"加载中小"] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        _imgV.image = [UIImage imageNamed:@"加载失败小"];
    } received:^(CGFloat progress) {
        
    }];
    
    self.label = [[YYLabel alloc] initWithFrame:CGRectMake(60 * WidthCoefficient, 86 * WidthCoefficient, 273 * WidthCoefficient, 40 * WidthCoefficient)];
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont fontWithName:FontName size:14];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _label.text = self.order.items[0].title;
    [top addSubview:_label];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 343 * WidthCoefficient, 136 * WidthCoefficient)];
    _textView.font = [UIFont fontWithName:FontName size:14];
    _textView.center = CGPointMake(kScreenWidth / 2, (166 + 68) * WidthCoefficient);
    _textView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    _textView.layer.cornerRadius = 4;
    _textView.placeholderColor = [UIColor colorWithHexString:@"#999999"];
    _textView.placeholder = NSLocalizedString(@"写下您的评价", nil);
    [self.view addSubview:_textView];

    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.frame = CGRectMake(0, 0, 271 * WidthCoefficient, 44 * WidthCoefficient);
    _submitBtn.center = CGPointMake(kScreenWidth / 2, (322 + 22) * WidthCoefficient);
    _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    _submitBtn.layer.cornerRadius = 4;
    _submitBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [_submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_submitBtn];
}

- (void)submitClick:(UIButton *)sender {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    NSDictionary *paras = @{
                            @"itemId": [NSNumber numberWithInteger:self.order.items[0].itemId],
                            @"itemScore": [NSNumber numberWithFloat:_starView.scorePercent * 5],
                            @"content": _textView.text,
                            @"orderId": [NSNumber numberWithInteger:self.order.orderId]
                            };
    [CUHTTPRequest POST:addItemcommentURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            hud.label.text = NSLocalizedString(@"评论成功", nil);
            [hud hideAnimated:YES afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            hud.label.text = dic[@"msg"];
            [hud hideAnimated:YES afterDelay:1];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"请求失败%ld",code];
        [hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)starView:(YYStarView *)starView scorePercentDidChange:(CGFloat)newScorePercent {
    
}

@end
