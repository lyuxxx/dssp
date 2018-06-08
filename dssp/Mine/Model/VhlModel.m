#import "VhlModel.h"

@implementation VhlModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"vhlId" : @"id"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *typeName = dic[@"vhlTypeName"];
    if ([typeName isKindOfClass:[NSString class]] && [typeName containsString:@"_RCC"]) {
        _vhlTypeName = [typeName stringByReplacingOccurrencesOfString:@"_RCC" withString:@""];
    }
    return YES;
}

@end
