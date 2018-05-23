//
//  FeedbackController.m
//  dssp
//
//  Created by dy on 2018/5/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "FeedbackController.h"
#import "PlaceholderTextView.h"
#import "FeedbackPicView.h"
#import "FeedbackChoosePicView.h"

#define kActivityQuestion 100
#define kCarQuestion 101
#define kAppQuestion 102
#define kOtherQuestion 103
#define kFeedbackButtonWidth 100 * WidthCoefficient
#define kFeedbackButtonHeight 33 * HeightCoefficient
#define kMaxInputCount 150

@interface FeedbackController () <UITextViewDelegate>
/** 激活问题按钮*/
@property (nonatomic, strong) UIButton *activityQuestionButton;
/** 车辆问题按钮*/
@property (nonatomic, strong) UIButton *carQuestionButton;
/** app问题按钮*/
@property (nonatomic, strong) UIButton *appQuestionButton;
/** 其他问题按钮*/
@property (nonatomic, strong) UIButton *otherQuestionButton;
/** 按钮数组*/
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
/** 意见反馈文字说明*/
@property (nonatomic, strong) UILabel *feedbackLabel ;
/** 意见反馈输入框*/
@property (nonatomic, strong) PlaceholderTextView *textView;
/** 输入文字字数展示*/
@property (nonatomic, strong) UILabel *inputCountLabel;
/** 图片区域*/
@property (nonatomic, strong) FeedbackPicView *picView;
/** 图片选择区域*/
@property (nonatomic, strong) FeedbackChoosePicView *choosePicView;
/** 提交按钮*/
@property (nonatomic, strong) UIButton *commintButton;

@end

@implementation FeedbackController

#pragma mark- 方法重写
- (BOOL)needGradientBg {
    return YES;
}

#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark- 搭建界面
- (void)setUpUI {
    self.navigationItem.title = NSLocalizedString(@"意见反馈", nil);
    
    CGFloat margin = (kScreenWidth - 4 * kFeedbackButtonWidth) / 4;
    
    [self.view addSubview:self.activityQuestionButton];
    [self.buttons addObject:self.activityQuestionButton];
    [self.activityQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.view).offset(20 * HeightCoefficient);
    }];
    
    [self.view addSubview:self.carQuestionButton];
    [self.buttons addObject:self.carQuestionButton];
    [self.carQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.activityQuestionButton.mas_trailing).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.activityQuestionButton);
    }];
    
    [self.view addSubview:self.appQuestionButton];
    [self.buttons addObject:self.appQuestionButton];
    [self.appQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.carQuestionButton.mas_trailing).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.activityQuestionButton);
    }];
    
    [self.view addSubview:self.otherQuestionButton];
    [self.buttons addObject:self.otherQuestionButton];
    [self.otherQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.appQuestionButton.mas_trailing).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.activityQuestionButton);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(15 * WidthCoefficient);
        make.trailing.mas_equalTo(self.view).offset(-15 * WidthCoefficient);
        make.top.mas_equalTo(self.activityQuestionButton.mas_bottom).offset(20 * HeightCoefficient);
        make.height.mas_equalTo(200 * HeightCoefficient);
    }];
    
    [self.view addSubview:self.inputCountLabel];
    [self.inputCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.textView);
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.width.mas_equalTo(100 * WidthCoefficient);
    }];
    
    [self.view addSubview:self.picView];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputCountLabel.mas_bottom).offset(20 * HeightCoefficient);
        make.leading.trailing.mas_equalTo(self.textView);
        make.height.mas_equalTo(66);
    }];
    
    [self.picView addSubview:self.choosePicView];
    [self.choosePicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.picView);
        make.top.mas_equalTo(self.picView).offset(17);
    }];
    self.choosePicView.backgroundColor = [UIColor yellowColor];
    
    __weak typeof(self)weakSelf = self;
    self.choosePicView.pickerCallback = ^(TZImagePickerController *picker){
        [weakSelf presentViewController:picker animated:YES completion:nil];
    };
    
    self.choosePicView.imageCountCallback = ^(NSString *imageCount) {
        [weakSelf.picView setImageCount:imageCount];
    };
    
    [self.view addSubview:self.commintButton];
    [self.commintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(kBottomHeight);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark- 按钮的点击事件
- (void)buttonAction:(UIButton *) button {
    NSLog("点击了反馈按钮");
    
    //  如果已经被选中,那么返回
    if (button.selected) { return; }
    
    //  否则进行遍历
    for (UIButton *feedbackButton in self.buttons) {
        if (feedbackButton == button) {
            button.selected = YES;
        }else {
            feedbackButton.selected = NO;
        }
    }
}

- (void)commitButtonAction:(UIButton *) button {
    NSLog("点击了提交按钮")
}

#pragma mark- UITextView的代理
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
    if (count <= kMaxInputCount) {
        self.inputCountLabel.text = [NSString stringWithFormat:@"%d/%d", count,kMaxInputCount];
    }else {
        self.inputCountLabel.text = @"150/150";
        textView.text = [textView.text substringWithRange:NSMakeRange(0, kMaxInputCount)];
        [MBProgressHUD showText:@"至多输入150个字符"];
    }
    
}

