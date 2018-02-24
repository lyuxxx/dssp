//
//  TrafficReportdatailController.m
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrafficReportdatailController.h"
#import "TrafficReportdatailCell.h"
@interface TrafficReportdatailController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger openSection;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *isExpland;
@property (nonatomic, strong) NSMutableArray *cArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImageView *rightimageView;
@property (nonatomic, assign) BOOL isDo;
@end

@implementation TrafficReportdatailController
static NSString *const cellID = @"cell";


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车况报告详情";
    _isDo = NO;
    openSection = -1;
//     [self.view addSubview:self.tableView];
    [self initTableView];
     [self loadData];
    
}



-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    //    _tableView.tableFooterView = [UIView new];
    //    _tableView.tableHeaderView = [UIView new];
    
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
    _tableView.bounces=NO;
    //滚动条隐藏
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    //    隐藏线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[TrafficReportdatailCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,260*HeightCoefficient)];
//    _headerView.backgroundColor=[UIColor whiteColor];
//    _tableView.tableHeaderView=_headerView;
    
}

- (void)loadData {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    if (!self.isExpland) {
        self.isExpland = [NSMutableArray array];
    }

    //这里用一个二维数组来模拟数据。
    self.dataArray = [NSArray arrayWithObjects:@[@"a",@"b",@"c",@"d"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n"],nil].mutableCopy;

    //用0代表收起，非0（不一定是1）代表展开，默认都是收起的
    for (int i = 0; i < self.dataArray.count; i++) {
        [self.isExpland addObject:@0];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这里是关键，如果选中
    NSArray *array = self.dataArray[section];
    if ([self.isExpland[section] boolValue]) {
        return array.count;
    }
    else {
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    static NSString *cellID = @"TrafficReportCellName";

    TrafficReportdatailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
//    }
    if (cell == nil) {
        cell = [[TrafficReportdatailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
     cell.backgroundColor = [UIColor colorWithHexString:@"#040000"];
//    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
   
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(62*WidthCoefficient, 10*HeightCoefficient, 297*WidthCoefficient, 40*HeightCoefficient)];
    view1.backgroundColor=[UIColor colorWithHexString:@"#120F0E"];
//     view1.backgroundColor=[UIColor grayColor];
    [view addSubview:view1];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*WidthCoefficient, 10*HeightCoefficient, 80*WidthCoefficient, 20*HeightCoefficient)];
    titleLabel.font =[UIFont systemFontOfSize:15];
//    titleLabel.text=[titleArray objectAtIndex:section];
    titleLabel.textColor =[UIColor colorWithHexString:@"#999999"];
    titleLabel.text=@"发动机系统";
    [view1 addSubview:titleLabel];
    
    
    UIImageView *leftimageView=[[UIImageView alloc] init];
    leftimageView.image=[UIImage imageNamed:@"变速箱_icon"];
    [view addSubview:leftimageView];
    [leftimageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(19.5*WidthCoefficient);
        make.width.equalTo(21.5*WidthCoefficient);
        make.left.equalTo(23.5 * WidthCoefficient);
        make.centerY.equalTo(0);
        
    }];
    
    self.rightimageView=[[UIImageView alloc] init];
//    rightimageView.tag=20000+section;
    
//    NSString *string = [NSString stringWithFormat:@"%d",section];
 
    
    int intString = [[_isExpland objectAtIndex:section] intValue];
    NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
   
    if ([stringInt isEqualToString:@"1"]) {
        _rightimageView.image=[UIImage imageNamed:@"arrowup"];
    }else{
        _rightimageView.image=[UIImage imageNamed:@"arrowdown"];
    }
//    _rightimageView.image=[UIImage imageNamed:@"arrowdown"];
    [view1 addSubview:_rightimageView];
    [_rightimageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(16*WidthCoefficient);
        make.width.equalTo(16*WidthCoefficient);
        make.right.equalTo(-10 * WidthCoefficient);
        make.centerY.equalTo(0);
        
    }];

    
    //添加一个button 用来监听点击分组，实现分组的展开关闭。
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//     btn.backgroundColor=[UIColor redColor];
    btn.frame=CGRectMake(0, 0, kScreenWidth, 40);
    btn.tag=666+section;
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:btn];
    
    return view;
    
    
//    UIButton *headerSection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
////    headerSection.backgroundColor =[UIColor redColor];
//    headerSection.tag = 666+section;
//
//    //标题
//    [headerSection setTitle:[NSString stringWithFormat:@"第%@组",@(section)] forState:UIControlStateNormal];
//
//    [headerSection addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    return headerSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
   
    return 50 *HeightCoefficient;
}

- (void)buttonAction:(UIButton *)button {
    NSInteger section = button.tag - 666;
    self.isExpland[section] = [self.isExpland[section] isEqual:@0]?@1:@0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    
//    int intString = [[_isExpland objectAtIndex:section] intValue];
//    NSString *stringInt = [NSString stringWithFormat:@"%d",intString];
//    if ([stringInt isEqualToString:@"1"]) {
//        _rightimageView.image=[UIImage imageNamed:@"arrowup"];
//    }else{
//        _rightimageView.image=[UIImage imageNamed:@"arrowdown"];
//    }
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
