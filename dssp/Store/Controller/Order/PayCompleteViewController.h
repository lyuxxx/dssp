//
//  PayCompleteViewController.h
//  dssp
//
//  Created by yxliu on 2018/2/26.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"
typedef NS_ENUM(NSUInteger, PayState) {
    PayStateOK,
    PayStateFail
};
@interface PayCompleteViewController : StoreBaseViewController

- (instancetype)initWithState:(PayState)payState;

@end
