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

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"picImages": [NSString class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    float price = [dic[@"price"] floatValue];
    _price = [NSString stringWithFormat:@"%.2f",price];
    
    NSString *image = dic[@"image"];
    if ([image containsString:@","]) {
        _image = [image componentsSeparatedByString:@","][0];
    } else {
        _image = image;
    }
    
    return YES;
}

@end

@implementation StoreCommodityData

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"result": [StoreCommodity class]
             };
}

@end

@implementation StoreCommodityResponse

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

//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    float price = [dic[@"price"] floatValue];
//    _price = [NSString stringWithFormat:@"%.2f",price];
//    float discountPrice = [dic[@"discountPrice"] floatValue];
//    _discountPrice = [NSString stringWithFormat:@"%.2f",discountPrice];
//    float currentPrice = [dic[@"currentPrice"] floatValue];
//    _currentPrice = [NSString stringWithFormat:@"%.2f",currentPrice];
//    float salePrice = [dic[@"salePrice"] floatValue];
//    _salePrice = [NSString stringWithFormat:@"%.2f",salePrice];
//    return YES;
//}

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
