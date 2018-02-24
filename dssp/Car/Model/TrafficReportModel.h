//
//  TrafficReportModel.h
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RecordItem :NSObject
@property (nonatomic , copy) NSString              * alertCode;
@property (nonatomic , copy) NSString              * alertName;
@property (nonatomic , copy) NSString              * alertPriority;
@property (nonatomic , copy) NSString              * alertCount;

@end


@interface HealthAlertsItem :NSObject
@property (nonatomic , copy) NSString              * vehicleSystem;
@property (nonatomic , strong) NSArray <RecordItem *>              * record;

@end


@interface Data :NSObject
@property (nonatomic , copy) NSString              * vin;
@property (nonatomic , copy) NSString              * totalMileage;
@property (nonatomic , copy) NSString              * levelOil;
@property (nonatomic , copy) NSString              * levelFuel;
@property (nonatomic , copy) NSString              * mileageBeforeMaintenance;
@property (nonatomic , strong) NSArray <HealthAlertsItem *>              * healthAlerts;

@end


@interface TrafficReportModel : NSObject
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) Data              * data;
@end

