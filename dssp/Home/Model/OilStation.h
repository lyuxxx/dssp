//
//  OilStation.h
//  dssp
//
//  Created by yxliu on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import <CoreLocation/CoreLocation.h>

@interface OilStation : NSObject

@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger stationid;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationDegrees coordinatex;
@property (nonatomic, assign) CLLocationDegrees coordinatey;
@property (nonatomic, assign) NSInteger cheap;
@property (nonatomic, copy) NSString *stationtype;

@end

@interface GasNo : NSObject

@property (nonatomic, copy) NSString *gasno;
@property (nonatomic, assign) NSInteger gasnoid;

@end

@interface OilListData : NSObject <YYModel>

@property (nonatomic, strong) NSArray<GasNo *> *gasnolist;
@property (nonatomic, strong) NSArray<OilStation *> *stations;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, assign) NSInteger errorcode;

@end

@interface OilListResponse : NSObject

@property (nonatomic, strong) OilListData *data;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;

@end

@interface GasPrice : NSObject

@property (nonatomic, copy) NSString *gasno;
@property (nonatomic, assign) NSInteger cheap;
@property (nonatomic, assign) NSInteger price;

@end

@interface StationInfo : NSObject <YYModel>

@property (nonatomic, assign) NSInteger stationid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *stationtype;
@property (nonatomic, assign) BOOL carwashing;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) CLLocationDegrees *coordinatex;
@property (nonatomic, assign) CLLocationDegrees *coordinatey;
@property (nonatomic, copy) NSString *telephonenum;
@property (nonatomic, copy) NSString *noticemsg;
@property (nonatomic, copy) NSString *opentime;
@property (nonatomic, strong) NSArray<GasPrice *> *pricelist;

@end

@interface StationDetailData : NSObject

@property (nonatomic, copy) NSString *result;
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) StationInfo *stationinfo;

@end

@interface StationDetailResponse : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) StationDetailData *data;

@end
