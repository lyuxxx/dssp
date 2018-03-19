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
#import "UITabBar+badge.h"
@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectedDatas;
@property (nonatomic, strong) UIButton *deleteBtn;
 @property (nonatomic, strong) NSMutableArray *noticeDatas;
@property (nonatomic, strong) NoticeModel *notice;
@property (nonatomic, assign) BOOL end;
@property (nonatomic, assign) BOOL ends;
@end

@implementation NoticeViewController

//- (BOOL)needGradientBg {
//    return YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(executeNotification) name:@"DiscoverVCneedRefresh" object:nil];
    
    self.view.clipsToBounds = YES;
    
    CGFloat height = kScreenHeight -(70 * HeightCoefficient)-kTabbarHeight-kNaviHeight;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, height);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
//    self.view.backgroundColor=[UIColor blueColor];
    
    [self createTable];
    [self.tableView.mj_header beginRefreshing];
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestNoticeData];
}


- (void)executeNotification {
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"－－－－－接收到通知------");
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pullDownToRefreshLatestNews {
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNoticeData)];
//    // 设置header
////    _tableView.mj_header.lastUpdatedTimeLabel.hidden = YES;
//    [_tableView.mj_header beginRefreshing];
    
     
      MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestNoticeData)];
      self.tableView.mj_header = header;
      // 隐藏时间
//      header.lastUpdatedTimeLabel.hidden = YES;
//      // 隐藏状态
//      header.stateLabel.hidden = YES;
  
}

- (void)createTable {
    [self.view addSubview:self.tableView];
//    [_tableView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
     [self pullDownToRefreshLatestNews];
}

-(void)requestNoticeData
{
    NSDictionary *paras = @{
                            
                          };
    NSString *NumberByVin = [NSString stringWithFormat:@"%@/%@",findAppPushInboxTitleByVin,kVin];
    [CUHTTPRequest POST:NumberByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSArray *dataArray = dic[@"data"];
            _noticeDatas =[NSMutableArray new];
            for (NSDictionary *dic in dataArray) {
                self.notice = [NoticeModel yy_modelWithDictionary:dic];
                [self.noticeDatas addObject:_notice];
            }
            self.dataSource = _noticeDatas;
//            [self.dataSource addObjectsFromArray:resultArr];
//            [self.dataSource addObjectsFromArray:_noticeDatas];
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        } else {
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
         [self.tableView.mj_header endRefreshing];
//        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
       
    }];
}

// delete
- (void)deleteSelectIndexPaths:(NSArray *)indexPaths
{
        NSString *idStr = @"";
        NSString *readStatus = @"";
        NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:self.selectedDatas.count];
       NSMutableArray *idArr1 = [NSMutableArray arrayWithCapacity:self.selectedDatas.count];
        for (NoticeModel *item in self.selectedDatas) {
            [idArr addObject:item.noticeId];
            [idArr1 addObject:item.readStatus];
        }
        idStr = [idArr componentsJoinedByString:@","];
        readStatus = [idArr1 componentsJoinedByString:@","];
       if ([readStatus isEqualToString:@"0"]) {
          
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveloadMsg" object:nil userInfo:nil];
       }
    
        NSDictionary *paras = @{
                                @"readStatus":@"0",
                                @"isDel":@"1",
                                @"id":idStr
                                };
        [CUHTTPRequest POST:updateReadStatusOrIsDelByVinAndType parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                // 删除数据源
                [self.dataSource removeObjectsInArray:self.selectedDatas];
                [self.selectedDatas removeAllObjects];
                
                //    [UIView setAnimationsEnabled:NO];
                // 删除选中项
                //        [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                
                    if (self.dataSource.count == 0)
                    {
                        //没有收藏数据
 
                    }
                
            } else {
                
                [MBProgressHUD showText:dic[@"msg"]];
            }
        } failure:^(NSInteger code) {
            
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        }];
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
//    cell.backgroundColor=[UIColor colorWithHexString:@"#AC0042"];
    cell.backgroundColor=[UIColor clearColor];
//     cell.backgroundColor=[UIColor redColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

//点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NoticeModel *notice = self.dataSource[indexPath.row];
    RemindViewController *remindView =[[RemindViewController alloc] init];
    remindView.noticeModel = notice;
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
        return @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"delete_icon"] backgroundColor:[UIColor colorWithHexString:@"#AC0042"] insets:UIEdgeInsetsMake(0, 25 * WidthCoefficient, 0, 25 * WidthCoefficient)]];
    } else {
        return nil;
    }
}

#pragma mark -getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
         CGFloat height = kScreenHeight -(70 * HeightCoefficient)-kTabbarHeight-kNaviHeight;
         [_tableView setFrame:CGRectMake(0, 0, kScreenWidth, height)];
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
        _tableView.backgroundColor=[UIColor clearColor];
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
