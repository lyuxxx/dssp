//
//  CarInfoModel.h
//  dssp
//
//  Created by qinbo on 2017/11/16.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface CarInfoModel : NSObject
///车辆编码
@property (nonatomic, copy) NSString *carId;
///车架号
@property (nonatomic, copy) NSString *vin;
///经销商姓名
@property (nonatomic, copy) NSString *dealerName;
///客户姓名
@property (nonatomic, copy) NSString *customerName;
///客户证件类型编码
@property (nonatomic, copy) NSString *customerCredentials;
///客户证件号码
@property (nonatomic, copy) NSString *customerCredentialsNum;
///客户性别编码
@property (nonatomic, copy) NSString *customerSex;
///客户手机号码
@property (nonatomic, copy) NSString *customerMobilePhone;
///客户家庭电话
@property (nonatomic, copy) NSString *customerHomePhone;
///用户邮箱
@property (nonatomic, copy) NSString *customerEmail;
///车牌号
@property (nonatomic, copy) NSString *vhlLicence;
///备注
@property (nonatomic, copy) NSString *remark;
///车辆状态编码
@property (nonatomic, copy) NSString *vhlStatus;
///服务等级
@property (nonatomic, copy) NSString *serviceLevelId;
///保险公司名称
@property (nonatomic, copy) NSString *insuranceCompany;
///保单号
@property (nonatomic, copy) NSString *insuranceNum;
///保险到期日
@property (nonatomic, strong) NSDate *dueDate;
///销售时间
@property (nonatomic, strong) NSDate *saleDate;
///记录状态编码
@property (nonatomic, copy) NSString *recordStatus;
///创建时间
@property (nonatomic, strong) NSDate *createTime;
///最后更新时间
@property (nonatomic, strong) NSDate *updateTime;
///客户证件类型
@property (nonatomic, copy) NSString *credentialsName;
///客户性别
@property (nonatomic, copy) NSString *customerSexName;
///车辆状态
@property (nonatomic, copy) NSString *vhlStatusName;
///记录状态
@property (nonatomic, copy) NSString *recordStatusName;
///品牌名称
@property (nonatomic, copy) NSString *brandName;
///颜色名称
@property (nonatomic, copy) NSString *colorName;
///车系名称
@property (nonatomic, copy) NSString *seriesName;
///车型名称
@property (nonatomic, copy) NSString *typeName;
@end
