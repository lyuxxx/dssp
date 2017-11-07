//
//  MapSearchManager.h
//  MapManager
//
//  Created by yxliu on 2017/10/31.
//

#import <Foundation/Foundation.h>
#import "MapSearchObject.h"

/**
 关键字搜索回调block

 @param pointAnnotations 返回的点标注数组
 */
typedef void(^KeyWordSearchBlock)(NSArray<__kindof MapSearchPointAnnotation *> *pointAnnotations);

/**
 tips搜索回调block

 @param tips 返回的tips数组
 */
typedef void(^TipsSearchBlock)(NSArray<__kindof MapSearchTip *> *tips);

/**
 逆地理编码周边poi回调

 @param pois 回调的pois
 */
typedef void(^ReGeocodeSearchBlock)(NSArray<__kindof MapSearchPoi *> *pois);

@interface MapSearchManager : NSObject

/**
 单例模式

 @return 返回单例
 */
+ (instancetype)sharedManager;

/**
 关键字检索
 注意：关键字未设置城市信息（默认为全国搜索）时，如果涉及多个城市数据返回，仅会返回建议城市

 @param keyword 关键字
 @param city 城市
 @param block 返回的block
 */
- (void)keyWordsSearch:(NSString *)keyword
                  city:(NSString *)city
           returnBlock:(TipsSearchBlock)block;

/**
 输入提示查询

 @param keyword 关键字
 @param city 城市
 @param block 返回的Tips
 */
- (void)inputTipsSearch:(NSString *)keyword
                   city:(NSString *)city
            returnBlock:(TipsSearchBlock)block;

/**
 根据经纬度逆地理编码查询POI点

 @param coordinate 传入的经纬度
 @param block 返回的经纬度逆地理编码附近poi点
 */
- (void)poiReGeocode:(CLLocationCoordinate2D)coordinate
         returnBlock:(ReGeocodeSearchBlock)block;

@end
