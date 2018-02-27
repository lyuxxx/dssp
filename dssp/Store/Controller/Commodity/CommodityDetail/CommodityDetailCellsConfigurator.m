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
        _salePriceStr = [NSString stringWithFormat:@"¥%@",detail.salePrice];
        _desc = detail.itemDesc;
        
        if (detail.choosePriceType != 1) {
            NSString *str = [NSString stringWithFormat:@"¥%@",detail.price];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange range = [str rangeOfString:[NSString stringWithFormat:@"¥%@",detail.price]];
            [attStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
            [attStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:range];
            _originalPriceStr = attStr;
        }
        
        if (detail.choosePriceType == 1) {//原价
            
        } else if (detail.choosePriceType == 2) {//现价
            _promotionStr = [NSString stringWithFormat:@"满减%@元",detail.subtractCash];
        } else if (detail.choosePriceType == 3) {//折扣价
            _promotionStr = [NSString stringWithFormat:@"活动%.1f折",detail.discountRate.floatValue * 10];
        }
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
        case CommodityDetailCellTypeDescriptionTitle:
            return self.isDescriptionCellVisible;
            break;
        case CommodityDetailCellTypeDescription:
            return self.isDescriptionCellVisible;
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
    return self.salePriceStr.length > 0;
}

- (BOOL)isDescriptionCellVisible {
    return self.desc.length > 0;
}

- (BOOL)isCommentCellVisible {
    return self.comments.count;
}

@end
