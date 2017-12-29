//
//  OilStation.m
//  dssp
//
//  Created by yxliu on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "OilStation.h"

@implementation OilStation

@end

@implementation GasNo

@end

@implementation OilListData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"gasnolist": [GasNo class],
             @"stations": [OilStation class]
             };
}

@end

@implementation OilListResponse

@end

@implementation GasPrice

@end

@implementation StationInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"pricelist": [GasPrice class]
             };
}

@end

@implementation StationDetailData

@end

@implementation StationDetailResponse

@end
