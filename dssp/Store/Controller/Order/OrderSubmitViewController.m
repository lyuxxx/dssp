//
//  OrderSubmitViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderSubmitViewController.h"
#import "OrderSubmitCell.h"
#import "OrderPayViewController.h"
#import "StoreObject.h"
#import "OrderObject.h"

@interface OrderSubmitViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) StoreCommodity *commodity;
@end

@implementation OrderSubmitViewController

- (instancetype)initWithCommodity:(StoreCommodity *)commodity {
    self = [super init];
    if (self) {
        self.commodity = commodity;
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
    self.navigationItem.title = NSLocalizedString(@"提交订单", nil);
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 49 * WidthCoefficient, 0));
    }];
    
    UIView *botV = [[UIView alloc] init];
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
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    [submitBtn setTitle:NSLocalizedString(@"提交订单", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [botV addSubview:submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(130 * WidthCoefficient);
        make.height.equalTo(49 * WidthCoefficient);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.text = [NSString stringWithFormat:@"实付款:￥%@",self.commodity.price];
    [botV addSubview:_priceLabel];
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.centerY.equalTo(botV);
        make.right.equalTo(submitBtn.left).offset(-10 * WidthCoefficient);
    }];
}

- (void)submitOrder:(UIButton *)sender {
    [self createOrder];
}

- (void)createOrder {
    NSArray *items = @[@{
                           @"itemId": [NSNumber numberWithInteger:_commodity.itemId],
                           @"num": [NSNumber numberWithInteger:1]
                           }];
    NSDictionary *paras = @{
                            @"items": items
                            };
    [CUHTTPRequest POST:createOrderURL parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"msg"] isEqualToString:@"success"]) {
            Order *order = [Order yy_modelWithJSON:dic[@"data"]];
            OrderPayViewController *vc = [[OrderPayViewController alloc] initWithPrice:order.payment.floatValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSInteger code) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OrderSubmitCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderSubmitCell *cell = [OrderSubmitCell cellWithTableView:tableView];
    [cell configWithCommodity:self.commodity];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        [_tableView registerClass:[OrderSubmitCell class] forCellReuseIdentifier:@"OrderSubmitCell"];
    }
    return _tableView;
}

@end
