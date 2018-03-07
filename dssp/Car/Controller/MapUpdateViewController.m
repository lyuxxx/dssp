//
//  MapUpdateViewController.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "MapUpdateViewController.h"
#import "GetActivationCodeViewController.h"
#import "MapUpdateHelpViewController.h"
#import "ActivationCodeListViewController.h"
#import "MapUpdateObject.h"
#import "ActivationCodeListCell.h"

@interface MapUpdateViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *limitLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray<ActivationCode *> *codes;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIView *codeV;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *expireLabel;
@property (nonatomic, strong) UIView *redV;

@property (nonatomic, assign) BOOL canGetActivationCode;
@property (nonatomic, assign) BOOL canShowActivationList;

@end

@implementation MapUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"地图升级", nil);
    
    UIButton *rtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rtBtn addTarget:self action:@selector(helpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rtBtn setTitle:NSLocalizedString(@"帮助", nil) forState:UIControlStateNormal];
    [rtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rtBtn];
    [rtBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
    }];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)setupUI {
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"update_backgroud"];
    [self.view addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(95 * WidthCoefficient);
    }];
    
    UIView *topWV = [[UIView alloc] init];
    topWV.layer.cornerRadius = 4;
    topWV.layer.masksToBounds = YES;
    topWV.layer.shadowOffset = CGSizeMake(0, 4);
    topWV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    topWV.layer.shadowOpacity = 0.5;
    topWV.layer.shadowRadius = 7;
    topWV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topWV];
    [topWV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(70 * WidthCoefficient);
        make.top.equalTo(86 * WidthCoefficient);
    }];
    
    UIView *line = [[UIView alloc] init];
    [topWV addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topWV);
        make.width.equalTo(1 * WidthCoefficient);
        make.height.equalTo(40 * WidthCoefficient);
    }];
    
    UIView *leftV = [[UIView alloc] init];
    [topWV addSubview:leftV];
    [leftV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(171.5 * WidthCoefficient);
        make.height.equalTo(topWV);
        make.left.equalTo(topWV);
        make.centerY.equalTo(topWV);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.limitLabel = timeLabel;
    timeLabel.text = @"-次";
    timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [leftV addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftV);
        make.height.equalTo(25 * WidthCoefficient);
        make.top.equalTo(13 * WidthCoefficient);
    }];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = NSLocalizedString(@"已购买升级权限", nil);
    leftLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    leftLabel.font = [UIFont fontWithName:FontName size:11];
    [leftV addSubview:leftLabel];
    [leftLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftV);
        make.height.equalTo(15 * WidthCoefficient);
        make.top.equalTo(timeLabel.bottom).offset(5 * WidthCoefficient);
    }];
    
    UIView *rtV = [[UIView alloc] init];
    [topWV addSubview:rtV];
    [rtV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(171.5 * WidthCoefficient);
        make.height.equalTo(topWV);
        make.right.equalTo(topWV);
        make.centerY.equalTo(topWV);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    self.countLabel = numLabel;
    numLabel.text = @"-个";
    numLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [rtV addSubview:numLabel];
    [numLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rtV);
        make.height.equalTo(25 * WidthCoefficient);
        make.top.equalTo(13 * WidthCoefficient);
    }];
    
    UILabel *rtLabel = [[UILabel alloc] init];
    rtLabel.text = NSLocalizedString(@"已获取激活码", nil);
    rtLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    rtLabel.font = [UIFont fontWithName:FontName size:11];
    [rtV addSubview:rtLabel];
    [rtLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rtV);
        make.height.equalTo(15 * WidthCoefficient);
        make.width.equalTo(66 * WidthCoefficient);
        make.top.equalTo(numLabel.bottom).offset(5 * WidthCoefficient);
    }];
    
    UIView *redV = [[UIView alloc] init];
    self.redV = redV;
    self.redV.hidden = YES;
    redV.layer.cornerRadius = 2.5;
    redV.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    [rtV addSubview:redV];
    [redV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rtLabel);
        make.left.equalTo(rtLabel.right).offset(2);
        make.width.height.equalTo(5);
    }];
    
    UIView *botV = [[UIView alloc] init];
    botV.layer.cornerRadius = 4;
    botV.layer.masksToBounds = YES;
    botV.layer.shadowOffset = CGSizeMake(0, 4);
    botV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    botV.layer.shadowOpacity = 0.5;
    botV.layer.shadowRadius = 7;
    botV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botV];
    [botV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(343 * WidthCoefficient);
        make.height.equalTo(100 * WidthCoefficient);
        make.centerX.equalTo(self.view);
        make.top.equalTo(topWV.bottom).offset(20 * WidthCoefficient);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.userInteractionEnabled = YES;
    imgV.image = [UIImage imageNamed:@"激活bg"];
    [botV addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(botV);
        make.width.equalTo(123.5 * WidthCoefficient);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"点击获取激活码", nil);
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = [UIColor colorWithHexString:@"#ac0042"];
    [botV addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
        make.height.equalTo(22.5 * WidthCoefficient);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    self.tipLabel = label1;
    label1.font = [UIFont fontWithName:FontName size:13];
    label1.textColor = [UIColor colorWithHexString:@"#999999"];
    [botV addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(label.bottom).offset(5 * WidthCoefficient);
        make.height.equalTo(18.5 * WidthCoefficient);
    }];
    
//    self.codeV = [[UIView alloc] init];
//    _codeV.layer.cornerRadius = 4;
//    _codeV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    _codeV.layer.shadowOffset = CGSizeMake(0, 4);
//    _codeV.layer.shadowOpacity = 0.5;
//    _codeV.layer.shadowRadius = 7;
//    _codeV.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_codeV];
//    [_codeV makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(343 * WidthCoefficient);
//        make.height.equalTo(85 * HeightCoefficient);
//        make.top.equalTo(botV.bottom).offset(20 * WidthCoefficient);
//        make.centerX.equalTo(self.view);
//    }];
//
//    self.codeLabel = [[UILabel alloc] init];
//    _codeLabel.font = [UIFont fontWithName:FontName size:16];
//    _codeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    [_codeV addSubview:_codeLabel];
//    [_codeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(20 * HeightCoefficient);
//        make.left.equalTo(10 * WidthCoefficient);
//        make.height.equalTo(20 * HeightCoefficient);
//    }];
//
//    self.stateLabel = [[UILabel alloc] init];
//    _stateLabel.textAlignment = NSTextAlignmentRight;
//    _stateLabel.font = [UIFont fontWithName:FontName size:16];
//    _stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
//    [_codeV addSubview:_stateLabel];
//    [_stateLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_codeLabel);
//        make.right.equalTo(-10 * WidthCoefficient);
//        make.height.equalTo(20 * HeightCoefficient);
//    }];
//
//    self.expireLabel = [[UILabel alloc] init];
//    _expireLabel.textAlignment = NSTextAlignmentLeft;
//    _expireLabel.font = [UIFont fontWithName:FontName size:13];
//    _expireLabel.textColor = [UIColor colorWithHexString:@"#999999"];
//    [_codeV addSubview:_expireLabel];
//    [_expireLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_codeLabel);
//        make.top.equalTo(_codeLabel.bottom).offset(5 * HeightCoefficient);
//        make.height.equalTo(20 * HeightCoefficient);
//    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activate:)];
    [botV addGestureRecognizer:tap];
    
    UITapGestureRecognizer *countTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeList:)];
    [rtV addGestureRecognizer:countTap];
    
    UITapGestureRecognizer *ListTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeList:)];
    [self.codeV addGestureRecognizer:ListTap];
    
    UITapGestureRecognizer *storeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToStore:)];
    [leftV addGestureRecognizer:storeTap];
    
