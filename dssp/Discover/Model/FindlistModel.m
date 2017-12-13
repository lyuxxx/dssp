//
//  FindlistModel.m
//  dssp
//
//  Created by qinbo on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "FindlistModel.h"

@implementation FindDataItem
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"menuId" : @"id"
             };
}
@end

@implementation FindlistModel

@end
