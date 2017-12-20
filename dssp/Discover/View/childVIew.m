//
//  childVIew.m
//  ZXPageScrollView
//
//  Created by anphen on 2017/3/29.
//  Copyright © 2017年 anphen. All rights reserved.
//

#import "childVIew.h"
#import "MBProgressHUD.h"
#import <YYCategoriesSub/YYCategories.h>
#import "SubscriCell.h"
@implementation childVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        self.backgroundColor = [UIColor colorWithHexString:@"#F9F8F8"];
      
        _dataArray = [[NSArray alloc]init];
        if (_dataArray.count == 0) {
//            [self fetchData];
            [self initTableView];
        }
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _label.font = [UIFont systemFontOfSize:24];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
//    self.label.text = [NSString stringWithFormat:@"%ld",(long)index];
}

- (void)fetchData
{
//    NSLog(@"====%@====", self.label.text);
//    self.dataArray = @[@"1", @"2", @"3"];
//    [MBProgressHUD showHUDAddedTo:self animated:NO];
//    [self performSelector:@selector(hiddenHUD) withObject:nil afterDelay:1];
}

-(void)initTableView
{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    //    _tableView.tableFooterView = [UIView new];
    //    _tableView.tableHeaderView = [UIView new];
    //取消cell的线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    adjustsScrollViewInsets_NO(tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
    //    _tableView.bounces=NO;
    //滚动条隐藏
    //    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor clearColor];
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).offset(UIEdgeInsetsMake(0 , 0, kTabbarHeight-10, 0));
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCellName";
    SubscriCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SubscriCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //    cell.img.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row][0]];
    //    cell.lab.text =_dataArray[indexPath.section][indexPath.row][1];
    //    cell.arrowImg.image=[UIImage imageNamed:@"arrownext"];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220*HeightCoefficient;
}


- (void)hiddenHUD{
    [MBProgressHUD hideHUDForView:self animated:NO];
//    self.label.text = [NSString stringWithFormat:@"%@ == 已加载数据",  self.label.text];
}

@end
