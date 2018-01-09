//
//  NoticeModel.h
//  dssp
//
//  Created by qinbo on 2017/12/27.
//  Copyright © 2017年 capsa. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface NoticeModel : NSObject
@property (nonatomic, assign) NSInteger   currentPage;
@property (nonatomic, assign) NSInteger   pageSize;
@property (nonatomic, copy)   NSString  *noticeId;
@property (nonatomic, copy)   NSString  *vin;
@property (nonatomic, copy)   NSString  *title;
@property (nonatomic, copy)   NSString  *depict;
@property (nonatomic, copy)   NSString  *businType;
@property (nonatomic, copy)   NSString  *piority;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger lastUpdateTime;
@property (nonatomic, copy)   NSString *isDel;
@property (nonatomic, copy)   NSString *noticeData;
@property (nonatomic, copy)   NSString *readStatus;
@end


@interface NoticedatailModel : NSObject <YYModel>
@property (nonatomic , assign) NSInteger currentPage;
@property (nonatomic , assign) NSInteger pageSize;
@property (nonatomic , copy)   NSString *NoticedatailId;
@property (nonatomic , copy)   NSString *vin;
@property (nonatomic , copy)   NSString *title;
@property (nonatomic , copy)   NSString *depict;
@property (nonatomic , copy)   NSString *businType;
@property (nonatomic , copy)   NSString *piority;
@property (nonatomic , assign) NSInteger createTime;
@property (nonatomic , assign) NSInteger lastUpdateTime;
@property (nonatomic , copy)   NSString  *isDel;
@property (nonatomic , copy)   NSString  *noticeData;
@end


