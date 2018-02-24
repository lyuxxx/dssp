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
    InfoMessageTypeOther,
    InfoMessageTypeTwo
    
};



@interface serviceKnowledgeProfileList :NSObject <YYModel>

@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy)   NSString *infoMessagedatailId;
@property (nonatomic , copy)   NSString              * serviceType;
@property (nonatomic , copy)   NSString              * serviceName;
@property (nonatomic , copy)   NSString              * serviceParentId;
@property (nonatomic , copy)   NSString              * serviceDetails;
@property (nonatomic , assign) NSInteger              isHelp;
@property (nonatomic , assign) NSInteger              noHelp;
@property (nonatomic , assign) NSInteger              readingNumber;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              lastUpdateTime;
@property (nonatomic , assign) BOOL              parent;
@end


@interface InfoMessage : NSObject
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, assign) InfoMessageType type;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              infoMessageId;
@property (nonatomic , copy) NSString              * serviceType;
@property (nonatomic , copy) NSString              *appServiceCode;
@property (nonatomic , copy) NSString              *appServiceName;
@property (nonatomic , copy) NSString              *appServiceNum;
@property (nonatomic , copy) NSString              *children;
@property (nonatomic , copy) NSString              *knowledgeInfoJson;
@property (nonatomic , copy) NSString              *sourceData;
@property (nonatomic , copy) NSString              * serviceName;
@property (nonatomic , copy) NSString              * serviceParentId;
@property (nonatomic , copy) NSString              * serviceDetails;
@property (nonatomic , assign) NSInteger              isHelp;
@property (nonatomic , assign) NSInteger              noHelp;
@property (nonatomic , assign) NSInteger              readingNumber;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              lastUpdateTime;
@property (nonatomic , assign) BOOL              parent;
@property (nonatomic , strong) NSArray <serviceKnowledgeProfileList *>    * serviceKnowledgeProfileList;

- (instancetype)initWithTime:(NSDate *)time text:(NSString *)text choices:(NSArray *)choices type:(InfoMessageType)type;

@end



