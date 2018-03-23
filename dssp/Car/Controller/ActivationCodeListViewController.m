//
//  ActivationCodeListController.m
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "ActivationCodeListViewController.h"
#import "ActivationCodeListCell.h"
#import "MapUpdateObject.h"

@interface ActivationCodeListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray<ActivationCode *> *codes;
@end

@implementation ActivationCodeListViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"激活码", nil);
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)setupUI {
    self.table = [[UITableView alloc] init];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [UIView new];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)pullData {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:getMapUpdateActivationCodeListURL parameters:@{@"vin":[[NSUserDefaults standardUserDefaults] objectForKey:@"vin"]} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            ActivationCodeListResponse *response = [ActivationCodeListResponse yy_modelWithJSON:dic];
            self.codes = response.data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
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
    return 85 * HeightCoefficient;
}

@end
