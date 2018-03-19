//
//  CarBindingViewController.h
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"
#import "CarInfoModel.h"
@interface CarBindingViewController : StoreBaseViewController
@property (nonatomic, copy) NSString *bingVin;
@property (nonatomic, copy) NSString *doptCode;
@property (nonatomic, strong) NSObject *bingVins;
@property (nonatomic, strong) CarInfoModel *carInfo;
@property (nonatomic,strong) CarbindModel *carbind;
@end
