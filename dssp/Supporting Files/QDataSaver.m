//
//  QDataSaver.m
//  dssp
//
//  Created by qinbo on 2018/3/6.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "QDataSaver.h"

@implementation QDataSaver
+(void)saveString:(NSString *)string forKey:(NSString *)key
{NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:key];
    [defaults synchronize];
}
+(NSString *)getStringForKey:(NSString *)key
{ NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
+(void)removeStringForKey:(NSString *)key
{ NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
@end
