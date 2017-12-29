//
//  MapSearchManager.h
//  MapManager
//
//  Created by yxliu on 2017/10/31.
//

#import <Foundation/Foundation.h>
#import "MapSearchObject.h"

/**
 搜索失败block

 @param error 返回的错误信息
 */
typedef void(^SearchFailBlock)(NSError *error);

/**
 关键字搜索回调block

 @param pointAnnotations 返回的点标注数组
 */
typedef void(^KeyWordSearchBlock)(NSArray<__kindof MapPoiInfo *> *pointAnnotations);

/**
 周边搜索回调block

 @param pointAnnotations 返回的点标注数组
 */
typedef void(^KeyWordAroundBlock)(NSArray<__kindof MapPoiInfo *> *pointAnnotations);

/**
 id搜索poi数据回调

 @param pointAnnotation 返回的点标注数据
 */
typedef void(^IDSearchBlock)(MapPoiInfo *pointAnnotation);

/**
 tips搜索回调block

 @param tips 返回的tips数组
 */
typedef void(^TipsSearchBlock)(NSArray<__kindof MapPoiInfo *> *tips);

/**
 逆地理编码周边poi回调

 @param pois 回调的pois
 */
typedef void(^ReGeocodeSearchBlock)(NSArray<__kindof MapPoiInfo *> *pois);

/**
 逆地理编码地址信息回调

 @param regeoInfo 回调的地址信息
 */
typedef void(^ReGeoInfoBlock)(MapReGeoInfo *regeoInfo);

@interface MapSearchManager : NSObject

///失败block
@property (nonatomic, copy) SearchFailBlock searchFailBlock;

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
           returnBlock:(KeyWordSearchBlock)block;

/**
 周边关键字搜索

 @param keyword 关键字
 @param coordinate 位置
 @param block 返回的block
 */
- (void)keyWordsAround:(NSString *)keyword
              location:(CLLocationCoordinate2D)coordinate
           returnBlock:(KeyWordAroundBlock)block;

/**
 id检索poi数据回调

 @param idStr id
 @param block 返回的block
 */
- (void)idSearch:(NSString *)idStr
     returnBlock:(IDSearchBlock)block;

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
 根据location输入提示查询

 @param keyword 关键字
 @param city 城市
 @param location 位置,在此location附近优先返回搜索关键词信息
 @param block 返回的tips
 */
- (void)inputTipsSearch:(NSString *)keyword
                   city:(NSString *)city
               location:(CLLocationCoordinate2D)location
            returnBlock:(TipsSearchBlock)block;

/**
 根据经纬度逆地理编码查询POI点

 @param coordinate 传入的经纬度
 @param block 返回的经纬度逆地理编码附近poi点
 */
- (void)poiReGeocode:(CLLocationCoordinate2D)coordinate
         returnBlock:(ReGeocodeSearchBlock)block;

/**
 根据经纬度逆地理编码查询地址信息

 @param coordinate 传入的经纬度
 @param block 返回的地址信息
 */
- (void)reGeoInfo:(CLLocationCoordinate2D)coordinate
      returnBlock:(ReGeoInfoBlock)block;

@end
