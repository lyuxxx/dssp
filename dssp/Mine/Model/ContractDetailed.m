//
//  ContractDetailed.m
//  dssp
//
//  Created by qinbo on 2017/12/7.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractDetailed.h"

@implementation vhlTypeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"carmodelId" : @"id"
             };
}
@end

@implementation vhlSeriesModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"cartrainId" : @"id"
             };
}
@end

@implementation vhlBrandModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"brandId" : @"id"
             };
}

@end


@implementation ContractData
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"packageId" : @"id"
             };
}
@end


@implementation ContractDetailed

@end




