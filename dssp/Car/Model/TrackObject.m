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


@implementation Geometry

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"coordinates": [CoordinatesItem class]
             };
}

@end


@implementation AdasEventItem
@end



@implementation Properties

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"adasEvent": [AdasEventItem class]
             };
}

@end


@implementation RecordItem
@end


@implementation TrackDetailResponseDetail

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"record": [RecordItem class]
             };
}

@end



@implementation NewCoordinatesItem
@end


@implementation ReportGeometry
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"afterCoordinates" : @"newCoordinates"
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"coordinates": [CoordinatesItem class],
             @"afterCoordinates": [NewCoordinatesItem class]
             };
}

@end


@implementation Statis

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    formatter0.dateFormat = @"yyyyMMddTHHmmssZ";
    formatter0.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    formatter1.dateFormat = @"HH:mm:ss";
    formatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    formatter2.dateFormat = @"HHhmmmsss";
    formatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
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
    NSDate *date11 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
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


@implementation DrvingReport
@end


@implementation TrackDetailResponseData
@end


@implementation TrackDetailResponse
@end

