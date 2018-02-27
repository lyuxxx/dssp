//
//  MapUpdateObject.m
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "MapUpdateObject.h"

@implementation ActivationCode

@end

@implementation ActivationCodeListResponse

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data": [ActivationCode class]
             };
}

@end
