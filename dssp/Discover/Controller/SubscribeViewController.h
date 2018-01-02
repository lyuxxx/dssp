//
//  SubscribeViewController.h
//  dssp
//
//  Created by qinbo on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

//#import "BaseViewController.h"
#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};
@interface SubscribeViewController : WMPageController
@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;
@end
