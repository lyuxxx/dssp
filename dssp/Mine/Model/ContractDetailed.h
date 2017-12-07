//
//  ContractDetailed.h
//  dssp
//
//  Created by qinbo on 2017/12/7.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>



@interface vhlTypeModel : NSObject
//车型id
@property (nonatomic , copy) NSString *carmodelId;
//车型名称
@property (nonatomic , copy) NSString *typeName;
//品牌代码
@property (nonatomic , copy) NSString *vhlBrandId;
//车系代码
@property (nonatomic , copy) NSString *vhlSeriesId;
//记录状态
@property (nonatomic , copy) NSString *recordStatus;
//操作人id
@property (nonatomic , copy) NSString *userId;
//创建时间
@property (nonatomic , assign) NSInteger updatTime;
//最后更新时间
@property (nonatomic , assign) NSInteger createTime;
@end


@interface vhlSeriesModel : NSObject
//车系id
@property (nonatomic , copy) NSString *cartrainId;
//车系名称
@property (nonatomic , copy) NSString *seriesName;
//是否进口车
@property (nonatomic , copy) NSString *seriesType;
//品牌代码
@property (nonatomic , copy) NSString *vhlBrandId;
//记录状态
@property (nonatomic , copy) NSString *recordStatus;
//操作人id
@property (nonatomic , copy) NSString *userId;
//创建时间
@property (nonatomic , assign) NSInteger updatTime;
//最后更新时间
@property (nonatomic , assign) NSInteger createTime;
//当前页
@property (nonatomic , copy) NSString *currentPage;
//当前页条数
@property (nonatomic , copy) NSString *pageSize;
@end


@interface vhlBrandModel : NSObject
//品牌代码
@property (nonatomic , copy) NSString *brandId;
//品牌名称
@property (nonatomic , copy) NSString *brandName;
//记录状态
@property (nonatomic , copy) NSString *recordStatus;
//创建时间
@property (nonatomic , assign) NSInteger updatTime;
//最后更新时间
@property (nonatomic , assign) NSInteger createTime;
@end


@interface serviceItemProfiles : NSObject
//当前页
@property (nonatomic , copy) NSString *currentPage;
//当前页条数
@property (nonatomic , copy) NSString *pageSize;
//id
@property (nonatomic , copy) NSString *elemServiceId;
//品牌
@property (nonatomic , copy) NSString *vhlBrandId;
//车型
@property (nonatomic , copy) NSString *vhlModelId;
//车系
@property (nonatomic , copy) NSString *vhlSeriesId;
//设备类型
@property (nonatomic , copy) NSString *deviceType;
//服务项编码
@property (nonatomic , copy) NSString *businessServiceCode;
//服务项别名
@property (nonatomic , copy) NSString *businessServiceLabel;
//创建时间
@property (nonatomic , assign) NSInteger createTime;
//最后更新时间
@property (nonatomic , assign) NSInteger lastUpdateTime;

@end


@interface ContractData : NSObject <YYModel>
//套餐ID
@property (nonatomic , copy) NSString *packageId;
//套餐名称
@property (nonatomic , copy) NSString *name;
//描述
@property (nonatomic , copy) NSString *descript;
//T服务套餐周期数
@property (nonatomic , copy) NSString *packNum;
//记录删除标志
@property (nonatomic , copy) NSString *recordStatus;
//是否有效
@property (nonatomic , copy) NSString *isValid;
//套餐类型
@property (nonatomic , copy) NSString *packType;

@property (nonatomic, strong) vhlTypeModel *vhlTypedata;
@property (nonatomic, strong) vhlSeriesModel *vhlSeriesdata;
@property (nonatomic, strong) vhlBrandModel *vhlBranddata;
@property (nonatomic, strong) serviceItemProfiles *serviceItemdata;

//创建时间
@property (nonatomic , assign) NSInteger createTime;
//创建人
@property (nonatomic , copy) NSString *createBy;
//最后更新时间
@property (nonatomic , assign) NSInteger lastUpdateTime;
//最后更新人
@property (nonatomic , copy) NSString *lastUpdateBy;
@end


@interface ContractDetailed : NSObject
///结果状态码
@property (nonatomic, copy) NSString *code;
///处理结果描述
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) ContractData *data;
@end

