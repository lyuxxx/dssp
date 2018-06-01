//
//  DrivingReportObject.h
//  dssp
//
//  Created by yxliu on 2018/2/28.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrivingReportWeek : NSObject <YYModel>
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *mileage;
@property (nonatomic, copy) NSString *totalFuelConsumed;
@property (nonatomic, copy) NSString *averageFuelConsumed;
@property (nonatomic, copy) NSString *driverAttentionTimes;
@property (nonatomic, copy) NSString *autoBrakeTimes;
@property (nonatomic, copy) NSString *accMileage;
@property (nonatomic, copy) NSString *harshAccelerationTimes;
@property (nonatomic, copy) NSString *harshDecelerationTimes;
@property (nonatomic, copy) NSString *harshTurnTimes;
@end

@interface DrivingReportWeekResponseData : NSObject <YYModel>
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<DrivingReportWeek *> *record;
@end

@interface DrivingReportWeekResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) DrivingReportWeekResponseData *data;
@end




@interface DrivingReportMonth : NSObject <YYModel>
@property (nonatomic, copy) NSString *periodMonth;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *mileage;
@property (nonatomic, copy) NSString *totalFuelConsumed;
@property (nonatomic, copy) NSString *averageFuelConsumed;
@property (nonatomic, copy) NSString *driverAttentionTimes;
@property (nonatomic, copy) NSString *autoBrakeTimes;
@property (nonatomic, copy) NSString *accMileage;
@property (nonatomic, copy) NSString *harshAccelerationTimes;
@property (nonatomic, copy) NSString *harshDecelerationTimes;
@property (nonatomic, copy) NSString *harshTurnTimes;
@end

@interface DrivingReportMonthResponseData : NSObject <YYModel>
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<DrivingReportMonth *> *record;
@end

@interface DrivingReportMonthResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) DrivingReportMonthResponseData *data;
@end
