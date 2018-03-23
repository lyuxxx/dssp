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
#import <CUPayTool.h>
#import "CatchCrash.h"

@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupCrash];
    
    [CUHTTPRequest customSecurityPolicyWithCerPath:[[NSBundle mainBundle] pathForResource:@"server_formal" ofType:@"cer"]];
    
//    [self setuploading];

    //清空cid

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [CUPayTool wechatRegisterAppWithAppId:WXAppId];
    
    [NSThread sleepForTimeInterval:1];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    RTRootNavigationController *naVC = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = naVC;
    [self.window makeKeyAndVisible];
    [self startupView];
    
    [self config];
    
    return YES;
}

- (void)setupCrash {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *crashPath = [NSString stringWithFormat:@"%@/Documents/crash", NSHomeDirectory()];
    if ([fileManager fileExistsAtPath:crashPath]) {//上次存在crash
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:crashPath];
        NSDictionary *paras = @{@"appErrorInfoList": arr};
        [CUHTTPRequest POST:addAppErrorInfo parameters:paras success:^(id responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] isEqualToString:@"200"] && ((NSNumber *)dic[@"data"]).integerValue > 0) {//成功
                //成功后删除文件
                NSError *error;
                [fileManager removeItemAtPath:crashPath error:&error];
            }
        } failure:^(NSInteger code) {
            
        }];
    }
}


-(void)setuploading
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/tmp/myJson.txt"];//获取json文件保存的路径
    NSData *data = [NSData dataWithContentsOfFile:filePath];//获取指定路径的data文件
    NSArray<NSData *> *arr = [NSArray arrayWithObjects:data, nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    [filePath removeItemAtPath:jsonString:&err];
    [CUHTTPRequest POSTUpload:uploading parameters:@{} uploadType:(UploadDownloadType_Images) dataArray:arr success:^(id responseData) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//             [MBProgressHUD showText:@"上传TXT文件成功"];
            //上传TXT文件成功，就删除
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:filePath];
            if (bRet) {
                NSError *err;
                [fileMgr removeItemAtPath:filePath error:&err];
            }
            
        }
        else
        {
//            [MBProgressHUD showText:[dic objectForKey:@"msg"]];
        }
        
    } failure:^(NSInteger code) {
        
    }];

}

- (void)config {
    
    [[UIActivityIndicatorView appearanceWhenContainedIn:NSClassFromString(@"MJRefreshComponent"), nil] setColor:[UIColor colorWithHexString:@"#5a5a5a"]];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 70 * HeightCoefficient;
    [IQKeyboardManager sharedManager].canAdjustAdditionalSafeAreaInsets = YES;
    [AMapServices sharedServices].apiKey = AmapKey;
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

- (void)startupView {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.image = [UIImage imageNamed:@"launch"];
    [self.window addSubview:imgV];
    [self.window bringSubviewToFront:imgV];
    [UIView animateWithDuration:2 animations:^{
        imgV.alpha = 0;
    } completion:^(BOOL finished) {
        [imgV removeFromSuperview];
    }];
    /**
    UIView *botBlack = [[UIView alloc] initWithFrame:imgV.bounds];
    botBlack.backgroundColor = [UIColor blackColor];
    [imgV addSubview:botBlack];
    
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    colorAnimation.fromValue = (__bridge id)([UIColor blackColor].CGColor);
    colorAnimation.toValue = (__bridge id)([UIColor clearColor].CGColor);
    colorAnimation.duration = 1;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
//    [botBlack.layer addAnimation:colorAnimation forKey:@"color"];
    
    UIView *black = [[UIView alloc] initWithFrame:imgV.bounds];
    black.backgroundColor = [UIColor blackColor];
    [imgV addSubview:black];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imgV.bounds];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:imgV.center radius:0.01 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [path appendPath:circlePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    black.layer.mask = shapeLayer;
    
    UIBezierPath *inPath = [UIBezierPath bezierPathWithRect:imgV.bounds];
    UIBezierPath *inCirclePath = [UIBezierPath bezierPathWithArcCenter:imgV.center radius:sqrt(pow(kScreenHeight / 2, 2) + pow(kScreenWidth / 2, 2)) startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [inPath appendPath:inCirclePath];
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    maskAnimation.fromValue = (__bridge id)(path.CGPath);
    maskAnimation.toValue = (__bridge id)(inPath.CGPath);
    maskAnimation.duration = 1;
    maskAnimation.fillMode = kCAFillModeForwards;
    maskAnimation.removedOnCompletion = NO;
    maskAnimation.delegate = self;
//    [shapeLayer addAnimation:maskAnimation forKey:@"maskAnimation"];
    **/
}

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

#pragma mark - 支付相关 -
//iOS9之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if([url.scheme isEqualToString:WXAppId] && [url.host isEqualToString:@"pay"])//微信支付
    {
        return [CUPayTool wechatHandleOpenURL:url];
    }
    else if([url.host isEqualToString:@"safepay"])//支付宝
    {
        return [CUPayTool alipayHandleOpenURL:url];
    }
    return YES;
}

//iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if([url.scheme isEqualToString:WXAppId] && [url.host isEqualToString:@"pay"])//微信支付
    {
        return [CUPayTool wechatHandleOpenURL:url];
    }
    else if([url.host isEqualToString:@"safepay"])//支付宝
    {
        return [CUPayTool alipayHandleOpenURL:url];
    }
    return YES;
}

#pragma mark - 个推推送相关 -

- (void)restartGetui {
    [GeTuiSdk destroy];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [GeTuiSdk startSdkWithAppId:@"qNaVHr6IvHAWOlhxsr52p4" appKey:@"mgJCFoCvAD6EkXzU3WS1SA" appSecret:@"7LaratXCRAAeRUgMAT7BK7" delegate:self];
        [GeTuiSdk resume];
    });
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
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.mobile.capsa.local" content:content trigger:trigger];
        
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
        RTRootNavigationController *navc = tabVC.viewControllers[1];
        [navc popToRootViewControllerAnimated:YES];
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
//cid获取成功
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"[GTSdk cid]%@",clientId);
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"cid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refreshcid" object:nil userInfo:nil];
    
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
            if (!offLine) {//online
//                [self increaseBadgeNumber];//在线消息加一
                [self registerLocalNotificationWithInfo:dic];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceivePayloadMsg" object:nil userInfo:nil];
        }
    }
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GTSdk ReceivePayload]:%@\n\n", msg);
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    NSLog(@"[GTSdk SdkState]:%u\n\n",aStatus);
}

@end
