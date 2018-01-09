//
//  CarTrackModel.h
//  dssp
//
//  Created by qinbo on 2018/1/5.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarTrackModel : NSObject
@property (nonatomic , copy) NSString              * carTrackId;
@property (nonatomic , copy) NSString              * vin;
@property (nonatomic , copy) NSString              * responseBody;
@property (nonatomic , copy) NSString              * previousPosition;
@property (nonatomic , copy) NSString              * preDeadReckoningPosition;
@property (nonatomic , copy) NSString              * currentPosition;
@property (nonatomic , copy) NSString              * curDeadReckoningPosition;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              lastUpdateTime;

@end
