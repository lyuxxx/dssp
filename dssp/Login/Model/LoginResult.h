//
//  LoginResult.h
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface RoleVO : NSObject

///角色名称
@property (nonatomic, copy) NSString *roleName;
///角色描述
@property (nonatomic, copy) NSString *roleDesc;

@end

@interface PermissionVO : NSObject

@property (nonatomic, copy) NSString *operationCode;
@property (nonatomic, copy) NSString *operationDesc;
@property (nonatomic, copy) NSString *operationParentCode;
@property (nonatomic, copy) NSString *operationParentDesc;
@property (nonatomic, assign) BOOL defaultPermission;

@end

@interface LoginResultData : NSObject <YYModel>

///用户id
@property (nonatomic, assign) NSInteger userId;
///用户名
@property (nonatomic, copy) NSString *userName;
///用户角色
@property (nonatomic, strong) NSArray<RoleVO *> *roles;
///用户权限
@property (nonatomic, strong) NSArray<PermissionVO *> *permissions;
///Token
@property (nonatomic, copy) NSString *token;
///失效日期
@property (nonatomic, assign) NSInteger expiredTime;
@property (nonatomic, copy) NSString *vin;
@property (nonatomic, copy) NSString *vhlTStatus;
@property (nonatomic, copy) NSString *certificationStatus;
@end

@interface LoginResult : NSObject

///结果状态码
@property (nonatomic, copy) NSString *code;
///处理结果描述
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) LoginResultData *data;

@end
