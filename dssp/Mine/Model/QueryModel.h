//
//  QueryModel.h
//  dssp
//
//  Created by qinbo on 2018/1/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryModel : NSObject
@property (nonatomic , copy) NSString              * vhlTStatus;
@property (nonatomic , copy) NSString              * vhlStatus;
@property (nonatomic , assign) NSInteger           vhlBindStatus;
@property (nonatomic , copy) NSString              * vhlFlowStatus;
@property (nonatomic , copy) NSString              * vhlActivate;
@property (nonatomic , copy) NSString              * serviceStatus;
@property (nonatomic , copy) NSString              * finalStatus;
@property (nonatomic , copy) NSString              * certificationStatus;
@end
