//
//  PersonInViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/21.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "PersonInViewController.h"
#import "MineCell.h"
#import <YYCategoriesSub/YYCategories.h>
@interface PersonInViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation PersonInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"个人信息", nil);
    
    NSArray *titles = @[
                              NSLocalizedString(@"头像", nil),
                              NSLocalizedString(@"用户名", nil),
                              NSLocalizedString(@"手机号", nil),
                              NSLocalizedString(@"昵称", nil)
          
                              
                              ];
    
    [self initTableView];
}


-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    _tableView.estimatedRowHeight = 0;
//    _tableView.estimatedSectionFooterHeight = 0;
//    _tableView.estimatedSectionHeaderHeight = 0;
    //    _tableView.tableFooterView = [UIView new];
    //    _tableView.tableHeaderView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
//    _tableView.bounces=NO;
    //滚动条隐藏
//    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(-35, 0, 0, 0));
//          make.edges.equalTo(self.view);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60*HeightCoefficient;
    }
    return 44*HeightCoefficient;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
//    cell.img.image = [UIImage imageNamed:@""];
////    cell.lab.text = [indexPath.row];
//    cell.arrowImg.image=[UIImage imageNamed:@"arrownext"];
   
       
//        if (indexPath.row==1) {
//
//        }
//        if (indexPath.row==3) {
//            cell.whiteView.hidden=YES;
//        }
//
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
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
