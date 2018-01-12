//
//  SendPoiProgressView.h
//  dssp
//
//  Created by yxliu on 2018/1/11.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPoiProgressView : UIView

+ (instancetype)showWithCancelBlock:(void(^)(void))block;
+ (void)dismiss;

@end
