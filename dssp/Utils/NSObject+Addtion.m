//
//  NSObject+Addtion.m
//  dssp
//
//  Created by dy on 2018/5/18.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "NSObject+Addtion.h"

@implementation NSObject (ZDAddtion)

+ (BOOL)isNullWithObject:(id)object {
    if (nil == object) {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else if ([object isEqual:[NSNull null]]) {
        return YES;
    }else {
        
    }
    return NO;
}

@end

@implementation NSString (ZDStringExtension)

+ (BOOL)isEmptyWithString:(NSString *)string {
    return [NSString isNullOrEmptyWithString:string];
}

+ (BOOL)isNullOrEmptyWithString:(NSString *)string {
    if ([NSString isNullWithObject:string]) {
        return YES;
    } else if (!string) {
        return YES;
    } else {
        if ([string isKindOfClass:[NSString class]]) {
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
            
            if ([trimedString length] == 0) {
                return YES;
            }else {
                return NO;
            }
        }else {
            return NO;
        }
    }
    return NO;
}

- (BOOL)containEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              // surrogate pair
                              if (0xd800) {
                                  if (0xd800 <= hs && hs <= 0xdbff) {
                                      if (substring.length > 1) {
                                          const unichar ls = [substring characterAtIndex:1];
                                          const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                          if ((0x1d000 <= uc && uc <= 0x1f77f)||
                                              (0x1f910 <= uc && uc <= 0x1f984)) {
                                              returnValue =YES;
                                          }
                                      }
                                  }else if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      if (ls == 0x20e3) {
                                          returnValue =YES;
                                      }
                                  }else {
                                      // non surrogate
                                      if (0x2100 <= hs && hs <= 0x27ff) {
                                          returnValue =YES;
                                      }else if (0x2B05 <= hs && hs <= 0x2b07) {
                                          returnValue =YES;
                                      }else if (0x2934 <= hs && hs <= 0x2935) {
                                          returnValue =YES;
                                      }else if (0x3297 <= hs && hs <= 0x3299) {
                                          returnValue =YES;
                                      }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                          returnValue =YES;
                                      }
                                  }
                              }
                          }];
    return returnValue;
    
}

- (BOOL)containEngChar {
    for(int i = 0; i < self.length; i++) {
        unichar chara = [self characterAtIndex:i];
        if ((chara > 64 && chara < 91) || (chara > 96 && chara < 123)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containChineseChar {
    for (int i = 0; i < self.length; i++) {
        NSString *str = [@"" stringByPaddingToLength:1 withString:self startingAtIndex:i];
        if ([self isChinese:str]) {
            //包含中文字符
            return YES;
        }
    }
    return NO;
}

- (BOOL)isChinese:(NSString *)c {
    int strLength = 0;
    char *p = (char *)[c cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [c lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strLength++;
        }else {
            p++;
        }
    }
    return ((strLength / 2) == 1) ? YES : NO;
}

- (BOOL)containNumberChar {
    for(int i = 0; i < self.length; i++) {
        unichar chara = [self characterAtIndex:i];
        if (chara > 47 && chara < 58) {
            //包含数字
            return YES;
        }
    }
    return NO;
}

+ (NSString *)stringFormatWithNSNumber:(NSNumber*)nsNumber {
    NSString * value = @"";
    if (nil == nsNumber) {
        return value;
    }
    
    if (![nsNumber isKindOfClass:NSClassFromString(@"NSNumber")]) {
        return value;
    }
    
    NSString *temStr = [nsNumber stringValue];
    
    if (nil != temStr && [temStr rangeOfString:@"."].length > 0) {
        // 包含点，则认为后台返回的是浮点数，为避免造成精度错误，强制处理只保留一位小数
        value = [NSString stringWithFormat:@"%.1f",nsNumber.doubleValue];
    }
    else {
        // 如果不包含点，则认为是整数，直接取值即可
        value = temStr;
    }
    
    return value;
}

- (NSString *)stringByAppendingAnotherString:(NSString *)string {
    if(!string) {
        return self;
    }
    else {
        return [self stringByAppendingString:string];
    }
}

- (NSString *)unicode2Chinese {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL
                                                                      error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end

@implementation NSArray(SafeObject)

- (id)safeObjectAtIndex:(NSInteger)index {
    if(index < 0) {
        return nil;
    }
    if(self.count == 0) {
        return nil;
    }
    if(index > MAX(self.count - 1, 0)) {
        return nil;
    }
    return ([self objectAtIndex:index]);
}

@end

@implementation NSMutableArray(SafeObject)

- (void)safeAddObject:(id)anObject {
    if(!anObject) {
        return;
    }
    [self addObject:anObject];
}

- (void)safeInsertObject:(id)anObject atIndex:(NSInteger)index {
    if(index < 0) {
        return;
    }
    if(index > MAX((NSInteger)self.count - 1, 0)) {
        NSLog(@"%s:out of range", __func__);
        return;
    }
    if(!anObject) {
        NSLog(@"%s:object must not nil", __func__);
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)safeRemoveObjectAtIndex:(NSInteger)index {
    if(index < 0) {
        return;
    }
    if(index > MAX((NSInteger)self.count - 1, 0)) {
        NSLog(@"%s:out of range", __func__);
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)safeReplaceObjectAtIndex:(NSInteger)index withObject:(id)anObject{
    if(index < 0) {
        return;
    }
    if(index > MAX((NSInteger)self.count - 1, 0)) {
        NSLog(@"%s:out of range", __func__);
        return;
    }
    if(!anObject) {
        NSLog(@"%s:object must not nil", __func__);
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}
@end

@implementation NSDictionary(SafeObject)

- (NSString *)stringObjectForKey:(id <NSCopying>)key {
    if (!key) {
        return @"";
    }
    
    id ob = [self objectForKey:key];
    if(ob == [NSNull null] || ob == nil) {
        return (@"");
    }
    if([ob isKindOfClass:[NSString class]]) {
        return (ob);
    }
    return ([NSString stringWithFormat:@"%@", ob]);
}

- (id)safeJsonObjectForKey:(id <NSCopying>)key {
    if (!key) {
        return nil;
    }
    
    id ob = [self objectForKey:key];
    if(ob == [NSNull null]) {
        return nil;
    }
    return ob;
}
@end

@implementation NSMutableDictionary(SafeObject)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if(!aKey) {
        NSLog(@"%s:key must not nil", __func__);
        return;
    }
    if(!anObject) {
        NSLog(@"%s:value must not nil", __func__);
        return;
    }
    [self setObject:anObject forKey:aKey];
}
@end

