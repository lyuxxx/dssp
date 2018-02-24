//
//  StoreObject.h
//  dssp
//
//  Created by yxliu on 2018/2/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreCategory : NSObject
@property (nonatomic, assign) NSInteger itemcatId;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, copy) NSString *name;
@end

@interface StoreCategoryResponse : NSObject <YYModel>
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray<StoreCategory *> *data;
@end

@interface StoreCommodity : NSObject
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *itemNo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *sellPoint;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) float discountPrice;
@property (nonatomic, assign) float choosePriceType;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger shippingYn;
@property (nonatomic, strong) NSDate *onlineTime;
@property (nonatomic, strong) NSDate *offlineTime;
@property (nonatomic, assign) NSInteger packageflow;
@property (nonatomic, assign) NSInteger flowUseEnd;
@property (nonatomic, copy) NSString *flowUnit;
@property (nonatomic, assign) NSInteger recordStatus;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSArray<NSString *> *picImages;
@end

@interface StoreCommodityData : NSObject <YYModel>
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageSql;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<StoreCommodity *> *result;
@end

@interface StoreCommodityResponse : NSObject <YYModel>
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) StoreCommodityData *data;
@end

@interface ItemServicePackage : NSObject

@property (nonatomic, assign) NSInteger itemServicePackageId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger servicePackageId;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, copy) NSString *packageSourceId;
@property (nonatomic, copy) NSString *packageCode;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *packageDesc;
@property (nonatomic, copy) NSString *packNum;
@property (nonatomic, copy) NSString *isValid;
@property (nonatomic, copy) NSString *packType;
@property (nonatomic, copy) NSString *vhlSeriesId;
@property (nonatomic, copy) NSString *vhlSeriesName;
@property (nonatomic, copy) NSString *vhlTypeId;
@property (nonatomic, copy) NSString *vhlTypeName;
@property (nonatomic, copy) NSString *vhlBrandId;
@property (nonatomic, copy) NSString *vhlBrandName;
@property (nonatomic, copy) NSString *serviceVersion;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger flow;
@property (nonatomic, assign) NSInteger flowEndDate;
@property (nonatomic, copy) NSString *flowUnit;

@end

@interface StoreCommodityDetail : NSObject <YYModel>
@property (nonatomic, strong) NSArray<NSString *> *picImages;
@property (nonatomic, strong) NSArray<ItemServicePackage *> *itemServicePackageList;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *itemNo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *sellPoint;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *discountPrice;
@property (nonatomic, copy) NSString *currentPrice;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSDate *onlineTime;
@property (nonatomic, strong) NSDate *offlineTime;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, copy) NSString *itemDesc;
@property (nonatomic, assign) NSInteger recordStatus;
@end

@interface StoreCommodityDetailResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) StoreCommodityDetail *data;
@end

@interface CommodityComment : NSObject <YYModel>
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, assign) NSInteger itemScore;
@property (nonatomic, assign) NSInteger serviceScore;
@property (nonatomic, assign) NSInteger timeScore;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headPortrait;
@end

@interface CommodityCommentData : NSObject <YYModel>
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageSql;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<CommodityComment *> *result;
@end

@interface CommodityCommentResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) CommodityCommentData *data;
@end
