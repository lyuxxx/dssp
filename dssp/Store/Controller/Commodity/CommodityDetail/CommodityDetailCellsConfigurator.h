//
//  CommodityDetailCellsConfigurator.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreCommodityDetail;
@class CommodityComment;

typedef NS_ENUM(NSUInteger, CommodityDetailCellType) {
    CommodityDetailCellTypeBanner,
    CommodityDetailCellTypeName,
    CommodityDetailCellTypePrice,
    CommodityDetailCellTypeCommentHeader,
    CommodityDetailCellTypeComment,
    CommodityDetailCellTypeCommentFooter
};

@interface CommodityDetailCellsConfigurator : NSObject

@property (nonatomic, strong) NSArray<NSString *> *bannerPics;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) NSArray<CommodityComment *> *comments;

@property (nonatomic, assign) BOOL isBannerVisible;
@property (nonatomic, assign) BOOL isNameCellVisible;
@property (nonatomic, assign) BOOL isPriceCellVisible;
@property (nonatomic, assign) BOOL isCommentCellVisible;

- (instancetype)initWithCommodityDetail:(StoreCommodityDetail *)detail;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

//- (CGFloat)heightForHeaderInSection:(NSInteger)section;

@end
