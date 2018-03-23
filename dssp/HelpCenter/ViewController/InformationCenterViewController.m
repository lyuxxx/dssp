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
#import "VINBindingViewController.h"
#import "DKSTextView.h"
#import "DKSKeyboardView.h"
#import <IQKeyboardManager.h>
@interface InformationCenterViewController () <UITableViewDelegate, UITableViewDataSource,DKSKeyboardDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DKSKeyboardView *keyView;
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

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHides) name:@"keyboardHides" object:nil];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"智能管家", nil);
    [self createTableView];
    [self pullData];
   
}

- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView = [[UITableView alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - 50) style:UITableViewStylePlain];
    
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
//    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
//    UIView *view = [[UIView alloc] init];
//    self.tableView.tableFooterView = view;
    
    
//    [self.tableView registerClass:[InfoMessageHelpCenterCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageHelpCenterCell class])];
//    [self.tableView registerClass:[InfoMessageUserCell class] forCellReuseIdentifier:NSStringFromClass([InfoMessageUserCell class])];
    
    // 注册键盘的通知hide or show
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //给UITableView添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    //添加输入框
    self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, kScreenHeight -kNaviHeight-50-kBottomHeight, kScreenWidth, 50)];
    self.keyView.backgroundColor = [UIColor colorWithHexString:@"#232120"];
    
    [self.keyView.moreBtn addTarget:self action:@selector(clickSengMsg:) forControlEvents:UIControlEventTouchUpInside];
    //设置代理方法
    self.keyView.delegate = self;
    [self.view addSubview:_keyView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

// 监听键盘弹出
- (void)keyBoardShow:(NSNotification *)noti
{
    // 咱们取自己需要的就好了
    CGRect rec = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(rec));
    // 小于，说明覆盖了输入框
    if ([UIScreen mainScreen].bounds.size.height - rec.size.height < self.inputView.frame.origin.y + self.inputView.frame.size.height)
    {
        // 把我们整体的View往上移动
        CGRect tempRec = self.view.frame;
        tempRec.origin.y = - (rec.size.height);
        self.view.frame = tempRec;
    }
    // 由于可见的界面缩小了，TableView也要跟着变化Frame
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - 50- rec.size.height);
    if (self.dataSource.count != 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
}

-(void)keyboardHides
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.frame = CGRectMake(0,kNaviHeight, kScreenWidth, kScreenHeight);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight-50);
        
        self.keyView.frame = CGRectMake(0, kScreenHeight -kNaviHeight-50-kBottomHeight, kScreenWidth, 50);
        
    });
    
}

// 监听键盘隐藏
- (void)keyboardHide:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.frame = CGRectMake(0,kNaviHeight, kScreenWidth, kScreenHeight);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight-50);
        
        self.keyView.frame = CGRectMake(0, kScreenHeight -kNaviHeight-50-kBottomHeight, kScreenWidth, 50);

    });
}


- (void)clickSengMsg:(UIButton *)btn
{


    //通知键盘消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];

    
    if (self.keyView.textView.text.length>1 ||self.keyView.textView.text.length == 1) {
       
//        dispatch_async(dispatch_get_main_queue(), ^{
            InfoMessage *messageMe = [[InfoMessage alloc] init];
            messageMe.text = self.keyView.textView.text;
            messageMe.type = InfoMessageTypeMe;
            [self sendMessage:messageMe];
            
//        });
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DKSTextView" object:nil userInfo:nil];
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataSource.count != 0)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
  
    
        
        NSDictionary *result = CONF_GET(@"resultId");
        NSDictionary *result1 = CONF_GET(@"resultsourceData");
        NSDictionary *result2 = CONF_GET(@"appServiceNum");
        
        NSString *str3 =[result objectForKey:self.keyView.textView.text];
        
        NSString *str4 =[result1 objectForKey:self.keyView.textView.text];
        NSString *str5 =[result2 objectForKey:self.keyView.textView.text];
        
        NSDictionary * dic3 = @{ @"10010":@"MapHomeViewController",
                                 @"10012":@"RefuelViewController",
                                 @"10001":@"WifiViewController",
                                 @"10002":@"UpkeepViewController",
                                 @"10003":@"CarflowViewController",
                                 @"10004":@"CarTrackViewController",
                                 @"10005":@"TrafficReportController",
                                 @"10006":@"DrivingWeekReportViewController",
                                 @"10007":@"LllegalViewController",
                                 @"10013":@"RealVinViewcontroller",
                                 @"10009":@"MapUpdateViewController",
                                 @"10008":@"TrackListViewController",
                                 @"10014":@"StorePageController",
                                 @"10015":@"OrderPageController",
                                 @"10011":@"ParkingViewController"
                                 
                                 };
        
        if([dic3 objectForKey:str5])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                InfoMessage *message = [[InfoMessage alloc] init];
                message.type = InfoMessageTypeTwo;
                message.choices = @[@"确定",@"关闭"];
                message.serviceDetails = @"没有查询到问题，是否继续使用dssp知识库服务?";
                [self sendMessage:message];
                
            });
            
        }
        
        else
        {
        NSString *sourceData = nil;
        if ([self isBlankString:str4] ) {
            sourceData = @"0";
        }
        else
        {
            sourceData = str4;
            
        }
        
        self.keyView.textView.text = @"";
        NSDictionary *paras = @{
                                @"serviceParentId":str3,
                                @"sourceData":sourceData
                                };
        [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary *dic1 = dic[@"data"];
                //                        _dataArray =[[NSMutableArray alloc] init];
                InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
                message.type = InfoMessageTypeOther;
                [self sendMessage:message];
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    InfoMessage *message = [[InfoMessage alloc] init];
                    message.type = InfoMessageTypeTwo;
                    message.choices = @[@"确定",@"关闭"];
                    message.serviceDetails = @"没有查询到问题，是否继续使用dssp知识库服务?";
                    [self sendMessage:message];
                    
                });
              
                
