//
//  LoginResult.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LoginResult.h"
#import <CUHTTPRequest.h>

@implementation RoleVO

@end

@implementation PermissionVO

@end

@implementation LoginResultData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"roles": [RoleVO class],
             @"permissions": [PermissionVO class]
             };
}

- (void)setUserId:(NSInteger)userId {
    if (_userId != userId) {
        _userId = userId;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    }
}

- (void)setToken:(NSString *)token {
    if (_token != token) {
        _token = token;
        NSLog(@"!!!%@",token);
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [CUHTTPRequest setHTTPHeader:@{
                                       @"token": token
                                       }];
    }
}

- (void)setExpiredTime:(NSInteger)expiredTime {
    if (_expiredTime != expiredTime) {
        _expiredTime = expiredTime;
    }
}

@end

@implementation LoginResult

@end
