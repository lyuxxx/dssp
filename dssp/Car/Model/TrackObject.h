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


@interface NewCoordinatesItem :NSObject <YYModel>
@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) CGFloat              lon;
@property (nonatomic , copy) NSString              * address;

@end


@interface Geometry :NSObject <YYModel>
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) NSArray <CoordinatesItem *>              * coordinates;
@property (nonatomic , strong) NSArray <NewCoordinatesItem *>              * afterCoordinates;

@end


@interface TrackStatis :NSObject <YYModel>
@property (nonatomic , copy) NSString              * vin;
@property (nonatomic , copy) NSString              * tripId;
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


@interface TrackInfo :NSObject <YYModel>
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , strong) Geometry              * geometry;
@property (nonatomic , strong) TrackStatis              * properties;

@end


@interface TrackListSection :NSObject <YYModel>
@property (nonatomic , copy) NSString              * date;
@property (nonatomic , strong) NSMutableArray <TrackInfo *>              * list;

@end


@interface TrackListResponseData :NSObject <YYModel>
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              totalPage;
@property (nonatomic , assign) NSInteger              totalCount;
@property (nonatomic , strong) NSArray <TrackListSection *>              * result;
@property (nonatomic , assign) NSInteger              offset;
@property (nonatomic , assign) NSInteger              limit;
@property (nonatomic , assign) BOOL              hasPre;
@property (nonatomic , assign) NSInteger              nextPage;
@property (nonatomic , assign) BOOL              hasNext;
@property (nonatomic , assign) NSInteger              prePage;

@end


@interface TrackListResponse :NSObject <YYModel>
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) TrackListResponseData              * data;

@end

@interface TrackDetailRecordItem :NSObject
@property (nonatomic , assign) CGFloat              lat;
@property (nonatomic , assign) CGFloat              lon;

@end


@interface TrackDetailResponseData :NSObject <YYModel>
@property (nonatomic , assign) NSInteger              totalCount;
@property (nonatomic , assign) NSInteger              pageNo;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , strong) NSArray <TrackDetailRecordItem *>              * record;

@end


@interface TrackDetailResponse :NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) TrackDetailResponseData              * data;

@end
