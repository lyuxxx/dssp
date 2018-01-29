//
//  LllegaModel.h
//  dssp
//
//  Created by qinbo on 2018/1/29.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LllegaModel : NSObject
//主键id
@property (nonatomic , assign) NSInteger  violationsDetailId;
//车架号
@property (nonatomic , copy) NSString *vin;
//采集机关
@property (nonatomic , copy) NSString *agency;
//违章地点
@property (nonatomic , copy) NSString *address;
//罚款
@property (nonatomic , copy) NSString *fine;
//是否处理
@property (nonatomic , copy) NSString *handled;
//罚分
@property (nonatomic , copy) NSString *point;
//违章时间
@property (nonatomic , copy) NSString *time;
//违章行为
@property (nonatomic , copy) NSString *violationType;
//推送时间
@property (nonatomic , copy) NSString *pushTime;
//是否已推送
@property (nonatomic , assign) NSInteger  pushYn;
@end
