//
//  POIList.h
//  dssp
//
//  Created by yxliu on 2017/12/6.
//  Copyright © 2017年 capsa. All rights reserved.
//
#import <YYModel.h>

@interface ResultItem : NSObject <YYModel>
///当前页条数
@property (nonatomic, assign) NSInteger pageSize;
///当前页
@property (nonatomic, assign) NSInteger currentPage;
///总页数
@property (nonatomic, assign) NSInteger totalPage;
///总条数
@property (nonatomic, assign) NSInteger totalCount;
///返回信息
@property (nonatomic, strong) NSArray *result;
///id
@property (nonatomic, copy) NSString * poiId;
///用户id
@property (nonatomic, copy) NSString * userId;
///车架号
@property (nonatomic, copy) NSString * vin;
///poi名
@property (nonatomic, copy) NSString * poiName;
///经度
@property (nonatomic, copy) NSString * longitude;
///纬度
@property (nonatomic, copy) NSString * latitude;
///电话
@property (nonatomic, copy) NSString *tel;
///地址
@property (nonatomic, copy) NSString *address;
///搜索关键字
@property (nonatomic, copy) NSString *keyword;
///创建时间
@property (nonatomic, assign) NSInteger createTime;
///最后更新时间
@property (nonatomic, assign) NSInteger lastUpdateTime;
///描述
@property (nonatomic, copy) NSString *descript;

@end


@interface POIListData : NSObject
///当前页条数
@property (nonatomic, assign) NSInteger pageSize;
///当前页
@property (nonatomic, assign) NSInteger currentPage;
///总页数
@property (nonatomic, assign) NSInteger totalPage;
///总条数
@property (nonatomic, assign) NSInteger totalCount;
///返回信息
@property (nonatomic, strong) NSArray<ResultItem *> * result;

@end


@interface POIList : NSObject
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) POIListData * data;

@end

@interface POIFavoriteInput : NSObject <YYModel>
///车架号
@property (nonatomic, copy) NSString * vin;
///poi名
@property (nonatomic, copy) NSString * poiName;
///经度
@property (nonatomic, copy) NSString * longitude;
///纬度
@property (nonatomic, copy) NSString * latitude;
///电话号码
@property (nonatomic, copy) NSString * tel;
///地址
@property (nonatomic, copy) NSString * address;
///描述
@property (nonatomic, copy) NSString * descript;

@end

@interface POISendInput : NSObject <YYModel>

@property (nonatomic, copy) NSString * routeType;
///车架号
@property (nonatomic, copy) NSString * vin;
///目的地名称
@property (nonatomic, copy) NSString * destinationPoiName;
///目的地经度
@property (nonatomic, copy) NSString * destinationLongitude;
///目的地纬度
@property (nonatomic, copy) NSString * destinationLatitude;
///电话
@property (nonatomic, copy) NSString * tel;
///地址
@property (nonatomic, copy) NSString * address;
///搜索关键字
@property (nonatomic, copy) NSString * keyword;
///描述
@property (nonatomic, copy) NSString * descript;

@end
