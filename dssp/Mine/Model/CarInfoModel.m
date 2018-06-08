//
//  CarInfoModel.m
//  dssp
//
//  Created by qinbo on 2017/11/16.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "CarInfoModel.h"

@implementation CarInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"carId" : @"id"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *typeName = dic[@"typeName"];
    if ([typeName isKindOfClass:[NSString class]] && [typeName containsString:@"_RCC"]) {
        _typeName = [typeName stringByReplacingOccurrencesOfString:@"_RCC" withString:@""];
    }
    return YES;
}

@end


@implementation CarbindModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"carId" : @"id"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *typeName = dic[@"vhlTypeName"];
    if ([typeName isKindOfClass:[NSString class]] && [typeName containsString:@"_RCC"]) {
        _vhlTypeName = [typeName stringByReplacingOccurrencesOfString:@"_RCC" withString:@""];
    }
    return YES;
}

@end


