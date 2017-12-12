//
//  RNRInput.h
//  dssp
//
//  Created by yxliu on 2017/11/16.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNRInput : NSObject

///姓名
@property (nonatomic, copy) NSString *username;
///性别
@property (nonatomic, copy) NSString *gender;
///证件类型
@property (nonatomic, copy) NSString *ownercerttype;
///证件号码
@property (nonatomic, copy) NSString *ownercertid;
///所有人证件地址
@property (nonatomic, copy) NSString *ownercertaddr;
///证件正面
@property (nonatomic, copy) NSString *pic1;
///证件背面
@property (nonatomic, copy) NSString *pic2;
///手持证件照
@property (nonatomic, copy) NSString *facepic;
///联系电话
@property (nonatomic, copy) NSString *servnumber;
///ICCID
@property (nonatomic, copy) NSString *iccid;
@end
