//
//  TrackDetailResponse.h
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface CoordinatesItem :NSObject <YYModel>
@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) CGFloat              lon;

@end


@interface Geometry :NSObject <YYModel>
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) NSArray <CoordinatesItem *>              * coordinates;

@end


@interface AdasEventItem :NSObject <YYModel>
@property (nonatomic , copy) NSString              * adasType;
@property (nonatomic , copy) NSString              * adasStatus;

@end


@interface Properties :NSObject <YYModel>
@property (nonatomic , copy) NSString              * collectTime;
@property (nonatomic , copy) NSString              * instantSpeed;
@property (nonatomic , strong) NSArray <AdasEventItem *>              * adasEvent;
@property (nonatomic , copy) NSString              * harshAcceleration;
@property (nonatomic , copy) NSString              * harshDeceleration;
@property (nonatomic , copy) NSString              * harshTurn;

@end


@interface RecordItem :NSObject <YYModel>
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) Geometry              * geometry;
@property (nonatomic , strong) Properties              * properties;

@end


@interface TrackDetailResponseDetail :NSObject <YYModel>
@property (nonatomic , assign) NSInteger              totalCount;
@property (nonatomic , assign) NSInteger              pageNo;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , strong) NSArray <RecordItem *>              * record;

@end


@interface NewCoordinatesItem :NSObject <YYModel>
@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) CGFloat              lon;
@property (nonatomic , copy) NSString              * address;

@end


@interface ReportGeometry :NSObject <YYModel>
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) NSArray <CoordinatesItem *>              * coordinates;
@property (nonatomic , strong) NSArray <NewCoordinatesItem *>              * afterCoordinates;

@end


@interface Statis :NSObject <YYModel>
@property (nonatomic , copy) NSString              * vin;
@property (nonatomic , copy) NSString              * tripNo;
@property (nonatomic , copy) NSString              * mileage;
@property (nonatomic , copy) NSString              * startTime;
@property (nonatomic , copy) NSString              * endTime;
@property (nonatomic , copy) NSString              * duration;
@property (nonatomic , copy) NSString              * averageSpeed;
@property (nonatomic , copy) NSString              * fuelConsumed;
@property (nonatomic , copy) NSString              * driverAttentionTimes;
@property (nonatomic , copy) NSString              * autoBrakeTimes;
@property (nonatomic , copy) NSString              * accMilage;
@property (nonatomic , copy) NSString              * harshAccelerationTimes;
@property (nonatomic , copy) NSString              * harshDecelerationTimes;
@property (nonatomic , copy) NSString              * harshTurnTimes;

@end


@interface DrvingReport :NSObject <YYModel>
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) ReportGeometry              * geometry;
@property (nonatomic , strong) Statis              * properties;

@end


@interface TrackDetailResponseData :NSObject <YYModel>
@property (nonatomic , strong) TrackDetailResponseDetail              * detail;
@property (nonatomic , strong) DrvingReport              * drvingReport;

@end


@interface TrackDetailResponse :NSObject <YYModel>
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) TrackDetailResponseData              * data;

@end

