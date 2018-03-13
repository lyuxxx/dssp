//
//  WMViewController.h
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface WMViewController : BaseViewController
@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, copy) NSString *indexs;
@property (nonatomic, assign) BOOL doNotRefresh;
@property (nonatomic,strong) UITableView *tableView;
@end
