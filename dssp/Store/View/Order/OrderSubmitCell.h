//
//  OrderSubmitCell.h
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreCommodity;

@interface OrderSubmitCell : UITableViewCell

- (void)configWithCommodity:(StoreCommodity *)commodity;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end
