//
//  LoginResult.h
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleVO : NSObject

///角色id
@property (nonatomic, assign) NSInteger roleId;
///角色名称
@property (nonatomic, copy) NSString *roleName;
///角色描述
@property (nonatomic, copy) NSString *roleDesc;

@end

@interface PermissionVO : NSObject

///权限id
@property (nonatomic, assign) NSInteger permissionId;
///权限类型
@property (nonatomic, copy) NSString *permissionType;

@end

@interface LoginResultData : NSObject

///用户id
@property (nonatomic, assign) NSInteger userId;
///用户名
@property (nonatomic, copy) NSString *userName;
///用户手机
@property (nonatomic, copy) NSString *userMobileNo;
///用户email
@property (nonatomic, copy) NSString *userEmail;
///用户角色
@property (nonatomic, strong) RoleVO *roles;
///用户权限
@property (nonatomic, strong) PermissionVO *permissions;
///Token
@property (nonatomic, copy) NSString *token;
///失效日期
@property (nonatomic, assign) NSInteger expiredTime;
///用户密码
@property (nonatomic, copy) NSString *userPassword;
///系统code
@property (nonatomic, copy) NSString *systemCode;
///扩展字段
@property (nonatomic, strong) NSDictionary *lookUps;

@end

@interface LoginResult : NSObject

///结果状态码
@property (nonatomic, copy) NSString *code;
///处理结果描述
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) LoginResultData *data;

@end
