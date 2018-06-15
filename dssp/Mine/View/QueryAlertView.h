//
//  QueryAlertView.h
//  dssp
//
//  Created by season on 2018/6/15.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 针对实名制查询专门设计的弹窗
 */
@interface QueryAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag;

- (void)show;

@end
