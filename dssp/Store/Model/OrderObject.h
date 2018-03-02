//
//  OrderObject.h
//  dssp
//
//  Created by yxliu on 2018/2/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject <YYModel>
@property (nonatomic, assign) NSInteger orderItemId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *totalFee;
@property (nonatomic, copy) NSString *picPath;
@property (nonatomic, strong) NSArray<NSString *> *picImages;
@end

@interface Order : NSObject <YYModel>
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, assign) BOOL haveInvoice;
@property (nonatomic, assign) NSInteger paymentType;
@property (nonatomic, copy) NSString *postFee;
///0、未付款，1、已付款，2、交易成功，3、交易取消
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, strong) NSDate *paymentTime;
@property (nonatomic, strong) NSDate *consignTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *closeTime;
@property (nonatomic, copy) NSString *shippingName;
@property (nonatomic, copy) NSString *shippingCode;
@property (nonatomic, copy) NSString *shippingStatus;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *buyerMessage;
@property (nonatomic, copy) NSString *buyerNick;
@property (nonatomic, copy) NSString *buyerRate;
@property (nonatomic, strong) NSDate *finishTime;
@property (nonatomic, strong) NSArray<OrderItem *> *items;
@end

@interface OrderDetailResponse : NSObject <YYModel>
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) Order *data;
@end

@interface OrderResponseData : NSObject <YYModel>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentPageSql;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSArray<Order *> *result;

@end

@interface OrderResponse : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) OrderResponseData *data;
@end

@interface PayMessage : NSObject
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) NSNumber *totalFee;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *tradeType;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *timeOut;
@property (nonatomic, copy) NSString *vin;
@end

@interface PayRequest : NSObject
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *protocolId;
@property (nonatomic, copy) NSString *thirdInfoId;
@property (nonatomic, copy) NSString *t;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, copy) NSString *message;
@end
