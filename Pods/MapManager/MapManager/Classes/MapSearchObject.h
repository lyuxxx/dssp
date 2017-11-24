//
//  MapSearchObject.h
//  MapManager
//
//  Created by yxliu on 2017/10/31.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MapAnnotation <NSObject>
///名称
@property (nonatomic, copy) NSString *name;
///地址
@property (nonatomic, copy) NSString *address;
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@interface MapSearchObject : NSObject <MapAnnotation>
///经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
///名称
@property (nonatomic, copy) NSString *name;
///地址
@property (nonatomic, copy) NSString *address;
@end

///输入提示
@interface MapSearchTip : MapSearchObject
///poi的id
@property (nonatomic, copy) NSString *uid;
///区域编码
@property (nonatomic, copy) NSString *adcode;
///所属区域
@property (nonatomic, copy) NSString *district;
@end


/**
 点标注数据
 */
@interface MapSearchPointAnnotation : MapSearchObject

@end


/**
 POI点
 */
@interface MapSearchPoi : MapSearchObject
///城市
@property (nonatomic, copy) NSString *city;
///城市编码
@property (nonatomic, copy) NSString *cityCode;
@end

@interface MapReGeoInfo : MapSearchObject

///格式化地址
@property (nonatomic, copy) NSString *formattedAddress;
///省/直辖市
@property (nonatomic, copy) NSString *province;
///市
@property (nonatomic, copy) NSString *city;
///城市编码
@property (nonatomic, copy) NSString *citycode;
///区
@property (nonatomic, copy) NSString *district;
///区域编码
@property (nonatomic, copy) NSString *adcode;
///乡镇街道
@property (nonatomic, copy) NSString *township;
///乡镇街道编码
@property (nonatomic, copy) NSString *towncode;
///社区
@property (nonatomic, copy) NSString *neighborhood;
///建筑
@property (nonatomic, copy) NSString *building;

@end
