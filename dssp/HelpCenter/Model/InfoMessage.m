//
//  InfoMessage.m
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InfoMessage.h"

@implementation InfoMessage

- (instancetype)initWithTime:(NSDate *)time text:(NSString *)text choices:(NSArray *)choices type:(InfoMessageType)type {
    self = [super init];
    if (self) {
        self.time = time;
        self.text = text;
        self.choices = choices;
        self.type = type;
    }
    return self;
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"infoMessageId": @"id",
             
             };
}


@end

@implementation serviceKnowledgeProfileList

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"infoMessagedatailId": @"id",
             
             };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"serviceKnowledgeProfileList": [serviceKnowledgeProfileList class],
             
             };
}
@end


