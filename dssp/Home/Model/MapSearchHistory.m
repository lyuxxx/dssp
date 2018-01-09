//
//  MapSearchHistory.m
//  dssp
//
//  Created by yxliu on 2017/11/24.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MapSearchHistory.h"

@implementation MapSearchHistory

+ (void)initialize {
    [self removePropertyWithColumnName:@"coordinate"];
}

- (instancetype)initWithPoiInfo:(MapPoiInfo *)info {
    if (self = [super init]) {
        self.name = info.name;
        self.address = info.address;
        self.coordinate = info.coordinate;
        self.latitude = info.coordinate.latitude;
        self.longitude = info.coordinate.longitude;
        self.uid = info.uid;
        self.adcode = info.adcode;
        self.district = info.district;
        self.type = info.type;
        self.typecode = info.typecode;
        self.tel = info.tel;
        self.distance = info.distance;
        self.parkingType = info.parkingType;
        self.shopID = info.shopID;
        self.postcode = info.postcode;
        self.website = info.website;
        self.email = info.email;
        self.province = info.province;
        self.pcode = info.pcode;
        self.city = info.city;
        self.citycode = info.citycode;
        self.gridcode = info.gridcode;
        self.direction = info.direction;
        self.businessArea = info.businessArea;
    }
    return self;
}

- (instancetype)initWithPoiInfo:(MapPoiInfo *)info timeStamp:(NSTimeInterval)timeStamp {
    MapSearchHistory *obj = [self initWithPoiInfo:info];
    obj.timeStamp = timeStamp;
    return obj;
}

+ (LKDBHelper *)getUsingLKDBHelper {
    static LKDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"searchHistory/searchHistory.db"];
        db = [[LKDBHelper alloc] initWithDBPath:dbPath];
        [db setKey:@"encry"];
    });
    return db;
}

+ (NSString *)getTableName {
    return @"SearchHistory";
}

+ (BOOL)isContainParent {
    return YES;
}

+ (BOOL)isContainSelf {
    return YES;
}

+ (BOOL)dbWillInsert:(NSObject *)entity {
    NSLog(@"will insert:%@",NSStringFromClass(self));
    return YES;
}

+ (void)dbDidInserted:(NSObject *)entity result:(BOOL)result {
    NSLog(@"did insert:%@",NSStringFromClass(self));
}

+ (void)updateWithHistory:(MapSearchHistory *)history {
    MapSearchHistory *tmp = [MapSearchHistory selectHistoryWithLatitude:history.coordinate.latitude longitude:history.coordinate.longitude];
    if (tmp) {//update
        tmp.timeStamp = [[NSDate date] timeIntervalSince1970];
        [[self getUsingLKDBHelper] updateToDB:tmp where:nil];
    } else {//insert
        [[self getUsingLKDBHelper] insertWhenNotExists:history];
    }
}

+ (NSMutableArray<MapSearchHistory *> *)selectHistoryWithWhere:(id)where orderBy:(NSString *)orderBy {
    NSMutableArray *arr = [[self getUsingLKDBHelper] search:[MapSearchHistory class] where:where orderBy:orderBy offset:0 count:0];
    for (MapSearchHistory *tmp in arr) {
        tmp.coordinate = CLLocationCoordinate2DMake(tmp.latitude, tmp.longitude);
    }
    return arr;
}

+ (MapSearchHistory *)selectHistoryWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    return [[self getUsingLKDBHelper] searchSingle:[MapSearchHistory class] where:[NSString stringWithFormat:@"latitude = %f and longitude = %f",latitude,longitude] orderBy:nil];
}

+ (NSMutableArray *)selectAllHistoryWithTimeStampDesc {
    NSMutableArray *arr = [[self getUsingLKDBHelper] search:[MapSearchHistory class] where:nil orderBy:@"timeStamp desc" offset:0 count:0];
    for (MapSearchHistory *tmp in arr) {
        tmp.coordinate = CLLocationCoordinate2DMake(tmp.latitude, tmp.longitude);
    }
    return arr;
}

+ (void)dropAllHistory {
    [LKDBHelper clearTableData:[MapSearchHistory class]];
}

@end
