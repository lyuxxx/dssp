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

#import <GTSDK/GeTuiSdk.h>
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import "NavigationController.h"
#import "RTRootNavigationController.h"
#import <CUHTTPRequest.h>
#import <MBProgressHUD+CU.h>
@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    RTRootNavigationController *naVC = [[RTRootNavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = naVC;
    
    [self.window makeKeyAndVisible];
    
    [self configWithOptions:launchOptions];
   
    
    return YES;
}


- (void)configWithOptions:(NSDictionary *)launchOptions {
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
    //则默认每天1个Log文件、存5天、单个文件最大1M、总计最大20M，否则自动清理最前面的记录。
    
    [[WBAFNetworkingLogger sharedLogger] startLogging];
    [[WBAFNetworkingLogger sharedLogger] setLevel:WBLoggerLevelDebug];
    
    [self setupGeTui];
}

- (void)setupGeTui {
    [GeTuiSdk startSdkWithAppId:@"lpFxdUx2Oi5P6KXqmqzOC7" appKey:@"3jbhgfE1jD7xPBw8n1uE3A" appSecret:@"AOv1mRuxb8AxR8oPZEVTZ3" delegate:self];
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [GeTuiSdk handleRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"%@\n%@",userInfo,notification.request.content);
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时远程推送接收
        
    } else {
        //应用处于前台时本地推送接收
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时远程推送接收
        [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    } else {
        //应用处于后台时本地推送接收
    }
    completionHandler();
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    NSLog(@"%@",clientId);
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

@end
