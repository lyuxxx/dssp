//
//  CarTrackModel.m
//  dssp
//
//  Created by qinbo on 2018/1/5.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CarTrackModel.h"

@implementation CarTrackModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"carTrackId" : @"id"
             };
}
@end
