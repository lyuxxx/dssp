//
//  CommodityDetailViewController.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@class StoreCommodity;

@interface CommodityDetailViewController : StoreBaseViewController

- (instancetype)initWithCommodity:(StoreCommodity *)commodity;

@end
