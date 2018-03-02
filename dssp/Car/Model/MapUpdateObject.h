//
//  MapUpdateObject.h
//  dssp
//
//  Created by yxliu on 2018/2/27.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface ActivationCode : NSObject <YYModel>

@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *accCode;
@property (nonatomic, copy) NSString *dataVersion;
@property (nonatomic, strong) NSDate *getDate;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
///0：已过期1：已获取
@property (nonatomic, copy) NSString *recordStatus;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *custName;
@property (nonatomic, copy) NSString *custMobile;
@property (nonatomic, copy) NSString *checkCode;

@end

@interface ActivationCodeListResponse : NSObject <YYModel>
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray<ActivationCode *> *data;
@end
