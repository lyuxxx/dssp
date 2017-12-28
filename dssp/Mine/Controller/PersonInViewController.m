//
//  PersonInViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/21.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "PersonInViewController.h"
#import "PersonInCell.h"
#import <YYCategoriesSub/YYCategories.h>
#import "ModifyPhoneController.h"

@interface PersonInViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *titles;
@end

@implementation PersonInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"个人信息", nil);
    
    self.titles = @[
                              NSLocalizedString(@"头像", nil),
                              NSLocalizedString(@"用户名", nil),
                              NSLocalizedString(@"手机号", nil),
                              NSLocalizedString(@"昵称", nil)
          
                              
                              ];
    
    [self initTableView];
}


-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
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
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//          make.edges.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
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
    static NSString *cellID = @"PersonInCellName";
    PersonInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PersonInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
     cell.lab.text = _titles[indexPath.row] ;
     cell.arrowImg.image=[UIImage imageNamed:@"arrownext"];
   
       if (indexPath.row==0) {
           cell.img.image = [UIImage imageNamed:@"avatar"];
        }
       if (indexPath.row==1) {
           cell.realName.text = @"xxx";
        }
        if (indexPath.row==2) {
            NSString *originTel = @"15871707603";
            NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.realName.text = tel;
        }
        if (indexPath.row==3) {
            cell.whiteView.hidden=YES;
            cell.realName.text = @"xxx";
        }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   if (indexPath.row == 0) {
            
    }
    if (indexPath.row == 1) {
        
    }
    if (indexPath.row == 2) {
        ModifyPhoneController *modifyPhone = [ModifyPhoneController new];
        [self.navigationController pushViewController:modifyPhone animated:YES];
    }
    if (indexPath.row == 3) {
        
    }
    
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
