//
//  MapUpdateViewController.h
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@class ActivationCode;

@interface MapUpdateViewController : StoreBaseViewController

- (void)showCodeViewWithCode:(ActivationCode *)code;

@end
