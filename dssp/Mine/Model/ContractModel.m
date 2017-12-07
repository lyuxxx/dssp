//
//  ContractModel.m
//  dssp
//
//  Created by qinbo on 2017/12/7.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "ContractModel.h"

@implementation ContractModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"contractId" : @"id"
             };
}
@end
