//
//  POIList.m
//  dssp
//
//  Created by yxliu on 2017/12/6.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "POI.h"

@implementation ResultItem

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"poiId": @"id",
             @"descript": @"description"
             };
}

@end


@implementation POIListData
@end


@implementation POIList
@end

@implementation POIFavoriteInput

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"descript": @"description"
             };
}

@end

@implementation POISendInput

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"descript": @"description"
             };
}

@end
