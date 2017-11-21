//
//  CarSeriesViewController.h
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CarSeriesSelect)(NSString *);

@interface CarSeriesViewController : BaseViewController

@property (nonatomic, copy) CarSeriesSelect carSeriesSelct;

@end
