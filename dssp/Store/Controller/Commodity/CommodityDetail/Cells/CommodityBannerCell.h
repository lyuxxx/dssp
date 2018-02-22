//
//  CommodityBannerCell.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CommodityBannerCellIdentifier;

@interface CommodityBannerCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configWithImages:(NSArray *)images;

@end
