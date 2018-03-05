//
//  PayCompleteViewController.h
//  dssp
//
//  Created by yxliu on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@class PayRequest;

@interface PayCompleteViewController : StoreBaseViewController

- (instancetype)initWithPayRequest:(PayRequest *)payRequest;

@end
