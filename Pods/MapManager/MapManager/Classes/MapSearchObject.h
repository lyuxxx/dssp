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

///合并了tip和poi
@interface MapPoiInfo : MapSearchObject
///uid
@property (nonatomic, copy) NSString *uid;
///区域编码
@property (nonatomic, copy) NSString *adcode;
///所属区域
@property (nonatomic, copy) NSString *district;
///兴趣点类型
@property (nonatomic, copy) NSString *type;
///类型码
@property (nonatomic, copy) NSString *typecode;
///电话
@property (nonatomic, copy) NSString *tel;
///距中心点的距离，单位米。在周边搜索时有效
@property (nonatomic, assign) NSInteger distance;
///停车场类型，地上、地下、路边
@property (nonatomic, copy) NSString *parkingType;
///商铺id
@property (nonatomic, copy) NSString *shopID;
///邮编
@property (nonatomic, copy) NSString *postcode;
///网址
@property (nonatomic, copy) NSString *website;
///电子邮件
@property (nonatomic, copy) NSString *email;
///省
@property (nonatomic, copy) NSString *province;
///省编码
@property (nonatomic, copy) NSString *pcode;
///城市名称
@property (nonatomic, copy) NSString *city;
///城市编码
@property (nonatomic, copy) NSString *citycode;
///地理格ID
@property (nonatomic, copy) NSString *gridcode;
///方向
@property (nonatomic, copy) NSString *direction;
///所在商圈
@property (nonatomic, copy) NSString *businessArea;
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
