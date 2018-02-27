//
//  MapUpdateViewController.h
//  dssp
//
//  Created by yxliu on 2018/1/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "BaseViewController.h"

@class ActivationCode;

@interface MapUpdateViewController : BaseViewController

- (void)showCodeViewWithCode:(ActivationCode *)code;

@end
