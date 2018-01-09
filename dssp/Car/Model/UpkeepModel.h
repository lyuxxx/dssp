//
//  UpkeepModel.h
//  dssp
//
//  Created by qinbo on 2018/1/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpkeepModel : NSObject
@property (nonatomic , copy) NSString * vin;
@property (nonatomic , copy) NSString * maintenanceDay;
@property (nonatomic , copy) NSString * maintenanceMileage;
@property (nonatomic , copy) NSString * collectTime;
@end
