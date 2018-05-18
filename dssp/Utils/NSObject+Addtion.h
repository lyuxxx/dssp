//
//  NSObject+Addtion.h
//  dssp
//
//  Created by season on 2018/5/18.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@interface NSObject (ZDAddtion)


/**
 对象是否存在
 
 @param object 传入需要判断的对象
 @return 返回是或否
 */
+ (BOOL)isNullWithObject:(id)object;

@end



/**
 注意:使用NSString的对象方法前,请先确保对象是存在的
 */
@interface NSString (ZDStringExtension)


/**
 字符是否为空
 
 @param string 传入需要判断的字符串
 @return 返回是或否
 */
+ (BOOL)isEmptyWithString:(NSString *)string;


/**
 字符是否为空格或者为null
 
 @param string 传入需要判断的字符串
 @return 返回是或否
 */
+ (BOOL)isNullOrEmptyWithString:(NSString *)string;

/**
 字符串中是否包含emoji表情
 
 @return 返回是或者否
 */
- (BOOL)containEmoji;


/**
 字符串中是否包含英文字符
 
 @return 返回是或者否
 */
- (BOOL)containEngChar;


/**
 字符串中是否包含中文字符
 
 @return 返回是或者否
 */
- (BOOL)containChineseChar;


/**
 字符串中是否包含数字字符
 
 @return 返回是或否
 */
- (BOOL)containNumberChar;


/**
 将NSNumber转化为NSString
 
 @param nsNumber 输入NSNumber类型的参数
 @return 返回NSString
 */
+ (NSString *)stringFormatWithNSNumber:(NSNumber*)nsNumber;


/**
 字符串拼接
 
 @param string 拼接的字符串,对其进行判断
 @return 整体字符串
 */
- (NSString *)stringByAppendingAnotherString:(NSString *)string;


/**
 Unicode转中文
 
 @return 返回中文
 */
- (NSString *)unicode2Chinese;

@end

@interface NSArray(SafeObject)

/**
 安全的通过数组下标获取元素
 
 @param index 数组下标
 @return 元素
 */
- (id)safeObjectAtIndex:(NSInteger)index;

@end


@interface NSMutableArray(SafeObject)

/**
 安全的添加元素
 
 @param anObject 添加的元素
 */
- (void)safeAddObject:(id)anObject;


/**
 安全的插入元素
 
 @param anObject 添加的元素
 @param index 下标号码
 */
- (void)safeInsertObject:(id)anObject atIndex:(NSInteger)index;


/**
 安全的通过下标删除元素
 
 @param index 下标号码
 */
- (void)safeRemoveObjectAtIndex:(NSInteger)index;


/**
 安全的通过下标替换元素
 
 @param index 下标号码
 @param anObject 元素
 */
- (void)safeReplaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
@end

@interface NSDictionary(SafeObject)

/**
 安全的通过key拿NSSting类型的value,用于[string:stirng]的字典
 
 @param key key
 @return value
 */
- (NSString *)stringObjectForKey:(id <NSCopying>)key;


/**
 安全的通过key拿到Json对象
 
 @param key key
 @return value
 */
- (id)safeJsonObjectForKey:(id <NSCopying>)key;
@end

@interface NSMutableDictionary(SafeObject)

/**
 安全的通过key装载对象
 
 @param anObject value
 @param aKey key
 */
- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;
@end
