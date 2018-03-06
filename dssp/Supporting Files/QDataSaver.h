//
//  QDataSaver.h
//  dssp
//
//  Created by qinbo on 2018/3/6.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDataSaver : NSObject
//轻量存储
+(void)saveString:(NSString *)string forKey:(NSString *)key;

//轻量获取本地数据
+(NSString*)getStringForKey:(NSString *)key;

//删除本地轻量数据
+(void)removeStringForKey:(NSString *)key;
@end