//                [MBProgressHUD showText:dic[@"msg"]];
            }
            
        } failure:^(NSInteger code) {
            
            
        }];
    }
 }
      
}

//发送的文zi
- (void)textViewContentText:(NSString *)textStr {

    //通知键盘消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    
    if (textStr.length>1 ||textStr.length == 1) {
//        dispatch_async(dispatch_get_main_queue(), ^{
            InfoMessage *messageMe = [[InfoMessage alloc] init];
            messageMe.text = textStr;
            messageMe.type = InfoMessageTypeMe;
            [self sendMessage:messageMe];
            
//        });
         [[NSNotificationCenter defaultCenter] postNotificationName:@"DKSTextView" object:nil userInfo:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dataSource.count != 0)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
        
        
        NSDictionary *result = CONF_GET(@"resultId");
        NSDictionary *result1 = CONF_GET(@"resultsourceData");
        NSDictionary *result2 = CONF_GET(@"appServiceNum");
        
        NSString *str3 =[result objectForKey:self.keyView.textView.text];
        NSString *str4 =[result1 objectForKey:self.keyView.textView.text];
        NSString *str5 =[result2 objectForKey:self.keyView.textView.text];
        NSDictionary * dic3 = @{ @"10010":@"MapHomeViewController",
                                 @"10012":@"RefuelViewController",
                                 @"10001":@"WifiViewController",
                                 @"10002":@"UpkeepViewController",
                                 @"10003":@"CarflowViewController",
                                 @"10004":@"CarTrackViewController",
                                 @"10005":@"TrafficReportController",
                                 @"10006":@"DrivingWeekReportViewController",
                                 @"10007":@"LllegalViewController",
                                 @"10013":@"RealVinViewcontroller",
                                 @"10009":@"MapUpdateViewController",
                                 @"10008":@"TrackListViewController",
                                 @"10014":@"StorePageController",
                                 @"10015":@"OrderPageController",
                                 @"10011":@"ParkingViewController"
                                 
                                 };
        
        if([dic3 objectForKey:str5])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                InfoMessage *message = [[InfoMessage alloc] init];
                message.type = InfoMessageTypeTwo;
                message.choices = @[@"确定",@"关闭"];
                message.serviceDetails = @"没有查询到问题，是否继续使用dssp知识库服务?";
                [self sendMessage:message];
                
            });
            
        }
        
        else
        {
        
        NSString *sourceData = nil;
        if ([self isBlankString:str4] ) {
            sourceData = @"0";
        }
        else
        {
            sourceData = str4;
            
        }
        NSDictionary *paras = @{
                                @"serviceParentId":str3,
                                @"sourceData":sourceData
                                };
        [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary *dic1 = dic[@"data"];
                //                        _dataArray =[[NSMutableArray alloc] init];
                InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
                message.type = InfoMessageTypeOther;
                [self sendMessage:message];
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    InfoMessage *message = [[InfoMessage alloc] init];
                    message.type = InfoMessageTypeTwo;
                    message.choices = @[@"确定",@"关闭"];
                    message.serviceDetails = @"没有查询到问题，是否继续使用dssp知识库服务?";
                    [self sendMessage:message];
                    
                });
//                [MBProgressHUD showText:dic[@"msg"]];
            }
            
        } failure:^(NSInteger code) {
            
            
        }];
    }
  }
}

