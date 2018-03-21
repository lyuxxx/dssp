//
//  CatchCrash.h
//  dssp
//
//  Created by yxliu on 2018/3/19.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashObject : NSObject
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *systemVersion;
@property (nonatomic, copy) NSString *versionName;
@property (nonatomic, copy) NSString *versionCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *systemType;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *exceptionInfo;
@end

@interface CatchCrash : NSObject
void uncaughtExceptionHandler(NSException *exception);
@end
