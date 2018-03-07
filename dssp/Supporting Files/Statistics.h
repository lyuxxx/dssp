//
//  Statistics.h
//  dssp
//
//  Created by qinbo on 2018/3/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Statistics : NSObject


/*
 @property (strong, nonatomic) GFDataSaver *ZJDataSaver;
 简易统计界面停留时间/以及次数:
 
 */

+(void)staticsvisitTimesDataWithViewControllerType:(NSString *)type;//统计次数

+(void)staticsstayTimeDataWithType:(NSString *)type WithController:(NSString *)name;//统计时间计算,type: 1代表进入界面 2 :出界面

+(NSString *)staticsTimeDataWithController:(NSString *)name;//统计时间,一直停留的

+(NSString *)getStayTime:(NSString *)controller;

+(void)removeLocalDataWithController:(NSString *)name;//清除本地数据;

+(NSDictionary *)packageDictionary:(NSString *)name WithType:(NSString *)type;//打包字典
@end
