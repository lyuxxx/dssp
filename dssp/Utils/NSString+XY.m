//
//  NSString+XY.m
//  dssp
//
//  Created by qinbo on 2018/5/18.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "NSString+XY.h"

@implementation NSString (XY)
+ (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
