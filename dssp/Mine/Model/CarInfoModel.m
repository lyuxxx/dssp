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
@end
