//
//  SubscribeModel.m
//  dssp
//
//  Created by qinbo on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "SubscribeModel.h"

@implementation SubscribeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"subscribeId" : @"id"
             };
}
@end



@implementation ChannelModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"listId" : @"id"
             };
}
@end

