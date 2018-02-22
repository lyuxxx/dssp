//
//  CommodityNameCell.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CommodityNameCellIdentifier;

@interface CommodityNameCell : UITableViewCell

- (void)configWithCommodityName:(NSString *)name;

+ (CGFloat)cellHeightWithCommodityName:(NSString *)name;

@end
