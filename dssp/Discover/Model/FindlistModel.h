//
//  FindlistModel.h
//  dssp
//
//  Created by qinbo on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
//查询菜单接口

@interface FindDataItem :NSObject
//当前页
@property (nonatomic , assign) NSInteger currentPage;
//当前页条数
@property (nonatomic , assign) NSInteger pageSize;
//菜单Id
@property (nonatomic , copy) NSString *menuId;
//菜单名
@property (nonatomic , copy) NSString *name;
//菜单描述
@property (nonatomic , copy) NSString *depict;
//是否启用
@property (nonatomic , copy) NSString *isEnable;
//优先级
@property (nonatomic , copy) NSString *piority;
//创建时间
@property (nonatomic , assign) NSInteger createTime;
//最后更新时间
@property (nonatomic , assign) NSInteger lastUpdateTime;
//是否删除
@property (nonatomic , copy) NSString *isDel;

@end


@interface FindlistModel :NSObject
@property (nonatomic , copy) NSString *code;
@property (nonatomic , copy) NSString *msg;
@property (nonatomic , strong) NSArray <FindDataItem *> *findData;

@end




