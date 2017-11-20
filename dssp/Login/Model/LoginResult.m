//
//  LoginResult.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LoginResult.h"

@implementation RoleVO

@end

@implementation PermissionVO

@end

@implementation LoginResultData

- (void)setUserId:(NSInteger)userId {
    if (_userId != userId) {
        _userId = userId;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    }
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"roles": [RoleVO class],
             @"permissions": [PermissionVO class]
             };
}

@end

@implementation LoginResult

@end
