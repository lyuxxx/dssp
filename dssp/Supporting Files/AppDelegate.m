//
//  AppDelegate.m
//  dssp
//
//  Created by yxliu on 2017/10/24.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WBAFNetworkingLogger.h"
#import "InputAlertView.h"

#import <GTSDK/GeTuiSdk.h>
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import "TabBarController.h"
#import "NavigationController.h"
#import "RTRootNavigationController.h"
#import <CUHTTPRequest.h>
#import <MBProgressHUD+CU.h>
@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //清空cid
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    RTRootNavigationController *naVC = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = naVC;
    [self.window makeKeyAndVisible];
    [self config];
    return YES;
}


- (void)config {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 70 * HeightCoefficient;
    [AMapServices sharedServices].apiKey = @"e3aed20c93efeea15495d8bf27a87fac";
    [AMapServices sharedServices].enableHTTPS = YES;
    
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //这将在你的日志框架中添加两个“logger”。也就是说你的日志语句将被发送到Console.app和Xcode控制 台（就像标准的NSLog）
    
    //这个框架的好处之一就是它的灵活性，如果你还想要你的日志语句写入到一个文件中，你可以添加和配置一个file logger:
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    
    //上面的代码告诉应用程序要在系统上保持一周的日志文件。
    //如果不设置rollingFrequency和maximumNumberOfLogFiles，
    //则默认每天1个Log文件、存5天、单个文件最大1M、总计最大20M，否则自动清理最前面的记录
    
    [[WBAFNetworkingLogger sharedLogger] startLogging];
    [[WBAFNetworkingLogger sharedLogger] setLevel:WBLoggerLevelDebug];
    
    [self setupGeTui];
}

#pragma mark - 个推推送相关 -

#pragma mark -BadgeNumber相关-

- (void)setBadgeNumber:(NSInteger)number {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
    [GeTuiSdk setBadge:number];
}

- (void)decreaseBadgeNumber {
    NSInteger oriNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (oriNum < 1) {
        return;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:--oriNum];
    [GeTuiSdk setBadge:--oriNum];
}

- (void)increaseBadgeNumber {
    NSInteger oriNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:++oriNum];
    [GeTuiSdk setBadge:++oriNum];
}

- (void)registerLocalNotificationWithInfo:(NSDictionary *)info {
    if (@available(iOS 10.0, *)) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = info[@"title"];
        content.body = info[@"content"];
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.capsa.dssp.local" content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:nil];
    } else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        
        notification.fireDate = fireDate;
        // 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        notification.repeatInterval = 0;
        // 通知标题
        if (@available(iOS 8.2, *)) {
            notification.alertTitle = info[@"title"];
        } else {
            // Fallback on earlier versions
        }
        // 通知内容
        notification.alertBody = info[@"content"];
        // 通知被触发时播放的声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)showLogout {
    if ([self.window.rootViewController isKindOfClass:[TabBarController class]]) {
        //todo 被登出弹窗
        InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [InputalertView initWithTitle:@"您的账号已经在另外一台设备上登录，您已经被迫下线" img:@"账号警告" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"重新登录", nil] ];
        //            InputalertView.delegate = self;
        UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview: InputalertView];
        
        InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
            if (btn.tag == 100) {//左边按钮
                
                NSDictionary *paras = @{
                                        
                                      };
//                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:loginout parameters:paras success:^(id responseData) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"] || [dic[@"code"] isEqualToString:@"ERROR1003"]) {
//                        [hud hideAnimated:YES];
                        //响应事件
                        LoginViewController *vc=[[LoginViewController alloc] init];
                        RTRootNavigationController *navc = [[RTRootNavigationController alloc] initWithRootViewController:vc];
                        navc.hidesBottomBarWhenPushed = YES;
                        
                        [[UIApplication sharedApplication].delegate.window setRootViewController:navc];

                    } else {
                        [MBProgressHUD showText:dic[@"msg"]];
                    }
                } failure:^(NSInteger code) {
                    
                     [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
                
                }];
            }
            
        };
        
    }
}

- (void)gotoMessageVC {
    if ([self.window.rootViewController isKindOfClass:[TabBarController class]]) {
        TabBarController *tabVC = (TabBarController *)self.window.rootViewController;
        tabVC.selectedIndex = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverVCneedRefresh" object:nil userInfo:nil];
        });
    }
}

- (void)setupGeTui {
    [GeTuiSdk startSdkWithAppId:@"qNaVHr6IvHAWOlhxsr52p4" appKey:@"mgJCFoCvAD6EkXzU3WS1SA" appSecret:@"7LaratXCRAAeRUgMAT7BK7" delegate:self];
    [self registerRemoteNotification];
}

- (void)registerRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (granted) {
                
            } else {
                
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",token);
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"推送注册失败:%@",error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *tag = userInfo[@"tag"];
    NSLog(@"fetchRemote:%@ tag:%@",userInfo,tag);
    [GeTuiSdk handleRemoteNotification:userInfo];
    [self gotoMessageVC];
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10之后回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSString *tag = userInfo[@"tag"];
    NSLog(@"前台收到推送:%@\n%@ tag:%@",userInfo,notification.request.content,tag);
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时远程推送接收
        
    } else {
        //应用处于前台时本地推送接收
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [self gotoMessageVC];
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *tag = userInfo[@"tag"];
    NSLog(@"后台收到推送:%@\n%@ tag:%@",userInfo,response.notification.request.content,tag);
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时远程推送接收
        [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
        [self gotoMessageVC];
    } else if ([response.notification.request.trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]) {
        //应用处于后台时本地推送接收
        [self gotoMessageVC];
    }
    completionHandler();
}

#pragma mark - GeTuiSdkDelegate

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"[GTSdk cid]%@",clientId);
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"cid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@"[GTSdk error]:%@",error.localizedDescription);
}

///个推透传消息
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[payloadMsg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSString *tag = dic[@"tag"];
        if ([tag isEqualToString:@"login_exception"]) {
            [self showLogout];
        } else {
            [self registerLocalNotificationWithInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceivePayloadMsg" object:nil userInfo:nil];
        }
    }
    
    
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    NSLog(@"[GTSdk SdkState]:%u\n\n",aStatus);
}

@end
