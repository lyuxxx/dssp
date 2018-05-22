//
//  PlaceholderTextView.m
//  dssp
//
//  Created by dy on 2018/5/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "PlaceholderTextView.h"

@implementation PlaceholderTextView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - 界面搭建
- (void)setUpUI {
    
    //  placeHolderLabel
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = NSLocalizedString(@"提供5个字以上的问题描述以便我们提供更好的帮助", nil);
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel = placeHolderLabel;
    [self addSubview:_placeHolderLabel];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //  使用系统约束
    _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:@[
                           
                           [NSLayoutConstraint constraintWithItem:_placeHolderLabel
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:8],
                           
                           [NSLayoutConstraint constraintWithItem:_placeHolderLabel
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:8],
                           
                           [NSLayoutConstraint constraintWithItem:_placeHolderLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:8],
                           ]];
    
    //  监听TextView的变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
}

#pragma mark - 监听通知的方法
- (void)textChanged {
    
    _placeHolderLabel.hidden = [self hasText];
}

#pragma mark - 移除通知
- (void)dealloc {
    //  控制器销毁的时候移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



@end
