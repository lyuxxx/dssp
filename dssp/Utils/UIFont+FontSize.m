//
//  UIFont+FontSize.m
//  dssp
//
//  Created by yxliu on 2018/3/15.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "UIFont+FontSize.h"
#import <objc/runtime.h>

@implementation UIFont (FontSize)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method newMethod = class_getClassMethod([self class], @selector(ds_fontWithName:size:));
        Method method = class_getClassMethod([self class], @selector(fontWithName:size:));
        method_exchangeImplementations(newMethod, method);
    });
}

+ (UIFont *)ds_fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    if ([UIScreen mainScreen].bounds.size.width < 375.0f) {
        fontSize = fontSize - 1;
    }
    return [UIFont ds_fontWithName:fontName size:fontSize];
}

@end
