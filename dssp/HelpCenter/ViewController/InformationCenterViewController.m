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
#import "InfoMessageLeftCell.h"
#import "InputAlertView.h"
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
@property (nonatomic, strong) NSMutableDictionary *result3;
@end

@implementation InformationCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"智能管家", nil);
    [self createTableView];
    [self pullData];
   
}

- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] init];
//     self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
//    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.backgroundColor= [UIColor clearColor];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
    
    self.tableView.backgroundView = imageView;
    
    // cellForRowAtIndexPath
    
//    cell.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//     adjustsScrollViewInsets_NO(_tableView,self);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[InfoMessageHelpCenterCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageHelpCenterCell class])];
    [self.tableView registerClass:[InfoMessageUserCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageUserCell class])];
     [self.tableView registerClass:[InfoMessageLeftCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageLeftCell class])];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    UIView *view = [[UIView alloc] init];
//    self.tableView.tableFooterView = view;
    
    
//    [self.tableView registerClass:[InfoMessageHelpCenterCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageHelpCenterCell class])];
//    [self.tableView registerClass:[InfoMessageUserCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageUserCell class])];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.dataSource.count != 0)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

    });
 
}

/**
 * 返回每一行的估计高度
 * 只要返回了估计高度，那么就会先调用tableView:cellForRowAtIndexPath:方法创建cell，再调   用tableView:heightForRowAtIndexPath:方法获取cell的真实高度
 */
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 380 * WidthCoefficient;//不要设置的太小
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoMessage *message = self.dataSource[indexPath.row];
    
    if (message.type == InfoMessageTypeOther) {
        InfoMessageHelpCenterCell *cell = [InfoMessageHelpCenterCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *str1,NSString *str2,NSString *str3) {
            
            cell.backgroundColor=[UIColor clearColor];
            NSLog(@"click:%@",sender.titleLabel.text);
            NSLog(@"click:%@",self.dataArray);
            NSLog(@"%@888",message.serviceParentId);
            if ([sender.titleLabel.text isEqualToString:@"是"]) {
                NSDictionary *paras = @{
                                        @"isHelp": @"1",
                                        @"noHelp": @"1",
                                        @"id":str2
                                        };
                [CUHTTPRequest POST:dynamicUpdateServiceKnowledgeProfileById parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:@"提交反馈成功"];
                        InfoMessage *message1 = [[InfoMessage alloc] init];
                        message1.type = InfoMessageTypeTwo;
                        message1.choices = @[@"确定",@"关闭"];
                        message1.serviceDetails = @"是否继续使用dssp知识库服务";
                        [self sendMessage:message1];
                        
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
                                        @"id":str2
                                        };
                [CUHTTPRequest POST:dynamicUpdateServiceKnowledgeProfileById parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        [MBProgressHUD showText:@"提交反馈成功"];
                        InfoMessage *message1 = [[InfoMessage alloc] init];
                        message1.type = InfoMessageTypeTwo;
                        message1.choices = @[@"咨询",@"否"];
                        message1.serviceDetails = @"是否继续咨询客服人员";
                        [self sendMessage:message1];
                        
                    } else {
                        
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
            
//                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                        [MBProgressHUD showText:@"提交反馈成功"];
//
//
//                    }
//                        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//                        [InputalertView initWithTitle:@"是否拨打人工服务?" img:@"警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否", nil] ];
//                        //            InputalertView.delegate = self;
//                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
//                        [keywindow addSubview: InputalertView];
//
//                        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
//                            if (btn.tag == 100) {//左边按钮
//
//                                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-400800888"];
//                                UIWebView *callWebview = [[UIWebView alloc] init];
//                                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//                                [self.view addSubview:callWebview];
//
//                            }
//                            if(btn.tag ==101)
//                            {
//
//                                //右边按钮
//                                NSLog(@"666%@",str);
//                            }

//                        };
                    
                        
//                        InfoMessage *message1 = [[InfoMessage alloc] init];
//                        message1.type = InfoMessageTypeTwo;
//                        message1.serviceDetails = @"是否继续使用dssp知识库服务";
//                        [self sendMessage:message1];
                        
//                    }
//                    else
//                    {
//
//                        [MBProgressHUD showText:dic[@"msg"]];
//                    }
                    
                } failure:^(NSInteger code) {
                    
                }];
            }
            else
            {
                NSArray *values = @[@"10010",@"10012",@"10001",@"10002",@"10003",@"10004",@"10005",@"10006",@"10007",@"10013",@"10009",@"10008",@"10014",@"10015",@"10011",@"10016"];
                
                NSArray *keys = @[@"MapHomeViewController",@"RefuelViewController",@"WifiViewController",@"UpkeepViewController",@"CarflowViewController",@"CarTrackViewController",@"TrafficReportViewController",@"驾驶行为",@"LllegalViewController",@"RealVinViewcontroller",@"紧急救援",@"道路救援",@"商品列表",@"OrderPageController",@"智慧停车",@"地图升级"];
                
                self.result3 = [NSMutableDictionary new];

                //根据value取页面名称
                for (int i = 0; i < values.count; i++) {
                    [self.result3 setObject:keys[i] forKey:values[i]];
//                    [_imgArray addObject:[_result objectForKey:_titleArray[i]]];
                }
                
                InfoMessage *messageMe = [[InfoMessage alloc] init];
                messageMe.text = sender.titleLabel.text;
                messageMe.type = InfoMessageTypeMe;
                [self sendMessage:messageMe];
                NSString *sourceData = nil;
                if ([self isBlankString:str3] ) {
                   
                    sourceData = @"0";
                }
                else
                {
                   sourceData = str3;
                    
                }
                
                NSDictionary *paras = @{
                                        @"serviceParentId":str1,
                                        @"sourceData":sourceData
                                        };
                [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        NSDictionary *dic1 = dic[@"data"];
                        _dataArray =[[NSMutableArray alloc] init];
                        InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
                        message.type = InfoMessageTypeOther;
                        [self sendMessage:message];
                        
                        NSLog(@"4433%@",message.appServiceNum);
                        if (![self isBlankString:message.appServiceNum]) {
                            UIViewController *vc = [[NSClassFromString([_result3 objectForKey:message.appServiceNum]) alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }

                    } else {
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                    
                } failure:^(NSInteger code) {
                    
                    
                }];
                
            }
            
        }];
        cell.message = message;
        return cell;
    }
    if (message.type == InfoMessageTypeMe) {
        InfoMessageUserCell *cell = [InfoMessageUserCell cellWithTableView:tableView];
          cell.backgroundColor=[UIColor clearColor];
        cell.message = message;
        return cell;
    }
    if (message.type == InfoMessageTypeTwo) {
       
         InfoMessageLeftCell *cell = [InfoMessageLeftCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *str1,NSString *str2,NSString *str3) {
            
              if ([sender.titleLabel.text isEqualToString:@"确定"]) {
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
                          [self sendMessage:message];
                          
                      } else {
                          
                          [MBProgressHUD showText:dic[@"msg"]];
                      }
                      
                      
                  } failure:^(NSInteger code) {
                      
                      
                  }];
              }
              else if([sender.titleLabel.text isEqualToString:@"咨询"])
              {
                  NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-400800888"];
                  UIWebView *callWebview = [[UIWebView alloc] init];
                  [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                  [self.view addSubview:callWebview];
                 
              }
              else if([sender.titleLabel.text isEqualToString:@"否"])
              {
                 
                  
              }
              else
              {
                 [self.navigationController popToRootViewControllerAnimated:YES];
              }
 
         }];
        
        cell.backgroundColor=[UIColor clearColor];
        cell.message = message;
        return cell;
    }
    return nil;
}

- (void)scrollTableToFoot:(BOOL)animated
{
    
}

- (BOOL)isBlankString:(NSString *)string {
    
         if (string == nil || string == NULL) {
                 return YES;
            }
        if ([string isKindOfClass:[NSNull class]]) {
        
                return YES;
            }
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
       
                return YES;
             }
    
        return NO;
}


- (NSMutableArray<InfoMessage *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

