//
//  TrafficReportModel.h
//  dssp
//
//  Created by qinbo on 2018/2/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RecordItems :NSObject <YYModel>
@property (nonatomic , copy) NSString              * alertCode;
@property (nonatomic , copy) NSString              * alertName;
@property (nonatomic , copy) NSString              * alertPriority;
@property (nonatomic , copy) NSString              * alertCount;
@property (nonatomic , copy) NSString              * jdaName;
@property (nonatomic, assign) CGFloat cellHeights;

@end


@interface HealthAlertsItem :NSObject <YYModel>
@property (nonatomic , copy) NSString        * vehicleSystem;
@property (nonatomic , copy) NSString        *vehicleSystemName;
@property (nonatomic , strong) NSArray <RecordItems *> *record;

@end


@interface TrafficReporData :NSObject <YYModel>
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
@property (nonatomic , strong) TrafficReporData              * data;
@end

