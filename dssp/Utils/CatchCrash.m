//
//  CatchCrash.m
//  dssp
//
//  Created by yxliu on 2018/3/19.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CatchCrash.h"
#import <mach-o/dyld.h>
#import <YYModel.h>

@implementation CrashObject

@end

@implementation CatchCrash
void uncaughtExceptionHandler(NSException *exception) {
    
    long slide = 0;
    
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceType = [UIDevice currentDevice].machineModelName;
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *crashTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    //获取系统当前时间，（注：用[NSDate date]直接获取的是格林尼治时间，有时差）
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *readableTime = [formatter stringFromDate:[NSDate date]];
    //异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    //出现异常的原因
    NSString *reason = [exception reason];
    //异常名称
    NSString *name = [exception name];
    
    //拼接错误信息
    NSString *exceptionInfo = [NSString stringWithFormat:@"slide: %lx crashTime: %@ Exception reason: %@\nException name: %@\nException stack:%@", slide , readableTime, reason, name, stackArray];
    
    NSMutableDictionary *crashDic = [NSMutableDictionary dictionary];
    [crashDic setObject:bundleId forKey:@"packageName"];
    [crashDic setObject:deviceType forKey:@"deviceModel"];
    [crashDic setObject:iOSVersion forKey:@"systemVersion"];
    [crashDic setObject:appVersion forKey:@"versionName"];
    [crashDic setObject:appBuild forKey:@"versionCode"];
    [crashDic setObject:userName forKey:@"userName"];
    [crashDic setObject:@"ios" forKey:@"systemType"];
    [crashDic setObject:crashTime forKey:@"time"];
    [crashDic setObject:exceptionInfo forKey:@"exceptionInfo"];
    
    NSString *crashPath = [NSString stringWithFormat:@"%@/Documents/crash", NSHomeDirectory()];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:crashPath]) {
        arr = [NSMutableArray arrayWithContentsOfFile:crashPath];
        NSError *inerror;
        [manager removeItemAtPath:crashPath error:&inerror];
    }
    [arr addObject:crashDic];
    
    //把错误信息保存到本地文件，设置errorLogPath路径下
    //并且经试验，此方法写入本地文件有效。
    
    NSError *error = nil;
    BOOL isSuccess = [arr writeToFile:crashPath atomically:YES];
    if (!isSuccess) {
        NSLog(@"将crash信息保存到本地失败: %@", error.userInfo);
    }
}
@end
