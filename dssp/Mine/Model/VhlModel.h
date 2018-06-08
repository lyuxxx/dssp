
#import <Foundation/Foundation.h>
@interface VhlModel :NSObject <YYModel>
//车辆Id
@property (nonatomic , copy) NSString *vhlId;
//车架号
@property (nonatomic , copy) NSString *vin;
//车主编码
@property (nonatomic , copy) NSString *customerId;
//发动机号后七位
@property (nonatomic , copy) NSString *doptCode;
//车牌号
@property (nonatomic , copy) NSString *vhlLicence;
//颜色
@property (nonatomic , copy) NSString *vhlColorName;
@property (nonatomic , copy) NSString *color;
//备注
@property (nonatomic , copy) NSString *remark;
//品牌代码
@property (nonatomic , copy) NSString *vhlBrandName;
//车系代码
@property (nonatomic , copy) NSString *vhlSeriesId;
//车型代码
@property (nonatomic , copy) NSString *vhlTypeId;
//颜色代码
@property (nonatomic , copy) NSString *vhlColorId;
//车辆状态
@property (nonatomic , copy) NSString *vhlStatus;
//保险公司代码
@property (nonatomic , copy) NSString *insuranceId;
//保单号
@property (nonatomic , copy) NSString *insuranceNum;
//经销商
@property (nonatomic , copy) NSString *dealerId;
//车辆类型
@property (nonatomic , copy) NSString *isTest;
//记录状态
@property (nonatomic , copy) NSString *recordStatus;
//创建时间
@property (nonatomic , assign) NSInteger createTime;
//最后修改时间
@property (nonatomic , assign) NSInteger updateTime;
//车辆所属区域
@property (nonatomic , assign) NSInteger areaId;
//套餐id
@property (nonatomic , copy) NSString *servicePackageId;
//保险到期日
@property (nonatomic , assign) NSInteger dueDate;
//收车日期
@property (nonatomic , assign) NSInteger receiveDate;
//保险客服电话
@property (nonatomic , copy) NSString *insurancePhone;
//销售时间
@property (nonatomic , assign) NSInteger purchaseDate;
//过程状态
@property (nonatomic , copy) NSString *flowStatus;
//收车登记时间
@property (nonatomic , assign) NSInteger receiveCheckDate;
//颜色名
@property (nonatomic , copy) NSString *colorName;
//品牌名
@property (nonatomic , copy) NSString *brandName;
//车系名
@property (nonatomic , copy) NSString *seriesName;
@property (nonatomic , copy) NSString *vhlSeriesName;
//车型名
@property (nonatomic , copy) NSString *vhlTypeName;
//保险公司名
@property (nonatomic , copy) NSString *insuranceName;
//经销商名
@property (nonatomic , copy) NSString *dealerName;
//车辆T状态
@property (nonatomic , copy) NSString *vhlTStatus;

@property (nonatomic , copy) NSString *typeName;

@end
