//
//  MapUpdateObject.m
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "MapUpdateObject.h"

@implementation ActivationCode

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *getDateStr = dic[@"getDate"];
    NSDateFormatter *formatter0 = [[NSDateFormatter alloc] init];
    formatter0.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter0.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+8"];
    _getDate = [formatter0 dateFromString:getDateStr];
    return YES;
}

@end

@implementation ActivationCodeListResponse

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data": [ActivationCode class]
             };
}

@end
