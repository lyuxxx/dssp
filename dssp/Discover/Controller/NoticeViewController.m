//
//  NoticeViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "NoticeViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MBProgressHUD+CU.h>
#import "CarInfoModel.h"
#import <CUHTTPRequest.h>
#import "NoticeCell.h"
#import <MGSwipeTableCell.h>
#import <MJRefresh.h>
#import "FavoriteCell.h"
#import "NoticeModel.h"
#import "RemindViewController.h"
@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedDatas;
@property (nonatomic, strong) UIButton *deleteBtn;
 @property (nonatomic, strong) NSMutableArray *noticeDatas;
@property (nonatomic, strong) NoticeModel *notice;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor redColor];
   
    [self requestNoticeData];
    [self createTable];
//    [self.tableView.mj_footer beginRefreshing];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestNoticeData];
    [self createTable];
    
}


- (void)createTable {
    [self.view addSubview:self.tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);

    }];

//    [self setupFooter];
}

- (void)setupFooter {
    if (self.tableView.mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestNoticeData)];
        //    footer.refreshingTitleHidden = YES;
        [footer setTitle:[NSString stringWithFormat:@"一共%ld个通知",self.dataSource.count] forState:MJRefreshStateIdle];
        footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
        self.tableView.mj_footer = footer;
    } else {
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:[NSString stringWithFormat:@"一共%ld个通知",self.dataSource.count] forState:MJRefreshStateIdle];
    }
}

-(void)requestNoticeData
{
    NSDictionary *paras = @{
                            
                          };
    NSString *NumberByVin = [NSString stringWithFormat:@"%@/VF7CAPSA000000002",findAppPushInboxTitleByVin];
    [CUHTTPRequest POST:NumberByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSArray *dataArray = dic[@"data"];
            _noticeDatas =[NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                self.notice = [NoticeModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:_notice];
            }
            
          
//            [self.dataSource addObjectsFromArray:resultArr];
            
//            [self.dataSource addObjectsFromArray:_noticeDatas];
            [_tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            
        } else {
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
         [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
       
    }];
}


// delete
- (void)deleteSelectIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 1) {
        
        NSDictionary *paras = @{
                                @"readStatus":@"0",
                                @"isDel":@"1",
                                @"id":_notice.noticeId
                                };
        [CUHTTPRequest POST:updateReadStatusOrIsDelByVinAndType parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
              
                
                
            } else {
                
                [MBProgressHUD showText:dic[@"msg"]];
            }
        } failure:^(NSInteger code) {
            
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        }];

    } else {
      
        
    }

    // 删除数据源
    [self.dataSource removeObjectsInArray:self.selectedDatas];
    [self.selectedDatas removeAllObjects];
    
    //    [UIView setAnimationsEnabled:NO];
    // 删除选中项
//        [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView endUpdates];
    //    [UIView setAnimationsEnabled:YES];
    
    // 验证数据源
//    [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
    
    // 验证
    // 没有
    if (self.dataSource.count == 0)
    {
        //没有收藏数据


    }
    
//    [self setupFooter];
}



#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110 * WidthCoefficient;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"FavoriteCellId";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
 
    
//    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"delete_icon"] backgroundColor:[UIColor clearColor]insets:UIEdgeInsetsMake(0, 16 * WidthCoefficient, 0, 25 * WidthCoefficient)]];
//    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    
    NoticeModel *notice=self.dataSource[indexPath.row];
    cell.noticeModel = notice;
    cell.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
//     cell.backgroundColor=[UIColor redColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

//点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeModel *notice = self.dataSource[indexPath.row];
    RemindViewController *remindView =[[RemindViewController alloc] init];
    remindView.vin= notice.vin;
    remindView.businType= notice.businType;
    remindView.noticeId = notice.noticeId;
    remindView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:remindView animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
//        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        // 删除
        return UITableViewCellEditingStyleNone;
    }
    
   
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.selectedDatas removeAllObjects];
        [self deleteSelectIndexPaths:@[indexPath]];
    }
}


#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *tmp = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPathM = self.dataSource[tmp.row];
    
//    ResultItem *item = self.dataSource[tmp.row];
    if (![self.selectedDatas containsObject:indexPathM]) {
        [self.selectedDatas addObject:indexPathM];
    }
   [self deleteSelectIndexPaths:@[[self.tableView indexPathForCell:cell]]];
    return YES;
}


- (NSArray<UIView *> *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {

    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionClipCenter;
        //            expansionSettings.buttonIndex = 0;
        //            expansionSettings.fillOnTrigger = YES;
        return @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"delete_icon"] backgroundColor:[UIColor clearColor] insets:UIEdgeInsetsMake(0, 16 * WidthCoefficient, 0, 25 * WidthCoefficient)]];
    } else {
        return nil;
    }
}

#pragma mark -getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        if (@available(iOS 11.0, *)) {
            if (Is_Iphone_X) {
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
                _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomHeight, 0);
                _tableView.scrollIndicatorInsets = _tableView.contentInset;
            }
        } else {
            // Fallback on earlier versions
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
                _tableView.tableFooterView = [UIView new];
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        //        _tableView.allowsMultipleSelection = YES;
        //        _tableView.allowsSelectionDuringEditing = YES;
        //        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)selectedDatas {
    if (!_selectedDatas) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
