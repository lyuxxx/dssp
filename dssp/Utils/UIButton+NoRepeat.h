//
//  UIButton+NoRepeat.h
//  dssp
//
//  Created by yxliu on 2018/3/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NoRepeat)
/**
 *  为按钮添加点击间隔 eventTimeInterval秒
 */
@property (nonatomic, assign) NSTimeInterval eventTimeInterval;
@end
