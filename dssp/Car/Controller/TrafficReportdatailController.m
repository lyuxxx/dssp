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
@property (nonatomic, strong) NSMutableArray *cellArray1;
@property (nonatomic, strong) NSMutableArray *cellArray2;
@property (nonatomic, strong) NSMutableArray *cellArray3;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *isExpland;
@property (nonatomic, strong) NSMutableArray *cArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImageView *rightimageView;
@property (nonatomic, assign) BOOL isDo;
@property (nonatomic,strong) TrafficReporData  *trafficReporData;
@property (nonatomic, strong) NSMutableArray<RecordItems *> *dataSource;
//@property (nonatomic, strong) RecordItem *recordItem;
@property (nonatomic,strong) NSMutableDictionary *result;
@end

@implementation TrafficReportdatailController
static NSString *const cellID = @"cell";

- (NSMutableArray<RecordItems *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

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
 
}

- (void)loadData {
    
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }

    if (!self.isExpland) {
        self.isExpland = [NSMutableArray array];
    }

    //这里用一个二维数组来模拟数据。
//    self.dataArray = [NSArray arrayWithObjects:@[@"a",@"b",@"c",@"d"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n",@"a",@"b",@"c",@"d"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n"],@[@"d",@"e",@"f"],@[@"h",@"i",@"j",@"m",@"n"],@[@"h",@"i",@"j",@"m",@"n"],nil].mutableCopy;
    
    NSArray *titles = @[@"胎压状态",@"转向系统",@"电器系统",@"发动机系统",@"电器系统灯光部分",@"变速箱系统",@"制动系统",@"气囊系统"];
    
    NSArray *imgs = @[@"胎压_icon",@"转向系统_icon",@"电器系统_icon",@"发动机_icon",@"电器系统灯光_icon",@"变速箱_icon",@"制动系统_icon",@"气囊_icon"];
    
    self.titleArray = [NSMutableArray array];
    self.cellArray1 = [NSMutableArray array];
    self.cellArray2 = [NSMutableArray array];
    self.cellArray3 = [NSMutableArray array];
    self.imgArray = [NSMutableArray array];
    self.result = [NSMutableDictionary new];
    
    for (NSDictionary *dic in _dataArray1) {
        HealthAlertsItem *healthAlerts = [HealthAlertsItem yy_modelWithDictionary:dic];
        //保存title数组
        [self.titleArray addObject:healthAlerts.vehicleSystemName];
        [self.cellArray1 addObject:healthAlerts.record];
        
        
        }
    
    //用0代表收起，非0（不一定是1）代表展开，默认都是收起的
    for (int i = 0; i < self.titleArray.count; i++) {
        [self.isExpland addObject:@0];
    }
    
    
   //    根据title取图片
    for (int i = 0; i < self.titleArray.count; i++) {
       [_result setObject:imgs[i] forKey:titles[i]];
       [_imgArray addObject:[_result objectForKey:_titleArray[i]]];
    }


    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //有多少组
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这里是关键，如果选中
    NSArray *array = self.cellArray1[section];
    if ([self.isExpland[section] boolValue]) {
        return array.count;
    }
    else {
        return 0;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data1=self.cellArray1[indexPath.section];
    for (NSDictionary *dic in data1) {
        RecordItems *recordItem = [RecordItems yy_modelWithDictionary:dic];
         [self setcellHight:recordItem.jdaName];
        recordItem.cellHeights = [self setcellHight:recordItem.jdaName];
       
        [self.dataSource addObject:recordItem];
       
        //        [self.cellArray2 addObject: recordItem.jdaName];
        [self.cellArray3 addObject: [[NSString stringWithFormat:@"%@",recordItem.alertCount] stringByAppendingString:@"次"]];
    }
    
    
    return self.dataSource[indexPath.row].cellHeights;
 
}

-(CGFloat)setcellHight:(NSString *)cellModel
{
    CGRect tmpRect= [cellModel boundingRectWithSize:CGSizeMake(223 * WidthCoefficient, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
   
    CGFloat contentH = tmpRect.size.height+11;
    NSLog(@"显示高度:%f",contentH);
    return contentH;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordItems *recordItem = self.dataSource[indexPath.row];
    TrafficReportdatailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TrafficReportdatailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
     cell.backgroundColor = [UIColor colorWithHexString:@"#040000"];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
     cell.recordItem = recordItem;
//       cell.leftlab.text = self.cellArray2[indexPath.row];
//      [self setcellHight:self.cellArray2[indexPath.row]];
    
//      NSLog(@"555%f",[self setcellHight:self.cellArray2[indexPath.row]]);
//      cell.rightlab.text = self.cellArray3[indexPath.row];
      return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
   
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(62*WidthCoefficient, 10*HeightCoefficient, 297*WidthCoefficient, 40*HeightCoefficient)];
    view1.backgroundColor=[UIColor colorWithHexString:@"#120F0E"];
//     view1.backgroundColor=[UIColor grayColor];
    [view addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 10*HeightCoefficient, 62*WidthCoefficient, 40*HeightCoefficient)];
    view2.backgroundColor=[UIColor colorWithHexString:@"#040000"];
    //     view1.backgroundColor=[UIColor grayColor];
    [view addSubview:view2];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*WidthCoefficient, 10*HeightCoefficient, 180*WidthCoefficient, 20*HeightCoefficient)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = [self.titleArray objectAtIndex:section];
    titleLabel.textColor =[UIColor colorWithHexString:@"#999999"];
//    titleLabel.text=@"发动机系统";
    [view1 addSubview:titleLabel];
    

    
    UIImageView *leftimageView=[[UIImageView alloc] init];
    leftimageView.image=[UIImage imageNamed:[self.imgArray objectAtIndex:section]];
    [view2 addSubview:leftimageView];
    [leftimageView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(19.5*WidthCoefficient);
        make.width.equalTo(21.5*WidthCoefficient);
        make.left.equalTo(23.5 * WidthCoefficient);
        make.centerY.equalTo(view2).offset(0);
    }];
    
    self.rightimageView=[[UIImageView alloc] init];

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
        make.centerY.equalTo(view1).offset(0);
        
    }];

    //添加一个button 用来监听点击分组，实现分组的展开关闭。
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//     btn.backgroundColor=[UIColor redColor];
    btn.frame=CGRectMake(62*WidthCoefficient, 0, 297*HeightCoefficient, 40);
    btn.tag=666+section;
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:btn];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 *HeightCoefficient;
}

- (void)buttonAction:(UIButton *)button {
    NSInteger section = button.tag - 666;
    self.isExpland[section] = [self.isExpland[section] isEqual:@0]?@1:@0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
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
