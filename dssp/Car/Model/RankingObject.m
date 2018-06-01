//
//  RankingObject.m
//  dssp
//
//  Created by yxliu on 2018/6/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "RankingObject.h"

@implementation LevelListItem

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    //(0,50]
    NSString *section = dic[@"section"];
    NSString *newStr = [section stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]()"]];
    NSArray<NSString *> *arr = [newStr componentsSeparatedByString:@","];
    _xValue = arr[0].floatValue;
    
    _yValue = _levelPercent;
    
    return YES;
}

@end

@implementation RankingWeekRecordItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"levelList" : [LevelListItem class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    _mileagePercent = 0;
    _fuelPercent = 0;
    
    for (NSInteger i = 0; i < _levelList.count; i++) {
        LevelListItem *item = _levelList[i];
        if (_vehicleLevel >= item.level) {
            _mileagePercent += item.levelPercent;
        }
        if (_vehicleLevel <= item.level) {
            _fuelPercent += item.levelPercent;
        }
    }
    
    
    return YES;
}

@end

@implementation RankingMonthRecordItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"levelList" : [LevelListItem class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    _mileagePercent = 0;
    _fuelPercent = 0;
    
    for (NSInteger i = 0; i < _levelList.count; i++) {
        LevelListItem *item = _levelList[i];
        if (_vehicleLevel >= item.level) {
            _mileagePercent += item.levelPercent;
        }
        if (_vehicleLevel <= item.level) {
            _fuelPercent += item.levelPercent;
        }
    }
    
    
    return YES;
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
