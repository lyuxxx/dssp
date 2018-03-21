//
//  DKSKeyboardView.h
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKSTextView.h"
@protocol DKSKeyboardDelegate <NSObject>

@optional //非必实现的方法

/**
 点击发送时输入框内的文案

 @param textStr 文案
 */
- (void)textViewContentText:(NSString *)textStr;

/**
 键盘的frame改变
 */
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY;

@end

@interface DKSKeyboardView : UIView <UITextViewDelegate>
@property (nonatomic, strong) UIButton *moreBtn;
//@property (nonatomic,strong) UITextView *textView;
@property (nonatomic, strong) DKSTextView *textView;
@property (nonatomic, weak) id <DKSKeyboardDelegate>delegate;

@end
