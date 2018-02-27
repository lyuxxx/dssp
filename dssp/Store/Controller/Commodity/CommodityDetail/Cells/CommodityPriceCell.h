//
//  CommodityPriceCell.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityDetailCellsConfigurator;

extern NSString * const CommodityPriceCellIdentifier;

@interface CommodityPriceCell : UITableViewCell

- (void)configWithConfig:(CommodityDetailCellsConfigurator *)config;

+ (CGFloat)cellHeight;

@end
