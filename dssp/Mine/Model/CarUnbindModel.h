//
//  CarUnbindModel.h
//  dssp
//
//  Created by qinbo on 2018/1/3.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarUnbindModel : NSObject
@property (nonatomic , copy) NSString              * carunbindId;
@property (nonatomic , copy) NSString              * vin;
@property (nonatomic , copy) NSString              * customerId;
@property (nonatomic , copy) NSString              * doptCode;
@property (nonatomic , copy) NSString              * vhlLisence;
@property (nonatomic , copy) NSString              * vhlBrandId;
@property (nonatomic , copy) NSString              * vhlSeriesId;
@property (nonatomic , copy) NSString              * vhlTypeId;
@property (nonatomic , copy) NSString              * vhlColorId;
@property (nonatomic , copy) NSString              * vhlStatus;
@property (nonatomic , copy) NSString              * insuranceId;
@property (nonatomic , copy) NSString              * dealerId;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              updateTime;
@property (nonatomic , copy) NSString              *color;
@end
