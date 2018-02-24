//
//  InformationCenterViewController.m
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#define CONF_SET(_K, _V) _V == nil ? [[NSUserDefaults standardUserDefaults] removeObjectForKey:_K] : [[NSUserDefaults standardUserDefaults] setObject:_V forKey:_K]
#define CONF_GET(_K) [[NSUserDefaults standardUserDefaults] objectForKey:_K]
#import "InformationCenterViewController.h"
#import "InfoMessageHelpCenterCell.h"
#import "InfoMessageUserCell.h"

@interface InformationCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<InfoMessage *> *dataSource;
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) InfoMessage *message;
@property (nonatomic, strong) NSMutableDictionary *result;
@property (nonatomic, strong) NSMutableDictionary *result1;
@property (nonatomic, strong) NSMutableDictionary *result2;
@property (nonatomic, copy) NSString *serviceParentIds;
@property (nonatomic, copy) NSString *serviceParentIds1;
@end

@implementation InformationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"咨询中心", nil);
    
    [self createTableView];
    [self pullData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     adjustsScrollViewInsets_NO(_tableView,self);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[InfoMessageHelpCenterCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageHelpCenterCell class])];
    [self.tableView registerClass:[InfoMessageUserCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageUserCell class])];
}

- (void)pullData {
    
    NSDictionary *paras = @{
                            @"serviceParentId":@"0",
                            @"sourceData":@"0"
                            
                            };
    [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic1 = dic[@"data"];
            InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            //现在时间,你可以输出来看下是什么格式
            NSDate *datenow = [NSDate date];
            message.time = datenow;
            message.type = InfoMessageTypeOther;
            [self.dataSource removeAllObjects];
            
            [self sendMessage:message];
            
            
        } else {
            
            [MBProgressHUD showText:dic[@"msg"]];
        }
        
        
    } failure:^(NSInteger code) {
        
        
    }];
    
}

- (void)sendMessage:(InfoMessage *)message {
    
    if (self.dataSource > 0) {
        NSDate *lastDate = self.dataSource.lastObject.time;
        message.time = [NSDate date];
//         message.showTime = YES;
        NSTimeInterval interval = [message.time timeIntervalSinceDate:lastDate];
        if (interval > 5 * 60) {//5分钟后显示时间
            message.showTime = YES;
        }
    } else {
        message.time = [NSDate date];
        message.showTime = YES;
    }
    
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    
//
    
    if (self.dataSource.count > 4) {
//          self.tableView.frame = CGRectMake(0, 100+64, 375, 667 - 64  - 30);
//        [self.tableView setContentOffset:CGPointMake(0, self.tableView.bounds.size.height) animated:YES];
//
        
//          [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//          [self.tableView reloadData];
    }

}

/**
 * 返回每一行的估计高度
 * 只要返回了估计高度，那么就会先调用tableView:cellForRowAtIndexPath:方法创建cell，再调   用tableView:heightForRowAtIndexPath:方法获取cell的真实高度
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 380 * WidthCoefficient;//不要设置的太小
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoMessage *message = self.dataSource[indexPath.row];
    
    if (message.type == InfoMessageTypeOther) {
        InfoMessageHelpCenterCell *cell = [InfoMessageHelpCenterCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *str1) {
            NSLog(@"click:%@",sender.titleLabel.text);
            NSLog(@"click:%@",self.dataArray);
            NSLog(@"%@888",message.serviceParentId);
            
            if ([sender.titleLabel.text isEqualToString:@"是"]) {
                
                NSDictionary *paras = @{
                                        @"isHelp": @"1",
                                        @"noHelp": @"1",
                                        @"id":str1
                                        };
                [CUHTTPRequest POST:dynamicUpdateServiceKnowledgeProfileById parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:@"提交反馈成功"];
                        
                    } else {
                        
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                    
                } failure:^(NSInteger code) {
                    
                }];
                
                
            }
            else if ([sender.titleLabel.text isEqualToString:@"否"])
            {
                NSDictionary *paras = @{
                                        @"isHelp": @"1",
                                        @"noHelp": @"1",
                                        @"id":@"2"
                                        };
                [CUHTTPRequest POST:dynamicUpdateServiceKnowledgeProfileById parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:@"提交反馈成功"];
                        
                    } else {
                        
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                    
                } failure:^(NSInteger code) {
                    
                }];
                
                
            }
            else
            {
              
                
                InfoMessage *messageMe = [[InfoMessage alloc] init];
                messageMe.text = sender.titleLabel.text;
                messageMe.type = InfoMessageTypeMe;
                [self sendMessage:messageMe];
                
                NSDictionary *paras = @{
                                        @"serviceParentId":str1,
                                        @"sourceData":@"0"
                                        };
                [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        NSDictionary *dic1 = dic[@"data"];
                        _dataArray =[[NSMutableArray alloc] init];
                        InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
                        
                        message.type = InfoMessageTypeOther;
                        [self sendMessage:message];
                        
                    
                    } else {
                        
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                    
                } failure:^(NSInteger code) {
                    
                    
                }];
                
            }
            
            
            
            
            //            if (message.serviceParentId == nil) {
            
            //            }
            
            
        }];
        cell.message = message;
        return cell;
    }
    if (message.type == InfoMessageTypeMe) {
        InfoMessageUserCell *cell = [InfoMessageUserCell cellWithTableView:tableView];
        cell.message = message;
        return cell;
    }
    return nil;
}

- (void)scrollTableToFoot:(BOOL)animated
{
    
}



- (NSMutableArray<InfoMessage *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

