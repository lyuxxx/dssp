//
//  OrderPayViewController.h
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@class Order;

@interface OrderPayViewController : StoreBaseViewController

- (instancetype)initWithOrder:(Order *)order;

@end
