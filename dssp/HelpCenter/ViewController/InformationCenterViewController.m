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
#import "RealVinViewcontroller.h"
#import "BaseWebViewController.h"
#import "FeedbackShowImageView.h"
#import "UserModel.h"
#import "StoreTabViewController.h"
#import "FeedbackController.h"

//  作为控件的imageView的tag值基数
#define kImageTag 9999

@interface InformationCenterViewController () <UITableViewDelegate, UITableViewDataSource,DKSKeyboardDelegate,SevenProtocolDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DKSKeyboardView *keyView;
@property (nonatomic, strong) NSMutableArray<InfoMessage *> *dataSource;
@property (nonatomic, strong) NSMutableDictionary *imgCellHeightDict;
@property (nonatomic, strong) NSDictionary *funcDict;
@end

@implementation InformationCenterViewController

#pragma mark- 方法重载
- (BOOL)needGradientBg {
    return NO;
}

#pragma mark- 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHides) name:@"keyboardHides" object:nil];
    self.navigationItem.title = NSLocalizedString(@"智能管家", nil);
    [self createTableView];
    [self pullData];
    [self refreshUserModel];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark- 创建tableView及子控件
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight-50-kBottomHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"背景"]];
    
    if (@available(iOS 11.0, *)) {
        //_tableView.estimatedRowHeight = 0;
    } else {
        _tableView.estimatedRowHeight = 380 * WidthCoefficient;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    // 注册键盘的通知hide or show
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHides) name:UIKeyboardWillHideNotification object:nil];
    
    //给UITableView添加手势
    weakifySelf
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        strongifySelf
        [self.keyView.textView resignFirstResponder];
    }];;
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.numberOfTapsRequired = 1;
    //tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    //添加输入框
    self.keyView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, kScreenHeight -kNaviHeight-50-kBottomHeight, kScreenWidth, 50)];
    self.keyView.backgroundColor = [UIColor colorWithHexString:@"#232120"];
    [self.keyView.moreBtn addTarget:self action:@selector(clickSengMsg:) forControlEvents:UIControlEventTouchUpInside];
    //设置输入框的代理方法
    self.keyView.delegate = self;
    [self.view addSubview:_keyView];
}

#pragma mark- 监听键盘弹出
- (void)keyBoardShow:(NSNotification *)noti {
    // 咱们取自己需要的就好了
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"rect:%@",NSStringFromCGRect(rect));
    // 小于，说明覆盖了输入框
    if ([UIScreen mainScreen].bounds.size.height - rect.size.height < self.inputView.frame.origin.y + self.inputView.frame.size.height) {
        // 把我们整体的View往上移动
        CGRect tempRec = self.view.frame;
        tempRec.origin.y = - (rect.size.height);
        self.view.frame = tempRec;
    }
    // 由于可见的界面缩小了，TableView也要跟着变化Frame
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - 50- rect.size.height - kBottomHeight);
    if (self.dataSource.count != 0) {
        [self tableViewScrollToBottom];
    }
}

#pragma mark- 监听键盘隐藏
-(void)keyboardHides {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.frame = CGRectMake(0,kNaviHeight, kScreenWidth, kScreenHeight);
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNaviHeight - 50 - kBottomHeight);
        self.keyView.frame = CGRectMake(0, kScreenHeight -kNaviHeight-50-kBottomHeight, kScreenWidth, 50);
    });
}

#pragma mark- tableView的滑动
- (void)tableViewScrollToBottom {
    if (@available(iOS 11.0, *)) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } else {
        if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
            [self.tableView scrollToBottomAnimated:NO];
        }
    }
}

