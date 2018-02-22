//
//  CommodityCommentsListCell.h
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityComment;

@interface CommodityCommentsListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configWithComment:(CommodityComment *)comment;

+ (CGFloat)cellHeightWithComment:(CommodityComment *)comment;
@end
