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
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
    
    [self.window makeKeyAndVisible];
    
    [self configWithOptions:launchOptions];
    
    return YES;
}

- (void)configWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 70 * HeightCoefficient;
    [AMapServices sharedServices].apiKey = @"276493345747181efd3c01d675705889";
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
    
    [self setupUMPushWithOptions:launchOptions];
}

- (void)setupUMPushWithOptions:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:@"5a29ffbaf29d98735e000059" launchOptions:launchOptions httpsEnable:YES];
    [UMessage registerForRemoteNotifications];
    
    //iOS10
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center= [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            } else {
                
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    [UMessage setLogEnabled:YES];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [UMessage registerDeviceToken:deviceToken];
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",token);
}

//iOS10以下
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时远程推送接收
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于前台时本地推送接收
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时远程推送接收
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于后台时本地推送接收
    }
    completionHandler();
}

@end
