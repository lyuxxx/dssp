//
//  CarBindingViewController.h
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "BaseViewController.h"
#import "CarInfoModel.h"
@interface CarBindingViewController : BaseViewController
@property (nonatomic, copy) NSString *bingVin;
@property (nonatomic, strong) NSObject *bingVins;
@property (nonatomic, strong) CarInfoModel *carInfo;
@end