#pragma mark- 懒加载
- (UIButton *)activityQuestionButton {
    if (!_activityQuestionButton) {
        _activityQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_activityQuestionButton setTitle:NSLocalizedString(@"激活问题", nil) forState:UIControlStateNormal];
        [_activityQuestionButton setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        [_activityQuestionButton setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
        _activityQuestionButton.tag = kActivityQuestion;
        [_activityQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _activityQuestionButton;
}

- (UIButton *)carQuestionButton {
    if (!_carQuestionButton) {
        _carQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_carQuestionButton setTitle:NSLocalizedString(@"车辆问题", nil) forState:UIControlStateNormal];
        [_carQuestionButton setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        [_carQuestionButton setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
        _carQuestionButton.tag = kCarQuestion;
        [_carQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _carQuestionButton;
}


- (UIButton *)appQuestionButton {
    if (!_appQuestionButton) {
        _appQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_appQuestionButton setTitle:NSLocalizedString(@"App问题", nil) forState:UIControlStateNormal];
        [_appQuestionButton setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        [_appQuestionButton setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
        _appQuestionButton.tag = kAppQuestion;
        [_appQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _appQuestionButton;
}

- (UIButton *)otherQuestionButton {
    if (!_otherQuestionButton) {
        _otherQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_otherQuestionButton setTitle:NSLocalizedString(@"其他问题", nil) forState:UIControlStateNormal];
        [_otherQuestionButton setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        [_otherQuestionButton setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
        _otherQuestionButton.tag = kOtherQuestion;
        [_otherQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _otherQuestionButton;
}

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIButton *)commintButton {
    if (!_commintButton) {
        _commintButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_commintButton setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [_commintButton setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        [_commintButton setTitleColor: [UIColor redColor] forState:UIControlStateSelected];
        [_commintButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commintButton;
}

- (PlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [PlaceholderTextView new];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(6, 0, 0, 0);
        _textView.font = [UIFont systemFontOfSize:15];
    }
    return _textView;
}

- (UILabel *)inputCountLabel {
    if (!_inputCountLabel) {
        _inputCountLabel = [UILabel new];
        _inputCountLabel.text = [NSString stringWithFormat:@"0/%d", kMaxInputCount];
        _inputCountLabel.backgroundColor = [UIColor whiteColor];
    }
    return _inputCountLabel;
}

- (FeedbackPicView *)picView {
    if (!_picView) {
        _picView = [FeedbackPicView new];
    }
    return  _picView;
}

- (FeedbackChoosePicView *)choosePicView {
    if (!_choosePicView) {
        _choosePicView = [FeedbackChoosePicView new];
    }
    return _choosePicView;
}

@end
