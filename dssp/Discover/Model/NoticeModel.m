//
//  NoticeModel.m
//  dssp
//
//  Created by qinbo on 2017/12/27.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"noticeId" : @"id"
             };
}

@end