//    self.codeV.hidden = YES;
    
    self.table = [[UITableView alloc] init];
    _table.showsVerticalScrollIndicator = NO;
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [UIView new];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(botV.bottom).offset(15 * WidthCoefficient);
    }];
}

- (void)pullData {
    [CUHTTPRequest POST:getMapUpdateCountURL parameters:@{@"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            self.limit = ((NSString *)dic[@"data"][@"mapCount"]).integerValue;
            self.count = ((NSString *)dic[@"data"][@"activationCodeCount"]).integerValue;
            self.tipLabel.text = [NSString stringWithFormat:@"您还可以获取激活%ld次",_limit];
            self.limitLabel.text = [NSString stringWithFormat:@"%ld次",_limit];
            self.countLabel.text = [NSString stringWithFormat:@"%ld个",_count];
            NSString *validaGetCode = dic[@"data"][@"validaGetCode"];
            if ([validaGetCode isEqualToString:@"true"]) {
                self.canGetActivationCode = YES;
            } else {
                self.canGetActivationCode = NO;
                NSArray<NSDictionary *> *tmp = dic[@"data"][@"validaCodeList"];
                [self.codes removeAllObjects];
                for (NSInteger i = 0; i < tmp.count; i++) {
                    ActivationCode *code = [ActivationCode yy_modelWithJSON:tmp[i]];
                    [self.codes addObject:code];
                }
                [self.table reloadData];
            }
            if (_count == 0) {
                self.redV.hidden = YES;
            } else {
                self.redV.hidden = NO;
            }
            if (_count) {
                self.canShowActivationList = YES;
            } else {
                self.canShowActivationList = NO;
            }
        } else {
            
        }
    } failure:^(NSInteger code) {
        
    }];
}

#pragma mark - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.codes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"activationCodeCellId";
    ActivationCodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ActivationCodeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell configWithActivationCode:self.codes[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95 * HeightCoefficient;
}

- (void)showCodeViewWithCode:(ActivationCode *)code {
    self.codeV.hidden = NO;
    self.codeLabel.text = code.checkCode;
    if ([code.recordStatus isEqualToString:@"1"]) {
        _stateLabel.textColor = [UIColor colorWithHexString:@"#ac0042"];
        _stateLabel.text = NSLocalizedString(@"有效", nil);
    } else if ([code.recordStatus isEqualToString:@"0"]) {
        _stateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _stateLabel.text = NSLocalizedString(@"无效", nil);
    }
    
    if (code.getDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        self.expireLabel.text = [NSString stringWithFormat:@"有效期:%@",[formatter stringFromDate:code.getDate]];
    }
}

- (void)helpBtnClick:(UIButton *)sender {
    MapUpdateHelpViewController *vc = [[MapUpdateHelpViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToStore:(UITapGestureRecognizer *)sender {
    UIViewController *vc = [[NSClassFromString(@"StoreTabViewController") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)activate:(UITapGestureRecognizer *)sender {
    if (self.canGetActivationCode && _limit) {
        GetActivationCodeViewController *vc = [[GetActivationCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (self.codes.count) {
            [MBProgressHUD showText:NSLocalizedString(@"当前还有未过期的激活码", nil)];
        } else if (_limit == 0) {
            [MBProgressHUD showText:NSLocalizedString(@"请前往商城购买地图升级商品", nil)];
        } else {
            [MBProgressHUD showText:NSLocalizedString(@"无法获取激活码", nil)];
        }
    }
}

- (void)codeList:(UITapGestureRecognizer *)sender {
    if (self.canShowActivationList) {
        ActivationCodeListViewController *vc = [[ActivationCodeListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSMutableArray<ActivationCode *> *)codes {
    if (!_codes) {
        _codes = [NSMutableArray array];
    }
    return _codes;
}

@end