#pragma mark- 点击输入框上的确定按钮
- (void)clickSengMsg:(UIButton *)btn
{
    //通知键盘消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    if (self.keyView.textView.text.length) {
        InfoMessage *messageMe = [[InfoMessage alloc] init];
        messageMe.text = self.keyView.textView.text;
        messageMe.type = InfoMessageTypeMe;
        [self sendMessage:messageMe];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"DKSTextView" object:nil userInfo:nil];
    

        NSDictionary *result = CONF_GET(@"resultId");
        NSDictionary *result1 = CONF_GET(@"resultsourceData");
        NSDictionary *result2 = CONF_GET(@"appServiceNum");
        
        NSString *str3 =[result objectForKey:self.keyView.textView.text];
        NSString *str4 =[result1 objectForKey:self.keyView.textView.text];
        NSString *str5 =[result2 objectForKey:self.keyView.textView.text];
        

        if([self.funcDict objectForKey:str5]) {
            InfoMessage *message = [[InfoMessage alloc] init];
            message.type = InfoMessageTypeTwo;
            message.choices = @[@"拨打热线",@"不用了"];//@[@"已解答",@"未解答"];
            message.serviceDetails = @"未查询到相关信息!\n是否解答您的问题?";
            [self sendMessage:message];

            self.keyView.textView.text = @"";
            
        } else {
            NSString *sourceData = nil;
            if ([NSString isBlankString:str4] ) {
                sourceData = @"0";
            } else {
                sourceData = str4;
            }
    //        self.keyView.textView.text = @"";
            NSDictionary *paras = @{
    //                                @"serviceParentId":str3,
    //                                @"sourceData":sourceData
                                    @"searchKey":self.keyView.textView.text
                                    };
            self.keyView.textView.text = @"";
           
            [CUHTTPRequest POST:findValueBySearchValue parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                
                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                    
                    if (dic[@"data"] != nil && ![ dic[@"data"] isKindOfClass:[NSNull class]] &&  [dic[@"data"] count] != 0) {
                        NSDictionary *dic1 = dic[@"data"];
                        InfoMessage *message = [InfoMessage yy_modelWithDictionary:dic1];
                        if ([message.serviceName isEqualToString:@"未查询到相关信息!"]) {
                            message.type = InfoMessageTypeTwo;
                            message.choices = @[@"拨打热线",@"不用了"];//@[@"已解答",@"未解答"];
                            message.serviceDetails = @"未查询到相关信息!\n是否解答您的问题?";
                            [self sendMessage:message];
                        }else {
                            message.type = InfoMessageTypeOther;
                            [self sendMessage:message];
                        }
                    }
                    else {
                        InfoMessage *message = [[InfoMessage alloc] init];
                        message.type = InfoMessageTypeTwo;
                        message.choices = @[@"拨打热线",@"不用了"];//@[@"已解答",@"未解答"];
                        message.serviceDetails = @"未查询到相关信息!\n是否解答您的问题?";
                        [self sendMessage:message];
                    }
                    
                } else {
                    
                    InfoMessage *message = [[InfoMessage alloc] init];
                    message.type = InfoMessageTypeTwo;
                    message.choices = @[@"拨打热线",@"不用了"];//@[@"已解答",@"未解答"];
                    message.serviceDetails = @"未查询到相关信息!\n是否解答您的问题?";
                    [self sendMessage:message];
                        
    //                [MBProgressHUD showText:dic[@"msg"]];
                }
                
            } failure:^(NSInteger code) {
                
            }];
    }
 }
      
}

#pragma mark- 第一次请求数据
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
            //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
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

#pragma mark- 发送消息
- (void)sendMessage:(InfoMessage *)message {

    if (self.dataSource > 0) {
        NSDate *lastDate = self.dataSource.lastObject.time;
        message.time = [NSDate date];
        NSTimeInterval interval = [message.time timeIntervalSinceDate:lastDate];
        if (interval > 5 * 60) {
            //5分钟后显示时间
            message.showTime = YES;
        }
    } else {
        message.time = [NSDate date];
        message.showTime = YES;
    }
    
    [self.dataSource addObject:message];
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.dataSource.count != 0) {
            [self tableViewScrollToBottom];
        }

    });
 
}

