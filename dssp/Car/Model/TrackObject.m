//
//  TrackDetailResponse.m
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrackObject.h"

@implementation CoordinatesItem
@end


@implementation NewCoordinatesItem
@end


@implementation Geometry

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"coordinates": [CoordinatesItem class],
             @"afterCoordinates": [NewCoordinatesItem class]
             };
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"afterCoordinates" : @"newCoordinates"
             };
}

@end


@implementation TrackStatis

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    formatter0.dateFormat = @"yyyyMMdd'T'HHmmss'Z'";
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"HH:mm:ss";
    
    NSString *startTime = dic[@"startTime"];
    NSDate *date0 = [formatter0 dateFromString:startTime];
    _startTime = [formatter1 stringFromDate:date0];
    
    NSString *endTime = dic[@"endTime"];
    NSDate *date1 = [formatter0 dateFromString:endTime];
    _endTime = [formatter1 stringFromDate:date1];
    
    // The time interval
    NSTimeInterval theTimeInterval = [date1 timeIntervalSinceDate:date0];
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date10 = [[NSDate alloc] init];
    NSDate *date11 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date10];
    
    // Get conversion to months, days, hours, minutes
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *info = [sysCalendar components:unitFlags fromDate:date10 toDate:date11 options:NSCalendarWrapComponents];
    
    NSInteger hour = info.hour;
    NSInteger minute = info.minute;
    NSInteger second = info.second;
    
    if (hour) {
        _duration = [NSString stringWithFormat:@"%ldh%ldm%lds",hour,minute,second];
    } else if (minute) {
        _duration = [NSString stringWithFormat:@"%ldm%lds",minute,second];
    } else {
        _duration = [NSString stringWithFormat:@"%lds",second];
    }
    
    return YES;
}
@end


@implementation TrackInfo
@end


@implementation TrackListSection

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"list": [TrackInfo class]
             };
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    NSString *dateStr = dic[@"date"];
    
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    formatter0.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"yyyy/MM/dd";
    
    NSDate *date = [formatter0 dateFromString:dateStr];
    _date = [formatter1 stringFromDate:date];
    
    return YES;
}

@end


@implementation TrackListResponseData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"result": [TrackListSection class]
             };
}

@end


@implementation TrackListResponse
@end

@implementation TrackDetailRecordItem
@end


@implementation TrackDetailResponseData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"record": [TrackDetailRecordItem class]
             };
}

@end


@implementation TrackDetailResponse
@end
