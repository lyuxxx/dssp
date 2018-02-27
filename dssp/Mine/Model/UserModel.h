//
//  UserModel.h
//  dssp
//
//  Created by qinbo on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic , copy) NSString *userId ;
@property (nonatomic , copy) NSString *userName ;
@property (nonatomic , copy) NSString *userMobileNo ;
@property (nonatomic , copy) NSString *userEmail ;
@property (nonatomic , copy) NSString *createTime ;
@property (nonatomic , copy) NSString *updateTime ;
@property (nonatomic , copy) NSString *tserviceStatus ;
@property (nonatomic , copy) NSString *vin ;
@property (nonatomic , copy) NSString *nickname ;
@property (nonatomic , copy) NSString *headPortrait ;

@end
