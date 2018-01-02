//
//  SubscribeModel.h
//  dssp
//
//  Created by qinbo on 2017/12/28.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeModel : NSObject
@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy)   NSString              * subscribeId;
@property (nonatomic , copy)   NSString              * name;
@property (nonatomic , copy)   NSString              * depict;
@property (nonatomic , copy)   NSString              * isEnable;
@property (nonatomic , copy)   NSString              * piority;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              lastUpdateTime;
@property (nonatomic , copy)   NSString              * isDel;
@end
