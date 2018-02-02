//
//  InfoMessage.h
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, InfoMessageType) {
    InfoMessageTypeMe = 0,
    InfoMessageTypeOther
};
@interface InfoMessage : NSObject

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, assign) InfoMessageType type;
@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithTime:(NSDate *)time text:(NSString *)text choices:(NSArray *)choices type:(InfoMessageType)type;

@end
