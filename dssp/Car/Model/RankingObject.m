//
//  RankingObject.m
//  dssp
//
//  Created by yxliu on 2018/6/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "RankingObject.h"

@implementation LevelListItem

@end

@implementation RankingWeekRecordItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"levelList" : [LevelListItem class]
             };
}

@end

@implementation RankingMonthRecordItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"levelList" : [LevelListItem class]
             };
}

@end



@implementation RankingWeekResponseData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"record" : [RankingWeekRecordItem class]
             };
}

@end

@implementation RankingWeekResponse

@end

@implementation RankingMonthResponseData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"record" : [RankingMonthRecordItem class]
             };
}

@end

@implementation RankingMonthResponse

@end
