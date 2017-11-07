//
//  MapSearchObject.h
//  MapManager
//
//  Created by yxliu on 2017/10/31.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MapSearchObject : NSObject

@end


/**
 输入提示
 */
@interface MapSearchTip : MapSearchObject

/**
 名称
 */
@property (nonatomic, copy) NSString *name;

/**
 区域编码
 */
@property (nonatomic, copy) NSString *adcode;

/**
 所属区域
 */
@property (nonatomic, copy) NSString *district;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end


/**
 点标注数据
 */
@interface MapSearchPointAnnotation : MapSearchObject

/**
 经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 副标题
 */
@property (nonatomic, copy) NSString *subtitle;

@end


/**
 POI点
 */
@interface MapSearchPoi : MapSearchObject

/**
 名称
 */
@property (nonatomic, copy) NSString *name;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 经纬度
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 城市
 */
@property (nonatomic, copy) NSString *city;

/**
 城市编码
 */
@property (nonatomic, copy) NSString *cityCode;

@end
