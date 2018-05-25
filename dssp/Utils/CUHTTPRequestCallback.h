//
//  CUHTTPRequestCallback.h
//  dssp
//
//  Created by dy on 2018/5/25.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallbackSuccess)(id value);
typedef void(^CallbackFailure)(NSInteger code);

/**
网络请求万精油回调
 */
@interface CUHTTPRequestCallback : NSObject

/** 正常回调*/
@property(nonatomic,copy) CallbackSuccess success;

/** 异常回调*/
@property(nonatomic,copy) CallbackFailure failure;


@end
