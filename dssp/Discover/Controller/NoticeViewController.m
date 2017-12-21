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
@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedDatas;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor colorWithHexString:@"#F9F8F8"];
    [self createTable];
}

- (void)createTable {
    [self.view addSubview:self.tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        
          make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0 *HeightCoefficient, 0, -kNaviHeight, 0));
    }];
    
    for (NSInteger i = 0; i < 10; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.dataSource addObject:indexPath];
    }
    
    [self setupFooter];
}

- (void)setupFooter {
    if (self.tableView.mj_footer == nil) {
        weakifySelf
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            strongifySelf
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        }];
        //    footer.refreshingTitleHidden = YES;
        [footer setTitle:[NSString stringWithFormat:@"一共%ld个通知",self.dataSource.count] forState:MJRefreshStateIdle];
        footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
        self.tableView.mj_footer = footer;
    } else {
        [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:[NSString stringWithFormat:@"一共%ld个通知",self.dataSource.count] forState:MJRefreshStateIdle];
    }
}


// delete
- (void)deleteSelectIndexPaths:(NSArray *)indexPaths
{
    // 删除数据源
    [self.dataSource removeObjectsInArray:self.selectedDatas];
    [self.selectedDatas removeAllObjects];
    
    //    [UIView setAnimationsEnabled:NO];
    // 删除选中项
    //    [self.tableView beginUpdates];
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
    
    [self setupFooter];
}

- (void)indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.dataSource.count;
//    self.allBtn.selected = (currentCount == allCount);
    NSString *title = (currentCount > 0) ? [NSString stringWithFormat:@"删除(%zd)",currentCount] : @"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount > 0;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
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
//    cell.backgroundColor=[UIColor redColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
        
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
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
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
//        [self deleteSelectIndexPaths:@[indexPath]];
    }
}

#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *tmp = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPathM = self.dataSource[tmp.row];
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
        //        _tableView.tableFooterView = [UIView new];
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        //        _tableView.allowsMultipleSelection = YES;
        //        _tableView.allowsSelectionDuringEditing = YES;
        //        _tableView.allowsMultipleSelectionDuringEditing = YES;
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

//- (UIButton *)deleteBtn {
//    if (_deleteBtn == nil) {
//        _deleteBtn = [[UIButton alloc] init];
//        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ac0042"]] forState:UIControlStateNormal];
//        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
//        [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
//        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _deleteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//        [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _deleteBtn.enabled = NO;
//        
//    }
//    return _deleteBtn;
//}

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
