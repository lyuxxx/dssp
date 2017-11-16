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
@property (nonatomic, assign) NSInteger carId;
///车架号
@property (nonatomic, copy) NSString *vin;
///经销商姓名
@property (nonatomic, copy) NSString *dealerName;
///客户姓名
@property (nonatomic, copy) NSString *customerName;
///客户证件类型编码
@property (nonatomic, strong) NSString *customerCredentials;
///客户证件号码
@property (nonatomic, strong) NSString *customerCredentialsNum;
///客户性别编码
@property (nonatomic, copy) NSString *customerSex;
///客户手机号码
@property (nonatomic, assign) NSString *customerMobilePhone;
///客户家庭电话
@property (nonatomic, copy) NSString *customerHomePhone;
///用户邮箱
@property (nonatomic, copy) NSString *customerEmail;
///车辆颜色代码
@property (nonatomic, strong) NSString *vhlColor;
///车牌号
@property (nonatomic, strong) NSString *vhlLicence;
///备注
@property (nonatomic, strong) NSString *remark;
///车辆状态编码
@property (nonatomic, strong) NSString *vhlStatus;
///服务等级
@property (nonatomic, strong) NSString *serviceLevelId;
///保险公司名称
@property (nonatomic, strong) NSString *insuranceCompany;
///保单号
@property (nonatomic, strong) NSString *insuranceNum;
///保险到期日
@property (nonatomic, strong) NSDate *dueDate;
///销售时间
@property (nonatomic, strong) NSDate *saleDate;
///记录状态编码
@property (nonatomic, strong) NSString *recordStatus;
///创建时间
@property (nonatomic, strong) NSDate *createTime;
///最后更新时间
@property (nonatomic, strong) NSDate *updateTime;
///客户证件类型
@property (nonatomic, strong) NSString *credentialsName;
///客户性别
@property (nonatomic, strong) NSString *customerSexName;
///车辆状态
@property (nonatomic, strong) NSString *vhlStatusName;
///品牌名称
@property (nonatomic, strong) NSString *brandName;
///颜色名称
@property (nonatomic, strong) NSString *colorName;
///车系名称
@property (nonatomic, strong) NSString *seriesName;
///车型名称
@property (nonatomic, strong) NSString *typeName;
@end
