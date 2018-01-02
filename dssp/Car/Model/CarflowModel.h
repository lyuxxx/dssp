//
//  CarflowModel.h
//  dssp
//
//  Created by qinbo on 2017/12/29.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarflowModel : NSObject
@property (nonatomic , assign) NSInteger              useFlow;
@property (nonatomic , assign) NSInteger              wifi;
@property (nonatomic , assign) NSInteger              totalFlow;
@property (nonatomic , assign) NSInteger              music;
@property (nonatomic , copy)   NSString              * thresholdVal;
@property (nonatomic , assign) NSInteger              remainFlow;
@property (nonatomic , assign) NSInteger              fm;
@property (nonatomic , assign) NSInteger              ota;
@end
