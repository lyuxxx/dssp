//
//  CommodityDetailCellsConfigurator.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityDetailCellsConfigurator.h"
#import "StoreObject.h"

@implementation CommodityDetailCellsConfigurator

- (instancetype)initWithCommodityDetail:(StoreCommodityDetail *)detail {
    self = [super init];
    if (self) {
        _bannerPics = detail.picImages;
        _name = detail.title;
        _price = [NSString stringWithFormat:@"￥%@",detail.price];
    }
    return self;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case CommodityDetailCellTypeBanner:
            return self.isBannerVisible;
            break;
        case CommodityDetailCellTypeName:
            return self.isNameCellVisible;
            break;
        case CommodityDetailCellTypePrice:
            return self.isPriceCellVisible;
            break;
        case CommodityDetailCellTypeCommentHeader:
            return self.isCommentCellVisible;
            break;
        case CommodityDetailCellTypeComment:
            return self.comments.count;
            break;
        case CommodityDetailCellTypeCommentFooter:
            return self.isCommentCellVisible;
            break;
        default:
            break;
    }
    return 0;
}

//- (CGFloat)heightForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case CommodityDetailCellTypeBanner:
//            return self.isBannerVisible ? 10 * WidthCoefficient :CGFLOAT_MIN;
//            break;
//        case CommodityDetailCellTypeCommentHeader:
//            return self.isCommentCellVisible ? 10 * WidthCoefficient : CGFLOAT_MIN;
//            break;
//        default:
//            break;
//    }
//    return CGFLOAT_MIN;
//}

- (BOOL)isBannerVisible {
    return self.bannerPics.count;
}

- (BOOL)isNameCellVisible {
    return self.name.length > 0;
}

- (BOOL)isPriceCellVisible {
    return self.price.length > 0;
}

- (BOOL)isCommentCellVisible {
    return self.comments.count;
}

@end
