//
//  OrderSubmitViewController.h
//  dssp
//
//  Created by yxliu on 2018/2/9.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@class StoreCommodity;

@interface OrderSubmitViewController : StoreBaseViewController

- (instancetype)initWithCommodity:(StoreCommodity *)commodity;

@end