#pragma mark- 跳转到不同的控制器
- (void)jumpByFuncDictWihtAppNum:(NSString *)appNum {
    if ([self.funcDict[appNum] isEqualToString:@"StorePageController"]) {
        StoreTabViewController *storeTab = [[StoreTabViewController alloc] init];
        storeTab.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeTab animated:YES];
    } else if ([self.funcDict[appNum] isEqualToString:@"OrderPageController"]) {
        StoreTabViewController *storeTab = [[StoreTabViewController alloc] init];
        storeTab.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:storeTab animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [storeTab gotoOrderPageController];
        });
    } else {
        UIViewController *vc = [[NSClassFromString([self.funcDict objectForKey:appNum]) alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ====== 点击UITableView ======
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //    收回键盘
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHide" object:nil];
    //若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
*/

#pragma mark- HelperCenterCell的代理方法
- (void)sevenProrocolMethod:(NSString *)cellUrl {
    BaseWebViewController *vc = [[BaseWebViewController alloc] initWithURL:cellUrl];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showPic:(UIImage *)image {
    [self.keyView.textView resignFirstResponder];
    NSLog("手势的点击事件");
    #warning 这里为了复用意见反馈的预览图片 所以对传入的参数进行了封装 9999 是预定的tag初始值 因为对于图片数组的会移除最后一个 所以这里添加了一个空图片对象
    NSMutableArray<UIImage *> *imageArray = [NSMutableArray array];
    [imageArray addObject:image];
    [imageArray addObject:[UIImage new]];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [window addSubview:maskview];
    
    FeedbackShowImageView *fbImageV = [[FeedbackShowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds byClick:kImageTag appendArray:imageArray];
    [fbImageV show:maskview didFinish:^(){
        [UIView animateWithDuration:0.5f animations:^{
            fbImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [fbImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
}

- (void)updateTableViewWithCell:(InfoMessageHelpCenterCell *)cell CellHeight:(CGFloat)height DownloadSuccess:(BOOL)success {
    NSInteger row = [self.dataSource indexOfObject:cell.message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    //存储过当前cellHeight
    if (![[self.imgCellHeightDict allKeys] containsObject:indexPath]) {
        [self.imgCellHeightDict setObject:[NSNumber numberWithFloat:height] forKey:indexPath];
        [self updateTableViewWithIndexPath:indexPath];
    } else {//存储过
        CGFloat storedHeight = ((NSNumber *)[self.imgCellHeightDict objectForKey:indexPath]).floatValue;
        NSLog(@"###%f\n%f",storedHeight,height);
        if (fabs(storedHeight - height) > 0.000001) {
            [self.imgCellHeightDict setObject:[NSNumber numberWithFloat:height] forKey:indexPath];
            [self updateTableViewWithIndexPath:indexPath];
        }
    }
}

- (void)removeStoredHeightWithCell:(InfoMessageHelpCenterCell *)cell {
    NSInteger row = [self.dataSource indexOfObject:cell.message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if ([[self.imgCellHeightDict allKeys] containsObject:indexPath]) {
        [self.imgCellHeightDict removeObjectForKey:indexPath];
        [self updateTableViewWithIndexPath:indexPath];
    }
}

- (void)updateTableViewWithIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *indexPaths = [self.tableView indexPathsForVisibleRows];
    if ([indexPaths containsObject:indexPath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            //[self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            [self.tableView endUpdates];
            
            if (self.dataSource.count != 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self tableViewScrollToBottom];
                });
            }
        });
    }
}

- (void)functionButtonAction:(UIButton *)button {
    if (button.tag == feedbackTag) {
        FeedbackController *feedbackController = [FeedbackController new];
        [self.navigationController pushViewController:feedbackController animated:YES];
    }else if (button.tag == contactServiceTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",kphonenumber]]];
    }else {
        
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

/**
 * 返回每一行的估计高度
 * 只要返回了估计高度，那么就会先调用tableView:cellForRowAtIndexPath:方法创建cell，再调   用tableView:heightForRowAtIndexPath:方法获取cell的真实高度
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.imgCellHeightDict allKeys] containsObject:indexPath]) {
        return ((NSNumber *)[self.imgCellHeightDict objectForKey:indexPath]).floatValue;
    }
    return self.dataSource[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoMessage *message = self.dataSource[indexPath.row];
    weakifySelf
    
    //  InfoMessageHelpCenterCell类型
    if (message.type == InfoMessageTypeOther) {
        
        InfoMessageHelpCenterCell *cell = [InfoMessageHelpCenterCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *serviceId,NSString *serviceParentId,NSString *sourceDataTmp,NSString *appNum) {
            
            // 点击的是已解答按钮
            if ([sender.titleLabel.text isEqualToString:@"已解答"]) {
                strongifySelf
                
                InfoMessage *message = [[InfoMessage alloc] init];
                message.type = InfoMessageTypeTwo;
                message.choices = nil;
                message.serviceDetails = @"感谢您的支持!";//@"欢迎使用智能客服服务?";
                
                [self infoMessageHelpCenterCellTouchAnswerOrUnanswerWithMessage:message serviceParentId:serviceParentId];
                
            }//  点击的未解答按钮
            else if ([sender.titleLabel.text isEqualToString:@"未解答"]) {
                strongifySelf
                
                InfoMessage *message = [[InfoMessage alloc] init];
                message.type = InfoMessageTypeTwo;
                message.choices = @[@"拨打热线",@"不用了"];
                message.serviceDetails = @"是否拨打400客服热线进一步咨询?";
                
                [self infoMessageHelpCenterCellTouchAnswerOrUnanswerWithMessage:message serviceParentId:serviceParentId];
            }//  点击了跳转功能按钮
            else if ([self.funcDict objectForKey:appNum]) {
            
                //  判断车辆是否绑定过
                if ([kVin isEqualToString:@""]) {
                    
                    strongifySelf
                    [self infoMessageHelpCenterCellBindingCarInfoTips:^{
                        //响应事件
                        VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                } else {
                    //非T车
                    if([CuvhlTStatus isEqualToString:@"0"]) {
                        strongifySelf
                        [self infoMessageHelpCenterCellUpdateTUserTips:^{
                            RealVinViewcontroller *vc=[[RealVinViewcontroller alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                    }
                    // T车
                    else if ([CuvhlTStatus isEqualToString:@"1"]) {
                        
                        if([KcontractStatus isEqualToString:@"1"]) {
                            //T车辆 游客模式与非游客模式的跳转判断
                            if ([KuserName isEqualToString:@"18911568274"]) {
                                
                                //  游客模式下 实名认证 地图升级 进行拦截 其他的允许跳转
                                if([appNum isEqualToString:@"10013"] || [appNum isEqualToString:@"10009"]) {
                                    [MBProgressHUD showText:NSLocalizedString(@"当前为游客模式，无此操作权限", nil)];
                                } else {
                                    strongifySelf
                                    [self jumpByFuncDictWihtAppNum:appNum];
                                }
                                
                            } else {
                                strongifySelf
                                [self jumpByFuncDictWihtAppNum:appNum];
                            }
                            
                        }
                        //  其他情况 其实和CuvhlTStatus isEqualToString:@"0" 的写法基本是一样的 不知道有什么意义
                        else {
                            strongifySelf
                            [self infoMessageHelpCenterCellUpdateTUserTips:nil];
                        }
                    }
                }
            }
            else {
                strongifySelf
                InfoMessage *messageMe = [[InfoMessage alloc] init];
                messageMe.text = sender.titleLabel.text;
                messageMe.type = InfoMessageTypeMe;
                [self sendMessage:messageMe];
                
                NSString *sourceData = nil;
                if ([NSString isBlankString:sourceDataTmp] ) {
                    sourceData = @"0";
                } else {
                    sourceData = sourceDataTmp;
                }
                NSDictionary *paras = @{
                                        @"serviceParentId":serviceId,
                                        @"sourceData":sourceData
                                        };
                
                
                [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    strongifySelf
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        NSDictionary *dict = dic[@"data"];
                        InfoMessage *message = [InfoMessage yy_modelWithDictionary:dict];
                        if (message.serviceImage) {
                            message.type = InfoMessageTypeOther;
                            [self sendMessage:message];
                        } else {
                            message.type = InfoMessageTypeOther;
                            [self sendMessage:message];
                        }
                        
                    } else {
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                    
                } failure:^(NSInteger code) {
                    
                    
                }];
            }
        }];
        cell.customDelegate = self;
        cell.message = message;
        return cell;
    }
    
    if (message.type == InfoMessageTypeMe) {
        InfoMessageUserCell *cell = [InfoMessageUserCell cellWithTableView:tableView];
        cell.message = message;
        return cell;
    }
    
    if (message.type == InfoMessageTypeTwo) {
        InfoMessageLeftCell *cell = [InfoMessageLeftCell cellWithTableView:tableView serviceBlock:^(UIButton *sender,NSString *serviceId,NSString *serviceParentId,NSString *sourceData,NSString *appNum) {
            
            if ([sender.titleLabel.text isEqualToString:@"确定"]) {//没有用
                
                NSDictionary *paras = @{
                                        @"serviceParentId":@"0",
                                        @"sourceData":@"0"
                                        };
                [CUHTTPRequest POST:sendToServiceKnowledgeProfileValue parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                        NSDictionary *dict = dic[@"data"];
                        
                        InfoMessage *message = [InfoMessage yy_modelWithDictionary:dict];
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                        [formatter setDateFormat:@"MM-dd HH:mm:ss"];
                        NSDate *datenow = [NSDate date];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            strongifySelf
                            message.time = datenow;
                            message.type = InfoMessageTypeOther;
                            [self sendMessage:message];
                        });
                        
                    } else {
                        
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                    
                } failure:^(NSInteger code) {
                    
                    
                }];
            } else if([sender.titleLabel.text isEqualToString:@"拨打热线"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",kphonenumber]]];
            } else if([sender.titleLabel.text isEqualToString:@"不用了"] || [sender.titleLabel.text isEqualToString:@"已解答"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    InfoMessage *message = [[InfoMessage alloc] init];
                    message.type = InfoMessageTypeTwo;
                    message.choices = nil;
                    message.serviceDetails = @"感谢您的支持!";//@"欢迎使用智能客服服务?";
                    strongifySelf
                    [self sendMessage:message];
                });
                
            } else if ([sender.titleLabel.text isEqualToString:@"未解答"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    InfoMessage *message = [[InfoMessage alloc] init];
                    message.type = InfoMessageTypeTwo;
                    message.choices = @[@"拨打热线",@"不用了"];
                    message.serviceDetails = @"是否拨打400客服热线进一步咨询?";
                    strongifySelf
                    [self sendMessage:message];
                });
            } else if ([sender.titleLabel.text isEqualToString:@"我要反馈"]) {
                /*
                FeedbackController *feedbackController = [FeedbackController new];
                strongifySelf
                [self.navigationController pushViewController:feedbackController animated:YES];
                 */
            }
            
        }];
        cell.message = message;
        return cell;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark- DKSKeyBoard的代理
- (void)textViewContentText:(NSString *)textStr {
    [self clickSengMsg:nil];
}

#pragma mark- InfoMessageHelpCenterCell类型 中 点击 已解答与未解答
- (void)infoMessageHelpCenterCellTouchAnswerOrUnanswerWithMessage:(InfoMessage *)message serviceParentId: (NSString *)serviceParentId {
    NSDictionary *paras = @{
                            @"isHelp": @"1",
                            @"noHelp": @"1",
                            @"id":serviceParentId
                            };
    [CUHTTPRequest POST:dynamicUpdateServiceKnowledgeProfileById parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [self sendMessage:message];
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
        
    } failure:^(NSInteger code) {
        
    }];
}

#pragma mark- InfoMessageHelpCenterCell类型 中 绑定车辆信息的提示
- (void)infoMessageHelpCenterCellBindingCarInfoTips:(void (^)(void))runable {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    InputAlertView *popupView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [popupView initWithTitle:@"检测到您未绑定车辆信息,请绑定!" img:@"首页弹窗背景" type:12 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
    //            InputalertView.delegate = self;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: popupView];
    
    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
        
        if(btn.tag ==100) {
            if (runable) {
                runable();
            }
        }
    };
}

#pragma mark- InfoMessageHelpCenterCell类型 中 升级为T车用户的提示
- (void)infoMessageHelpCenterCellUpdateTUserTips:(void (^)(void))runable {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    PopupView *popupView = [[PopupView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-kTabbarHeight)];
    [popupView initWithTitle:@"您当前不是T用户无法使用服务,若想使用服务,请升级为T用户!" img:@"首页弹窗背景" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"确定",nil] ];
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: popupView];
    
    popupView.clickBlock = ^(UIButton *btn,NSString *str) {
        if (btn.tag == 100) {//左边按钮
            if (runable) {
                runable();
            }
        }
    };
}

#pragma mark- 更新个人信息的头像 用于右边cell的头像获取使用
- (void)refreshUserModel {

    NSDictionary *paras = @{};
    [CUHTTPRequest POST:queryUser parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSDictionary *dict = dic[@"data"];
            UserModel *userModel = [UserModel yy_modelWithDictionary:dict];
            
            [self downloadImageToFileWithUserModel:userModel];
        } else {
            
        }
    } failure:^(NSInteger code) {
        
    }];
}

- (void)downloadImageToFileWithUserModel: (UserModel *)userModel {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingString:UserHead];
    
    //  创建文件夹
    if (![NSFileManager.defaultManager fileExistsAtPath:[path stringByAppendingString:@"/UserHead"]]) {
        [NSFileManager.defaultManager createDirectoryAtPath:[path stringByAppendingString:@"/UserHead"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURL *imageUrl = [[NSURL alloc] initWithString:userModel.headPortrait];
    [[SDWebImageManager.sharedManager imageDownloader] downloadImageWithURL:imageUrl options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (!image) {
            //  如果获取的图片为空 给其赋默认值
            image = [UIImage imageNamed:@"用户头像"];
        }
        
        //  写入文件夹
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:true];
    }];
}

#pragma mark - 懒加载

- (NSMutableArray<InfoMessage *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableDictionary *)imgCellHeightDict {
    if (!_imgCellHeightDict) {
        _imgCellHeightDict = [NSMutableDictionary dictionary];
    }
    return _imgCellHeightDict;
}

- (NSDictionary *)funcDict {
    if (!_funcDict) {
        _funcDict = @{@"10010":@"MapHomeViewController",
                      @"10012":@"RefuelViewController",
                      @"10001":@"WifiViewController",
                      @"10002":@"UpkeepViewController",
                      @"10003":@"CarflowViewController",
                      @"10004":@"CarTrackViewController",
                      @"10005":@"TrafficReportController",
                      @"10006":@"DrivingReportPageController",
                      @"10007":@"LllegalViewController",
                      @"10013":@"RealVinViewcontroller",
                      @"10009":@"MapUpdateViewController",
                      @"10008":@"TrackListViewController",
                      @"10014":@"StorePageController",
                      @"10015":@"OrderPageController",
                      @"10011":@"ParkingViewController"
                     };
    }
    return _funcDict;
}

#pragma mark- dealloc
- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
