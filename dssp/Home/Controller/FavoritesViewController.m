//
//  FavoritesViewController.m
//  dssp
//
//  Created by yxliu on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "FavoritesViewController.h"
#import <YYCategories.h>
#import "FavoriteCell.h"
#import <MJRefresh.h>
#import <MGSwipeTableCell.h>
#import "POI.h"
#import <CUHTTPRequest.h>
#import "MapBaseController.h"

#define pageSize 20

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>

@property (nonatomic, assign) PoiType type;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) NSMutableArray<ResultItem *> *dataSource;
@property (nonatomic, strong) NSMutableArray<ResultItem *> *selectedDatas;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) NSIndexPath *editingIndexPath;
@property (nonatomic, assign) BOOL end;

@end

@implementation FavoritesViewController

- (instancetype)initWithType:(PoiType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"POI收藏夹", nil);
    
    [self createTable];
    [self setupUI];
    [self.tableView.mj_footer beginRefreshing];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    return;
//    if (self.editingIndexPath) {
//        [self configSwipeButton];
//    }
//}
//
//- (void)configSwipeButton {
//    if (@available(iOS 11.0, *)) {
//        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
//        for (UIView *subview in self.tableView.subviews) {
//            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 1) {
//                //和iOS10按钮顺序相反 0  1
//                UIButton *deleteButton = subview.subviews[0];
//                if (deleteButton) {
//                    [self configDeleteButton:deleteButton];
//                }
//                [subview setBackgroundColor:[UIColor clearColor]];
//            }
//        }
//    } else {
//        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
//        FavoriteCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
//        for (UIView *subview in tableCell.subviews) {
//            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 1) {
//                //按钮顺序 1 0
//                UIButton *deleteButton = subview.subviews[0];
//                if (deleteButton) {
//                    [self configDeleteButton:deleteButton];
//                }
//                [subview setBackgroundColor:[UIColor clearColor]];
//            }
//        }
//    }
//}
//
//- (void)configDeleteButton:(UIButton *)deleteButton {
//    [deleteButton setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
//    deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
////    deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [deleteButton setBackgroundColor:[UIColor clearColor]];
//    [deleteButton.subviews[0] setBackgroundColor:[UIColor clearColor]];
//    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15 * WidthCoefficient, 0, 0);
//}

- (void)setupUI {
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [_editBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateSelected];
    [_editBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    [_editBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
    }];
    
    UIView *botView = [[UIView alloc] init];
    [self.view addSubview:botView];
    [botView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.tableView.bottom);
        make.height.equalTo(60 * WidthCoefficient + kBottomHeight);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [botView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(botView);
        make.height.equalTo(0.5 * WidthCoefficient);
    }];
    
    [botView addSubview:self.deleteBtn];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom);
        make.right.equalTo(botView);
        make.width.equalTo(100 * WidthCoefficient);
        make.height.equalTo(59.5 * WidthCoefficient);
    }];
    
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _allBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_allBtn setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
    [_allBtn setTitle:NSLocalizedString(@"取消全选", nil) forState:UIControlStateSelected];
    [_allBtn setImage:[UIImage imageNamed:@"selected_empty"] forState:UIControlStateNormal];
    [_allBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_allBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [_allBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:self.allBtn];
    [self.allBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(botView).offset(18 * WidthCoefficient);
        make.height.equalTo(24 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.width.equalTo(130 * WidthCoefficient);
    }];
    _allBtn.titleEdgeInsets = UIEdgeInsetsMake(10 * WidthCoefficient, 10 * WidthCoefficient, 10 * WidthCoefficient, 0);
    
}

- (void)createTable {
    [self.view addSubview:self.tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self setupFooter];
}

- (void)setupFooter {
    if (self.tableView.mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullData)];
        //    footer.refreshingTitleHidden = YES;
        if (self.end) {
            [footer setTitle:[NSString stringWithFormat:@"一共%ld个收藏",self.dataSource.count] forState:MJRefreshStateIdle];
        }
        footer.stateLabel.font = [UIFont fontWithName:FontName size:12];
        self.tableView.mj_footer = footer;
    } else {
        if (self.end) {
            [(MJRefreshAutoNormalFooter *)self.tableView.mj_footer setTitle:[NSString stringWithFormat:@"一共%ld个收藏",self.dataSource.count] forState:MJRefreshStateIdle];
        }
    }
}

- (void)pullData {
    NSString *typeStr = @"";
    if (self.type == PoiTypeAll) {
        typeStr = @"";
    }
    if (self.type == PoiTypeAmap) {
        typeStr = @"amap";
    }
    if (self.type == PoiTypeOil) {
        typeStr = @"oil";
    }
    if (self.type == PoiTypePark) {
        typeStr = @"park";
    }
    NSString *lastId = @"";
    if (self.dataSource.count) {
        lastId = self.dataSource.lastObject.poiId;
    }
    [CUHTTPRequest POST:findPoiFavoritesFromApp parameters:@{@"appOffset": [NSNumber numberWithInteger:pageSize],@"id": lastId,@"vin": kVin, @"poiType": typeStr} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        POIList *list = [POIList yy_modelWithDictionary:dic];
        NSArray<ResultItem *> *resultArr = list.data.result;
        if (resultArr.count) {
            if (resultArr.count < pageSize) {
                self.end = YES;
            } else {
                self.end = NO;
            }
            [self.dataSource addObjectsFromArray:resultArr];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {//数据已拉取完毕
            self.end = YES;
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataSource.count == 0) {
            self.editBtn.enabled = NO;
        } else {
            self.editBtn.enabled = YES;
        }
        [self setupFooter];
    } failure:^(NSInteger code) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (MapBaseController *)getPreviousViewController {
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:[FavoritesViewController class]]) {
            return (MapBaseController *)self.navigationController.viewControllers[i-1];
        }
    }
    return nil;
}

