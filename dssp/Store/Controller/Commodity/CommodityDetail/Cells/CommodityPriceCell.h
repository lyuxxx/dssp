//
//  CommodityPriceCell.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CommodityPriceCellIdentifier;

@interface CommodityPriceCell : UITableViewCell

- (void)configWithPrice:(NSString *)price;

+ (CGFloat)cellHeight;

@end