#pragma mark ====== 点击UITableView ======
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //收回键盘
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
//    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}


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
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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
        InfoMessageHelpCenterCell *cell = [InfoMessageHelpCenterCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *str1,NSString *str2,NSString *str3,NSString *str4) {
            
//            cell.backgroundColor=[UIColor clearColor];
            NSLog(@"click:%@",sender.titleLabel.text);
            NSLog(@"click:%@",self.dataArray);
            NSLog(@"%@888",message.serviceParentId);
            
            NSDictionary * dic2 = @{ @"10010":@"MapHomeViewController",
                                     @"10012":@"RefuelViewController",
                                     @"10001":@"WifiViewController",
                                     @"10002":@"UpkeepViewController",
                                     @"10003":@"CarflowViewController",
                                     @"10004":@"CarTrackViewController",
                                     @"10005":@"TrafficReportController",
                                     @"10006":@"DrivingWeekReportViewController",
                                     @"10007":@"LllegalViewController",
                                     @"10013":@"RealVinViewcontroller",
                                     @"10009":@"MapUpdateViewController",
                                     @"10008":@"TrackListViewController",
                                     @"10014":@"StorePageController",
                                     @"10015":@"OrderPageController",
                                     @"10011":@"ParkingViewController"
                                 
                                     };
            
 
            if ([sender.titleLabel.text isEqualToString:@"是"]) {
                NSDictionary *paras = @{
                                        @"isHelp": @"1",
                                        @"noHelp": @"1",
                                        @"id":str2
                                        };
                [CUHTTPRequest POST:dynamicUpdateServiceKnowledgeProfileById parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                        [MBProgressHUD showText:@"提交反馈成功"];
                        InfoMessage *message = [[InfoMessage alloc] init];
                        message.type = InfoMessageTypeTwo;
                        message.choices = @[@"确定",@"关闭"];
                        message.serviceDetails = @"是否继续使用dssp知识库服务?";
                        [self sendMessage:message];
                        
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
//                        [MBProgressHUD showText:@"提交反馈成功"];
                        InfoMessage *message = [[InfoMessage alloc] init];
                        message.type = InfoMessageTypeTwo;
                        message.choices = @[@"咨询客服",@"关闭"];
                        message.serviceDetails = @"是否拨打客服电话继续咨询?";
                        [self sendMessage:message];
                        
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
            else if ([dic2 objectForKey:str4])
            {
                
                if ([kVin isEqualToString:@""]) {
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                    [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"首页弹窗背景" type:12 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                    //            InputalertView.delegate = self;
                    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                    [keywindow addSubview: popupView];
                    
                    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                        
                        if(btn.tag ==100)
                        {
                            //响应事件
                            VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }
                        
                    };
                }
                else
                {
                    //非T车
                    if([CuvhlTStatus isEqualToString:@"0"])
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                        [popupView initWithTitle:@"您当前不是T用户无法使用服务，若想使用服务，请升级为T用户!" img:@"首页弹窗背景" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                        //            InputalertView.delegate = self;
                        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                        [keywindow addSubview: popupView];
                        
                        popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                            if (btn.tag == 100) {//左边按钮
                                
                                
                            }
                            
                        };
                    }
                    else if ([CuvhlTStatus isEqualToString:@"1"])
                    {
                        
                        if([KcertificationStatus isEqualToString:@"1"])
                        {
                            //T车辆
                            UIViewController *vc = [[NSClassFromString([dic2 objectForKey:str4]) alloc] init];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                        }
                        else
                        {
                            
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
                            [popupView initWithTitle:@"您当前还未完成实名制认证无法使用服务!" img:@"首页弹窗背景" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
                            //            InputalertView.delegate = self;
                            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
                            [keywindow addSubview: popupView];
                            
                            popupView.clickBlock = ^(UIButton *btn,NSString *str) {
                                if (btn.tag == 100) {//左边按钮
                                    
                                    
                                    
                                }
                                
                                
                            };
                            
                        }
                    }
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    InfoMessage *messageMe = [[InfoMessage alloc] init];
                    messageMe.text = sender.titleLabel.text;
                    messageMe.type = InfoMessageTypeMe;
                    [self sendMessage:messageMe];
                    
                });
                
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
//                        _dataArray =[[NSMutableArray alloc] init];
                        InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
                        message.type = InfoMessageTypeOther;
                        [self sendMessage:message];

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
       
         InfoMessageLeftCell *cell = [InfoMessageLeftCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *str1,NSString *str2,NSString *str3,NSString *str4) {
            
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
                          
                         
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              message.time = datenow;
                              message.type = InfoMessageTypeOther;
                              [self sendMessage:message];
                              
                          });
                          
                        

                      } else {

                          [MBProgressHUD showText:dic[@"msg"]];
                      }

                  } failure:^(NSInteger code) {


                  }];
              }
              else if([sender.titleLabel.text isEqualToString:@"咨询客服"])
              {
                  NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-400800888"];
                  UIWebView *callWebview = [[UIWebView alloc] init];
                  [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                  [self.view addSubview:callWebview];
                 
              }
              else if([sender.titleLabel.text isEqualToString:@"关闭"])
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

