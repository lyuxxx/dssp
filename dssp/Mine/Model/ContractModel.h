//
//  ContractModel.h
//  dssp
//
//  Created by qinbo on 2017/12/7.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface result : NSObject
//页数
@property (nonatomic , copy) NSString *pageSize;
//当前页条数
@property (nonatomic , copy) NSString *currentPage;
//合同id
@property (nonatomic , copy) NSString *contractId;
//合同编码
@property (nonatomic , copy) NSString *contractCode;
//车主id
@property (nonatomic , copy) NSString *customerId;
//车架号
@property (nonatomic , copy) NSString *vin;
//保养状态
@property (nonatomic , copy) NSString *remindStatus;
//合同开始时间
@property (nonatomic , assign) NSInteger contractBeginTime;
//合同结束时间
@property (nonatomic , assign) NSInteger contractEndTime;
//支付金额
@property (nonatomic , copy) NSString *contractMoney;
//支付方式
@property (nonatomic , copy) NSString *payMode;
//支付日期
@property (nonatomic , assign) NSInteger payDate;
//合同类型
@property (nonatomic , copy) NSString *contractType;
//记录状态
@property (nonatomic , copy) NSString *recordStatus;
//创建时间
@property (nonatomic , assign) NSInteger createTime;
//最后更新时间
@property (nonatomic , assign) NSInteger updateTime;
//操作员Id
@property (nonatomic , copy) NSString *userId;
//同步次数
@property (nonatomic , copy) NSString *synNum;
//合同附件地址
@property (nonatomic , copy) NSString *contractUrl;
//合同附件文件名
@property (nonatomic , copy) NSString *fileName;
//记录合同状态
@property (nonatomic , copy) NSString *contractStatus;
//车主是否为车辆使用人
@property (nonatomic , copy) NSString *isSame;
//数据来源
@property (nonatomic , copy) NSString *dataSource;
//dms同步数据合同id
@property (nonatomic , copy) NSString *dmsId;
//合同过期时间
@property (nonatomic , assign) NSInteger contractExpireTime;
//保养规则id
@property (nonatomic , copy) NSString *remindId;
//是否解除合同
@property (nonatomic , copy) NSString *releaseTag;
//是否完成套餐切换
@property (nonatomic , copy) NSString *discntStatus;
//发票文件名
@property (nonatomic , copy) NSString *billName;
//注册状态
@property (nonatomic , copy) NSString *enrollStatus;
//套餐Id
@property (nonatomic , copy) NSString *servicePaceagId;
//发票地址
@property (nonatomic , copy) NSString *billUrl;

@end


@interface ContractModel : NSObject
//当前页条数
@property (nonatomic , copy) NSString *pageSize;
//页数
@property (nonatomic , copy) NSString *currentPage;
//sql页码
@property (nonatomic , copy) NSString *currentPageSql;
//总页数
@property (nonatomic , copy) NSString *totalPage;
//总记录数
@property (nonatomic , copy) NSString *totalCount;
@property (nonatomic, strong) NSArray <result *> *resultdata;

@end
