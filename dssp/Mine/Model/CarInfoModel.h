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
@property (nonatomic, copy) NSString *insruanceCompany;
///保单号
@property (nonatomic, copy) NSString *insruanceNum;
///保险到期日
@property (nonatomic, assign) NSInteger dueDate;
///销售时间
@property (nonatomic, assign) NSInteger saleDate;
///记录状态编码
@property (nonatomic, copy) NSString *recordStatus;
///创建时间
@property (nonatomic, assign) NSInteger createTime;
///最后更新时间
@property (nonatomic, assign) NSInteger updateTime;
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
///当前VIN号是否绑定用户信息
@property (nonatomic, copy) NSString *userRel;
///车辆T状态
@property (nonatomic, copy) NSString *vhlTStatus;

@end


@interface CarbindModel : NSObject <YYModel>
@property (nonatomic , copy) NSString *vin;
@property (nonatomic , copy) NSString *vhlBrandId;
@property (nonatomic , copy) NSString *vhlBrandName;
@property (nonatomic , copy) NSString *vhlSeriesId;
@property (nonatomic , copy) NSString *vhlSeriesName;
@property (nonatomic , copy) NSString *vhlTypeId;
@property (nonatomic , copy) NSString *vhlTypeName;
@property (nonatomic , copy) NSString *vhlColorName;
@property (nonatomic , copy) NSString *vhlColorId;
@property (nonatomic , copy) NSString *vhlTStatus;
@property (nonatomic , copy) NSString *doptCode;
@property (nonatomic , copy) NSString *userName;
@property (nonatomic , copy) NSString *mobilePhone;
@property (nonatomic , copy) NSString *sex;
@property (nonatomic , assign) BOOL isExist;
@property (nonatomic , copy) NSString *vhlLicence;
@end
