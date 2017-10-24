//
//  MBProgressHUD+CU.h
//  CUProgressHUD
//
//  Created by yxliu on 2017/9/20.
//


#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (CU)

/**
 提示成功信息

 @param success 提示的信息
 @param view 要显示的view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 提示错误信息

 @param error 提示的信息
 @param view 要显示的view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 提示信息

 @param message 提示的信息
 @param view 要显示的view
 @return 返回实例MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


/**
 提示成功信息

 @param success 提示的信息,显示在window上
 */
+ (void)showSuccess:(NSString *)success;

/**
 提示错误信息

 @param error 提示的信息,显示在window上
 */
+ (void)showError:(NSString *)error;

/**
 提示信息

 @param message 提示的信息,显示在window上
 @return 返回实例MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;


/**
 隐藏HUD

 @param view HUD所在的view
 */
+ (void)hideHUDForView:(UIView *)view;

/**
 隐藏HUD
 */
+ (void)hideHUD;

@end