- (void)btnClick:(UIButton *)sender {
    if (sender == _editBtn) {
        sender.selected = !sender.selected;
        if (sender.isSelected) {//编辑
            // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
            [self.tableView reloadData];
            
            [self.tableView setEditing:YES animated:YES];
            
            _allBtn.selected = NO;
            
            [self showDeleteButton];
            
            self.tableView.mj_footer = nil;
            
            if (Is_Iphone_X) {
                _tableView.contentInset = UIEdgeInsetsZero;
                _tableView.scrollIndicatorInsets = _tableView.contentInset;
            }

        } else {//完成
            if (Is_Iphone_X) {
                _tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomHeight, 0);
                _tableView.scrollIndicatorInsets = _tableView.contentInset;
            }
            
            [self setupFooter];
            
            [self.selectedDatas removeAllObjects];
            
            [self.tableView setEditing:NO animated:YES];
            
            [self hideDeleteButton];
            
        }
    }
    if (sender == _allBtn) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            // 全选
            NSInteger count = self.dataSource.count;
            for (NSInteger i = 0 ; i < count; i++)
            {
                ResultItem *item = self.dataSource[i];
                if (![self.selectedDatas containsObject:item]) {
                    [self.selectedDatas addObject:item];
                }
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                
            }
        } else {
            // 取消全选
            NSInteger count = self.dataSource.count;
            for (NSInteger i = 0 ; i < count; i++)
            {
                ResultItem *item = self.dataSource[i];
                if ([self.selectedDatas containsObject:item]) {
                    [self.selectedDatas removeObject:item];
                    
                }
                [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
            }
        }
        
        [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
    }
    if (sender == _deleteBtn) {
        [self deleteSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    }
}

// delete
- (void)deleteSelectIndexPaths:(NSArray *)indexPaths
{
    
    NSString *idStr = @"";
    NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:self.selectedDatas.count];
    for (ResultItem *item in self.selectedDatas) {
        [idArr addObject:item.poiId];
    }
    idStr = [idArr componentsJoinedByString:@","];
    
    [CUHTTPRequest POST:deletePoiFavoritesService parameters:@{@"id":idStr} success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"200"]) {
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
            [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
            
            // 验证
            // 没有
            if (self.dataSource.count == 0)
            {
                //没有收藏数据
                
                if(self.editBtn.selected)
                {
                    // 编辑状态 -- 取消编辑状态
                    [self btnClick:self.editBtn];
                }
                
                self.editBtn.enabled = NO;
                
            }
            
            [self setupFooter];
        }
    } failure:^(NSInteger code) {
        
    }];
    
}

- (void)indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.dataSource.count;
    self.allBtn.selected = (currentCount == allCount);
    NSString *title = (currentCount > 0) ? [NSString stringWithFormat:@"删除(%zd)",currentCount] : @"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount > 0;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 * WidthCoefficient;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"FavoriteCellId";
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell configWithModel:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        ResultItem *item = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:item]) {
            [self.selectedDatas addObject:item];
        }
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    } else {
        MapBaseController *vc = [self getPreviousViewController];
        vc.favoriteCallBack(self.dataSource[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing)
    {
        ResultItem *item = self.dataSource[indexPath.row];
        if ([self.selectedDatas containsObject:item]) {
            [self.selectedDatas removeObject:item];
        }
        
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //title调整按钮大小
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {//delete
//        [tableView setEditing:NO animated:YES];
//        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
//        if (![self.selectedDatas containsObject:indexPathM]) {
//            [self.selectedDatas addObject:indexPathM];
//        }
//        [self deleteSelectIndexPaths:@[indexPath]];
//    }];
//    return @[deleteAction];
//}
//
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
        ResultItem *item = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:item]) {
            [self.selectedDatas addObject:item];
        }
        [self deleteSelectIndexPaths:@[indexPath]];
    }
}
//
////- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
////    return NSLocalizedString(@"删除", nil);
////}
//
//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.editingIndexPath = indexPath;
//    [self.view setNeedsLayout]; //触发-(void)viewDidLayoutSubviews
//}
//
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.editingIndexPath = nil;
//}

#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *tmp = [self.tableView indexPathForCell:cell];
    ResultItem *item = self.dataSource[tmp.row];
    if (![self.selectedDatas containsObject:item]) {
        [self.selectedDatas addObject:item];
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

#pragma mark - 显示和隐藏 删除按钮
- (void)showDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-60 * WidthCoefficient - kBottomHeight);
    }];
    
    // 更新约束
    [self updateConstraints];
}

- (void)hideDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
    }];
    
    // 更新约束
    [self updateConstraints];
}

// 更新布局
- (void)updateConstraints
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
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

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ac0042"]] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
        [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.enabled = NO;
        
    }
    return _deleteBtn;
}

@end
