//
//  StoreObject.m
//  dssp
//
//  Created by yxliu on 2018/2/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreObject.h"

@implementation StoreCategory

@end

@implementation StoreCategoryResponse

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data": [StoreCategory class]
             };
}

@end

@implementation StoreCommodity

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    float price = [dic[@"price"] floatValue];
    _price = [NSString stringWithFormat:@"%.2f",price];
    return YES;
}

@end

@implementation StoreCommodityResponse

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data": [StoreCommodity class]
             };
}

@end

@implementation ItemServicePackage

@end

@implementation StoreCommodityDetail

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"picImages": [NSString class],
             @"itemServicePackageList": [ItemServicePackage class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    float price = [dic[@"price"] floatValue];
    _price = [NSString stringWithFormat:@"%.2f",price];
    return YES;
}

@end

@implementation StoreCommodityDetailResponse

@end

@implementation CommodityComment

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"userId": @"id"
             };
}

@end

@implementation CommodityCommentData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"result": [CommodityComment class]
             };
}

@end

@implementation CommodityCommentResponse

@end
