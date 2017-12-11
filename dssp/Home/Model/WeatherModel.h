//
//  WeatherModel.h
//  dssp
//
//  Created by qinbo on 2017/12/11.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherObserve :NSObject
//天气现象
@property (nonatomic , copy) NSString *WeatherPhenomena;
//当前温度
@property (nonatomic , copy) NSString *CTemperature;
//当前风向
@property (nonatomic , copy) NSString *WindDirection;
//当前风力
@property (nonatomic , copy) NSString *WindForce;
//当前湿度
@property (nonatomic , copy) NSString *RH;
//实况发布时间
@property (nonatomic , copy) NSString *ObservePublishTime;
//能见度
@property (nonatomic , copy) NSString *Visibility;
//气压
@property (nonatomic , copy) NSString *Pressure;
//风速
@property (nonatomic , copy) NSString *WindSpeed;
//体感温度
@property (nonatomic , copy) NSString *SendibleTemperature;
//发布时间
@property (nonatomic , copy) NSString *PublishTime;
//风向角度
@property (nonatomic , copy) NSString *WindDirectionAngle;
//天气图片编码
@property (nonatomic , copy) NSString *WeatherCode;
//天气图片下载地址
@property (nonatomic , copy) NSString *WeatherImage;

@end


@interface ObserveData :NSObject

@property (nonatomic , strong) WeatherObserve *WeatherObserve;

@end


@interface WeatherModel :NSObject
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *msg;
@property (nonatomic , strong) ObserveData *data;

@end

