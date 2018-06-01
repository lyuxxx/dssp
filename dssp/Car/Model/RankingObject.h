//
//  RankingObject.h
//  dssp
//
//  Created by yxliu on 2018/6/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelListItem : NSObject
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSString *levelPercent;
@end

@interface RankingWeekRecordItem : NSObject <YYModel>
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger vehicleLevel;
@property (nonatomic, strong) NSArray<LevelListItem *> *levelList;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@end

@interface RankingMonthRecordItem : NSObject <YYModel>
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger vehicleLevel;
@property (nonatomic, strong) NSArray<LevelListItem *> *levelList;
@property (nonatomic, copy) NSString *periodMonth;
@end






@interface RankingWeekResponseData : NSObject <YYModel>
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<RankingWeekRecordItem *> *record;
@end

@interface RankingWeekResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) RankingWeekResponseData *data;
@end


@interface RankingMonthResponseData : NSObject <YYModel>
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<RankingMonthRecordItem *> *record;
@end

@interface RankingMonthResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) RankingMonthResponseData *data;
@end



