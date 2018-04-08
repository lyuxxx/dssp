//
//  CarflowModel.h
//  dssp
//
//  Created by qinbo on 2017/12/29.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarflowModel : NSObject
@property (nonatomic , copy) NSString *useFlow;
@property (nonatomic , assign) double wifi;
@property (nonatomic , copy) NSString *totalFlow;
@property (nonatomic , assign) double music;
@property (nonatomic , copy)   NSString *thresholdVal;
@property (nonatomic , copy) NSString *remainFlow;
@property (nonatomic , assign) double fm;
@property (nonatomic , copy) NSString *ota;
@end
