//
//  DrivingReportObject.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingReportObject.h"
#import <objc/runtime.h>

@implementation DrivingReportWeek

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    ///值非空判断
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *strValue = (NSString *)value;
            if (![strValue isNotBlank]) {
                strValue = nil;
            }
        }
    }
    free(ivar);
    
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    formatter0.dateFormat = @"yyyyMMdd";
    formatter0.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy/MM/dd";
    formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSString *start = dic[@"startDate"];
    NSDate *startDate = [formatter0 dateFromString:start];
    _startDate = [formatter1 stringFromDate:startDate];
    
    NSString *end = dic[@"endDate"];
    NSDate *endDate = [formatter0 dateFromString:end];
    _endDate = [formatter1 stringFromDate:endDate];
    
    return YES;
}

@end

@implementation DrivingReportWeekResponseData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"record": [DrivingReportWeek class]
             };
}

@end

@implementation DrivingReportWeekResponse

@end






@implementation DrivingReportMonth

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    ///值非空判断
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:strName];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *strValue = (NSString *)value;
            if (![strValue isNotBlank]) {
                strValue = nil;
            }
        }
    }
    free(ivar);
    
    return YES;
}

@end

@implementation DrivingReportMonthResponseData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"record": [DrivingReportMonth class]
             };
}
@end

@implementation DrivingReportMonthResponse

@end
