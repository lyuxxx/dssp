//
//  OrderCell.h
//  dssp
//
//  Created by yxliu on 2018/2/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

typedef NS_ENUM(NSUInteger, OrderAction) {
    OrderActionCancel,
    OrderActionPay,
    OrderActionEvaluate,
    OrderActionInvoice
};
typedef void(^OrderActionBlock)(OrderAction);

@interface OrderCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView action:(OrderActionBlock)block;

+ (CGFloat)cellHeightWithOrder:(Order *)order;

- (void)configWithOrder:(Order *)order;

@end
