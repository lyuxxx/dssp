//
//  FindByAllModel.h
//  dssp
//
//  Created by qinbo on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
//查询菜单对应的列表接口

//@interface ResultItem :NSObject
//@property (nonatomic , assign) NSInteger              currentPage;
//@property (nonatomic , assign) NSInteger              pageSize;
//@property (nonatomic , copy) NSString              * ids;
//@property (nonatomic , copy) NSString              * channelId;
//@property (nonatomic , copy) NSString              * title;
//@property (nonatomic , assign) NSInteger              createTime;
//@property (nonatomic , copy) NSString              * isTop;
//
//@end
//
//
//@interface FindByAllData :NSObject
//@property (nonatomic , assign) NSInteger  pageSize;
//@property (nonatomic , assign) NSInteger  currentPage;
//@property (nonatomic , assign) NSInteger  totalPage;
//@property (nonatomic , assign) NSInteger  totalCount;
//@property (nonatomic , strong) NSArray <ResultItem *> *result;
//
//@end
//

@interface FindByAllModel :NSObject
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *msg;
//@property (nonatomic , strong) FindByAllData *data;

@end
