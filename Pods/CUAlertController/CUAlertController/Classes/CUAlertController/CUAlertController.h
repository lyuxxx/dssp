//
//  CUAlertController.h
//  CUAlertController
//
//  Created by yxliu on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import "CUAlertView.h"

@interface CUAlertController : UIViewController

/**
 实例化alert

 @param image 上方显示的图片
 @param attributedMessage attributedString类型的信息
 @return 返回的实例     
 */
+ (instancetype)alertWithImage:(UIImage *)image attributedMessage:(NSAttributedString *)attributedMessage;

/**
 实例化alert

 @param image 上方显示的图片
 @param message 显示的信息
 @return 返回的实例
 */
+ (instancetype)alertWithImage:(UIImage *)image message:(NSString *)message;

/**
 添加下方按钮

 @param title 按钮标题
 @param type 按钮类型
 @param clicked 点击事件
 */
- (void)addButtonWithTitle:(NSString *)title type:(CUButtonType)type clicked:(void(^)(void))clicked;

@end
