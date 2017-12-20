//
//  childVIew.h
//  ZXPageScrollView
//
//  Created by anphen on 2017/3/29.
//  Copyright © 2017年 anphen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface childVIew : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic,strong) UITableView *tableView;
- (void)fetchData;

@end
