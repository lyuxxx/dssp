#import "VhlModel.h"

@implementation VhlModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"vhlId" : @"id"
             };
}
@end
