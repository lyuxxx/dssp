//
//  CommodityDetailViewController.h
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "BaseViewController.h"

@class StoreCommodity;

@interface CommodityDetailViewController : BaseViewController

- (instancetype)initWithCommodity:(StoreCommodity *)commodity;

@end
