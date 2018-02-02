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
@property (nonatomic, copy) NSString *vhlLicence;
///备注
@property (nonatomic, copy) NSString *remark;
///发动机号
@property (nonatomic, copy) NSString *doptCode;
///颜色
@property (nonatomic, copy) NSString *colorId;

@end




@interface CarBindingtepy : NSObject<YYModel>
@property (nonatomic , copy) NSString              * vhlNtTypeId;
@property (nonatomic , copy) NSString              * typeName;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * recordStatus;
@property (nonatomic , copy) NSString              * updateTime;
@end

@interface CarBindingcolor : NSObject<YYModel>
@property (nonatomic , assign) NSInteger              currentPage;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , copy) NSString              * carBindingcolord;
@property (nonatomic , copy) NSString              * colorName;
@property (nonatomic , copy) NSString              * recordStatus;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * updateTime;
@end




