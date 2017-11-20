//
//  CarBindingInput.h
//  dssp
//
//  Created by yxliu on 2017/11/20.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarBindingInput : NSObject

///车架号
@property (nonatomic, copy) NSString *vin;
///车主名称
@property (nonatomic, copy) NSString *customerName;
///证件类型
@property (nonatomic, copy) NSString *credentials;
///证件号码
@property (nonatomic, copy) NSString *credentialsNum;
///性别
@property (nonatomic, copy) NSString *sex;
///移动电话
@property (nonatomic, copy) NSString *mobilePhone;
///家庭号码
@property (nonatomic, copy) NSString *phone;
///邮箱
@property (nonatomic, copy) NSString *email;
///车型
@property (nonatomic, copy) NSString *vhlType;
///车牌号
@property (nonatomic, copy) NSString *vhlLicense;
///备注
@property (nonatomic, copy) NSString *remark;
///发动机号
@property (nonatomic, copy) NSString *doptCode;

@end
