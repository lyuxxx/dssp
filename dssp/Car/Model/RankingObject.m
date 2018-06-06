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
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:_levelList.count];
    NSMutableArray *yTmp = [NSMutableArray arrayWithCapacity:_levelList.count];
    
    for (NSInteger i = 0; i < _levelList.count; i++) {
        LevelListItem *item = _levelList[i];
        //获取用户点所在index
        if (item.level == _vehicleLevel) {
            _userIndex = i;
        }
        if (_vehicleLevel >= item.level) {
            _mileagePercent += item.levelPercent;
        }
        if (_vehicleLevel <= item.level) {
            _fuelPercent += item.levelPercent;
        }
        [tmp addObject:[NSString stringWithFormat:@"%.0f",item.xValue]];
        [yTmp addObject:[NSNumber numberWithFloat:item.levelPercent]];
    }
    _xLabels = [NSArray arrayWithArray:tmp];
    _yData = [NSArray arrayWithArray:yTmp];
    
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
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:_levelList.count];
    NSMutableArray *yTmp = [NSMutableArray arrayWithCapacity:_levelList.count];
    
    for (NSInteger i = 0; i < _levelList.count; i++) {
        LevelListItem *item = _levelList[i];
        //获取用户点所在index
        if (item.level == _vehicleLevel) {
            _userIndex = i;
        }
        if (_vehicleLevel >= item.level) {
            _mileagePercent += item.levelPercent;
        }
        if (_vehicleLevel <= item.level) {
            _fuelPercent += item.levelPercent;
        }
        [tmp addObject:[NSString stringWithFormat:@"%.0f",item.xValue]];
        [yTmp addObject:[NSNumber numberWithFloat:item.levelPercent]];
    }
    _xLabels = [NSArray arrayWithArray:tmp];
    _yData = [NSArray arrayWithArray:yTmp];
    
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
