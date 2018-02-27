//
//  OrderObject.m
//  dssp
//
//  Created by yxliu on 2018/2/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "OrderObject.h"

@implementation OrderItem

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    float price = [dic[@"price"] floatValue];
    _price = [NSString stringWithFormat:@"%.2f",price];
    return YES;
}

@end

@implementation Order

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"items": [OrderItem class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    float payment = [dic[@"payment"] floatValue];
    _payment = [NSString stringWithFormat:@"%.2f",payment];
    return YES;
}

@end

@implementation OrderDetailResponse

@end

@implementation OrderResponseData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"result": [Order class]
             };
}

@end

@implementation OrderResponse

@end

@implementation PayMessage

@end

@implementation PayRequest

@end
