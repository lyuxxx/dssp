//
//  ForecastModel.h
//  dssp
//
//  Created by qinbo on 2017/12/11.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ForecastInfoItem :NSObject
//预报日期
@property (nonatomic , copy) NSString *ForcastDate;
//白天天气现象
@property (nonatomic , copy) NSString *DayWeatherPhenomena;
//白天摄氏温度
@property (nonatomic , copy) NSString *DayCTemperature;
//晚上天气现象
@property (nonatomic , copy) NSString *NightWeatherPhenomena;
//晚上摄氏温度
@property (nonatomic , copy) NSString *NightCTemperature;
//白天风向
@property (nonatomic , copy) NSString *DayWindDirection;
//白天风力
@property (nonatomic , copy) NSString *DayWindForce;
//晚上风向
@property (nonatomic , copy) NSString *NightWindDirection;
//晚上风力
@property (nonatomic , copy) NSString *NightWindForce;
//白天天气图片编码
@property (nonatomic , copy) NSString *DayWeatherCode;
//白天天气图片下载地址
@property (nonatomic , copy) NSString *DayWeatherImage;
//夜间天气图片编码
@property (nonatomic , copy) NSString *NightWeatherCode;
//夜间天气图片下载地址
@property (nonatomic , copy) NSString *NightWeatherImage;
//日出、日落时间
@property (nonatomic , copy) NSString *Sunrd;

@end


@interface WeatherForecast :NSObject
//区域id
@property (nonatomic , copy) NSString *AreaId;
//城市英文名
@property (nonatomic , copy) NSString *AreaEN;
//城市中文名
@property (nonatomic , copy) NSString *AreaZH;
//城市所在地英文名
@property (nonatomic , copy) NSString *CityEN;
//城市所在市中文名
@property (nonatomic , copy) NSString *CityZH;
//城市所在省英文名
@property (nonatomic , copy) NSString *ProvinceEN;
//城市所在国家英文名
@property (nonatomic , copy) NSString *StateEN;
//城市所在省中文名
@property (nonatomic , copy) NSString *ProvinceZH;
//城市所在国家中文名
@property (nonatomic , copy) NSString *StateZH;
//记录总数
@property (nonatomic , copy) NSString *RecordCount;
//发布时间
@property (nonatomic , copy) NSString *PublishTime;
@property (nonatomic , strong) NSArray <ForecastInfoItem *> *forecastInfo;
@end


@interface WeatherData :NSObject
@property (nonatomic , strong) WeatherForecast *forecast;
@end


@interface ForecastModel : NSObject
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *msg;
@property (nonatomic , strong) WeatherData *data;
@end
