//
//  DrivingReportObject.m
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "DrivingReportObject.h"

@implementation DrivingReportWeek

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
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
