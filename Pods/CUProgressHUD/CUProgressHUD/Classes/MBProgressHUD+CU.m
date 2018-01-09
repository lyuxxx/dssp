//
//  MBProgressHUD+CU.m
//  CUProgressHUD
//
//  Created by yxliu on 2017/9/20.
//

#define kThemeColor [UIColor colorWithRed:196.0/255.0 green:183.0/255.0 blue:166.0/255.0 alpha:1]

#import "MBProgressHUD+CU.h"

@implementation MBProgressHUD (CU)

+ (void)showText:(NSString *)text view:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:kThemeColor];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.textColor = kThemeColor;
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showText:(NSString *)text {
    [self showText:text view:nil];
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:kThemeColor];
    //快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    hud.label.text = text;
    //设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"CUProgressHUD.bundle/%@",icon]]];
    //设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.label.textColor = kThemeColor;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:0.7];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error.png" view:view];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:kThemeColor];
    //快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    hud.label.text = message;
    hud.label.textColor = kThemeColor;
    hud.removeFromSuperViewOnHide = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    return hud;
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}

@end
