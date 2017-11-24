//
//  MapSearchHistory.h
//  dssp
//
//  Created by yxliu on 2017/11/24.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <MapSearchManager.h>
#import <LKDBHelper.h>

@interface MapSearchHistory : MapSearchObject

@property (nonatomic, assign) NSTimeInterval timeStamp;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

- (instancetype)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate timeStamp:(NSTimeInterval)timeStamp;

///包含insert和update
+ (void)updateWithHistory:(MapSearchHistory *)history;
+ (NSMutableArray<MapSearchHistory *> *)selectHistoryWithWhere:(id)where orderBy:(NSString *)orderBy;
+ (NSMutableArray *)selectAllHistoryWithTimeStampDesc;
+ (void)dropAllHistory;

@end
