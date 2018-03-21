//
//  DKSKeyboardView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2017/9/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "DKSKeyboardView.h"
#import "DKSTextView.h"

//#import "UIView+FrameTool.h"

//状态栏和导航栏的总高度
#define StatusNav_Height (isIphoneX ? 88 : 64)
//判断是否是iPhoneX
#define isIphoneX (K_Width == 375.f && K_Height == 812.f ? YES : NO)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float bottomHeight = 230.0f; //底部视图高度
static float viewMargin = 8.0f; //按钮距离上边距
static float viewHeight = 36.0f; //按钮视图高度
@interface DKSKeyboardView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *emojiBtn;

@property (nonatomic, strong) UILabel *label;


@property (nonatomic, assign) CGFloat totalYOffset;
@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL emojiClick; //点击表情按钮
@property (nonatomic, assign) BOOL moreClick; //点击更多按钮

@end

@implementation DKSKeyboardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];

        //监听键盘出现、消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
        
        //创建视图
        [self creatView];
    }
    return self;
}

- (void)creatView {
    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
  
    //输入视图
    self.textView.frame = CGRectMake(CGRectGetMaxX(self.emojiBtn.frame) + viewMargin, 5, K_Width - 60, 40);
    
    
    self.label = [[UILabel alloc] init];
    _label.text = NSLocalizedString(@"输入你想知道的问题", nil);
   
    _label.font = [UIFont fontWithName:FontName size:14];
    _label.textColor = [UIColor colorWithHexString:@"#999999"];
    //    botLabel.backgroundColor =[UIColor redColor];
    [self.textView addSubview:_label];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
        make.width.equalTo(150);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreBtn.frame = CGRectMake(self.frame.size.width - 44, 7, 36, 36);
    [self.moreBtn setImage:[UIImage imageNamed:@"发送_btn"] forState:UIControlStateNormal];
//    [self.moreBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [self.moreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.moreBtn.layer.borderWidth = 1.0f;
//    self.moreBtn.layer.borderColor = [UIColor blackColor].CGColor;
//    self.moreBtn.layer.cornerRadius = 8;
    [self.backView addSubview:self.moreBtn];
}


#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    self.textView.frame = frame; //改变输入框的frame
    //当输入框大小改变时，改变backView的frame
    self.backView.frame = CGRectMake(0, 0, K_Width, height + (viewMargin * 2));
    self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.frame.size.height - _keyboardHeight, K_Width, self.backView.frame.size.height);
    //改变更多按钮、表情按钮的位置
//    self.emojiBtn.frame = CGRectMake(viewMargin, self.backView.height - viewHeight - viewMargin, viewHeight, viewHeight);
//    self.moreBtn.frame = CGRectMake(self.textView.maxX + viewMargin, self.backView.height - viewHeight - viewMargin, viewHeight, viewHeight);
    
    //主要是为了改变VC的tableView的frame
//    [self changeTableViewFrame];
}

#pragma mark ====== 点击空白处，键盘收起时，移动self至底部 ======
- (void)keyboardHide {
    //收起键盘
    [self.textView resignFirstResponder];
    [self removeBottomViewFromSupview];
    [UIView animateWithDuration:0.25 animations:^{
        //设置self的frame到最底部
        self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.frame.size.height, K_Width, self.backView.frame.size.height);
//        [self changeTableViewFrame];
    }];
}

#pragma mark ====== 键盘将要出现 ======
- (void)keyboardWillShow:(NSNotification *)notification {
    [self removeBottomViewFromSupview];
    
    _label.hidden = YES;
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
 
}

#pragma mark ====== 键盘将要消失 ======
- (void)keyboardWillHide:(NSNotification *)notification {
    //如果是弹出了底部视图时
    if (self.textView.text.length<1) {
          _label.hidden = NO;
    }
   
    if (self.moreClick || self.emojiClick) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.frame.size.height, K_Width, self.backView.frame.size.height);
//        [self changeTableViewFrame];
    }];
}

#pragma mark ====== 改变tableView的frame ======
//- (void)changeTableViewFrame {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardChangeFrameWithMinY:)]) {
//        [self.delegate keyboardChangeFrameWithMinY:self.frame.origin.y];
//    }
//}

#pragma mark ====== 移除底部视图 ======
- (void)removeBottomViewFromSupview {
//    [self.moreView removeFromSuperview];
//    [self.emojiView removeFromSuperview];
   
    self.moreClick = NO;
    self.emojiClick = NO;
}

#pragma mark ====== 点击发送按钮 ======
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(textViewContentText:)]) {
            [self.delegate textViewContentText:textView.text];
        }
        [self changeFrame:viewHeight];
        textView.text = @"";
        /*这里返回NO，就代表return键值失效，即页面上按下return，
         不会出现换行，如果为yes，则输入页面会换行*/
        return NO;
    }
    return YES;
}

#pragma mark ====== init ======
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
         _backView.backgroundColor =[UIColor colorWithHexString:@"#232120"];
//        _backView.layer.borderWidth = 1;
//        _backView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        [self addSubview:_backView];
    }
    return _backView;
}

- (DKSTextView *)textView {
    if (!_textView) {
        _textView = [[DKSTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        [_textView textValueDidChanged:^(CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        
        self.textView.textColor = [UIColor whiteColor];

        self.textView.backgroundColor=[UIColor colorWithHexString:@"#040000"];
        [self.backView addSubview:_textView];
    }
    return _textView;
}


#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
